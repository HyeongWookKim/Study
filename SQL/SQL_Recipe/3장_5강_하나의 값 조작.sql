-- <코드 5-1>
--DROP TABLE mst_users;
CREATE TABLE mst_users(
    user_id varchar(255)
  , register_date varchar(255)
  , register_device integer
);

INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U001', '2016-08-26', 1);
INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U002', '2016-08-26', 2);
INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U003', '2016-08-27', 3);

-- 코드를 레이블로 변경하기
select user_id
     , case
        when register_device = 1 then '데스크톱'
        when register_device = 2 then '스마트폰'
        when register_device = 3 then '애플리케이션'
       end as device_name
from mst_users;

-- <코드 5-2>
--DROP TABLE access_log ;
CREATE TABLE access_log (
    stamp varchar2(255)
  , referrer varchar2(255)
  , url varchar2(255)
);

INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001');
INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref');
INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:01', 'https://www.other.com/', 'http://www.example.com/book/detail?id=002');

-- 레퍼러 도메인을 추출하기
select stamp
    -- referrer의 호스트 이름 부분 추출하기
    -- RedShift의 경우 정규 표현식에 그룹을 사용할 수 없으므로,
    -- regexp_substr 함수와 regexp_replace 함수를 조합해서 사용하기
     , regexp_replace(regexp_substr(referrer, 'https?://[^/]*'), 'https?://', '') as referrer_host
from access_log;

-- <코드 5-3>
-- URL 경로와 GET 매개변수에 있는 특정 키 값을 추출하기
select stamp
     , url
     -- URL 경로 또는 GET 매개변수의 id 추출하기
     -- RedShift의 경우 정규 표현식에 그룹을 사용할 수 없으므로,
     -- regexp_substr 함수와 regexp_replace 함수를 조합해서 사용하기
     , regexp_replace(regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', '') as path
     , regexp_replace(regexp_substr(url, 'id=[^&]*'), 'id=', '') as id
from access_log;

-- <코드 5-4>
-- URL 경로를 슬래시로 분할해서 계층을 추출하기
-- ??? 에러가 발생함..
select stamp
    -- 경로를 슬래시로 잘라 배열로 분할하기
    -- RedShift는 split_part로 n번째 요소 추출하기
     , split_part(regexp_replace(
        regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', ''), '/', 2) as path1
     , split_part(regexp_replace(
        regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', ''), '/', 3) as path2
from access_log;

-- <코드 5-5>
-- 현재 날짜와 타임스탬프를 추출하기
select to_char(current_date, 'YYYY-MM-DD') as dt
    -- PostgreSQL의 경우 CURRENT_DATE 상수와 CURRENT_TIMESTAMP 상수 사용하기
    -- PostgreSQL의 경우 CURRENT_TIMESTAMP는 타임존이 적용된 타임스탬프
    -- 타임존을 적용하고 싶지 않으면 LOCALTIMESTAMP 사용하기
     , localtimestamp as stamp
from dual;

-- <코드 5-6>
-- 문자열을 날짜 자료형, 타임스탬프 자료형으로 변환하기
select cast('2020-08-15' as date) as dt
     , cast('2020-08-15 12:00:00' as timestamp) as stamp
from dual;

-- <코드 5-7>
-- 타임스탬프 자료형의 데이터에서 연, 월, 일 등을 추출하기
select stamp
     , extract(year from stamp) as year
     , extract(month from stamp) as month 
     , extract(day from stamp) as day
     , extract(hour from stamp) as hour
from 
    (select cast('2020-08-15 12:00:00' as timestamp) as stamp
     from dual)
;

-- <코드 5-8>
-- 타임스탬프를 나타내는 문자열에서 연, 월, 일 등을 추출하기
select stamp
     , substr(stamp, 1, 4) as year
     , substr(stamp, 6, 2) as month
     , substr(stamp, 9, 2) as day
     , substr(stamp, 12, 2) as hour
     , substr(stamp, 1, 7) as year_month
from 
    (select cast('2020-08-15 12:00:00' as varchar(255)) as stamp
     from dual)
;

-- <코드 5-9>
--DROP TABLE purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount integer
  , coupon integer
);

INSERT INTO purchase_log_with_coupon VALUES ('10001', 3280, NULL);
INSERT INTO purchase_log_with_coupon VALUES ('10002', 4650,  500);
INSERT INTO purchase_log_with_coupon VALUES ('10003', 3870, NULL);

-- 구매액에서 할인 쿠폰 값을 제외한 매출 금액을 구하기
select purchase_id
     , amount
     , coupon
     -- 아무런 함수를 사용하지 않은 경우(null 값의 영향을 받음)
     , amount - coupon as discount_amount1
     -- coalesce 함수를 사용한 경우
     , amount - coalesce(coupon, 0) as discount_amount2
     -- nvl2 함수를 사용한 경우
     , amount - nvl2(coupon, coupon, 0) as discount_amount3
from purchase_log_with_coupon;