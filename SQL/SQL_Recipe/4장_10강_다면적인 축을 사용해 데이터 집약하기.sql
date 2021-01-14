-- <코드 10-1>
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

-- 카테고리별 매출과 소계를 동시에 구하기
with sub_category_amount as (
    -- 소분류(소 카테고리)의 매출 집계하기
    select category
         , sub_category as sub_category
         , sum(price) as amount
    from purchase_detail_log
    group by category, sub_category
)
, category_amount as (
    -- 대분류(대 카테고리)의 매출 집계하기
    select category
         -- 'all' 값으로만 채워진 sub_category 컬럼 생성
         , 'all' as sub_category
         , sum(price) as amount
    from purchase_detail_log
    group by category
)
, total_amount as (
    -- 전체 매출 집계하기
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

-- <코드 10-2>
-- rollup을 사용해서 카테고리별 매출과 소계를 동시에 구하기
-- <참고>
-- coalesce(expr1, expr2, expr3, …): expr1이 NULL이 아니면 expr1값을, 그렇지 않으면 COALESCE(expr2, expr3, …)값을 반환해준다.
-- NVL 함수와 비슷하다.
select coalesce(category, 'all') as category
     , coalesce(sub_category, 'all') as sub_category
     , sum(price) as amount
from purchase_detail_log
group by rollup(category, sub_category);

-- <코드 10-3>
-- 매출 구성비누계와 ABC 등급을 계산하기
-- 아래의 코드를 돌리려면 테이블이 필요한데, 출판사에서 이상한 테이블을 제공해주었음(그래서 쿼리 실행 불가능..)
with monthly_sales as (
    select category1
         -- 항목별 매출 계산하기
         , sum(amount) as amount
    from purchase_log
    -- 대상 1개월 동안의 로그를 조건으로 걸기
    where dt between '2015-12-01' and '2015-12-31'
    group by category1
)
, sales_composition_ratio as (
    select category1
         , amount
         
         -- 구성비: 100.0 * <항목별 매출> / <전체 매출>
         , 100.0 * amount / sum(amount) over() as composition_ratio
         
         -- 구성비누계: 100.0 * <항목별 누계 매출> / <전체 매출>
         , 100.0 * sum(amount) over(order by amount desc 
         rows between unbounded preceding and current row)
         / sum(amount) over() as cumulative_ratio
    from monthly_sales
)
select *
     -- 구성비누계 범위에 따라 순위 붙이기
     , case
        when cumulative_ratio between 0 and 70 then 'A'
        when cumulative_ratio between 70 and 90 then 'B'
        when cumulative_ratio between 90 and 100 then 'C'
       end as abc_rank
from sales_composition_ratio
order by amount desc;

-- <코드 10-4>
-- 팬 차트 작성 때 필요한 데이터를 구하기
-- 아래의 코드를 돌리려면 테이블이 필요한데, 출판사에서 이상한 테이블을 제공해주었음
-- 그래서 결과는 교재와 다름..
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
         -- 아래와 같이 작성해도 됨!
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

-- <코드 10-5>
-- 최댓값, 최솟값, 범위를 구하기
with stats as (
    select 
         -- 금액의 최댓값
           max(price) as max_price
         -- 금액의 최솟값
         , min(price) as min_price
         -- 금액의 범위
         , max(price) - min(price) as range_price
         -- 계층 수
         , 10 as bucket_num
    from purchase_detail_log
)
select *
from stats;

-- <코드 10-6>
-- 데이터의 계층을 구하기
with stats as (
    select 
         -- 금액의 최댓값
           max(price) as max_price
         -- 금액의 최솟값
         , min(price) as min_price
         -- 금액의 범위
         , max(price) - min(price) as range_price
         -- 계층 수
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- 정규화 금액: 대상 금액에서 최소 금액을 뺀 것
         , price - min_price as diff
         
         -- 계층 범위: 금액 범위를 계층 수로 나눈 것
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- 계층 판정: floor(<정규화 금액> / <계층 범위>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index가 1부터 시작하므로 1만큼 더하기
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select *
from purchase_log_with_bucket
order by price;

-- <코드 10-7>
-- 계급 상한 값을 조정한 쿼리
with stats as (
    select 
         -- <금액의 최댓값> + 1
           max(price) + 1 as max_price
         -- 금액의 최솟값
         , min(price) as min_price
         -- <금액의 범위> + 1(실수)
         , max(price) + 1 - min(price) as range_price
         -- <계층 수>
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- 정규화 금액: 대상 금액에서 최소 금액을 뺀 것
         , price - min_price as diff
         
         -- 계층 범위: 금액 범위를 계층 수로 나눈 것
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- 계층 판정: floor(<정규화 금액> / <계층 범위>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index가 1부터 시작하므로 1만큼 더하기
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select *
from purchase_log_with_bucket
order by price;

-- <코드 10-8>
-- 히스토그램을 구하기
with stats as (
    select 
         -- <금액의 최댓값> + 1
           max(price) + 1 as max_price
         -- 금액의 최솟값
         , min(price) as min_price
         -- <금액의 범위> + 1(실수)
         , max(price) + 1 - min(price) as range_price
         -- <계층 수>
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- 정규화 금액: 대상 금액에서 최소 금액을 뺀 것
         , price - min_price as diff
         
         -- 계층 범위: 금액 범위를 계층 수로 나눈 것
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- 계층 판정: floor(<정규화 금액> / <계층 범위>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index가 1부터 시작하므로 1만큼 더하기
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select bucket
     -- 계층의 하한과 상한 계산하기
     , min_price + bucket_range * (bucket - 1) as lower_limit
     , min_price + bucket_range * bucket as upper_limit
     
     -- 도수 세기
     , count(price) as num_purchase
     
     -- 합계 금액 계산하기
     , sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket;

-- <코드 10-9>
-- 히스토그램의 상한과 하한을 수동으로 조정하기
with stats as (
    select
         -- 금액의 최댓값
           50000 as max_price
         -- 금액의 최솟값
         , 0 as min_price
         -- 금액의 범위
         , 50000 as range_price
         -- 계층 수
         , 10 as bucket_num
    from purchase_detail_log
)
, purchase_log_with_bucket as (
    select price
         , min_price
         
         -- 정규화 금액: 대상 금액에서 최소 금액을 뺀 것
         , price - min_price as diff
         
         -- 계층 범위: 금액 범위를 계층 수로 나눈 것
         , 1.0 * range_price / bucket_num as bucket_range
         
         -- 계층 판정: floor(<정규화 금액> / <계층 범위>)
         , floor(1.0 * (price - min_price) / (1.0 * range_price / bucket_num)
         -- index가 1부터 시작하므로 1만큼 더하기
         ) + 1 as bucket
         
    from purchase_detail_log, stats
)
select bucket
     -- 계층의 하한과 상한 계산하기
     , min_price + bucket_range * (bucket - 1) as lower_limit
     , min_price + bucket_range * bucket as upper_limit
     -- 도수 세기
     , count(price) as num_purchase
     -- 합계 금액 계산하기
     , sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket;