# 03 데이터 마이닝과 dplyr 패키지

# 데이터 불러오기와 저장하기

## 데이터 불러오기
#***** 데이터의 종류: R 내장 데이터, R 패키지내 데이터, 외장(R 프로그램 외부) 데이터

### 내장 데이터 불러오기(적재하기)
library(help = datasets) # 내장 데이터 목록보기

?data # 내장 데이터 불러오기 함수
?co2 # 내장 데이터 셋 설명 보기(확인)
CO2
data(CO2) # CO2 데이터 셋 불러오기
str(CO2) # 데이터 구조 확인하기

### 외장 데이터 불러오기

###### 외장 데이터는 불러오고자 하는 파일과 그 경로를 알아야 함

#### 작업경로(폴더) 확인하고 변경하기
?getwd # 현재 설정된 경로 확인
getwd()

?setwd # 앞으로 작업하고자 하는 폴더 또는 그 파일이 있는 폴더의 경로로 설정
######  작업경로 구분자는 “\” 이 아닌 "/" 또는 "\\"을 사용

# setwd("F:\도시공학과\강의\2019년2학기\수치해석\3주차_R_데이터마이닝_dplyr패키지")      # \를 사용하면 오류 발생
# setwd("F:\\도시공학과\\강의\\2019년2학기\\수치해석\\3주차_R_데이터마이닝_dplyr패키지") # \\ 사용
# setwd("F:/도시공학과/강의/2019년2학기/수치해석/3주차_R_데이터마이닝_dplyr패키지")      # / 사용
# getwd() # 바뀐 경로 확인

list.files() # 작업 폴더(경로) 내 파일 목록 확인하기

#### 데이터 파일 형식과 불러오기 함수 설명


#### 텍스트 파일 불러오고 저장하기
?read.table
?read.csv
?write.table
?write.csv

####### 충청북도 아파트 실거래가 자료(2018.09~2019.08.31) 불러오기
### R 4.0.0 버전부터는 "stringsAsFactors = FALSE" 옵션이 default 값이 되었음
apt_sale <- read.table('데이터_아파트매매가격.csv', # 현재 작업 폴더에 있는 파일 이름
                       sep=",",  # 구분자 = ","
                       header = TRUE  # 첫 행을 변수명으로
                       ) 

str(apt_sale) # 데이터 구조 확인하기

is.character(apt_sale$urban) # 데이터의 열($, 키)로 내부 열 urban 문자인지 여부 확인 
apt_sale$urban <- as.factor(apt_sale$urban) # 문자형 변수를 요인형 변수로 변환하기
# 문자, 요인변수 확인, ";"로 두 개 명령문 한 줄에서 동시 실행 가능
is.character(apt_sale$urban); is.factor(apt_sale$urban)

?write.csv # comma(,) separated values
?write.table

####### 데이터 텍스트 파일로 저장하기
write.table(apt_sale, # 저장할 객체(데이터) 이름
            'data_apt_sale_충북.txt', # 저장하고자 하는 파일 이름 명명(다른 폴더 저장시 해당 경로 설정)
            sep = ",") # 구분자 설정

file.exists('data_apt_sale_충북.txt')
list.files()

# "readr" 패키지로 텍스트 파일 불러오기
install.packages("readr")
install.packages("tidyverse")
library(readr)

?readr
?read_table # Read whitespace-separated columns into a tibble
?read_csv

apt_sale2 <- read_csv('데이터_아파트매매가격.csv', # 파일 경로와 이름
                      locale = locale('ko', encoding = 'euc-kr'))  # 한글 설정

head(apt_sale2) # 6째 행까지 데이터 확인
str(apt_sale2) # 데이터 구조 확인하기
View(apt_sale2) # 새로운 창에서 데이터 확인


?write_csv # 저장하기
write_csv(apt_sale2, # 저장할 객체 
          "test.csv") # 저장할 파일 이름 명명 

file.exists('test.csv')

#### 엑셀 데이터 불러오고 저장(출력)하기
##### Importing Excel files into R using readxl package
install.packages("readxl") # 엑셀 불러오고 저장하기 패키지 설치
library(readxl) # 엑셀 패키지 불러오기(요청)

getwd()

?read_excel

sigungu_data <- read_excel("data_by_sigungu_2018.xlsx") # 시군구 엑셀 데이터 불러오기
# sigungu_data <- read_excel(file.choose()) # 파일 이름을 모를 때 사용 또는 list.files() 함수 사용하여 확인

str(sigungu_data) # 데이터 구조 확인하기

?write_xlsx

##### Importing Excel files using xlsx package
install.packages("xlsx")
library(xlsx) # 자바(java)와 매칭되어야 하므로, 최신 자바버전 설치 필수
?xlsx
?read.xlsx
data_sigungu <- read.xlsx("data_by_sigungu_2018.xlsx", # file: 파일 경로와 이름
                          sheetName = "data", # 불러들일 시트 이름
                          header = TRUE, # 첫 행을 열의 변수명으로 함
                          encoding = "UTF-8") # 한글 코드 인식 
str(data_sigungu) # 데이터 구조 확인하기

data_sigungu2 <- read.xlsx2("data_by_sigungu_2018.xlsx", # file: 파일 경로와 이름
                            sheetIndex =  1, # 첫번 째 시트를 불러들임
                            header = TRUE) # 첫 행을 열의 변수명으로 함
str(data_sigungu2) # 모든 변수들이 요인(Factor)으로 인식됨

data_sigungu2$area <- as.numeric(data_sigungu2$area) # 시군구 면적: 요인형 변수를 숫자형 변수로 변환하기

data_sigungu2$pop_density <- as.numeric(data_sigungu2$pop_density) # 인구밀도 : 요인형 변수를 숫자형 변수로 변환하기
str(data_sigungu2)

?write.xlsx # Write a data.frame to an Excel workbook
write.xlsx(data_sigungu2, # 저장할 객체 이름 
           'd_sigungu.xlsx', # 저장할 엑셀 파일 이름
           sheetName = "data") # 엑셀 시트 이름

file.exists('d_sigungu.xlsx')
list.files()

########## 연습문제 01: 다음 중 R에서 rJava 패키지와 연동되어야 작동하는 함수(명령어)를 모두 고르시오. 
read.table ; read.csv ; write.csv ; write.xlsx ; read.xlsx ; read_xlsx ; read_xls ; read_excel

?xlsx
?read.xlsx
?write.xlsx

########## 연습문제 02: 아래의 csv 파일을 불러들여 x라는 객체에 할당하고자 할 때, 사용하게 될 올바른 명령문(함수)를 적으시오.
### 데이터_아파트매매가격.csv 파일 불러오기
x <- read.csv('데이터_아파트매매가격.csv')
str(x)
head(x)


# 데이터 마이닝
## 데이터 탐구하기
### R 4.0.0 버전부터는 "stringsAsFactors = FALSE" 옵션이 default 값이 되었음
apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)

str(apt) # 데이터 구조
head(apt) # 첫 행부터 6번째 행까지 데이터 확인
tail(apt) # 맨 마지막 행부터 6번째 행까지 데이터 확인

?View # Invoke a Data Viewer: V는 대문자 
View(apt) # 창으로 데이터 확인

summary(apt) # 요약통계

hist(apt$apt_price) # 아파트 실거래 가격(만원) 히스토 그램
summary(apt$apt_price) # 요약 통계

?quantile() # produces quantiles corresponding to the given probabilities
quantile(apt$apt_price, probs = seq(0, 1, 0.1)) # 10분위 
quantile(apt$apt_price, probs = seq(0.9, 1, 0.01)) # 90분위 부터 1%씩 가격 확인

### 자료의 크기와 길이 확인
nrow(apt) # 행의 갯수
ncol(apt) # 열의 갯수
dim(apt) # 행과 열의 갯수

### 색인(Index): 데이터 찾아보기(접근)
#******** 데이터 접근: 색인([]) 또는 키($)로 접근 가능
#******** d$colname = 데이터 프레임 d의 colname에 저장된 데이터
#******** d[m, n, drop=TRUE] = 데이터 프레임 d의 m행 n열 컬럼에 저장된 데이터
#******** x[n] n번째 요소, 숫자 또는 셀의 이름
#******** x[-n] n번째 요소를 제외한 나머지
#******** x[start:end] 벡터의 start부터 end까지의 값을 반환함. 시작과 끝 포함

##### 색인 또는 키($)로 자료 접근
apt
apt[1, 2] # 첫째 행과 두 번째 열에 있는 값
apt[13309, -3:-14]# 13309행과 3번째 부터 14번째 열을 제외한 열들에 있는 값
apt[1:2, 3:5] # 1:2행과 3:5열에 있는 값들
apt$floor_no[3] # apt 객체 중 층수(floor_no) 열에서 3번째 행에 있는 값
apt$floor_no[c(-1:-2, -4:-13309)] # 위와 동일

### 이상치 또는 특정 자료 확인
?which # Which indices are TRUE?
i <- which(apt$floor_no <= 0)
i # 행 주소(번호) 반환(확인)
apt$floor_no[i] # 실제 값 반환(확인): 지하층 있는 아파트도 있나요? ㅎㅎ

which(apt$floor_no %in% -1) # -1이 포함된 행 번호 반환

apt[c(1882, 1883, 1886, 1889, 1891 ), ] 

i <- which(apt$apt_price > 60000) # 실거래가가 6억 이상인 아파트 색인 
i
apt[i, c(2:9, 14)] # 해당 거래 자료 보기

apt$apt_price2 <- apt$apt_price / apt$area_m2 * 3.3 # 평당 아파트 가격(만원) 변수 생성
summary(apt$apt_price2)
hist(apt$apt_price2)

j <- which(apt$apt_price2 >= 1600) # 아파트 가격이 평당 1600만원 이상으로 거래된 자료 행 번호

apt[j, c(2:10, 15)] # 해당 거래 자료 보기
apt[j, -11:-14] # 해당 거래 자료 보기

### 문자(명목)변수 탐구하기
#### 요인(factor) 변수 고유값 및 빈도수 테이블 생성과 확인
str(apt)

unique(apt$urban) # 읍면동 고유값 확인
table(apt$urban) # 빈도

unique(apt$address_sigungu) # 시군구 고유값 확인
table(apt$address_sigungu) # 빈도

table(apt[c('urban', 'address_sigungu')])

#### 요인 생성, 명명, 수준, 확인 관련 함수(Factor-related Functions)
str(apt$ym_sale)
apt$ym_sale <- as.factor(apt$ym_sale)  # 거래년월 숫자형을 요인(factor)형으로 변환
str(apt$ym_sale)
is.factor(apt$ym_sale) # 팩터 여부 판단
nlevels(apt$ym_sale) # 팩터 라벨 갯수 반환
levels(apt$ym_sale) # 팩터 라벨 목록 반환
table(apt$ym_sale) # 빈도분포표

str(apt$day_sale)
apt$day_sale <- ordered(apt$day_sale) # 순서형 팩터 생성
str(apt$day_sale)
is.ordered(apt$day_sale) # 순서형 팩터 여부 판단
nlevels(apt$day_sale) # 순서형 팩터 라벨 갯수 반환
levels(apt$day_sale) # 순서형 팩터 라벨 목록 반환
table(apt$day_sale) # 빈도분포표

#### 하위데이터의 요약 통계: aggregate
?aggregate # Compute Summary Statistics of Data Subsets
#****** 사용법1 : aggregate(x, by, FUN, …, simplify = TRUE, drop = TRUE)
#Formulas, one ~ one, one ~ many, many ~ one, and many ~ many
aggregate(apt_price ~ urban, FUN=mean, data=apt) # 읍면동(urban)별 평균 실거래 가격 

?cbind # Combine R Objects by Columns: 행별 결합은 rbind()
# 읍면동(urban)별 평균 거래 가격과 평당 가격
x <- aggregate(cbind(apt_price, apt_price2) ~ urban, FUN = mean, data = apt)
x
# 시군구별 읍면동(urban)별 평균 거래 가격과 평당 가격
x2 <- aggregate(cbind(apt_price, apt_price2) ~ address_sigungu + urban, FUN = mean, data = apt)
x2
head(x2)
tail(x2)

### Formula가 아닌 색인(Index)을 활용한 방법
## <참고>
# 행렬에서 행이나 열을 하나만 인덱싱하게 되면 벡터로 변환됨
# 따라서 벡터가 아니라 행렬로 계속 차원을 유지하고 싶을 경우, "drop = FALSE" 옵션을 사용
aggregate(apt[, 'apt_price'], apt[, 'urban', drop = FALSE], mean)
# 다수의 열에 대해 결측치는 제거 후 aggregate 적용 - ex.1
aggregate(apt[, c('apt_price', 'apt_price2')], apt[, 'urban', drop = FALSE], mean, na.rm = TRUE)
# 다수의 열에 대해 결측치는 제거 후 aggregate 적용 - ex.2
aggregate(apt[, c('apt_price', 'apt_price2')], apt[, 'ym_sale', drop = FALSE], mean, na.rm = TRUE)

y <- aggregate(apt[, c(2:5, 15)], # 집계화하고자 하는 데이터 프레임
               by = list(apt$year_built), # 그룹화할 변수들의 리스트
               FUN = mean) # 계산하고자 하는 함수( Maximum, minimum, count, standard deviation and sum)
head(y)
tail(y)


### 행과 열의 집단별 요약통계: lapply, sapply, tapply
?apply  # Apply Functions Over Array Margins: apply(X, MARGIN, FUN, ...)
?lapply # Apply a Function over a List or Vector
?sapply # a user-friendly version and wrapper of lapply by default returning a vector, matrix, or others
?tapply # Apply a Function Over a Ragged Array

tapply(apt$apt_price, apt$urban, mean) # 읍면동별 평균 거래 가격
tapply(apt[, 'apt_price'], apt[, 'urban'], mean) # 읍면동별 평균 거래 가격

#*********** 연습문제 03: 전용면적(area_m2)이 30m2 이하이면서  아파트 가격(apt_price)이 2000만원 이하로 거래된 자료 행 번호를 which()로 추출하였을 때, 총 몇 개의 아파트 거래 건수가 있는지 적으시오.
apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)

str(apt)
summary(apt)

(k <- which(apt$area_m2 <= 30 & apt$apt_price <= 2000))
length(k) # 정답 : 21

#*********** 연습문제 04: 시군구(address_sigungu)별 평균 아파트 가격을 알기 위하여 tapply()로 사용하여 구하시오. 이 때 평균 아파트 거래 가격이 가장 높은 시군구를 적으시오.
tapply(apt$apt_price, apt$address_sigungu, mean) # 정답: 청주시 흥덕구 18015.900 만원


## 데이터 정렬, 병합, 변환, 추출하기
#***** 대용량 데이터를 다룰 때, 이들 데이터의 정렬, 병합, 추출, 재구조화는 분석단계 이전에서 중요한 역할을 함
#***** 데이터 구조의 병합(merge), 정렬(sort), 재구조화(reshape)의 실습을 하는 것은 중요

### 데이터 정렬: sort(), order()
#***** 데이터의 특정 변수들의 값들을 정렬(오름차순 및 내림차순)하여 데이터 탐구 및 추출을 용이하기 하는 절차적 변환
#***** 사용법: order(…, na.last = TRUE, decreasing = FALSE, method = c(“auto”, “shell”, “radix”))
#***** 정렬 방법: 오름차순 정렬과 내림차순 정렬


?sort # Sorting or Ordering Vectors(벡터만 가능)
x <- apt$apt_price
summary(x)
head(sort(x)) # 오름차순 정렬
head(sort(x, decreasing = TRUE)) # 내림차순 정렬

?order
# apt_price에 대하여 오름차순 정렬
x <- apt[order(apt$apt_price), 1:3] # 1:3 열만 추출 
head(x)
# apt_price에 대하여 내림차순 정렬
x <- apt[order(-apt$apt_price), 1:3] # 1:3 열만 추출 
head(x)
# area_m2와 apt_price에 대하여 내림차순 정렬
x <- apt[order(-apt$area_m2, -apt$apt_price), 1:5] #  1번째 열부터 5번째 열만 추출
head(x)

### 데이터 구조 변환: reshape
?reshape # Reshape Grouped Data
#****** varying: 하나의 새로운 변수로 통합할 변수들 목록
#****** v.names: 새로운 변수명
#****** timevar: 새로인 만들어진 변수인 time의 이름 부여
#****** times: 숫자 대신에 통합 되어질 고유 변수명 사용
data_sigungu <- as.data.frame(read_excel("data_by_sigungu_2018.xlsx")) # 시군구 엑셀 데이터 불러오기
str(data_sigungu) # 데이터 구조 확인하기

d <- data_sigungu[, c("id", "apt_sale_price", "apt_junse_price")] # 3개 열(변수)만 추출
head(d)
str(d)

#### wide to long
## 매매와 전세가격을 하나의 열로 재구조화
Long <- reshape(d, # 재구조화하고자 하는 데이터
                varying = c("apt_sale_price", "apt_junse_price"), # 하나의 변수로 통합할 목록
                v.names = "price", # 새로운 변수명
                timevar = "type", # 통합되어 만들어진 새로운 변수에 이름 부여
                times = c("apt_sale_price", "apt_junse_price"), # 숫자 대신 새로운 변수(열)를 만들어 통합할 변수 삽입
                direction = "long") # 재구조화 방향
str(Long)
head(Long)   
View(Long)
                                
### 특정 조건에 맞는 데이터 추출: subset
#***** 벡터, 행렬, 데이터 프레임에서 하위데이터 추출할 때 유용하게 사용되는 함수(명령문)
#***** 사용법: subset(x, subset, select, drop = FALSE, …)
apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)
str(apt)

sub_d <- subset(apt, # 추출할 데이터(객체) 
                select = id: urban) # id열부터 urban 열까지만 데이터 선택
str(sub_d)

d2 <- subset(apt,  # 추출할 데이터(객체) 
             urban == "동", # 조건: urban이 "동"인 데이터
             select = c("urban", "apt_price", "area_m2")) # 추출할 열(변수) 목록 
str(d2)
table(d2$urban) # 빈도

a <- subset(apt, 
            floor_no >20 & ym_sale <= 201812, # 층수가 20층 초과이면서 거래년월이 201812보다 이하
            select = c(-day_sale: -address_dong)) # day_sale 열부터 address_dong열 제외하고 선택
str(a)

### 데이터(프레임) 병합: merge
?merge
#***** 사용법: merge(x, y, by = intersect(names(x), names(y)), 
#*****                     by.x = by, by.y = by, all = FALSE, 
#*****                     all.x = all, all.y = all, 
#*****                     sort = TRUE, suffixes = c(“.x”,“.y”), incomparables = NULL, …)
str(apt) # 아파트 거래 자료의 시도, 시군구
str(data_sigungu) # 시군구 통계자료의 시도, 시군구

## inner join
m1 <- merge(apt, data_sigungu, # merge할 두 데이터 프레임(x, y)
            by.x = c("address_sido", "address_sigungu"), # x데이터의 병합 기준 id
            by.y = c("sido", "sigungu")) # y 객체의 병합 기준 id
str(m1)
View(m1)

## (왼쪽에 위취한 apt를 기준으로) left join
m2 <- merge(apt, data_sigungu, 
            by.x = c("address_sido", "address_sigungu"), 
            by.y = c("sido", "sigungu"),
            all.x = TRUE) # x 데이터 프레임은 매칭되지 않아도 모두 남겨둠
str(m2)
View(m2)

### rbind()를 통한 데이터 세로 결합
## rbind(x, y): x 데이터 프레임과 y 데이터 프레임을 세로 결합
apt_cb <- apt # 충청북도 아파트 거래 자료
str(apt_cb)

list.files()
# 아래의 파일은 제공받지 못했음..때문에 그냥 코드만 눈으로 익혀두자!
apt_cn <- read.table('데이터_아파트(매매)_실거래가_충남대전세종.csv', sep = ",", header = TRUE)
str(apt_cn)

a_cb <- subset(apt_cn, select = id:floor_no)
a_cn <- subset(apt_cb, select = id:floor_no)

apt_cncb <- rbind(a_cb, a_cn)
str(apt_cncb)

### 알아두면 유용한 함수들: (....), with, attach, detach
## 1. with()
# with()를 사용하지 않은 경우
a1 <- apt$apt_price[apt$floor_no > 20 & apt$area_m2 < 60]
summary(a1)
# with()를 사용한 경우우
a2 <- with(apt, apt_price[floor_no > 20 & area_m2 < 60])
summary(a2)

## 2-1. attach()
?attach # Attach Set of R Objects to Search Path
# attach()를 사용하지 않은 경우
a3 <- apt_price[floor_no > 20 & area_m2 < 60] # error 발생
summary(apt_price)
# attach()를 사용한 경우
attach(apt)
a3 <- apt_price[floor_no > 20 & area_m2 < 60] 
summary(a3)
## 2-2. detach()
detach() # 해제
summary(apt_price) # error 발생

##### 연습문제05. 아파트 전용면적(area_m2)이 100m2 이하이면서, 그 가격(apt_price)이 2억 이하로 거래된 자료만을 추출하되, apt_complex 열을 제외하고 선택하였을 때, 관측치(행)의 개수와 변수(열)의 개수를 적으시오.(subset() 함수 사용)
apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)
str(apt)
head(apt)

sub_apt <- subset(apt,
                  area_m2 <= 100 & apt_price <= 20000,
                  select = c(-apt_complex))
str(sub_apt) # 정답: 관측치(행)는 9961개, 변수(열)는 13개


# dplyr패키지를 활용한 데이터 마이닝
# install dplyr package
install.packages("tidyverse") # 깔끔한 자료
install.packages("dplyr") 

library(dplyr)
library(tidyverse)
?dplyr # a grammar of data manipulation

# usage 01
install.packages("ggplot2")
library(ggplot2)

?txhousing # Housing sales in TX in the package of "ggplot2"

dim(txhousing) #  차원 characteristics of the dataset 
str(txhousing) #  데이터 구조 characteristics of the dataset 
summary(txhousing) # 요약 통계
head(txhousing, 10) # 10개 행만 데이터 출력

## select()
?names # The Names of an Object
names(txhousing)[4:6] 

?select()
sub_tx <- select(txhousing, city, sales, median)
head(sub_tx)

sub_tx <- select(txhousing, sales:median)
head(sub_tx)

select(txhousing, -(sales:median))

sub_tx <- select(txhousing, ends_with('s'))
str(sub_tx)

sub_tx <- select(txhousing, starts_with('me'))
str(sub_tx)

## filter()
?filter # Return rows with matching conditions

tx.f <- filter(txhousing, median > 100000)
summary(tx.f$median)
str(tx.f)

tx.f <- filter(txhousing, median > 100000 & sales > 500)
summary(tx.f$sales)
str(tx.f)
select(tx.f, city, sales, median)

## rename()
?rename() # Select/rename variables by name
?txhousing # Housing sales in TX

head(txhousing[, ], 4)

txhousing <- rename(txhousing, sale_date = date, total_volume = volume)
head(txhousing[, ], 4)

## arrange()
?arrange # order tbl rows by an expression involving its variables.
txhousing <- arrange(txhousing, sales, median)
head(select(txhousing, city, sales, median), 4)
tail(select(txhousing, city, sales, median), 5) 

?desc # Descending order
txhousing <- arrange(txhousing, desc(sales, median))
head(select(txhousing, city, sales, median), 4)
tail(select(txhousing, city, sales, median), 5)

## mutate()
?mutate # Create variables (기존 데이터를 그대로 유지하면서 새로운 변수를 추가)
?transmute # transform variables (기존 데이터를 제거하고 새로이 생성된 변수만 추가)

txhousing <- mutate(txhousing,
                    median_detrend = median - mean(median, na.rm = TRUE))
head(txhousing)
summary(txhousing$median_detrend)

tx_tr <- transmute(txhousing,
                   median_detrend = median - mean(median, na.rm = TRUE),
                   invetory_detrend = inventory - mean(inventory, na.mr = TRUE))
head(tx_tr, 5)

tx_tr <- transmute(txhousing, 
                   median_detrend = median - mean(median, na.rm = TRUE), 
                   inventory_detrend = inventory - mean(inventory, na.rm = TRUE))
head(tx_tr, 5)

## group_by()
?group_by # Group by one or more variables

years <- group_by(txhousing, year) # 연도별 매트릭스 형태의 리스트 형성
head(years)
str(years)
class(years)
dim(years)

summarize(years, 
          avg_median = mean(median, na.rm = TRUE),
          min_median = min(median, na.rm = TRUE),
          max_median = max(median, na.rm = TRUE))

## %>% 파이프 연산자
### median 5분위별 median의 평균과 inventory의 평균을 알고자 한다. %%를 이용하지 않았을 때의 절차는 다음과 같다.
qq <- quantile(txhousing$median, seq(0, 1, 0.2), na.rm = TRUE)

#### 1st step: create a categorical variable of median divided into quintiles
txhousing <- mutate(txhousing, median.quint = cut(median, qq)) # 새로운 명목 변수 추가

#### 2nd step: group the data frame by the median.quint variable
quint <- group_by(txhousing, median.quint)

#### 3rd step: compute the mean of o3 and no2 within quintiles of median.
summarize(quint, 
          inventory2 = mean(inventory, na.rm = TRUE),
          median2 = mean(median, na.rm = TRUE))

## %>%
# 1. create a new variable median.quint 
# 2. split the data frame by that new variable 
# 3. compute the mean of median and inventory in the sub-groups defined by median.quint
qq <- quantile(txhousing$median, seq(0, 1, 0.2), na.rm = TRUE)

mutate(txhousing, median.quint = cut(median, qq)) %>% 
  group_by(median.quint) %>% 
  summarize(inventory2 = mean(inventory, na.rm = TRUE),
            median2 = mean(median, na.rm = TRUE))

## tbl_df()
?tibble # Build a data frame
?tbl_df # Create a data frame tbl.
?as_data_frame

library(tibble)
mtcars

(mtcars_tbl <- as_data_frame(mtcars))
(mtcars_tbl2 <- tbl_df(mtcars))

##### 연습문제07. apt 객체에서 읍면동(urban)별 거래된 아파트 가격(apt_price)의 최댓값과 전용면적(area_m2)의 최댓값을 구하시오.
apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)
str(apt)

attach(apt)

apt %>% 
  group_by(urban) %>% 
  summarize(max_apt_price = max(apt_price, na.rm = TRUE),
            max_area_m2 = max(area_m2, na.rm = TRUE))

##### 연습문제08. apt 객체에서 충주시(address_sigungu == '충주시')에서 전용면적(area_m2)이 100보다 크거나 같고, apt_price가 20000보다 크게 거래된 데이터를 추출하고 싶다. 이에 대한 함수(명령문)을 적고, 총 몇 개의 거래건수가 있는지 적으시오.
apt %>% 
  filter(address_sigungu == '충주시' & area_m2 >= 100 & apt_price > 20000) %>% 
  select(address_sigungu, area_m2, apt_price) %>% 
  summarize(count = n()) # 정답: 45건

##### 연습문제09. apt 객체에서 1979년도에 건축된 아파트의 거래건수와 거래된 아파트의 평균 가격을 dplyr 패키지를 활용하여 구하고자 한다. 실행 함수를 작성하고, 거래건수와 평균 가격을 적으시오.
str(apt)

apt %>%
  filter(year_built == 1979) %>% 
  summarize(count = n(),
            mean_apt_price = mean(apt_price, na.rm = TRUE))

##### 연습문제10. apt 데이터 프레임을 tibble 데이터 셋으로 변환하여 사용하고자 한다. 적용할 함수를 적으시오.
#* 함수명: library(tibble) > as_data_frame() 또는 tbl_df() 사용


# usage 02
?mtcars # Motor Trend Car Road Tests
str(mtcars)

## mutate()
?mutate() # Create variables; adds new variables and preserves existing one


# Newly created variables are available immediately
?min_rank

mtcars %>%
  group_by(cyl) %>%
  mutate(rank = min_rank(desc(mpg)))

# mutate() vs transmute() 비교
# mutate() keeps all existing variables
head(mtcars, 10)
x <- mtcars %>%
  mutate(displ_l = disp / 61.0237)
head(x, 10)

# transmute keeps only the variables you create
y <- mtcars %>%
  transmute(displ_l = disp / 61.0237)
head(y, 10)

## select()
?iris # Edgar Anderson's Iris Data
head(iris)
summary(iris)
str(iris)

?as_tibble # turns an existing object, such as a data frame, list, or matrix, into a so-called tibble, a data frame with class tbl_df.

iris <- as_tibble(iris) # so it prints a little nicer; Coerce lists, matrices, and more to data frames

select(iris, starts_with("Petal"))

select(iris, ends_with("Width"))

### Move Species variable to the front
select(iris, Species, everything())

select(iris, -Sepal.Length, everything())

select(iris, Petal.Length:Species)

# Drop variables with -
select(iris, -starts_with("Petal"))

# * rename() keeps all variables
rename(iris, petal_length = Petal.Length)


## filter()
?starwars # Starwars characters
class(starwars)
dim(starwars)

filter(starwars, species == "Human")

filter(starwars, mass > 1000)

# Multiple criteria
filter(starwars, hair_color == "none" & eye_color == "black")

# Multiple arguments are equivalent to and
filter(starwars, hair_color == "none", eye_color == "black")

# The following filters rows where `mass` is greater than the
# global average:
starwars %>% filter(mass > mean(mass, na.rm = TRUE))



## summarise()
?mtcars # Motor Trend Car Road Tests 데이터

head(mtcars) # 데이터 구조 확인

summary(mtcars)

# group first
mtcars %>%
  group_by(cyl) %>%
  summarise(mean = mean(disp), n = n())


# group data by two columns
mtcars %>%
  group_by(cyl, vs) %>%
  summarise(cyl_n = n())

# Each summary call removes one grouping level (since that group
# is now just a single row)
mtcars %>%
  group_by(cyl, vs) %>%
  summarise(cyl_n = n()) %>%
  group_vars()

## arrange
arrange(mtcars, cyl, disp)

arrange(mtcars, desc(disp))



# usage 03: %>%


?starwars # 데이터 설명

head(starwars) # 데이터 구조 확인

starwars %>% 
  filter(species == "Droid") # 데이터 추출

starwars %>% 
  select(name, ends_with("color")) # name열과 "color"로 끝나는 이름을 가진 조건을 충족하는 경우 열들만 선택

starwars %>% 
  mutate(name, bmi = mass / ((height / 100)  ^ 2)) %>% # bmi 변수 생성
  select(name:mass, bmi) #  name 부터 mass까지 열들과 bmi 열 선택

starwars %>% 
  arrange(desc(mass)) # mass열의 값을 기반으로 내림차순 정렬

?n() # The number of observations in the current group.
?summarise() # Reduce multiple values down to a single value

starwars %>%
  group_by(species) %>% # species별로 집단화 
  summarise(
    n = n(), # 집단별 관측치수 구하기
    mass = mean(mass, na.rm = TRUE) # mass의 관측치 값들에서 na값을 제거한 후의 평균값을 mass에 할당 
  ) %>%
  filter(n > 1) # 집단내 관측치수가 1개보다 상회한 값들만 추출(선택)


### 데이터 수정하기: 색인[], transform(), recode()
install.packages('car')
library(car) # recode() 함수를 사용하기 위해 필요한 패키지
library(dplyr)

apt <- read.table('데이터_아파트매매가격.csv', sep = ',', header = TRUE)
str(apt)

#* 아파트 거래년도 변수 생성 후 값 변경: [] 활용
apt$year_sale[apt$ym_sale > 201812] <- 2019 # year_sale 변수 생성
apt$year_sale[apt$ym_sale <= 201812] <- 2018
table(apt$year_sale)

#* 연속형 변수를 구간 변수로 생성: recode()
?recode
summary(apt$apt_price)

cuts <- '1250:7700 = 1; 7701:13500 = 2; 13501:19500 = 3; 19501:108000 = 4'
apt_price4gr <- recode(apt$apt_price, cuts)
table(apt_price4gr)

#* transform() 함수 활용
?transform
apt <- transform(apt, new = ifelse(year_built < 2000, 'old', 'new'))
table(apt$new) # 일원 빈도분포표
table(apt$new, apt$urban) # 이원 빈도분포표표

### 기타 함께 사용하는 유용한 함수들: distinct(), between(), row_number(), n()
#* 열(변수)의 행 고유값 선택하기: distinct()
?distinct
apt %>% distinct(urban)
apt %>% distinct(address_sigungu)

#* 조건 범위 설정 함수: between()
apt %>% 
  select(id:urban) %>% 
  filter(between(apt_price, 10000, 30000)) %>% # between() 함수를 사용한 경우
  summary()

apt %>% 
  select(id:urban) %>% 
  filter(apt_price >= 10000 & apt_price <= 30000) %>% # between() 함수를 사용하지 않은 경우
  summary()

#* 데이터의 순차적 숫자 값 부여: row_number()
?row_number
apt %>% 
  select(id:floor_no) %>% 
  mutate(id_number = row_number()) %>% 
  head(4)

#* 데이터의 건수를 구하는 데 사용: n()
?n()
apt %>% 
  group_by(urban) %>% 
  summarize(n())

### 데이터 병합: join()
?join

df.x <- apt
str(df.x)
df.x %>% distinct(address_sigungu)

library(readxl)
df <- sigungum_data <- read_excel('data_by_sigungu_2018.xlsx') # 전국 시군구 통계 데이터 불러오기
df.y <- df %>% filter(sido == '충청북도') # 충청북도 자료만 추출
str(df.y) # sido와 sigungu의 변수명과 속성(문자)가 df.x의 변수명과 속성(Factor)와 불일치

df.y %>% distinct(sigungu) # 시군구의 이름 확인: df.x와 일부 불일치(청주시, 상당구, 서원구, 흥덕구, 청원구)
df.y <- rename(df.y, address_sigungu = sigungu)
names(df.y)
df.y$address_sigungu <- with(df.y, as.factor(address_sigungu))
str(df.y)
df.y <- df.y %>% filter(address_sigungu != '청주시')

#* left_join()
j_left <- left_join(df.x, df.y, by = c('address_sigungu'))
str(j_left)
View(j_left)
j_left %>% 
  arrange(address_sigungu) %>% 
  distinct(address_sigungu)

#* right_join()
j_right <- right_join(df.x, df.y, by = c('address_sigungu'))
str(j_right)
View(j_right)
j_right %>% 
  filter(sido == '충청북도') %>% 
  arrange(address_sigungu) %>% 
  distinct(address_sigungu)

#* full_join()
j_full <- full_join(df.x, df.y, by = c('address_sigungu'))
str(j_full)
View(j_full)

#* anti_join()
j_anti <- anti_join(df.x, df.y, by = c('address_sigungu'))
str(j_anti)
View(j_anti)
j_anti %>% 
  arrange(address_sigungu) %>% 
  distinct(address_sigungu)

##### 연습문제: df.x와 df.y의 시군구명(address_sigungu)이 아래와 같이 서로 일치하지 않는다. df.y의 4개 시군구명으로 df.x 데이터에서 시군구명으로 바꾸고자 한다. 어떻게 하면 될까?
### 즉, 청주상당구 - 상당구, 청주서원구 - 서원구, 청주청원구 - 청원구, 청주흥덕구 - 흥덕구
library(car)
library(dplyr)

cuts = "'청주상당구' = '상당구'; '청주서원구' = '서원구'; '청주청원구' = '청원구'; '청주흥덕구' = '흥덕구'"
df.x$address_sigungu <- recode(df.x$address_sigungu, cuts)
df.x %>% 
  arrange(address_sigungu) %>% 
  distinct(address_sigungu)