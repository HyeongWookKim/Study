-- <�ڵ� 10-1>
--DROP TABLE purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48291, 'usr33395', 'lad533', 37300,  'ladys_fashion', 'bag');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48291, 'usr33395', 'lad329', 97300,  'ladys_fashion', 'jacket');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48291, 'usr33395', 'lad102', 114600, 'ladys_fashion', 'jacket');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48291, 'usr33395', 'lad886', 33300,  'ladys_fashion', 'bag');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48292, 'usr52832', 'dvd871', 32800,  'dvd'          , 'documentary');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48292, 'usr52832', 'gam167', 26000,  'game'         , 'accessories');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48292, 'usr52832', 'lad289', 57300,  'ladys_fashion', 'bag');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48293, 'usr28891', 'out977', 28600,  'outdoor'      , 'camp');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48293, 'usr28891', 'boo256', 22500,  'book'         , 'business');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48293, 'usr28891', 'lad125', 61500,  'ladys_fashion', 'jacket');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48294, 'usr33604', 'mem233', 116300, 'mens_fashion' , 'jacket');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48294, 'usr33604', 'cd477' , 25800,  'cd'           , 'classic');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48294, 'usr33604', 'boo468', 31000,  'book'         , 'business');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48294, 'usr33604', 'foo402', 48700,  'food'         , 'meats');
INSERT INTO purchase_detail_log VALUES ('2017-01-18', 48295, 'usr38013', 'lad147', 96100,  'ladys_fashion', 'jacket');

-- ī�װ��� ����� �Ұ踦 ���ÿ� ���ϱ�
with sub_category_amount as (
    -- �Һз�(�� ī�װ�)�� ���� �����ϱ�
    select category
         , sub_category as sub_category
         , sum(price) as amount
    from purchase_detail_log
    group by category, sub_category
)
, category_amount as (
    -- ��з�(�� ī�װ�)�� ���� �����ϱ�
    select category
         -- 'all' �����θ� ä���� sub_category �÷� ����
         , 'all' as sub_category
         , sum(price) as amount
    from purchase_detail_log
    group by category
)
, total_amount as (
    -- ��ü ���� �����ϱ�
    select 'all' as category
         , 'all' as sub_category
         , sum(price) as amount
    from purchase_detail_log
)
select category
     , sub_category
     , amount
from sub_category_amount
union all
select category
     , sub_category
     , amount
from category_amount
union all
select category
     , sub_category
     , amount
from total_amount;

-- <�ڵ� 10-2>
-- rollup�� ����ؼ� ī�װ��� ����� �Ұ踦 ���ÿ� ���ϱ�
-- <����>
-- coalesce(expr1, expr2, expr3, ��): expr1�� NULL�� �ƴϸ� expr1����, �׷��� ������ COALESCE(expr2, expr3, ��)���� ��ȯ���ش�.
-- NVL �Լ��� ����ϴ�.
select coalesce(category, 'all') as category
     , coalesce(sub_category, 'all') as sub_category
     , sum(price) as amount
from purchase_detail_log
group by rollup(category, sub_category);

-- <�ڵ� 10-3>
-- ���� �����񴩰�� ABC ����� ����ϱ�
-- �Ʒ��� �ڵ带 �������� ���̺��� �ʿ��ѵ�, ���ǻ翡�� �̻��� ���̺��� �������־���(�׷��� ���� ���� �Ұ���..)
with monthly_sales as (
    select category1
         -- �׸� ���� ����ϱ�
         , sum(amount) as amount
    from purchase_log
    -- ��� 1���� ������ �α׸� �������� �ɱ�
    where dt between '2015-12-01' and '2015-12-31'
    group by category1
)
, sales_composition_ratio as (
    select category1
         , amount
         
         -- ������: 100.0 * <�׸� ����> / <��ü ����>
         , 100.0 * amount / sum(amount) over() as composition_ratio
         
         -- �����񴩰�: 100.0 * <�׸� ���� ����> / <��ü ����>
         , 100.0 * sum(amount) over(order by amount desc 
         rows between unbounded preceding and current row)
         / sum(amount) over() as cumulative_ratio
    from monthly_sales
)
select *
     -- �����񴩰� ������ ���� ���� ���̱�
     , case
        when cumulative_ratio between 0 and 70 then 'A'
        when cumulative_ratio between 70 and 90 then 'B'
        when cumulative_ratio between 90 and 100 then 'C'
       end as abc_rank
from sales_composition_ratio
order by amount desc;

-- <�ڵ� 10-4>
-- �� ��Ʈ �ۼ� �� �ʿ��� �����͸� ���ϱ�
-- �Ʒ��� �ڵ带 �������� ���̺��� �ʿ��ѵ�, ���ǻ翡�� �̻��� ���̺��� �������־���
-- �׷��� ����� ����� �ٸ�..
with daily_category_amount as (
    select dt
         , category
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         , sum(price) as amount
    from purchase_detail_log
    group by dt, category
)
, monthly_category_amount as (
    select year || '-' || month as year_month
         -- �Ʒ��� ���� �ۼ��ص� ��!
         -- concat(concat(year, '-'), month) as year_month
         , category
         , sum(amount) as amount
    from daily_category_amount
    group by year, month, category
)
select year_month
     , category
     , amount
     , first_value(amount) over(partition by category
                                order by year_month, category rows unbounded preceding) as base_amount
     , 100.0 * amount / first_value(amount) over(partition by category 
                                                 order by year_month, category rows unbounded preceding) as rate
from monthly_category_amount
order by year_month, category;

-- <�ڵ� 10-5>
-- �ִ�, �ּڰ�, ������ ���ϱ�
with stats as (
    select 
         -- �ݾ��� �ִ�
           max(price) as max_price
         -- �ݾ��� �ּڰ�
         , min(price) as min_price
         -- �ݾ��� ����
         , max(price) - min(price) as range_price
         -- ���� ��
         , 10 as bucket_num
    from purchase_detail_log
)
select *
from stats;

-- <�ڵ� 10-6>
-- �������� ������ ���ϱ�
with stats as (
    select 
         -- �ݾ��� �ִ�
           max(price) as max_price
         -- �ݾ��� �ּڰ�
         , min(price) as min_price
         -- �ݾ��� ����
         , max(price) - min(price) as range_price
         -- ���� ��
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- ����ȭ �ݾ�: ��� �ݾ׿��� �ּ� �ݾ��� �� ��
         , price - min_price as diff
         
         -- ���� ����: �ݾ� ������ ���� ���� ���� ��
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- ���� ����: floor(<����ȭ �ݾ�> / <���� ����>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index�� 1���� �����ϹǷ� 1��ŭ ���ϱ�
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select *
from purchase_log_with_bucket
order by price;

-- <�ڵ� 10-7>
-- ��� ���� ���� ������ ����
with stats as (
    select 
         -- <�ݾ��� �ִ�> + 1
           max(price) + 1 as max_price
         -- �ݾ��� �ּڰ�
         , min(price) as min_price
         -- <�ݾ��� ����> + 1(�Ǽ�)
         , max(price) + 1 - min(price) as range_price
         -- <���� ��>
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- ����ȭ �ݾ�: ��� �ݾ׿��� �ּ� �ݾ��� �� ��
         , price - min_price as diff
         
         -- ���� ����: �ݾ� ������ ���� ���� ���� ��
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- ���� ����: floor(<����ȭ �ݾ�> / <���� ����>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index�� 1���� �����ϹǷ� 1��ŭ ���ϱ�
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select *
from purchase_log_with_bucket
order by price;

-- <�ڵ� 10-8>
-- ������׷��� ���ϱ�
with stats as (
    select 
         -- <�ݾ��� �ִ�> + 1
           max(price) + 1 as max_price
         -- �ݾ��� �ּڰ�
         , min(price) as min_price
         -- <�ݾ��� ����> + 1(�Ǽ�)
         , max(price) + 1 - min(price) as range_price
         -- <���� ��>
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- ����ȭ �ݾ�: ��� �ݾ׿��� �ּ� �ݾ��� �� ��
         , price - min_price as diff
         
         -- ���� ����: �ݾ� ������ ���� ���� ���� ��
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- ���� ����: floor(<����ȭ �ݾ�> / <���� ����>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index�� 1���� �����ϹǷ� 1��ŭ ���ϱ�
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select bucket
     -- ������ ���Ѱ� ���� ����ϱ�
     , min_price + bucket_range * (bucket - 1) as lower_limit
     , min_price + bucket_range * bucket as upper_limit
     
     -- ���� ����
     , count(price) as num_purchase
     
     -- �հ� �ݾ� ����ϱ�
     , sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket;

-- <�ڵ� 10-9>
-- ������׷��� ���Ѱ� ������ �������� �����ϱ�
with stats as (
    select
         -- �ݾ��� �ִ�
           50000 as max_price
         -- �ݾ��� �ּڰ�
         , 0 as min_price
         -- �ݾ��� ����
         , 50000 as range_price
         -- ���� ��
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- ����ȭ �ݾ�: ��� �ݾ׿��� �ּ� �ݾ��� �� ��
         , price - min_price as diff
         
         -- ���� ����: �ݾ� ������ ���� ���� ���� ��
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- ���� ����: floor(<����ȭ �ݾ�> / <���� ����>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index�� 1���� �����ϹǷ� 1��ŭ ���ϱ�
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select bucket
     -- ������ ���Ѱ� ���� ����ϱ�
     , min_price + bucket_range * (bucket - 1) as lower_limit
     , min_price + bucket_range * bucket as upper_limit
     -- ���� ����
     , count(price) as num_purchase
     -- �հ� �ݾ� ����ϱ�
     , sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket;