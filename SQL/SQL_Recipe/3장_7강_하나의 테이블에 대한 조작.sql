-- <�ڵ� 7-1>
--DROP TABLE review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review VALUES ('U001', 'A001', 4.0);
INSERT INTO review VALUES ('U001', 'A002', 5.0);
INSERT INTO review VALUES ('U001', 'A003', 5.0);
INSERT INTO review VALUES ('U002', 'A001', 3.0);
INSERT INTO review VALUES ('U002', 'A002', 3.0);
INSERT INTO review VALUES ('U002', 'A003', 4.0);
INSERT INTO review VALUES ('U003', 'A001', 5.0);
INSERT INTO review VALUES ('U003', 'A002', 4.0);
INSERT INTO review VALUES ('U003', 'A003', 4.0);

-- ���� �Լ��� ����ؼ� ���̺� ��ü�� Ư¡���� ����ϱ�
select count(*) total_count
     , count(distinct user_id) as user_count
     , count(distinct product_id) as product_count
     , sum(score) as sum
     , round(avg(score), 2) as avg
     , max(score) as max
     , min(score) as min
from review;

-- <�ڵ� 7-2>
-- ����� ������� �����͸� �����ϰ� ���� �Լ��� �����ϱ�
select user_id
     , count(*) total_count
     , count(distinct product_id) as product_count
     , sum(score) as sum
     , round(avg(score), 2) as avg
     , max(score) as max
     , min(score) as min
from review
group by user_id;

-- <�ڵ� 7-3>
-- ���� �Լ��� ����ؼ� ���� �Լ��� ����� ���� ���� ���ÿ� �ٷ��
select user_id
     , product_id
     -- ���� ���� ����
     , score
     -- ��ü ��� ���� ����
     , round(avg(score) over(), 2) as avg_score
     -- ������� ��� ���� ����
     , round(avg(score) over(partition by user_id), 2) as user_avg_score
     -- ���� ���� ������ ����� ��� ���� ������ ����
     , round(score - avg(score) over(partition by user_id), 2) as user_avg_score_diff
from review;

-- <�ڵ� 7-4>
--DROP TABLE popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products VALUES ('A001', 'action', 94);
INSERT INTO popular_products VALUES ('A002', 'action', 81);
INSERT INTO popular_products VALUES ('A003', 'action', 78);
INSERT INTO popular_products VALUES ('A004', 'action', 64);
INSERT INTO popular_products VALUES ('D001', 'drama' , 90);
INSERT INTO popular_products VALUES ('D002', 'drama' , 82);
INSERT INTO popular_products VALUES ('D003', 'drama' , 78);
INSERT INTO popular_products VALUES ('D004', 'drama' , 58);

-- ���� �Լ��� order by ������ ����ؼ� ���̺� ������ ������ �ٷ��
select product_id
     , score
     
--     -- ���� ������ ������ ������ ���� (�� �ڵ� �� ����..)
--     , row_number() over(order by score desc) as row
     
     -- ���� ������ ����ؼ� ������ ����
     , rank() over(order by score desc) as rank
     
     -- ���� ������ ���� �� ���� ���� ������ �ִ� ������ �ǳ� �ٰ� ������ ����
     , dense_rank() over(order by score desc) as dense_rank
     
     -- ���� �ຸ�� �տ� �ִ� ���� �� �����ϱ�
     , lag(product_id) over(order by score desc) as lag1
     , lag(product_id, 2) over(order by score desc) as lag2
     
     -- ���� �ຸ�� �ڿ� �ִ� ���� �� �����ϱ�
     , lead(product_id) over(order by score desc) as lead1
     , lead(product_id, 2) over(order by score desc) as lead2
from popular_products;
--order by row;

-- <�ڵ� 7-5>
-- order by ������ ���� �Լ��� �����ؼ� ����ϱ�
select product_id
     , score
     
--     -- ���� ������ ������ ������ ���� (�� �ڵ� �� ����..)
--     , row_number() over(order by score desc) as row
     
     -- ���� ���������� ���� ���� ����ϱ�
     , sum(score) over(order by score desc
                    rows between unbounded preceding and current row) as cum_score
    
     -- ���� ��� �� ���� ���� ���� ���� ������� ��� ���� ����ϱ�
     , round(avg(score) over(order by score desc
                            rows between 1 preceding and 1 following), 2) as local_avg
     
     -- ������ ���� ��ǰ ID �����ϱ�
     , first_value(product_id) over(order by score desc
                                rows between unbounded preceding and unbounded following) as first_value
     
     -- ������ ���� ��ǰ ID �����ϱ�
     , last_value(product_id) over(order by score desc
                                rows between unbounded preceding and unbounded following) as last_value
from popular_products;
--order by row;Data Modeler ����


-- <�ڵ� 7-7>
-- ���� ������ ������ ��ǰ ID�� �����ϱ�
select category
     , product_id
     , score
     
--     -- ī�װ����� ���� ������ �����ϰ� ������ ������ ����(�� �ڵ� �� ����..)
--     , row_number() over(partition by category order by score desc) as row
     
     -- ī�װ����� ���� ������ �㰡�ϰ� ������ ����
     , rank() over(partition by category order by score desc) as rank
     
     -- ī�װ����� ���� ������ ���� ��, ���� ���� ������ �ִ� ������ �ǳ� �ٰ� ������ ����
     , dense_rank() over(partition by category order by score desc) as dense_rank
from popular_products;
--order by category, row;

-- <�ڵ� 7-8>
-- ī�װ����� ���� ���� 2�������� ��ǰ�� �����ϱ�
select *
-- ���� ���� ���ο��� ���� ����ϱ�
from (select category
           , product_id
           , score
           -- ī�װ����� ���� ������ ������ ������ ����
           , row_number() over(partition by category order by score desc) as rank
      from popular_products) popular_producst_with_rank
-- �ܺ� �������� ���� Ȱ���ؼ� �����ϱ�
where rank <= 2
order by category, rank;

-- <�ڵ� 7-9>
-- ī�װ��� ���� �ֻ��� ��ǰ�� �����ϱ�
select distinct category
     -- ī�װ����� ���� �ֻ��� ��ǰ ID �����ϱ�
     , first_value(product_id) over(partition by category order by score desc
                                rows between unbounded preceding and unbounded following) as product_id
from popular_products;

-- <�ڵ� 7-10>
--DROP TABLE daily_kpi;
CREATE TABLE daily_kpi (
    dt        varchar(255)
  , indicator varchar(255)
  , val       integer
);

INSERT INTO daily_kpi VALUES ('2017-01-01', 'impressions', 1800);
INSERT INTO daily_kpi VALUES ('2017-01-01', 'sessions'   ,  500);
INSERT INTO daily_kpi VALUES ('2017-01-01', 'users'      ,  200);
INSERT INTO daily_kpi VALUES ('2017-01-02', 'impressions', 2000);
INSERT INTO daily_kpi VALUES ('2017-01-02', 'sessions'   ,  700);
INSERT INTO daily_kpi VALUES ('2017-01-02', 'users'      ,  250);

-- ������ ����� ��ǥ ���� ���� ��ȯ�ϱ�
select dt
     , max(case when indicator = 'impressions' then val end) as impressions
     , max(case when indicator = 'sessions' then val end) as sessions
     , max(case when indicator = 'users' then val end) as users
from daily_kpi
group by dt
order by dt;

-- <�ڵ� 7-11>
--DROP TABLE purchase_detail_log;
CREATE TABLE purchase_detail_log (
    purchase_id integer
  , product_id  varchar(255)
  , price       integer
);

INSERT INTO purchase_detail_log VALUES (100001, 'A001', 3000);
INSERT INTO purchase_detail_log VALUES (100001, 'A002', 4000);
INSERT INTO purchase_detail_log VALUES (100001, 'A003', 2000);
INSERT INTO purchase_detail_log VALUES (100002, 'D001', 5000);
INSERT INTO purchase_detail_log VALUES (100002, 'D002', 3000);
INSERT INTO purchase_detail_log VALUES (100003, 'A001', 3000);

-- ���� �����ؼ� ��ǥ�� ���е� ���ڿ��� ��ȯ�ϱ�
select purchase_id
     -- ��ǰ ID�� �迭�� �����ϰ� ��ǥ�� ���е� ���ڿ��� ��ȯ�ϱ�
     -- RedShift�� ���� listagg�� ���!!
     , listagg(product_id, ',') as product_ids
from purchase_detail_log
group by purchase_id
order by purchase_id;

-- <�ڵ� 7-12>
-- �Ϸ� ��ȣ�� ���� �ǹ� ���̺��� ����ؼ� ������ ��ȯ�ϱ�
select q.year
     -- q1���� q4������ ���̺� �̸� ����ϱ�
     , case
        when p.idx = 1 then 'q1'
        when p.idx = 2 then 'q2'
        when p.idx = 3 then 'q3'
        when p.idx = 4 then 'q4'
       end as quarter
     -- q1���� q4������ ���� ����ϱ�
     , case
        when p.idx = 1 then q.q1
        when p.idx = 2 then q.q2
        when p.idx = 3 then q.q3
        when p.idx = 4 then q.q4
       end as sales
from quarterly_sales  q
cross join (select 1 as idx from dual
            union all select 2 as idx from dual
            union all select 3 as idx from dual
            union all select 4 as idx from dual
            ) p
order by q.year, p.idx;

-- <�ڵ� 7-16>
-- �Ϸ� ��ȣ�� ���� �ǹ� ���̺� �����
select *
from (select 1 as idx from dual
      union all select 2 as idx from dual
      union all select 3 as idx from dual
      ) pivot;

-- <�ڵ� 7-17>      
-- split_part �Լ��� ��� ��(�� �ڵ� �� ����..)
select split_part('A001,A002,A003', ',', 1) as part_1
     , split_part('A001,A002,A003', ',', 2) as part_2
     , split_part('A001,A002,A003', ',', 3) as part_3;
     
-- <�ڵ� 7-18>
--DROP TABLE purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , product_ids varchar(255)
);

INSERT INTO purchase_log VALUES (100001, 'A001,A002,A003');
INSERT INTO purchase_log VALUES (100002, 'D001,D002');
INSERT INTO purchase_log VALUES (100003, 'A001');

-- ���� ���� ���̸� ����ؼ� ��ǰ ���� ����ϱ�
select purchase_id
     , product_ids
     -- ��ǰ ID ���ڿ��� ������� ��ǥ�� �����ϰ�, ���� ���� ���̸� ����ؼ� ��ǰ �� ���ϱ�
     , 1 + length(product_ids) - length(replace(product_ids, ',', '')) as product_num
from purchase_log;

-- <�ڵ� 7-19>
-- �ǹ� ���̺��� ����ؼ� ���ڿ��� ������ �����ϱ�
select l.purchase_id
     , l.product_ids
     -- ��ǰ ����ŭ ���� ���̱�
     , p.idx
--     -- ���ڿ��� ��ǥ�� �����ؼ� �����ϰ�, idx��° ��� �����ϱ�(�� �ڵ� �� ����..)
--     , split_part(l.product_ids, ',', p.idx) as product_id
from purchase_log l
join (select 1 as idx from dual
      union all select 2 as idx from dual
      union all select 3 as idx from dual
      ) p
      -- �ǹ� ���̺��� id�� ��ǰ �� ������ ��� �����ϱ�
      on p.idx <= (1 + length(l.product_ids) - length(replace(l.product_ids, ',', '')))
order by l.purchase_id;