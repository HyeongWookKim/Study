-- <�ڵ� 5-1>
--DROP TABLE mst_users;
CREATE TABLE mst_users(
    user_id varchar(255)
  , register_date varchar(255)
  , register_device integer
);

INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U001', '2016-08-26', 1);
INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U002', '2016-08-26', 2);
INSERT INTO mst_users (user_id, register_date, register_device) VALUES ('U003', '2016-08-27', 3);

-- �ڵ带 ���̺�� �����ϱ�
select user_id
     , case
        when register_device = 1 then '����ũ��'
        when register_device = 2 then '����Ʈ��'
        when register_device = 3 then '���ø����̼�'
       end as device_name
from mst_users;

-- <�ڵ� 5-2>
--DROP TABLE access_log ;
CREATE TABLE access_log (
    stamp varchar2(255)
  , referrer varchar2(255)
  , url varchar2(255)
);

INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001');
INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref');
INSERT INTO access_log (stamp, referrer, url) VALUES ('2016-08-26 12:02:01', 'https://www.other.com/', 'http://www.example.com/book/detail?id=002');

-- ���۷� �������� �����ϱ�
select stamp
    -- referrer�� ȣ��Ʈ �̸� �κ� �����ϱ�
    -- RedShift�� ��� ���� ǥ���Ŀ� �׷��� ����� �� �����Ƿ�,
    -- regexp_substr �Լ��� regexp_replace �Լ��� �����ؼ� ����ϱ�
     , regexp_replace(regexp_substr(referrer, 'https?://[^/]*'), 'https?://', '') as referrer_host
from access_log;

-- <�ڵ� 5-3>
-- URL ��ο� GET �Ű������� �ִ� Ư�� Ű ���� �����ϱ�
select stamp
     , url
     -- URL ��� �Ǵ� GET �Ű������� id �����ϱ�
     -- RedShift�� ��� ���� ǥ���Ŀ� �׷��� ����� �� �����Ƿ�,
     -- regexp_substr �Լ��� regexp_replace �Լ��� �����ؼ� ����ϱ�
     , regexp_replace(regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', '') as path
     , regexp_replace(regexp_substr(url, 'id=[^&]*'), 'id=', '') as id
from access_log;

-- <�ڵ� 5-4>
-- URL ��θ� �����÷� �����ؼ� ������ �����ϱ�
-- ??? ������ �߻���..
select stamp
    -- ��θ� �����÷� �߶� �迭�� �����ϱ�
    -- RedShift�� split_part�� n��° ��� �����ϱ�
     , split_part(regexp_replace(
        regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', ''), '/', 2) as path1
     , split_part(regexp_replace(
        regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+', ''), '/', 3) as path2
from access_log;

-- <�ڵ� 5-5>
-- ���� ��¥�� Ÿ�ӽ������� �����ϱ�
select to_char(current_date, 'YYYY-MM-DD') as dt
    -- PostgreSQL�� ��� CURRENT_DATE ����� CURRENT_TIMESTAMP ��� ����ϱ�
    -- PostgreSQL�� ��� CURRENT_TIMESTAMP�� Ÿ������ ����� Ÿ�ӽ�����
    -- Ÿ������ �����ϰ� ���� ������ LOCALTIMESTAMP ����ϱ�
     , localtimestamp as stamp
from dual;

-- <�ڵ� 5-6>
-- ���ڿ��� ��¥ �ڷ���, Ÿ�ӽ����� �ڷ������� ��ȯ�ϱ�
select cast('2020-08-15' as date) as dt
     , cast('2020-08-15 12:00:00' as timestamp) as stamp
from dual;

-- <�ڵ� 5-7>
-- Ÿ�ӽ����� �ڷ����� �����Ϳ��� ��, ��, �� ���� �����ϱ�
select stamp
     , extract(year from stamp) as year
     , extract(month from stamp) as month 
     , extract(day from stamp) as day
     , extract(hour from stamp) as hour
from 
    (select cast('2020-08-15 12:00:00' as timestamp) as stamp
     from dual)
;

-- <�ڵ� 5-8>
-- Ÿ�ӽ������� ��Ÿ���� ���ڿ����� ��, ��, �� ���� �����ϱ�
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

-- <�ڵ� 5-9>
--DROP TABLE purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount integer
  , coupon integer
);

INSERT INTO purchase_log_with_coupon VALUES ('10001', 3280, NULL);
INSERT INTO purchase_log_with_coupon VALUES ('10002', 4650,  500);
INSERT INTO purchase_log_with_coupon VALUES ('10003', 3870, NULL);

-- ���ž׿��� ���� ���� ���� ������ ���� �ݾ��� ���ϱ�
select purchase_id
     , amount
     , coupon
     -- �ƹ��� �Լ��� ������� ���� ���(null ���� ������ ����)
     , amount - coupon as discount_amount1
     -- coalesce �Լ��� ����� ���
     , amount - coalesce(coupon, 0) as discount_amount2
     -- nvl2 �Լ��� ����� ���
     , amount - nvl2(coupon, coupon, 0) as discount_amount3
from purchase_log_with_coupon;