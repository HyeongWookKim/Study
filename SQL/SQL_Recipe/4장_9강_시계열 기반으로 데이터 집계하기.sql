-- <코드 9-1>
--DROP TABLE purchase_log;
CREATE TABLE purchase_log(
    dt varchar(255)
  , order_id integer
  , user_id varchar(255)
  , purchase_amount integer
);

INSERT INTO purchase_log VALUES ('2014-01-01',  1, 'rhwpvvitou', 13900);
INSERT INTO purchase_log VALUES ('2014-01-01',  2, 'hqnwoamzic', 10616);
INSERT INTO purchase_log VALUES ('2014-01-02',  3, 'tzlmqryunr', 21156);
INSERT INTO purchase_log VALUES ('2014-01-02',  4, 'wkmqqwbyai', 14893);
INSERT INTO purchase_log VALUES ('2014-01-03',  5, 'ciecbedwbq', 13054);
INSERT INTO purchase_log VALUES ('2014-01-03',  6, 'svgnbqsagx', 24384);
INSERT INTO purchase_log VALUES ('2014-01-03',  7, 'dfgqftdocu', 15591);
INSERT INTO purchase_log VALUES ('2014-01-04',  8, 'sbgqlzkvyn',  3025);
INSERT INTO purchase_log VALUES ('2014-01-04',  9, 'lbedmngbol', 24215);
INSERT INTO purchase_log VALUES ('2014-01-04', 10, 'itlvssbsgx',  2059);
INSERT INTO purchase_log VALUES ('2014-01-05', 11, 'jqcmmguhik',  4235);
INSERT INTO purchase_log VALUES ('2014-01-05', 12, 'jgotcrfeyn', 28013);
INSERT INTO purchase_log VALUES ('2014-01-05', 13, 'pgeojzoshx', 16008);
INSERT INTO purchase_log VALUES ('2014-01-06', 14, 'msjberhxnx',  1980);
INSERT INTO purchase_log VALUES ('2014-01-06', 15, 'tlhbolohte', 23494);
INSERT INTO purchase_log VALUES ('2014-01-06', 16, 'gbchhkcotf',  3966);
INSERT INTO purchase_log VALUES ('2014-01-07', 17, 'zfmbpvpzvu', 28159);
INSERT INTO purchase_log VALUES ('2014-01-07', 18, 'yauwzpaxtx',  8715);
INSERT INTO purchase_log VALUES ('2014-01-07', 19, 'uyqboqfgex', 10805);
INSERT INTO purchase_log VALUES ('2014-01-08', 20, 'hiqdkrzcpq',  3462);
INSERT INTO purchase_log VALUES ('2014-01-08', 21, 'zosbvlylpv', 13999);
INSERT INTO purchase_log VALUES ('2014-01-08', 22, 'bwfbchzgnl',  2299);
INSERT INTO purchase_log VALUES ('2014-01-09', 23, 'zzgauelgrt', 16475);
INSERT INTO purchase_log VALUES ('2014-01-09', 24, 'qrzfcwecge',  6469);
INSERT INTO purchase_log VALUES ('2014-01-10', 25, 'njbpsrvvcq', 16584);
INSERT INTO purchase_log VALUES ('2014-01-10', 26, 'cyxfgumkst', 11339);

-- 날짜별 매출과 평균 구매액을 집계하기
select dt
     , count(*) as purchase_count
     , sum(purchase_amount) as total_amount
     , round(avg(purchase_amount), 2) as avg_amount
from purchase_log
group by dt
order by dt;

-- <코드 9-2>
-- 날짜별 매출과 7일 이동평균을 집계하기
select dt
     , sum(purchase_amount) as total_amount
     
     -- 최근 최대 7일 동안의 평균 계산하기
     -- 아래의 경우는 과거 7일분의 데이터를 추출할 수 없는 첫 번째 6일 간에 대해 해당 6일만을 가지고 평균을 구함!
     , round(avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row), 2) as seven_day_avg
     
     -- 최근 7일 동안의 평균을 확실하게 계산하기
     -- 만약 7일의 데이터가 모두 있는 경우에만 7일 이동평균을 구하고자 한다면 아래의 코드를 사용하면 됨!
     , case
        when count(*) over(order by dt rows between 6 preceding and current row) = 7
        then round(avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row), 2)
       end as seven_day_avg_strict
from purchase_log
group by dt
order by dt;

-- <코드 9-3>
-- 날짜별 매출과 당월 누계 매출을 집계하기
select dt
     -- '연-월' 추출하기
     , substr(dt, 1, 7) as year_month
     
     , sum(purchase_amount) as total_amount
     
     -- 누계 매출 구하기
     , sum(sum(purchase_amount)) over(partition by substr(dt, 1, 7) 
                                    order by dt rows unbounded preceding) as agg_amount
from purchase_log
group by dt
order by dt;

-- <코드 9-4>
-- 날짜별 매출을 일시 테이블로 만들기
with daily_purchase as (
    select dt
         -- '연', '월', '일'을 각각 추출하기
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log
    group by dt
)
select *
from daily_purchase
order by dt;

-- <코드 9-5>
-- daily_purchase 테이블에 대해 당월 누계 매출을 집계하기
with daily_purchase as (
    select dt
         -- '연', '월', '일'을 각각 추출하기
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log
    group by dt
)
select dt
     -- '연-월' 만들기
     , concat(concat(year, '-'), month) as year_month1
     -- 아래와 같이 입력해도 '연-월'을 만들 수 있음!
     , year || '-' || month as year_month2
     
     , purchase_amount
     , sum(purchase_amount) over(partition by year, month 
                                order by dt rows unbounded preceding) as agg_amount
from daily_purchase
order by dt;

-- <코드 9-6>
--DROP TABLE purchase_log;
CREATE TABLE purchase_log2(
    dt varchar(255)
  , order_id integer
  , user_id  varchar(255)
  , purchase_amount integer
);

INSERT INTO purchase_log2 VALUES ('2014-01-01',    1, 'rhwpvvitou', 13900);
INSERT INTO purchase_log2 VALUES ('2014-02-08',   95, 'chtanrqtzj', 28469);
INSERT INTO purchase_log2 VALUES ('2014-03-09',  168, 'bcqgtwxdgq', 18899);
INSERT INTO purchase_log2 VALUES ('2014-04-11',  250, 'kdjyplrxtk', 12394);
INSERT INTO purchase_log2 VALUES ('2014-05-11',  325, 'pgnjnnapsc',  2282);
INSERT INTO purchase_log2 VALUES ('2014-06-12',  400, 'iztgctnnlh', 10180);
INSERT INTO purchase_log2 VALUES ('2014-07-11',  475, 'eucjmxvjkj',  4027);
INSERT INTO purchase_log2 VALUES ('2014-08-10',  550, 'fqwvlvndef',  6243);
INSERT INTO purchase_log2 VALUES ('2014-09-10',  625, 'mhwhxfxrxq',  3832);
INSERT INTO purchase_log2 VALUES ('2014-10-11',  700, 'wyrgiyvaia',  6716);
INSERT INTO purchase_log2 VALUES ('2014-11-10',  775, 'cwpdvmhhwh', 16444);
INSERT INTO purchase_log2 VALUES ('2014-12-10',  850, 'eqeaqvixkf', 29199);
INSERT INTO purchase_log2 VALUES ('2015-01-09',  925, 'efmclayfnr', 22111);
INSERT INTO purchase_log2 VALUES ('2015-02-10', 1000, 'qnebafrkco', 11965);
INSERT INTO purchase_log2 VALUES ('2015-03-12', 1075, 'gsvqniykgx', 20215);
INSERT INTO purchase_log2 VALUES ('2015-04-12', 1150, 'ayzvjvnocm', 11792);
INSERT INTO purchase_log2 VALUES ('2015-05-13', 1225, 'knhevkibbp', 18087);
INSERT INTO purchase_log2 VALUES ('2015-06-10', 1291, 'wxhxmzqxuw', 18859);
INSERT INTO purchase_log2 VALUES ('2015-07-10', 1366, 'krrcpumtzb', 14919);
INSERT INTO purchase_log2 VALUES ('2015-08-08', 1441, 'lpglkecvsl', 12906);
INSERT INTO purchase_log2 VALUES ('2015-09-07', 1516, 'mgtlsfgfbj',  5696);
INSERT INTO purchase_log2 VALUES ('2015-10-07', 1591, 'trgjscaajt', 13398);
INSERT INTO purchase_log2 VALUES ('2015-11-06', 1666, 'ccfbjyeqrb',  6213);
INSERT INTO purchase_log2 VALUES ('2015-12-05', 1741, 'onooskbtzp', 26024);

-- 월별 매출과 작년 대비 비율을 계산하기
with daily_purchase as (
    select dt
         -- '연', '월', '일'을 각각 추출하기
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log2
    group by dt
)
select month
     , sum(case year when '2014' then purchase_amount end) as amount_2014
     , sum(case year when '2015' then purchase_amount end) as amount_2015
     , round(100 * sum(case year when '2014' then purchase_amount end) / sum(case year when '2015' then purchase_amount end), 2) as rate
from daily_purchase
group by month
order by month;

-- <코드 9-7>
-- 2015년 매출에 대한 Z 차트를 작성하기

-- <참고>
-- 1. 월차 매출 : 매출 합계를 월별로 집계한다.
-- 2. 매출 누계 : 해당 월의 매출에 이전 월까지의 매출 누계를 합한 값이다.
-- 3. 이동 년계 : 해당 월의 매출에 과거 11개월의 매출을 합한 값이다.

with daily_purchase as (
    select dt
         -- '연', '월', '일'을 각각 추출하기
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log2
    group by dt
)
-- "월별 매출" 집계하기
, monthly_amount as (
    select year
         , month
         , sum(purchase_amount) as amount
    from daily_purchase
    group by year, month
)
-- "매출 누계"와 "이동 년계" 집계하기
, calc_index as (
    select year
         , month
         , amount
         
         -- 2015년의 누계 매출 집계하기
         , sum(case when year = '2015' then amount end) over(order by year, month rows unbounded preceding) as agg_amount
         
         -- 당월부터 11개월 이전까지의 매출 합계(이동 년계) 집계하기
         -- 즉, 현재 행에서 11행 이전까지의 데이터 합계를 구함!
         , sum(amount) over(order by year, month rows between 11 preceding and current row) as year_avg_amount
    from monthly_amount
    order by year, month
)
-- 마지막으로 2015년의 데이터만 압축하기
select concat(concat(year, '-'), month) as year_month1
     , year || '-' || month as year_month2
     , amount
     , agg_amount
     , year_avg_amount
from calc_index
where year = '2015'
order by year_month1;

-- <코드 9-8>
-- 매출과 관련된 지표를 집계하기
with daily_purchase as (
    select dt
         -- '연', '월', '일' 추출하기
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log2
    group by dt
)
, monthly_purchase as (
    select year
         , month
         , sum(orders) as orders
         , round(avg(purchase_amount), 2) as avg_amount
         , sum(purchase_amount) as monthly
    from daily_purchase
    group by year, month
)
select concat(concat(year, '-'), month) as year_month1
     , year || '-' || month as year_month2
     -- 판매 횟수
     , orders
     -- 평균 구매액
     , avg_amount
     -- 매출액
     , monthly
     -- 누계 매출액
     , sum(monthly) over(partition by year 
                        order by month rows unbounded preceding) as agg_amount
     -- 12개월 전의 매출 구하기(즉, 작년 매출액)
     , lag(monthly, 12) over(order by year, month) as last_year
     -- 12개월 전의 매출과 비교해서 비율 구하기(즉, 작년 대비 비율)
     , round(100 * monthly / lag(monthly, 12) over(order by year, month), 2) as rate
from monthly_purchase
order by year_month1;