-- <�ڵ� 6-1>
--DROP TABLE mst_user_location;
CREATE TABLE mst_user_location (
    user_id varchar(255)
  , pref_name varchar(255)
  , city_name varchar(255)
);

INSERT INTO mst_user_location VALUES ('U001', '����Ư����', '������');
INSERT INTO mst_user_location VALUES ('U002', '��⵵������', '��ȱ�');
INSERT INTO mst_user_location VALUES ('U003', '����Ư����ġ��', '��������');

-- ���ڿ� �����ϱ�
select user_id
     -- RedShift�� ��� �Ű������� 2�� �ۿ� �� ����
     , concat(pref_name, city_name) as pref_city1
     , pref_name || city_name as pref_city2
     , pref_name || ' ' || city_name as pref_city3
from mst_user_location;

-- <�ڵ� 6-2>
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

-- �б⺰ ���� ���� �����ϱ�
select year
     , q1
     , q2
     -- q1�� q2�� ���� ��ȭ ���ϱ�
     , case
        when q1 < q2 then '+'
        when q1 = q2 then ' '
        else '-'
       end as judge_q1_q2
     -- q1�� q2�� ������� ���� ����ϱ�
     , q2 - q1 as diff_q2_q1
     -- q1�� q2�� ���� ��ȭ�� 1, 0, -1�� ǥ���ϱ�
     -- sign �Լ��� �Ű������� ������ 1, 0�̶�� 0, ������� -1�� �����ϴ� �Լ�
     , sign(q2 - q1) as sign_q2_q1
from quarterly_sales
order by year;

-- <�ڵ� 6-3>
-- ���� �ִ�/�ּ� 4�б� ���� ã��
select year
     -- q1 ~ q4�� �ִ� ���� ���ϱ�(null ���� ��꿡 ���ԵǾ� ����)
     , greatest(q1, q2, q3, q4) as greatest_sales
     -- q1 ~ q4�� �ּ� ���� ���ϱ�(null ���� ��꿡 ���ԵǾ� ����)
     , least(q1, q2, q3, q4) as least_sales
from quarterly_sales
order by year;

-- <�ڵ� 6-4>
-- �ܼ��� �������� ���� ��� 4�б� ���� ����ϱ�
select year
     , (q1 + q2 + q3 + q4) / 4 as average
from quarterly_sales
order by year;

-- <�ڵ� 6-5>
-- coalesce�� ����� null�� 0���� ��ȯ�ϰ� ��� ���� ����ϱ�
select year
     , (coalesce(q1, 0) + coalesce(q2, 0) + coalesce(q3, 0) + coalesce(q4, 0)) / 4 as average
from quarterly_sales
order by year;

-- <�ڵ� 6-6>
-- null�� �ƴ� �÷����� ����ؼ� ��� ���� ����ϱ�
select year
     -- sign �Լ��� �Ű������� ������ 1, 0�̶�� 0, ������� -1�� �����ϴ� �Լ�
     , (coalesce(q1, 0) + coalesce(q2, 0) + coalesce(q3, 0) + coalesce(q4, 0))
      / (sign(coalesce(q1, 0)) + sign(coalesce(q2, 0)) -- "1 + 1"
      + sign(coalesce(q3, 0)) + sign(coalesce(q4, 0))) -- "0 + 0"
      as average
from quarterly_sales
order by year;

-- <�ڵ� 6-7>
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

-- ���� �ڷ����� ������ ������
select dt
     , ad_id
     -- RedShift�� ��� ������ ���� ���� �ڵ������� �Ǽ��� ��ȯ
     , clicks / impressions as ctr
     , 100.0 * clicks / impressions as ctr_as_percent
from advertising_stats
where dt = '2017-04-01'
order by dt, ad_id;

-- <�ڵ� 6-8>
-- 0���� ������ �� ���ϱ�
select dt
     , ad_id
     -- 1. case ������ �и� 0�� ��츦 �б��ؼ�, 0���� ������ �ʰ� ����� ���
     , case
        when impressions > 0 then round(100.0 * clicks / impressions, 2)
        else null
       end as ctr_as_percent_by_case
     -- 2. �и� 0�̶�� null�� ��ȯ�ؼ�, 0���� ������ �ʰ� ����� ���
     -- 2-1. nullif(exp1, exp2): exp1���� exp2���� �����ϸ� NULL��, �׷��� ������ exp1�� ��ȯ���ִ� �Լ�
     , round(100.0 * clicks / nullif(impressions, 0), 2) as ctr_as_percent_by_null
from advertising_stats
order by dt, ad_id;

-- <�ڵ� 6-9>
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

-- ������ �������� ���񰪰� ���� ��� �������� ����ϱ�
select abs(x1 - x2) as abs
     , sqrt(power(x1 - x2, 2)) as rms
from location_1d;

-- <�ڵ� 6-10>
-- ������ ���̺� ���� ���� ��� ������(��Ŭ���� �Ÿ�)�� ����ϱ�
select round(sqrt(power(x1 - x2, 2) + power(y1 - y2, 2)), 5) as dist
from location_2d;

-- <�ڵ� 6-11>
--DROP TABLE mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id varchar(255)
  , register_stamp varchar(255)
  , birth_date varchar(255)
);

INSERT INTO mst_users_with_dates VALUES ('U001', '2016-02-28 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U002', '2016-02-29 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U003', '2016-03-01 10:00:00', '2000-02-29');

-- �̷� �Ǵ� ������ ��¥/�ð��� ����ϱ�
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

-- <�ڵ� 6-12>
-- �� ��¥�� ���̸� ����ϱ�
select user_id
     , to_char(current_date, 'YYYY-MM-DD') as today
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD') as register_date
     , to_date(to_char(current_date, 'YYYY-MM-DD')) - to_date(to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD')) as diff_days
from mst_users_with_dates;

-- <�ڵ� 6-13 ~ 6-14>
-- age �Լ��� ����ؼ� ���̸� ����ϱ�
select user_id
     , to_char(current_date, 'YYYY-MM-DD') as today
     , to_char(cast(register_stamp as timestamp), 'YYYY-MM-DD') as register_date
     , birth_date
     -- current_age(�� ����) ���
     , trunc(months_between(trunc(sysdate), to_date(birth_date, 'YYYY-MM-DD')) / 12) as current_age
     -- register_age ���
     , trunc(months_between(trunc(to_date(register_stamp, 'YYYY-MM-DD HH:MI:SS')), to_date(birth_date, 'YYYY-MM-DD')) / 12) 
       as register_age
from mst_users_with_dates;

-- <�ڵ� 6-15>
-- ��¥�� ������ ǥ���ؼ� �� ���� ����ϱ�
select floor((20200817 - 19931021) / 10000) as age
from dual;

-- <�ڵ� 6-16>
-- ��� ������ ���� ������ ���̸� ���ڿ��� ����ϱ�
select user_id
     , substr(register_stamp, 1, 10) as register_date
     , birth_date
     -- ��� ������ ���� ����ϱ�
     , floor(
        (cast(replace(substr(register_stamp, 1, 10), '-', '') as integer)
         - cast(replace(birth_date, '-', '') as integer)
        ) / 10000
      ) as register_age
     -- ���� ������ ���� ����ϱ�
     , floor(
        (cast(replace(to_char(current_date, 'YYYY-MM-DD'), '-', '') as integer)
         - cast(replace(birth_date, '-', '') as integer)
        ) / 10000
      ) as current_age
from mst_users_with_dates;

-- <�ڵ� 6-17 ~ 6-18>
-- inet �ڷ����� ����� IP �ּ� ��
-- �Ʒ��� �ڵ�� PostgreSQL������ �����Ƿ� skip!
--select cast('127.0.0.1' as inet) < cast('127.0.0.2' as inet) as lt
--     , cast('127.0.0.1' as inet) < cast('192.168.0.1' as inet) as gt
--     , cast('127.0.0.1' as inet) << cast('127.0.0.0/8' as inet) as is_contained
--from dual;

-- <�ڵ� 6-19 ~ 6-20, 6-21>
select ip
     -- IP �ּҿ��� 4���� 10���� �κ��� �����ϱ�
     , cast(substr(ip, 1, 3) as integer) as ip_part_1
     , cast(substr(ip, 5, 3) as integer) as ip_part_2
     , cast(substr(ip, 9, 1) as integer) as ip_part_3
     , cast(substr(ip, 11, 1) as integer) as ip_part_4
     -- IP �ּҸ� ���� �ڷ��� ǥ��� ��ȯ�ϱ�
     , cast(substr(ip, 1, 3) as integer) * power(2, 24)
      + cast(substr(ip, 5, 3) as integer) * power(2, 16)
      + cast(substr(ip, 9, 1) as integer) * power(2, 8)
      + cast(substr(ip, 11, 1) as integer) * power(2, 0)
      as ip_integer
     -- IP �ּҸ� 0���� �޿� ���ڿ��� ��ȯ�ϱ�
     -- LPAD("��", "�� ���ڱ���", "ä����"): ������ ���̸�ŭ ���ʺ��� Ư�� ���ڷ� ä����
     , lpad(substr(ip, 1, 3), 3, '0')
      || lpad(substr(ip, 5, 3), 3, '0')
      || lpad(substr(ip, 9, 1), 3, '0')
      || lpad(substr(ip, 11, 1), 3, '0')
      as ip_padding
from (select '192.168.0.1' as ip from dual);