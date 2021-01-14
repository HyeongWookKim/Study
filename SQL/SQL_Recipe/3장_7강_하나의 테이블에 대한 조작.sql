-- <코드 7-1>
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

-- 집약 함수를 사용해서 테이블 전체의 특징량을 계산하기
select count(*) total_count
     , count(distinct user_id) as user_count
     , count(distinct product_id) as product_count
     , sum(score) as sum
     , round(avg(score), 2) as avg
     , max(score) as max
     , min(score) as min
from review;

-- <코드 7-2>
-- 사용자 기반으로 데이터를 분할하고 집약 함수를 적용하기
select user_id
     , count(*) total_count
     , count(distinct product_id) as product_count
     , sum(score) as sum
     , round(avg(score), 2) as avg
     , max(score) as max
     , min(score) as min
from review
group by user_id;

-- <코드 7-3>
-- 윈도 함수를 사용해서 집약 함수의 결과와 원래 값을 동시에 다루기
select user_id
     , product_id
     -- 개별 리뷰 점수
     , score
     -- 전체 평균 리뷰 점수
     , round(avg(score) over(), 2) as avg_score
     -- 사용자의 평균 리뷰 점수
     , round(avg(score) over(partition by user_id), 2) as user_avg_score
     -- 개별 리뷰 점수와 사용자 평균 리뷰 점수의 차이
     , round(score - avg(score) over(partition by user_id), 2) as user_avg_score_diff
from review;

-- <코드 7-4>
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

-- 윈도 함수의 order by 구문을 사용해서 테이블 내부의 순서를 다루기
select product_id
     , score
     
--     -- 점수 순서로 유일한 순위를 붙임 (이 코드 안 먹힘..)
--     , row_number() over(order by score desc) as row
     
     -- 같은 순위를 허용해서 순위를 붙임
     , rank() over(order by score desc) as rank
     
     -- 같은 순위가 있을 때 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임
     , dense_rank() over(order by score desc) as dense_rank
     
     -- 현재 행보다 앞에 있는 행의 값 추출하기
     , lag(product_id) over(order by score desc) as lag1
     , lag(product_id, 2) over(order by score desc) as lag2
     
     -- 현재 행보다 뒤에 있는 행의 값 추출하기
     , lead(product_id) over(order by score desc) as lead1
     , lead(product_id, 2) over(order by score desc) as lead2
from popular_products;
--order by row;

-- <코드 7-5>
-- order by 구문과 집약 함수를 조합해서 계산하기
select product_id
     , score
     
--     -- 점수 순서로 유일한 순위를 붙임 (이 코드 안 먹힘..)
--     , row_number() over(order by score desc) as row
     
     -- 순위 상위부터의 누계 점수 계산하기
     , sum(score) over(order by score desc
                    rows between unbounded preceding and current row) as cum_score
    
     -- 현재 행과 앞 뒤의 행이 가진 값을 기반으로 평균 점수 계산하기
     , round(avg(score) over(order by score desc
                            rows between 1 preceding and 1 following), 2) as local_avg
     
     -- 순위가 높은 상품 ID 추출하기
     , first_value(product_id) over(order by score desc
                                rows between unbounded preceding and unbounded following) as first_value
     
     -- 순위가 낮은 상품 ID 추출하기
     , last_value(product_id) over(order by score desc
                                rows between unbounded preceding and unbounded following) as last_value
from popular_products;
--order by row;Data Modeler 보고서


-- <코드 7-7>
-- 윈도 프레임 지정별 상품 ID를 집약하기
select category
     , product_id
     , score
     
--     -- 카테고리별로 점수 순서로 정렬하고 유일한 순위를 붙임(이 코드 안 먹힘..)
--     , row_number() over(partition by category order by score desc) as row
     
     -- 카테고리별로 같은 순위를 허가하고 순위를 붙임
     , rank() over(partition by category order by score desc) as rank
     
     -- 카테고리별로 같은 순위가 있을 때, 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임
     , dense_rank() over(partition by category order by score desc) as dense_rank
from popular_products;
--order by category, row;

-- <코드 7-8>
-- 카테고리들의 순위 상위 2개까지의 상품을 추출하기
select *
-- 서브 쿼리 내부에서 순위 계산하기
from (select category
           , product_id
           , score
           -- 카테고리별로 점수 순서로 유일한 순위를 붙임
           , row_number() over(partition by category order by score desc) as rank
      from popular_products) popular_producst_with_rank
-- 외부 쿼리에서 순위 활용해서 압축하기
where rank <= 2
order by category, rank;

-- <코드 7-9>
-- 카테고리별 순위 최상위 상품을 추출하기
select distinct category
     -- 카테고리별로 순위 최상위 상품 ID 추출하기
     , first_value(product_id) over(partition by category order by score desc
                                rows between unbounded preceding and unbounded following) as product_id
from popular_products;

-- <코드 7-10>
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

-- 행으로 저장된 지표 값을 열로 변환하기
select dt
     , max(case when indicator = 'impressions' then val end) as impressions
     , max(case when indicator = 'sessions' then val end) as sessions
     , max(case when indicator = 'users' then val end) as users
from daily_kpi
group by dt
order by dt;

-- <코드 7-11>
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

-- 행을 집약해서 쉼표로 구분된 문자열로 변환하기
select purchase_id
     -- 상품 ID를 배열에 집약하고 쉼표로 구분된 문자열로 변환하기
     -- RedShift의 경우는 listagg를 사용!!
     , listagg(product_id, ',') as product_ids
from purchase_detail_log
group by purchase_id
order by purchase_id;

-- <코드 7-12>
-- 일련 번호를 가진 피벗 테이블을 사용해서 행으로 변환하기
select q.year
     -- q1에서 q4까지의 레이블 이름 출력하기
     , case
        when p.idx = 1 then 'q1'
        when p.idx = 2 then 'q2'
        when p.idx = 3 then 'q3'
        when p.idx = 4 then 'q4'
       end as quarter
     -- q1에서 q4까지의 매출 출력하기
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

-- <코드 7-16>
-- 일련 번호를 가진 피벗 테이블 만들기
select *
from (select 1 as idx from dual
      union all select 2 as idx from dual
      union all select 3 as idx from dual
      ) pivot;

-- <코드 7-17>      
-- split_part 함수의 사용 예(이 코드 안 먹힘..)
select split_part('A001,A002,A003', ',', 1) as part_1
     , split_part('A001,A002,A003', ',', 2) as part_2
     , split_part('A001,A002,A003', ',', 3) as part_3;
     
-- <코드 7-18>
--DROP TABLE purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , product_ids varchar(255)
);

INSERT INTO purchase_log VALUES (100001, 'A001,A002,A003');
INSERT INTO purchase_log VALUES (100002, 'D001,D002');
INSERT INTO purchase_log VALUES (100003, 'A001');

-- 문자 수의 차이를 사용해서 상품 수를 계산하기
select purchase_id
     , product_ids
     -- 상품 ID 문자열을 기반으로 쉼표를 제거하고, 문자 수의 차이를 계산해서 상품 수 구하기
     , 1 + length(product_ids) - length(replace(product_ids, ',', '')) as product_num
from purchase_log;

-- <코드 7-19>
-- 피벗 테이블을 사용해서 문자열을 행으로 전개하기
select l.purchase_id
     , l.product_ids
     -- 상품 수만큼 순번 붙이기
     , p.idx
--     -- 문자열을 쉼표로 구분해서 분할하고, idx번째 요소 추출하기(이 코드 안 먹힘..)
--     , split_part(l.product_ids, ',', p.idx) as product_id
from purchase_log l
join (select 1 as idx from dual
      union all select 2 as idx from dual
      union all select 3 as idx from dual
      ) p
      -- 피벗 테이블의 id가 상품 수 이하의 경우 결합하기
      on p.idx <= (1 + length(l.product_ids) - length(replace(l.product_ids, ',', '')))
order by l.purchase_id;