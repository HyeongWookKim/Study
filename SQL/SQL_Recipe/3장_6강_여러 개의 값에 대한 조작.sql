-- <코드 6-1>
--DROP TABLE mst_user_location;
CREATE TABLE mst_user_location (
    user_id varchar(255)
  , pref_name varchar(255)
  , city_name varchar(255)
);

INSERT INTO mst_user_location VALUES ('U001', '서울특별시', '강서구');
INSERT INTO mst_user_location VALUES ('U002', '경기도수원시', '장안구');
INSERT INTO mst_user_location VALUES ('U003', '제주특별자치도', '서귀포시');

-- 문자열 연결하기
select user_id
     -- RedShift의 경우 매개변수를 2개 밖에 못 받음
     , concat(pref_name, city_name) as pref_city1
     , pref_name || city_name as pref_city2
     , pref_name || ' ' || city_name as pref_city3
from mst_user_location;

-- <코드 6-2>
--DROP TABLE quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales VALUES (2015, 82000, 83000, 78000, 83000);
INSERT INTO quarterly_sales VALUES (2016, 85000, 85000, 80000, 81000);
INSERT INTO quarterly_sales VALUES (2017, 92000, 81000, NULL , NULL );

-- 분기별 매출 증감 판정하기
select year
     , q1
     , q2
     -- q1과 q2의 매출 변화 평가하기
     , case
        when q1 < q2 then '+'
        when q1 = q2 then ' '
        else '-'
       end as judge_q1_q2
     -- q1과 q2의 매출액의 차이 계산하기
     , q2 - q1 as diff_q2_q1
     -- q1과 q2의 매출 변화를 1, 0, -1로 표현하기
     -- sign 함수는 매개변수가 양수라면 1, 0이라면 0, 음수라면 -1을 리턴하는 함수
     , sign(q2 - q1) as sign_q2_q1
from quarterly_sales
order by year;

-- <코드 6-3>
-- 연간 최대/최소 4분기 매출 찾기
select year
     -- q1 ~ q4의 최대 매출 구하기(null 값도 계산에 포함되어 버림)
     , greatest(q1, q2, q3, q4) as greatest_sales
     -- q1 ~ q4의 최소 매출 구하기(null 값도 계산에 포함되어 버림)
     , least(q1, q2, q3, q4) as least_sales
from quarterly_sales
order by year;

-- <코드 6-4>
-- 단순한 연산으로 연간 평균 4분기 매출 계산하기
select year
     , (q1 + q2 + q3 + q4) / 4 as average
from quarterly_sales
order by year;

-- <코드 6-5>
-- coalesce를 사용해 null을 0으로 변환하고 평균 값을 계산하기
select year
     , (coalesce(q1, 0) + coalesce(q2, 0) + coalesce(q3, 0) + coalesce(q4, 0)) / 4 as average
from quarterly_sales
order by year;

-- <코드 6-6>
-- null이 아닌 컬럼만을 사용해서 평균 값을 계산하기
select year
     -- sign 함수는 매개변수가 양수라면 1, 0이라면 0, 음수라면 -1을 리턴하는 함수
     , (coalesce(q1, 0) + coalesce(q2, 0) + coalesce(q3, 0) + coalesce(q4, 0))
      / (sign(coalesce(q1, 0)) + sign(coalesce(q2, 0)) -- "1 + 1"
      + sign(coalesce(q3, 0)) + sign(coalesce(q4, 0))) -- "0 + 0"
      as average
from quarterly_sales
order by year;

-- <코드 6-7>
--DROP TABLE advertising_stats;
CREATE TABLE advertising_stats (
    dt varchar(255)
  , ad_id varchar(255)
  , impressions integer
  , clicks integer
);

INSERT INTO advertising_stats VALUES ('2017-04-01', '001', 100000, 3000);
INSERT INTO advertising_stats VALUES ('2017-04-01', '002', 120000, 1200);
INSERT INTO advertising_stats VALUES ('2017-04-01', '003', 500000, 10000);
INSERT INTO advertising_stats VALUES ('2017-04-02', '001', 0, 0);
INSERT INTO advertising_stats VALUES ('2017-04-02', '002', 130000, 1400);
INSERT INTO advertising_stats VALUES ('2017-04-02', '003', 620000, 15000);

-- 정수 자료형의 데이터 나누기
select dt
     , ad_id
     -- RedShift의 경우 정수를 나눌 때는 자동적으로 실수로 변환
     , clicks / impressions as ctr
     , 100.0 * clicks / impressions as ctr_as_percent
from advertising_stats
where dt = '2017-04-01'
order by dt, ad_id;

-- <코드 6-8>
-- 0으로 나누는 것 피하기
select dt
     , ad_id
     -- 1. case 식으로 분모가 0일 경우를 분기해서, 0으로 나누지 않게 만드는 방법
     , case
        when impressions > 0 then round(100.0 * clicks / impressions, 2)
        else null
       end as ctr_as_percent_by_case
     -- 2. 분모가 0이라면 null로 변환해서, 0으로 나누지 않게 만드는 방법
     -- 2-1. nullif(exp1, exp2): exp1값과 exp2값이 동일하면 NULL을, 그렇지 않으면 exp1을 반환해주는 함수
     , round(100.0 * clicks / nullif(impressions, 0), 2) as ctr_as_percent_by_null
from advertising_stats
order by dt, ad_id;

-- <코드 6-9>
--DROP TABLE location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d VALUES (5, 10);
INSERT INTO location_1d VALUES (10, 5);
INSERT INTO location_1d VALUES (-2, 4);
INSERT INTO location_1d VALUES (3, 3);
INSERT INTO location_1d VALUES (0, 1);

--DROP TABLE location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d VALUES (0, 0, 2, 2);
INSERT INTO location_2d VALUES (3, 5, 1, 2);
INSERT INTO location_2d VALUES (5, 3, 2, 1);

-- 일차원 데이터의 절댓값과 제곱 평균 제곱근을 계산하기
select abs(x1 - x2) as abs
     , sqrt(power(x1 - x2, 2)) as rms
from location_1d;

-- <코드 6-10>
-- 이차원 테이블에 대해 제곱 평균 제곱근(유클리드 거리)을 계산하기
select round(sqrt(power(x1 - x2, 2) + power(y1 - y2, 2)), 5) as dist
from location_2d;

-- <코드 6-11>
--DROP TABLE mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id varchar(255)
  , register_stamp varchar(255)
  , birth_date varchar(255)
);

INSERT INTO mst_users_with_dates VALUES ('U001', '2016-02-28 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U002', '2016-02-29 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U003', '2016-03-01 10:00:00', '2000-02-29');

-- 미래 또는 과거의 날짜/시간을 계산하기
select *
from mst_users_with_dates;

select user_id
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD HH:MI:SS') as register_stamp
     , to_char(cast(register_stamp as timestamp) + 1/24, 'YYYY-MM-DD HH:MI:SS') as after_1_hour
     , to_char(cast(register_stamp as timestamp) - 30/1440, 'YYYY-MM-DD HH:MI:SS') as before_30_minutes
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD') as register_date
     , to_char(cast(register_stamp as timestamp) + 1, 'YYYY-MM-DD') as after_1_day
     , add_months(to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD'), -1) as before_1_month
from mst_users_with_dates;

-- <코드 6-12>
-- 두 날짜의 차이를 계산하기
select user_id
     , to_char(current_date, 'YYYY-MM-DD') as today
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD') as register_date
     , to_date(to_char(current_date, 'YYYY-MM-DD')) - to_date(to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD')) as diff_days
from mst_users_with_dates;

-- <코드 6-13 ~ 6-14>
-- age 함수를 사용해서 나이를 계산하기
select user_id
     , to_char(current_date, 'YYYY-MM-DD') as today
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD') as register_date
     , birth_date
     -- current_age(만 나이) 계산
     , trunc(months_between(trunc(sysdate), to_date(birth_date, 'YYYY-MM-DD')) / 12) as current_age
     -- register_age 계산
     , trunc(months_between(trunc(to_date(register_stamp, 'YYYY-MM-DD HH:MI:SS')), to_date(birth_date, 'YYYY-MM-DD')) / 12) 
       as register_age
from mst_users_with_dates;

-- <코드 6-15>
-- 날짜를 정수로 표현해서 만 나이 계산하기
select floor((20200817 - 19931021) / 10000) as age
from dual;

-- <코드 6-16>
-- 등록 시점과 현재 시점의 나이를 문자열로 계산하기
select user_id
     , substr(register_stamp, 1, 10) as register_date
     , birth_date
     -- 등록 시점의 나이 계산하기
     , floor(
        (cast(replace(substr(register_stamp, 1, 10), '-', '') as integer)
         - cast(replace(birth_date, '-', '') as integer)
        ) / 10000
      ) as register_age
     -- 현재 시점의 나이 계산하기
     , floor(
        (cast(replace(to_char(current_date, 'YYYY-MM-DD'), '-', '') as integer)
         - cast(replace(birth_date, '-', '') as integer)
        ) / 10000
      ) as current_age
from mst_users_with_dates;

-- <코드 6-17 ~ 6-18>
-- inet 자료형을 사용한 IP 주소 비교
-- 아래의 코드는 PostgreSQL에서만 먹히므로 skip!
--select cast('127.0.0.1' as inet) < cast('127.0.0.2' as inet) as lt
--     , cast('127.0.0.1' as inet) < cast('192.168.0.1' as inet) as gt
--     , cast('127.0.0.1' as inet) << cast('127.0.0.0/8' as inet) as is_contained
--from dual;

-- <코드 6-19 ~ 6-20, 6-21>
select ip
     -- IP 주소에서 4개의 10진수 부분을 추출하기
     , cast(substr(ip, 1, 3) as integer) as ip_part_1
     , cast(substr(ip, 5, 3) as integer) as ip_part_2
     , cast(substr(ip, 9, 1) as integer) as ip_part_3
     , cast(substr(ip, 11, 1) as integer) as ip_part_4
     -- IP 주소를 정수 자료형 표기로 변환하기
     , cast(substr(ip, 1, 3) as integer) * power(2, 24)
      + cast(substr(ip, 5, 3) as integer) * power(2, 16)
      + cast(substr(ip, 9, 1) as integer) * power(2, 8)
      + cast(substr(ip, 11, 1) as integer) * power(2, 0)
      as ip_integer
     -- IP 주소를 0으로 메운 문자열로 변환하기
     -- LPAD("값", "총 문자길이", "채움문자"): 지정한 길이만큼 왼쪽부터 특정 문자로 채워줌
     , lpad(substr(ip, 1, 3), 3, '0')
      || lpad(substr(ip, 5, 3), 3, '0')
      || lpad(substr(ip, 9, 1), 3, '0')
      || lpad(substr(ip, 11, 1), 3, '0')
      as ip_padding
from (select '192.168.0.1' as ip from dual);