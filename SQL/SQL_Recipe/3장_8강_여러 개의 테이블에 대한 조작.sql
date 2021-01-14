-- <�ڵ� 8-1>
--DROP TABLE app1_mst_users;
CREATE TABLE app1_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , email   varchar(255)
);

INSERT INTO app1_mst_users VALUES ('U001', 'Sato'  , 'sato@example.com'  );
INSERT INTO app1_mst_users VALUES ('U002', 'Suzuki', 'suzuki@example.com');

--DROP TABLE app2_mst_users;
CREATE TABLE app2_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , phone   varchar(255)
);

INSERT INTO app2_mst_users VALUES ('U001', 'Ito'   , '080-xxxx-xxxx');
INSERT INTO app2_mst_users VALUES ('U002', 'Tanaka', '070-xxxx-xxxx');

-- union all ������ ����ؼ� ���̺��� ���η� �����ϱ�
select 'app1' as app_name, user_id, name, email from app1_mst_users
union all
select 'app2' as app_name, user_id, name, null as email from app2_mst_users;

-- <�ڵ� 8-2>
--DROP TABLE mst_categories;
CREATE TABLE mst_categories (
    category_id integer
  , name        varchar(255)
);

INSERT INTO mst_categories VALUES (1, 'dvd' );
INSERT INTO mst_categories VALUES (2, 'cd'  );
INSERT INTO mst_categories VALUES (3, 'book');

--DROP TABLE category_sales;
CREATE TABLE category_sales (
    category_id integer
  , sales       integer
);

INSERT INTO category_sales VALUES (1, 850000);
INSERT INTO category_sales VALUES (2, 500000);

--DROP TABLE product_sale_ranking;
CREATE TABLE product_sale_ranking (
    category_id integer
  , rank        integer
  , product_id  varchar(255)
  , sales       integer
);

INSERT INTO product_sale_ranking VALUES (1, 1, 'D001', 50000);
INSERT INTO product_sale_ranking VALUES (1, 2, 'D002', 20000);
INSERT INTO product_sale_ranking VALUES (1, 3, 'D003', 10000);
INSERT INTO product_sale_ranking VALUES (2, 1, 'C001', 30000);
INSERT INTO product_sale_ranking VALUES (2, 2, 'C002', 20000);
INSERT INTO product_sale_ranking VALUES (2, 3, 'C003', 10000);

-- ���� ���� ���̺��� �����ؼ� ���η� �����ϱ�
select m.category_id
     , m.name
     , s.sales
     , r.product_id as sale_product
from mst_categories m
-- 1. ī�װ����� ����� �����ϱ�
inner join category_sales s on m.category_id = s.category_id
-- 2. ī�װ����� ��ǰ �����ϱ�
inner join product_sale_ranking r on m.category_id = r.category_id;

-- <�ڵ� 8-3>
-- ������ ���̺��� �� ���� �������� �ʰ� ���� ���� ���̺��� ���η� �����ϱ�
select m.category_id
     , m.name
     , s.sales
     , r.product_id as top_sale_product
from mst_categories m
-- left join�� ����ؼ� ������ ���ڵ带 ����
left join category_sales s on m.category_id = s.category_id
-- left join�� ����ؼ� �������� ���� ���ڵ带 ����
left join product_sale_ranking r on m.category_id = r.category_id
and r.rank = 1;

-- <�ڵ� 8-4>
-- ��� ���������� ���� ���� ���̺��� ���η� �����ϱ�
select m.category_id
     , m.name
     
     -- ��� ���������� ����ؼ� ī�װ����� ����� �����ϱ�
     , (select s.sales
        from category_sales s
        where m.category_id = s.category_id) as sales
     
--     --  Oracle������ �Ʒ��� �ڵ尡 �� ����..
--     -- ��� ���������� ����ؼ� ī�װ����� �ְ� ���� ��ǰ�� �ϳ� �����ϱ�
--     -- ������ ���� �������� �ʾƵ� ��!
--     , (select r.product_id
--        from product_sale_ranking r
--        where m.category_id = r.category_id
--        order by sales desc) as top_sale_product
from mst_categories m;

-- <�ڵ� 8-5>
--DROP TABLE mst_users_with_card_number;
CREATE TABLE mst_users_with_card_number (
    user_id     varchar(255)
  , card_number varchar(255)
);

INSERT INTO mst_users_with_card_number VALUES ('U001', '1234-xxxx-xxxx-xxxx');
INSERT INTO mst_users_with_card_number VALUES ('U002', NULL                 );
INSERT INTO mst_users_with_card_number VALUES ('U003', '5678-xxxx-xxxx-xxxx');

--DROP TABLE purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , user_id     varchar(255)
  , amount      integer
  , stamp       varchar(255)
);

INSERT INTO purchase_log VALUES (10001, 'U001', 200, '2017-01-30 10:00:00');
INSERT INTO purchase_log VALUES (10002, 'U001', 500, '2017-02-10 10:00:00');
INSERT INTO purchase_log VALUES (10003, 'U001', 200, '2017-02-12 10:00:00');
INSERT INTO purchase_log VALUES (10004, 'U002', 800, '2017-03-01 10:00:00');
INSERT INTO purchase_log VALUES (10005, 'U002', 400, '2017-03-02 10:00:00');

-- �ſ� ī�� ��ϰ� ���� �̷� ������ 0�� 1�̶�� �÷��׷� ��Ÿ����
select m.user_id
     , m.card_number
     , count(p.user_id) as purchase_count
     
     -- �ſ� ī�� ��ȣ�� ����� ��� 1, ������� ���� ��� 0���� ǥ���ϱ�
     , case when m.card_number is not null then 1 else 0 end as has_card
     
     -- ���� �̷��� �ִ� ��� 1, ���� ��� 0���� ǥ���ϱ�
     -- sign �Լ�: -1: ǥ������ ����, 0: ǥ������ 0, 1: ǥ������ ���
     , sign(count(p.user_id)) as has_purchased
from mst_users_with_card_number m
left join purchase_log p on m.user_id = p.user_id
group by m.user_id, m.card_number;

-- <�ڵ� 8-6 ~ 8-8>
--DROP TABLE product_sales;
CREATE TABLE product_sales (
    category_name varchar(255)
  , product_id    varchar(255)
  , sales         integer
);

INSERT INTO product_sales VALUES ('dvd' , 'D001', 50000);
INSERT INTO product_sales VALUES ('dvd' , 'D002', 20000);
INSERT INTO product_sales VALUES ('dvd' , 'D003', 10000);
INSERT INTO product_sales VALUES ('cd'  , 'C001', 30000);
INSERT INTO product_sales VALUES ('cd'  , 'C002', 20000);
INSERT INTO product_sales VALUES ('cd'  , 'C003', 10000);
INSERT INTO product_sales VALUES ('book', 'B001', 20000);
INSERT INTO product_sales VALUES ('book', 'B002', 15000);
INSERT INTO product_sales VALUES ('book', 'B003', 10000);
INSERT INTO product_sales VALUES ('book', 'B004',  5000);

-- 1. ī�װ��� ������ �߰��� ���̺� �̸� ���̱�
with product_sale_ranking as (
    select category_name
         , product_id
         , sales
         , rank() over(partition by category_name order by sales desc) as rank
    from product_sales
)
select *
from product_sale_ranking;

-- 2. ī�װ����� �������� ����ũ�� ���� ����� ����ϱ�
with product_sale_ranking as (
    select category_name
         , product_id
         , sales
         , rank() over(partition by category_name order by sales desc) as rank
    from product_sales
)
-- <����> with ������ ����ؼ� ���� ���̺��� ������ ���� ��ǥ�� ����ؼ� ���̺��� ������!
, mst_rank as (
    select distinct rank
    from product_sale_ranking
)
select *
from mst_rank;

-- 3. ī�װ����� ������ Ⱦ�������� ����ϱ�
with product_sale_ranking as (
    select category_name
         , product_id
         , sales
         , rank() over(partition by category_name order by sales desc) as rank
    from product_sales
)
-- <����> with ������ ����ؼ� ���� ���̺��� ������ ���� ��ǥ�� ����ؼ� ���̺��� ������!
, mst_rank as (
    select distinct rank
    from product_sale_ranking
)
select m.rank
     , r1.product_id as dvd
     , r1.sales as dvd_sales
     , r2.product_id as cd
     , r2.sales as cd_sales
     , r3.product_id as book
     , r3.sales as book_sales
from mst_rank m
    -- (1) dvd�� ���
    left join product_sale_ranking r1 on m.rank = r1.rank
    and r1.category_name = 'dvd'
    -- (2) cd�� ���
    left join product_sale_ranking r2 on m.rank = r2.rank
    and r2.category_name = 'cd'
    -- (3) book�� ���
    left join product_sale_ranking r3 on m.rank = r3.rank
    and r3.category_name = 'book'
order by m.rank;

-- <�ڵ� 8-9>
-- ����̽� ID�� �̸��� ������ ���̺��� �����
with mst_devices as (
    select 1 as device_id, 'PC' as device_name from dual
    union all
    select 2 as device_id, 'SP' as device_name from dual
    union all
    select 3 as device_id, '���ø����̼�' as device_name from dual
)
select *
from mst_devices;

-- <�ڵ� 8-10>
-- �ǻ� ���̺��� ����ؼ� �ڵ带 ���̺�� ��ȯ�ϱ�
with mst_devices as (
    select 1 as device_id, 'PC' as device_name from dual
    union all
    select 2 as device_id, 'SP' as device_name from dual
    union all
    select 3 as device_id, '���ø����̼�' as device_name from dual
)
select u.user_id
     , d.device_name
from mst_users u
left join mst_devices d on u.register_device = d.device_id;