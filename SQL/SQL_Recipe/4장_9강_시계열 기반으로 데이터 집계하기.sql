-- <�ڵ� 9-1>
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

-- ��¥�� ����� ��� ���ž��� �����ϱ�
select dt
     , count(*) as purchase_count
     , sum(purchase_amount) as total_amount
     , round(avg(purchase_amount), 2) as avg_amount
from purchase_log
group by dt
order by dt;

-- <�ڵ� 9-2>
-- ��¥�� ����� 7�� �̵������ �����ϱ�
select dt
     , sum(purchase_amount) as total_amount
     
     -- �ֱ� �ִ� 7�� ������ ��� ����ϱ�
     -- �Ʒ��� ���� ���� 7�Ϻ��� �����͸� ������ �� ���� ù ��° 6�� ���� ���� �ش� 6�ϸ��� ������ ����� ����!
     , round(avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row), 2) as seven_day_avg
     
     -- �ֱ� 7�� ������ ����� Ȯ���ϰ� ����ϱ�
     -- ���� 7���� �����Ͱ� ��� �ִ� ��쿡�� 7�� �̵������ ���ϰ��� �Ѵٸ� �Ʒ��� �ڵ带 ����ϸ� ��!
     , case
        when count(*) over(order by dt rows between 6 preceding and current row) = 7
        then round(avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row), 2)
       end as seven_day_avg_strict
from purchase_log
group by dt
order by dt;

-- <�ڵ� 9-3>
-- ��¥�� ����� ��� ���� ������ �����ϱ�
select dt
     -- '��-��' �����ϱ�
     , substr(dt, 1, 7) as year_month
     
     , sum(purchase_amount) as total_amount
     
     -- ���� ���� ���ϱ�
     , sum(sum(purchase_amount)) over(partition by substr(dt, 1, 7) 
                                    order by dt rows unbounded preceding) as agg_amount
from purchase_log
group by dt
order by dt;

-- <�ڵ� 9-4>
-- ��¥�� ������ �Ͻ� ���̺�� �����
with daily_purchase as (
    select dt
         -- '��', '��', '��'�� ���� �����ϱ�
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

-- <�ڵ� 9-5>
-- daily_purchase ���̺� ���� ��� ���� ������ �����ϱ�
with daily_purchase as (
    select dt
         -- '��', '��', '��'�� ���� �����ϱ�
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log
    group by dt
)
select dt
     -- '��-��' �����
     , concat(concat(year, '-'), month) as year_month1
     -- �Ʒ��� ���� �Է��ص� '��-��'�� ���� �� ����!
     , year || '-' || month as year_month2
     
     , purchase_amount
     , sum(purchase_amount) over(partition by year, month 
                                order by dt rows unbounded preceding) as agg_amount
from daily_purchase
order by dt;

-- <�ڵ� 9-6>
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

-- ���� ����� �۳� ��� ������ ����ϱ�
with daily_purchase as (
    select dt
         -- '��', '��', '��'�� ���� �����ϱ�
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

-- <�ڵ� 9-7>
-- 2015�� ���⿡ ���� Z ��Ʈ�� �ۼ��ϱ�

-- <����>
-- 1. ���� ���� : ���� �հ踦 ������ �����Ѵ�.
-- 2. ���� ���� : �ش� ���� ���⿡ ���� �������� ���� ���踦 ���� ���̴�.
-- 3. �̵� ��� : �ش� ���� ���⿡ ���� 11������ ������ ���� ���̴�.

with daily_purchase as (
    select dt
         -- '��', '��', '��'�� ���� �����ϱ�
         , substr(dt, 1, 4) as year
         , substr(dt, 6, 2) as month
         , substr(dt, 9, 2) as day
         
         , sum(purchase_amount) as purchase_amount
         , count(order_id) as orders
    from purchase_log2
    group by dt
)
-- "���� ����" �����ϱ�
, monthly_amount as (
    select year
         , month
         , sum(purchase_amount) as amount
    from daily_purchase
    group by year, month
)
-- "���� ����"�� "�̵� ���" �����ϱ�
, calc_index as (
    select year
         , month
         , amount
         
         -- 2015���� ���� ���� �����ϱ�
         , sum(case when year = '2015' then amount end) over(order by year, month rows unbounded preceding) as agg_amount
         
         -- ������� 11���� ���������� ���� �հ�(�̵� ���) �����ϱ�
         -- ��, ���� �࿡�� 11�� ���������� ������ �հ踦 ����!
         , sum(amount) over(order by year, month rows between 11 preceding and current row) as year_avg_amount
    from monthly_amount
    order by year, month
)
-- ���������� 2015���� �����͸� �����ϱ�
select concat(concat(year, '-'), month) as year_month1
     , year || '-' || month as year_month2
     , amount
     , agg_amount
     , year_avg_amount
from calc_index
where year = '2015'
order by year_month1;

-- <�ڵ� 9-8>
-- ����� ���õ� ��ǥ�� �����ϱ�
with daily_purchase as (
    select dt
         -- '��', '��', '��' �����ϱ�
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
     -- �Ǹ� Ƚ��
     , orders
     -- ��� ���ž�
     , avg_amount
     -- �����
     , monthly
     -- ���� �����
     , sum(monthly) over(partition by year 
                        order by month rows unbounded preceding) as agg_amount
     -- 12���� ���� ���� ���ϱ�(��, �۳� �����)
     , lag(monthly, 12) over(order by year, month) as last_year
     -- 12���� ���� ����� ���ؼ� ���� ���ϱ�(��, �۳� ��� ����)
     , round(100 * monthly / lag(monthly, 12) over(order by year, month), 2) as rate
from monthly_purchase
order by year_month1;