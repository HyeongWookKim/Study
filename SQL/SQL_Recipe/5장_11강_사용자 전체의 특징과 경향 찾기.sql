-- <코드 11-1>
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

-- 액션 수와 비율을 계산하기
with stats as (
    -- 로그 전체의 유니크 사용자 수 구하기
    select count(distinct sessions) as total_uu
    from action_log
)
select l.action
     -- 액션 UU
     , count(distinct l.sessions) as action_uu
     -- 액션의 수
     , count(1) as action_count
     -- 전체 UU
     , s.total_uu
     -- 사용률: <액션 UU> / <전체 UU>
     , 100.0 * count(distinct l.sessions) / s.total_uu as usage_rate
     -- 1인당 액션 수: <액션 수> / <액션 UU>
     , round(1.0 * count(1) / count(distinct l.sessions), 2) as count_per_user
from action_log l
-- 로그 전체의 유니크 사용자 수를 모든 레코드에 결합하기
cross join stats s
group by l.action, s.total_uu;

-- <코드 11-2>
-- 로그인 상태를 판별하기
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- user_id가 NULL 또는 빈 문자가 아닌 경우 login이라고 판정하기
         , case 
            when coalesce(user_id, ' ') <> ' ' then 'login' else 'guest'
           end as login_status
    from action_log
)
select *
from action_log_with_status;

-- <코드 11-3>
-- 로그인 상태에 따라 액션 수 등을 따로 집계하기
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- user_id가 NULL 또는 빈 문자가 아닌 경우 login이라고 판정하기
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

-- <코드 11-4>
-- 회원 상태를 판별하기
with action_log_with_status as (
    select sessions
         , user_id
         , action
         -- 로그를 타임스탬프 순서로 나열하고, 한 번이라도 로그인한 사용자일 경우,
         -- 이후의 모든 로그 상태를 member로 설정
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

-- <코드 11-5>
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

-- 사용자의 생일을 계산하기
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- 특정 날짜(2017년 1월 1일)의 정수 표현
         , 20170101 as int_specific_date
         -- 문자열로 구성된 생년월일을 정수 표현으로 변환하기
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
         -- 특정 날짜(2017년 1월 1일)의 나이
         , floor((int_specific_date - int_birth_date) / 10000) as age
    from mst_users_with_int_birth_date
)
select user_id
     , sex
     , birth_date
     , age
from mst_users_with_age;

-- <코드 11-6>
-- 성별과 연령으로 연령별 구분을 계산하기
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- 특정 날짜(2017년 1월 1일)의 정수 표현
         , 20170101 as int_specific_date
         -- 문자열로 구성된 생년월일을 정수 표현으로 변환하기
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
         -- 특정 날짜(2017년 1월 1일)의 나이
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

-- <코드 11-7>
-- 연령별 구분의 사람 수를 계산하기
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- 특정 날짜(2017년 1월 1일)의 정수 표현
         , 20170101 as int_specific_date
         -- 문자열로 구성된 생년월일을 정수 표현으로 변환하기
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
         -- 특정 날짜(2017년 1월 1일)의 나이
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

-- <코드 11-8>
-- 연령별 구분과 카테고리를 집계하기
with mst_users_with_int_birth_date as (
    select user_id
         , sex
         , birth_date
         , register_date
         , register_device
         , withdraw_date
         -- 특정 날짜(2017년 1월 1일)의 정수 표현
         , 20170101 as int_specific_date
         -- 문자열로 구성된 생년월일을 정수 표현으로 변환하기
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
         -- 특정 날짜(2017년 1월 1일)의 나이
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
-- 구매 로그만 선택하기
where action = 'purchase'
group by p.categorys, u.category
order by p.categorys, u.category;

-- <코드 11-9>
-- 한 주에 며칠 사용되었는지를 집계하기
with action_log_with_dt as (
    select sessions
         , user_id
         , action
         , categorys
         , products
         , amount
         -- 타임스탬프에서 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
)
, action_day_count_per_user as (
    select user_id
         , count(distinct dt) as action_day_count
    from action_log_with_dt
    -- 2016년 11월 1일부터 11월 7일까지의 한 주 동안을 대상으로 지정
    where dt between '2016-11-01' and '2016-11-07'
    group by user_id
)
select action_day_count
     , count(distinct user_id) as user_count
from action_day_count_per_user
group by action_day_count
order by action_day_count;

-- <코드 11-10>
-- 구성비와 구성비누계를 계산하기
with action_log_with_dt as (
    select sessions
         , user_id
         , action
         , categorys
         , products
         , amount
         -- 타임스탬프에서 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
)
, action_day_count_per_user as (
    select user_id
         , count(distinct dt) as action_day_count
    from action_log_with_dt
    -- 2016년 11월 1일부터 11월 7일까지의 한 주 동안을 대상으로 지정
    where dt between '2016-11-01' and '2016-11-07'
    group by user_id
)
select action_day_count
     , count(distinct user_id) as user_count
     
     -- 구성비
     , 100.0 * count(distinct user_id) / sum(count(distinct user_id)) over() as composition_ratio
     
     -- 구성비누계
     , 100.0 * sum(count(distinct user_id))
                over(order by action_day_count
                rows between unbounded preceding and current row) 
       / sum(count(distinct user_id)) over() as cumulative_ratio
from action_day_count_per_user
group by action_day_count
order by action_day_count;

-- <코드 11-11>
-- 사용자들의 액션 플래그를 집계하기
with user_action_flag as (
    -- 사용자가 액션을 했으면 1, 안 했으면 0으로 플래그 붙이기
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
select *
from user_action_flag;

-- <코드 11-12>
-- 모든 액션 조합에 대한 사용자 수 계산하기1
-- cube 함수를 사용!
-- cube를 group by절에서 같이 사용하면 모든 경우의 수를 출력해준다.
with user_action_flag as (
    -- 사용자가 액션을 했으면 1, 안 했으면 0으로 플래그 붙이기
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- cube를 사용해서 모든 액션 조합 구하기
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

-- <코드 11-13>
-- 모든 액션 조합에 대한 사용자 수 계산하기2
-- cube 구문을 사용하지 않고 표준 SQL 구문만으로 작성!
with user_action_flag as (
    -- 사용자가 액션을 했으면 1, 안 했으면 0으로 플래그 붙이기
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- 모든 액션 조합을 개별적으로 구하고 union all로 결합
    
    -- 3개의 액션을 모두 한 경우
    select has_purchase
         , has_review
         , has_favorite
         , count(1) as users
    from user_action_flag
    group by has_purchase, has_review, has_favorite
    
    -- 3개의 액션 중에서 2개의 액션을 한 경우
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
        
    -- 3개의 액션 중에서 1개의 액션을 한 경우
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
    
    -- 액션과 관계없이 모든 사용자 집계
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

-- <코드 11-15>
-- 벤 다이어그램을 만들기 위해 데이터를 가공하기
with user_action_flag as (
    -- 사용자가 액션을 했으면 1, 안 했으면 0으로 플래그 붙이기
    select user_id
         , sign(sum(case when action = 'purchase' then 1 else 0 end)) as has_purchase
         , sign(sum(case when action = 'review' then 1 else 0 end)) as has_review
         , sign(sum(case when action = 'favorite' then 1 else 0 end)) as has_favorite
    from action_log
    group by user_id
)
, action_venn_diagram as (
    -- cube를 사용해서 모든 액션 조합 구하기
    select has_purchase
         , has_review
         , has_favorite
         , count(1) as users
    from user_action_flag
    group by cube(has_purchase, has_review, has_favorite)
)
select
     -- 0, 1 플래그를 문자열로 가공하기
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
     -- 전체 사용자 수를 기반으로 비율 구하기
     , 100.0 * users
       / nullif(
       -- 모든 액션이 NULL인 사용자 수가 전체 사용자 수를 나타내므로
       -- 해당 레코드의 사용자 수를 Window 함수로 구하기
        sum(case 
              when has_purchase is null and has_review is null and has_favorite is null
              then users else 0 end) over()
       , 0) as ratio
from action_venn_diagram
order by has_purchase, has_review, has_favorite;

-- <코드 11-16>
-- 구매액이 많은 순서로 사용자 그룹을 10등분하기
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

-- <코드 11-17>
-- 10분할한 Decile들을 집계하기
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

-- <코드 11-18>
-- 구매액이 많은 decile 순서로 구성비와 구성비누계를 계산하기
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

-- <코드 11-19>
-- 사용자별로 RFM을 집계하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
         , current_date - cast(max(dt) as date) as recency
         , count(dt) as frequency
         , sum(amount) as monetary
    from purchase_log
    group by user_id
)
select *
from user_rfm;

-- <코드 11-20>
-- 사용자들의 RFM 랭크를 계산하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
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

-- <코드 11-21>
-- 각 그룹의 사람 수를 확인하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
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
    -- 1부터 5까지의 숫자를 가지는 테이블 만들기
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

-- <코드 11-22>
-- 통합 랭크를 계산하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
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

-- <코드 11- 23>
-- 종합 랭크별로 사용자 수를 집계하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
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

-- <코드 11-24>
-- R과 F를 사용해서 2차원 사용자 층의 사용자 수를 집계하기
with purchase_log as (
    select user_id
         , amount
         -- 타임스탬프를 기반으로 날짜 추출하기
         , substr(stamp, 1, 10) as dt
    from action_log
    where action = 'purchase'
)
, user_rfm as (
    select user_id
         , max(dt) as recent_date
         -- "현재 일자 - 가장 최근 일자" 빼기 연산
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