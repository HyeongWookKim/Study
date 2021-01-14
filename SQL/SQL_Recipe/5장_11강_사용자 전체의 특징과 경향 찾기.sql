-- <�ڵ� 11-1>
--DROP TABLE action_log;
CREATE TABLE action_log(
    sessions varchar(255)
  , user_id varchar(255)
  , action varchar(255)
  , categorys varchar(255)
  , products varchar(255)
  , amount integer
  , stamp varchar(255)
);

INSERT INTO action_log VALUES ('989004ea', 'U001', 'purchase', 'drama' , 'D001,D002', 2000, '2016-11-03 18:10:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'view'    , NULL    , NULL       , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'favorite', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'review'  , 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-03 18:01:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'add_cart', 'drama' , 'D001,D002', NULL, '2016-11-03 18:02:00');
INSERT INTO action_log VALUES ('989004ea', 'U001', 'purchase', 'drama' , 'D001,D002', 2000, '2016-11-03 18:10:00');
INSERT INTO action_log VALUES ('47db0370', 'U002', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 19:00:00');
INSERT INTO action_log VALUES ('47db0370', 'U002', 'purchase', 'drama' , 'D001'     , 1000, '2016-11-03 20:00:00');
INSERT INTO action_log VALUES ('47db0370', 'U002', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-03 20:30:00');
INSERT INTO action_log VALUES ('87b5725f', 'U001', 'add_cart', 'action', 'A004'     , NULL, '2016-11-04 12:00:00');
INSERT INTO action_log VALUES ('87b5725f', 'U001', 'add_cart', 'action', 'A005'     , NULL, '2016-11-04 12:00:00');
INSERT INTO action_log VALUES ('87b5725f', 'U001', 'add_cart', 'action', 'A006'     , NULL, '2016-11-04 12:00:00');
INSERT INTO action_log VALUES ('9afaf87c', 'U002', 'purchase', 'drama' , 'D002'     , 1000, '2016-11-04 13:00:00');
INSERT INTO action_log VALUES ('9afaf87c', 'U001', 'purchase', 'action', 'A005,A006', 1000, '2016-11-04 15:00:00');

-- �׼� ���� ������ ����ϱ�
with stats as (
    -- �α� ��ü�� ����ũ ����� �� ���ϱ�
    select count(distinct sessions) as total_uu
    from action_log
)
select l.action
     -- �׼� UU
     , count(distinct l.sessions) as action_uu
     -- �׼��� ��
     , count(1) as action_count
     -- ��ü UU
     , s.total_uu
     -- ����: <�׼� UU> / <��ü UU>
     , 100.0 * count(distinct l.sessions) / s.total_uu as usage_rate
     -- 1�δ� �׼� ��: <�׼� ��> / <�׼� UU>
     , round(1.0 * count(1) / count(distinct l.sessions), 2) as count_per_user
from action_log l
-- �α� ��ü�� ����ũ ����� ���� ��� ���ڵ忡 �����ϱ�
cross join stats s
group by l.action, s.total_uu;

-- <�ڵ� 11-2>
-- �α��� ���¸� �Ǻ��ϱ�
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- user_id�� NULL �Ǵ� �� ���ڰ� �ƴ� ��� login�̶�� �����ϱ�
         , case 
            when coalesce(user_id, ' ') <> ' ' then 'login' else 'guest'
           end as login_status
    from action_log
)
select *
from action_log_with_status;

-- <�ڵ� 11-3>
-- �α��� ���¿� ���� �׼� �� ���� ���� �����ϱ�
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- user_id�� NULL �Ǵ� �� ���ڰ� �ƴ� ��� login�̶�� �����ϱ�
         , case 
            when coalesce(user_id, ' ') <> ' ' then 'login' else 'guest'
           end as login_status
    from action_log
)
select coalesce(action, 'all') as action
     , coalesce(login_status, 'all') as login_status
     , count(distinct sessions) as action_uu
     , count(1) as action_count
from action_log_with_status
group by rollup(action, login_status);

-- <�ڵ� 11-4>
-- ȸ�� ���¸� �Ǻ��ϱ�
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- �α׸� Ÿ�ӽ����� ������ �����ϰ�, �� ���̶� �α����� ������� ���,
         -- ������ ��� �α� ���¸� member�� ����
         , case
            when coalesce(max(user_id) 
                    over(partition by sessions order by stamp
                        rows between unbounded preceding and current row)
                    , ' ') <> ' '
            then 'member' else 'none'
           end as member_status
         , stamp
    from action_log                     
)
select *
from action_log_with_status;

-- <�ڵ� 11-5>
--DROP TABLE mst_users;
CREATE TABLE mst_users(
    user_id         varchar(255)
  , sex             varchar(255)
  , birth_date      varchar(255)
  , register_date   varchar(255)
  , register_device varchar(255)
  , withdraw_date   varchar(255)
);

INSERT INTO mst_users VALUES ('U001', 'M', '1977-06-17', '2016-10-01', 'pc' , NULL        );
INSERT INTO mst_users VALUES ('U002', 'F', '1953-06-12', '2016-10-01', 'sp' , '2016-10-10');
INSERT INTO mst_users VALUES ('U003', 'M', '1965-01-06', '2016-10-01', 'pc' , NULL        );
INSERT INTO mst_users VALUES ('U004', 'F', '1954-05-21', '2016-10-05', 'pc' , NULL        );
INSERT INTO mst_users VALUES ('U005', 'M', '1987-11-23', '2016-10-05', 'sp' , NULL        );
INSERT INTO mst_users VALUES ('U006', 'F', '1950-01-21', '2016-10-10', 'pc' , '2016-10-10');
INSERT INTO mst_users VALUES ('U007', 'F', '1950-07-18', '2016-10-10', 'app', NULL        );
INSERT INTO mst_users VALUES ('U008', 'F', '2006-12-09', '2016-10-10', 'sp' , NULL        );
INSERT INTO mst_users VALUES ('U009', 'M', '2004-10-23', '2016-10-15', 'pc' , NULL        );
INSERT INTO mst_users VALUES ('U010', 'F', '1987-03-18', '2016-10-16', 'pc' , NULL        );

-- ������� ������ ����ϱ�
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ���� ǥ��
         , 20170101 as int_specific_date
         -- ���ڿ��� ������ ��������� ���� ǥ������ ��ȯ�ϱ�
         , cast(replace(substr(birth_date, 1, 10), '-', '') as integer) as int_birth_date
    from mst_users
)
, mst_users_with_age as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         , int_specific_date
         , int_birth_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ����
         , floor((int_specific_date - int_birth_date) / 10000) as age
    from mst_users_with_int_birth_date
)
select user_id
     , sex
     , birth_date
     , age
from mst_users_with_age;

-- <�ڵ� 11-6>
-- ������ �������� ���ɺ� ������ ����ϱ�
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ���� ǥ��
         , 20170101 as int_specific_date
         -- ���ڿ��� ������ ��������� ���� ǥ������ ��ȯ�ϱ�
         , cast(replace(substr(birth_date, 1, 10), '-', '') as integer) as int_birth_date
    from mst_users
)
, mst_users_with_age as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         , int_specific_date
         , int_birth_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ����
         , floor((int_specific_date - int_birth_date) / 10000) as age
    from mst_users_with_int_birth_date
)
, mst_users_with_category as (
    select user_id
         , sex
         , age
         , concat(case 
                    when 20 <= age then sex else '' end
                , case
                    when age between 4 and 12 then 'C'
                    when age between 13 and 19 then 'T'
                    when age between 20 and 34 then '1'
                    when age between 35 and 49 then '2'
                    when age >= 50 then '3'
                  end) as category
    from mst_users_with_age
)
select *
from mst_users_with_category;

-- <�ڵ� 11-7>
-- ���ɺ� ������ ��� ���� ����ϱ�
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ���� ǥ��
         , 20170101 as int_specific_date
         -- ���ڿ��� ������ ��������� ���� ǥ������ ��ȯ�ϱ�
         , cast(replace(substr(birth_date, 1, 10), '-', '') as integer) as int_birth_date
    from mst_users
)
, mst_users_with_age as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         , int_specific_date
         , int_birth_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ����
         , floor((int_specific_date - int_birth_date) / 10000) as age
    from mst_users_with_int_birth_date
)
, mst_users_with_category as (
    select user_id
         , sex
         , age
         , concat(case 
                    when 20 <= age then sex else '' end
                , case
                    when age between 4 and 12 then 'C'
                    when age between 13 and 19 then 'T'
                    when age between 20 and 34 then '1'
                    when age between 35 and 49 then '2'
                    when age >= 50 then '3'
                  end) as category
    from mst_users_with_age
)
select category
     , count(1) as user_count
from mst_users_with_category
group by category;

-- <�ڵ� 11-8>
-- ���ɺ� ���а� ī�װ��� �����ϱ�
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ���� ǥ��
         , 20170101 as int_specific_date
         -- ���ڿ��� ������ ��������� ���� ǥ������ ��ȯ�ϱ�
         , cast(replace(substr(birth_date, 1, 10), '-', '') as integer) as int_birth_date
    from mst_users
)
, mst_users_with_age as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         , int_specific_date
         , int_birth_date
         -- Ư�� ��¥(2017�� 1�� 1��)�� ����
         , floor((int_specific_date - int_birth_date) / 10000) as age
    from mst_users_with_int_birth_date
)
, mst_users_with_category as (
    select user_id
         , sex
         , age
         , concat(case 
                    when 20 <= age then sex else '' end
                , case
                    when age between 4 and 12 then 'C'
                    when age between 13 and 19 then 'T'
                    when age between 20 and 34 then '1'
                    when age between 35 and 49 then '2'
                    when age >= 50 then '3'
                  end) as category
    from mst_users_with_age
)
select p.categorys as product_category
     , u.category as user_category
     , count(*) as purchase_count
from action_log p
join mst_users_with_category u on p.user_id = u.user_id
-- ���� �α׸� �����ϱ�
where action = 'purchase'
group by p.categorys, u.category
order by p.categorys, u.category;

-- <�ڵ� 11-9>
-- �� �ֿ� ��ĥ ���Ǿ������� �����ϱ�
with action_log_with_dt as (
    select sessions
         , user_id
         , action
         , categorys
         , products
         , amount
         -- Ÿ�ӽ��������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
)
, action_day_count_per_user as (
    select user_id
         , count(distinct dt) as action_day_count
    from action_log_with_dt
    -- 2016�� 11�� 1�Ϻ��� 11�� 7�ϱ����� �� �� ������ ������� ����
    where dt between '2016-11-01' and '2016-11-07'
    group by user_id
)
select action_day_count
     , count(distinct user_id) as user_count
from action_day_count_per_user
group by action_day_count
order by action_day_count;

-- <�ڵ� 11-10>
-- ������� �����񴩰踦 ����ϱ�
with action_log_with_dt as (
    select sessions
         , user_id
         , action
         , categorys
         , products
         , amount
         -- Ÿ�ӽ��������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
)
, action_day_count_per_user as (
    select user_id
         , count(distinct dt) as action_day_count
    from action_log_with_dt
    -- 2016�� 11�� 1�Ϻ��� 11�� 7�ϱ����� �� �� ������ ������� ����
    where dt between '2016-11-01' and '2016-11-07'
    group by user_id
)
select action_day_count
     , count(distinct user_id) as user_count
     
     -- ������
     , 100.0 * count(distinct user_id) / sum(count(distinct user_id)) over() as composition_ratio
     
     -- �����񴩰�
     , 100.0 * sum(count(distinct user_id))
                over(order by action_day_count
                rows between unbounded preceding and current row) 
       / sum(count(distinct user_id)) over() as cumulative_ratio
from action_day_count_per_user
group by action_day_count
order by action_day_count;

-- <�ڵ� 11-11>
-- ����ڵ��� �׼� �÷��׸� �����ϱ�
with user_action_flag as (
    -- ����ڰ� �׼��� ������ 1, �� ������ 0���� �÷��� ���̱�
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
select *
from user_action_flag;

-- <�ڵ� 11-12>
-- ��� �׼� ���տ� ���� ����� �� ����ϱ�1
-- cube �Լ��� ���!
-- cube�� group by������ ���� ����ϸ� ��� ����� ���� ������ش�.
with user_action_flag as (
    -- ����ڰ� �׼��� ������ 1, �� ������ 0���� �÷��� ���̱�
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- cube�� ����ؼ� ��� �׼� ���� ���ϱ�
    select has_purchase
         , has_review
         , has_favorite
         , count(1) as users
    from user_action_flag
    group by cube(has_purchase, has_review, has_favorite)
)
select *
from action_venn_diagram
order by has_purchase, has_review, has_favorite;

-- <�ڵ� 11-13>
-- ��� �׼� ���տ� ���� ����� �� ����ϱ�2
-- cube ������ ������� �ʰ� ǥ�� SQL ���������� �ۼ�!
with user_action_flag as (
    -- ����ڰ� �׼��� ������ 1, �� ������ 0���� �÷��� ���̱�
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- ��� �׼� ������ ���������� ���ϰ� union all�� ����
    
    -- 3���� �׼��� ��� �� ���
    select has_purchase
         , has_review
         , has_favorite
         , count(1) as users
    from user_action_flag
    group by has_purchase, has_review, has_favorite
    
    -- 3���� �׼� �߿��� 2���� �׼��� �� ���
    union all
        select NULL as has_purchase
             , has_review
             , has_favorite
             , count(1) as users
        from user_action_flag
        group by has_review, has_favorite
    union all
        select has_purchase
             , NULL as has_review
             , has_favorite
             , count(1) as users
        from user_action_flag
        group by has_purchase, has_favorite
    union all
        select has_purchase
             , has_review
             , NULL as has_favorite
             , count(1) as users
        from user_action_flag
        group by has_purchase, has_review
        
    -- 3���� �׼� �߿��� 1���� �׼��� �� ���
    union all
        select null as has_purchase
             , null as has_review
             , has_favorite
             , count(1) as users
        from user_action_flag
        group by has_favorite
    union all
        select NULL as has_purchase
             , has_review
             , NULL as has_favorite
             , count(1) as users
        from user_action_flag
        group by has_review
    union all
        select has_purchase
             , NULL as has_review
             , NULL as has_favorite
             , count(1) as users
        from user_action_flag
        group by has_purchase
    
    -- �׼ǰ� ������� ��� ����� ����
    union all
        select NULL as has_purchase
             , NULL as has_review
             , NULL as has_favorite
             , count(1) as users
        from user_action_flag
)
select *
from action_venn_diagram
order by has_purchase, has_review, has_favorite;

-- <�ڵ� 11-15>
-- �� ���̾�׷��� ����� ���� �����͸� �����ϱ�
with user_action_flag as (
    -- ����ڰ� �׼��� ������ 1, �� ������ 0���� �÷��� ���̱�
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- cube�� ����ؼ� ��� �׼� ���� ���ϱ�
    select has_purchase
         , has_review
         , has_favorite
         , count(1) as users
    from user_action_flag
    group by cube(has_purchase, has_review, has_favorite)
)
select
     -- 0, 1 �÷��׸� ���ڿ��� �����ϱ�
       case has_purchase
        when 1 then 'purchase' when 0 then 'not purchase' else 'any'
       end as has_purchase
     , case has_review
        when 1 then 'review' when 0 then 'not review' else 'any'
       end as has_review
     , case has_favorite
        when 1 then 'favorite' when 0 then 'not favorite' else 'any'
       end as has_favorite
     , users
     -- ��ü ����� ���� ������� ���� ���ϱ�
     , 100.0 * users
       / nullif(
       -- ��� �׼��� NULL�� ����� ���� ��ü ����� ���� ��Ÿ���Ƿ�
       -- �ش� ���ڵ��� ����� ���� Window �Լ��� ���ϱ�
        sum(case 
              when has_purchase is null and has_review is null and has_favorite is null
              then users else 0 end) over()
       , 0) as ratio
from action_venn_diagram
order by has_purchase, has_review, has_favorite;

-- <�ڵ� 11-16>
-- ���ž��� ���� ������ ����� �׷��� 10����ϱ�
with user_purchase_amount as (
    select user_id
         , sum(amount) as purchase_amount
    from action_log
    where action = 'purchase'
    group by user_id
)
, users_with_decile as (
    select user_id
         , purchase_amount
         , ntile(10) over(order by purchase_amount desc) as decile
    from user_purchase_amount
)
select *
from users_with_decile;

-- <�ڵ� 11-17>
-- 10������ Decile���� �����ϱ�
with user_purchase_amount as (
    select user_id
         , sum(amount) as purchase_amount
    from action_log
    where action = 'purchase'
    group by user_id
)
, users_with_decile as (
    select user_id
         , purchase_amount
         , ntile(10) over(order by purchase_amount desc) as decile
    from user_purchase_amount
)
, decile_with_purchase_amount as (
    select decile
         , sum(purchase_amount) as amount
         , avg(purchase_amount) as avg_amount
         , sum(sum(purchase_amount)) over(order by decile) as cumulative_amount
         , sum(sum(purchase_amount)) over() as total_amount
    from users_with_decile
    group by decile
)
select *
from decile_with_purchase_amount;

-- <�ڵ� 11-18>
-- ���ž��� ���� decile ������ ������� �����񴩰踦 ����ϱ�
with user_purchase_amount as (
    select user_id
         , sum(amount) as purchase_amount
    from action_log
    where action = 'purchase'
    group by user_id
)
, users_with_decile as (
    select user_id
         , purchase_amount
         , ntile(10) over(order by purchase_amount desc) as decile
    from user_purchase_amount
)
, decile_with_purchase_amount as (
    select decile
         , sum(purchase_amount) as amount
         , avg(purchase_amount) as avg_amount
         , sum(sum(purchase_amount)) over(order by decile) as cumulative_amount
         , sum(sum(purchase_amount)) over() as total_amount
    from users_with_decile
    group by decile
)
select decile 
     , amount
     , avg_amount
     , round(100.0 * amount / total_amount, 2) as total_ratio
     , round(100.0 * cumulative_amount / total_amount, 2) as cumulative_ratio
from decile_with_purchase_amount;

-- <�ڵ� 11-19>
-- ����ں��� RFM�� �����ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
select *
from user_rfm;

-- <�ڵ� 11-20>
-- ����ڵ��� RFM ��ũ�� ����ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
, user_rfm_rank as (
    select user_id
         , recent_date
         , recency
         , frequency
         , monetary
         , case
            when recency < 14 then 5
            when recency < 28 then 4
            when recency < 60 then 3
            when recency < 90 then 2
            else 1
           end as r
         , case
            when 20 <= frequency then 5
            when 10 <= frequency then 4
            when 5 <= frequency then 3
            when 2 <= frequency then 2
            when 1 = frequency then 1
           end as f
         , case
            when 3000000 <= monetary then 5
            when 1000000 <= monetary then 4
            when 300000 <= monetary then 3
            when 50000 <= monetary then 2
            else 1
           end as m
    from user_rfm
)
select *
from user_rfm_rank;

-- <�ڵ� 11-21>
-- �� �׷��� ��� ���� Ȯ���ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
, user_rfm_rank as (
    select user_id
         , recent_date
         , recency
         , frequency
         , monetary
         , case
            when recency < 14 then 5
            when recency < 28 then 4
            when recency < 60 then 3
            when recency < 90 then 2
            else 1
           end as r
         , case
            when 20 <= frequency then 5
            when 10 <= frequency then 4
            when 5 <= frequency then 3
            when 2 <= frequency then 2
            when 1 = frequency then 1
           end as f
         , case
            when 3000000 <= monetary then 5
            when 1000000 <= monetary then 4
            when 300000 <= monetary then 3
            when 50000 <= monetary then 2
            else 1
           end as m
    from user_rfm
)
, mst_rfm_index as (
    -- 1���� 5������ ���ڸ� ������ ���̺� �����
    select 1 as rfm_index from dual
    union all
    select 2 as rfm_index from dual
    union all
    select 3 as rfm_index from dual
    union all
    select 4 as rfm_index from dual
    union all
    select 5 as rfm_index from dual
)
, rfm_flag as (
    select m.rfm_index
         , case when m.rfm_index = r.r then 1 else 0 end as r_flag
         , case when m.rfm_index = r.f then 1 else 0 end as f_flag
         , case when m.rfm_index = r.m then 1 else 0 end as m_flag
    from mst_rfm_index m
    cross join user_rfm_rank r
)
select rfm_index
     , sum(r_flag) as r
     , sum(f_flag) as f
     , sum(m_flag) as m
from rfm_flag
group by rfm_index
order by rfm_index desc;

-- <�ڵ� 11-22>
-- ���� ��ũ�� ����ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
, user_rfm_rank as (
    select user_id
         , recent_date
         , recency
         , frequency
         , monetary
         , case
            when recency < 14 then 5
            when recency < 28 then 4
            when recency < 60 then 3
            when recency < 90 then 2
            else 1
           end as r
         , case
            when 20 <= frequency then 5
            when 10 <= frequency then 4
            when 5 <= frequency then 3
            when 2 <= frequency then 2
            when 1 = frequency then 1
           end as f
         , case
            when 3000000 <= monetary then 5
            when 1000000 <= monetary then 4
            when 300000 <= monetary then 3
            when 50000 <= monetary then 2
            else 1
           end as m
    from user_rfm
)
select r + f + m as total_rank
     , r
     , f
     , m
     , count(user_id)
from user_rfm_rank
group by r, f, m
order by total_rank desc, r desc, f desc, m desc;

-- <�ڵ� 11- 23>
-- ���� ��ũ���� ����� ���� �����ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
, user_rfm_rank as (
    select user_id
         , recent_date
         , recency
         , frequency
         , monetary
         , case
            when recency < 14 then 5
            when recency < 28 then 4
            when recency < 60 then 3
            when recency < 90 then 2
            else 1
           end as r
         , case
            when 20 <= frequency then 5
            when 10 <= frequency then 4
            when 5 <= frequency then 3
            when 2 <= frequency then 2
            when 1 = frequency then 1
           end as f
         , case
            when 3000000 <= monetary then 5
            when 1000000 <= monetary then 4
            when 300000 <= monetary then 3
            when 50000 <= monetary then 2
            else 1
           end as m
    from user_rfm
)
select r + f + m as total_rank
     , count(user_id)
from user_rfm_rank
group by r + f + m
order by r + f + m desc;

-- <�ڵ� 11-24>
-- R�� F�� ����ؼ� 2���� ����� ���� ����� ���� �����ϱ�
with purchase_log as (
    select user_id
         , amount
         -- Ÿ�ӽ������� ������� ��¥ �����ϱ�
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "���� ���� - ���� �ֱ� ����" ���� ����
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
, user_rfm_rank as (
    select user_id
         , recent_date
         , recency
         , frequency
         , monetary
         , case
            when recency < 14 then 5
            when recency < 28 then 4
            when recency < 60 then 3
            when recency < 90 then 2
            else 1
           end as r
         , case
            when 20 <= frequency then 5
            when 10 <= frequency then 4
            when 5 <= frequency then 3
            when 2 <= frequency then 2
            when 1 = frequency then 1
           end as f
         , case
            when 3000000 <= monetary then 5
            when 1000000 <= monetary then 4
            when 300000 <= monetary then 3
            when 50000 <= monetary then 2
            else 1
           end as m
    from user_rfm
)
select concat('r_', r) as r_rank
     , count(case when f = 5 then 1 end) as f_5
     , count(case when f = 4 then 1 end) as f_4
     , count(case when f = 3 then 1 end) as f_3
     , count(case when f = 2 then 1 end) as f_2
     , count(case when f = 1 then 1 end) as f_1
from user_rfm_rank
group by r
order by r_rank desc;