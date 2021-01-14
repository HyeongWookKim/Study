# R 정형데이터 분석 03: 비지도 학습

## 주성분 분석
### 사용하게 될 패키지와 작업 폴더 파일 확인
library(dplyr)
library(ggplot2)
library(GGally)

setwd("K:\\기타\\2019년2학기\\수치해석\\실습데이터") # 실습데이터가 있는 폴더로 작업폴더 변경

### 1. 데이터 불러오기와 탐색
df.apt <- read.csv("apt3.csv") # csv파일 불러오기
df2.apt <- df.apt %>% 
  select(apt_price, # 데이터 열 선택: 아파트 실거래가격(만원)
         price_pyung, # 평당가격(만원)
         area_m2, # 전용면적(m2)
         floor_no, # 층수
         built_age) # 건축연령 

round(cov(df2.apt), 3) # 공분산 행렬: 대각선은 분산,이외는 공분산
round(cor(df2.apt), 3) # 상관 행렬

?ggpairs() # A ggplot2 generalized pairs plot
ggpairs(df2.apt) # 객체 전체 데이터 산점도 매트릭스 그래프 작성

### 2. 차원 축소: 주성분 분석
?prcomp() # Principal Components Analysis
m.pca <- prcomp(df2.apt, # df2.apt 데이터 전체 변수들
                center = TRUE, # 평균 중심화: 평균을 0으로
                scale = TRUE) # 분산을 1로..
summary(m.pca) # 결과요약
print(m.pca) # 주성분 점수 출력
plot(m.pca, # 주성분 결과 스크리 검정 그래프 
     type="l") # 선의 유형 = line

?biplot() # Biplot of Multivariate Data
biplot(m.pca, # 주성분 2개 축 그래프 작성
       cex = c(0.3, 0.8)) # 점의 크기와 텍스트 크기 비율


### 3. 주성분 점수 산출
# 원래 데이터와 선형계수를 메트릭스 곱으로 관측치별 선형조합 주성분 값 산출
pr.c <- as.matrix(df2.apt) %*% # 행렬로 변환하고 행렬 곱 연산(%*%)
                m.pca$rotation # m.pca의 Rotation 값 
head(pr.c) # 데이터 일부 확인
pr.c.df <- as.data.frame(pr.c) # 데이터 프레임으로 변환
str(pr.c.df) # 데이터 구조 확인

df3.apt <- cbind(df.apt, # 데이터 열 결합
                 pr.c.df)
summary(df3.apt) # 요약 통계


### 4. 주성분 결과 활용: 랜덤포레스트 학습모델링
library(randomForest) # 미설치시 install.packages("randomForest")
m.rf.apt <- randomForest(urban ~ # 분류항목 urban 종속변수
                         PC1 + PC2 + season, # 설명변수 PC1, PC2, season
                         data=df3.apt, # 사용할 데이터 객체
                         importance = TRUE) # 변수 중요도 측정 여부
m.rf.apt # 모델 훈련에 사용되지 않은 데이터를 사용한 에러 추정치가 ‘OOBOut of Bag estimate of error rate’ 항목으로 출력

pred.y <- predict(m.rf.apt, # 학습모델 예측
                  data=df3.apt # 사용할 데이터
                  , type = "class") # 분류항목으로 에측
table(pred.y, # 빈도분포표: 예측치
      df3.apt$urban)  # 실측치
library(caret) # caret 패키지의 혼동행렬
confusionMatrix(pred.y, # 혼동 행렬: 예측치
                df3.apt$urban) # 시험데이터 실측치

#************************** 연습문제 01
#* "df.seoul.worker.csv“ 데이터를 불러들여, 서울 동남권 거주자(area.living == 5)와 
#* 아래에 해당하는 변수들만을 추출하여 df2에 할당하라는 명령문을 작성하시오.

?read.csv
df <- read.csv("df.seoul.worker.csv") # csv 파일 불러오기
df2 <- df %>% 
  filter(area.living == 5)  %>% # 서울 동남권 거주자만 추출 
  select(age, # 만나이
           edu.level, # 교육수준
           hh.income, # 총가구 소득
           commuting.time, # 통근시간(분)
           commuting.area, # 통근 목적지
           feel.commuting) # 통근 만족도
str(df2)


#************************** 연습문제 02
#* 연습문제 01에서의 df2객체를 활용하여 표준화(center, scale)한 데이터로 주성분 분석을 실행하시오. 
#* 이 때, 첫번째 주성분의 고유값은 얼마인가요?
#* 주성분 분석 결과로 볼 때, 몇 개의 주성분으로 차원을 축소하는 것이 좋을까요?

m.pca <- prcomp(df2,
                center = TRUE, # 평균 중심화: 평균을 0으로
                scale = TRUE) # 분산을 1로..
summary(m.pca)
print(m.pca)
plot(m.pca, type="l")

#################### 군집 분석 #####################################
setwd("K:\\기타\\2019년2학기\\수치해석\\실습데이터") # 실습데이터가 있는 폴더로 작업폴더 변경
list.files()
### 1. 데이터 불러오기와 탐색
library(readxl)
df <- read_excel("data_by_sigungu_2018.xlsx", 1) # 엑셀 파일 불러오기
df2 <- df %>%  # 필요한 변수 추출하기 
  select(id, # 시군구 id
         area, # 행정구역 면적
         pop_density, # 인구밀도 
         pop_tot, # 총인구수
         pop_female, # 여성인구수
         age_average, # 평균 나이
         r_aged, # 65세 이상 인구 비율
         pop_net_move, # 순인구 이동수
         housing) # 주택수
df2$age_average <- as.numeric(df2$age_average) # 평균 연령을 숫자형 변수로 변환
summary(df2) # 요약 통계

### 2. 데이터 준비: 결측치 제거와 정규화
df3 <- df2 %>% select(-id) # 분석에 사용될 데이터만 추출(id 제외)
df3 <- na.omit(df3) # listwise deletion of missing
df3 <- scale(df3) # standardize variables
summary(df3) # 데이터 요약

### 3. 군집의 갯수 설정Determine number of clusters
library(NbClust) # install.packages("NbClust")
?NbClust() # determining the best number of clusters
nc1 <- NbClust(df3,  # 군집화할 데이터
              min.nc=2, # 최소군집의 수
              max.nc=15, # 최대군집의 수
              distance = "euclidean", # 거리계산
              method="kmeans") # 군집 방법론

nc2 <- NbClust(df3, # 군집화할 데이터 
              min.nc=2, # 최소군집의 수 
              max.nc=15, # 최대군집의 수 
              distance = "euclidean", # 거리계산
              method="ward.D") # 군집 방법론

nc3 <- NbClust(df3, # 군집화할 데이터
              min.nc=2, # 최소군집의 수 
              max.nc=15,  # 최대군집의 수
              distance =  "manhattan", # 거리계산
              method="ward.D2") # 군집 방법론


### 4-1. K-Means Cluster Analysis
fit <- kmeans(df3, 3) # 3 cluster solution

aggregate(df3, # get cluster means
          by = list(fit$cluster), # 군집별로 
          FUN = mean) # 특성변수들의 평균 산출

# append cluster assignment
df4 <- data.frame(df3, # 군집 결과를 기존 데이터와 합치기
                  fit$cluster)
df4 <- df4 %>% rename(cluster.kmeans = fit.cluster)
table(df4$cluster.kmeans) # 군집 빈도분포

### 4-2. Ward Hierarchical Clustering
?dist() # Distance Matrix Computation
d <- dist(df3, method = "euclidean") # distance matrix 설정

?hclust() # Hierarchical Clustering
fit2 <- hclust(d,  # distance matrix
              method="ward.D") # 군집 방법 
par(mfrow = (c(1,1))) # 그래픽 환경 설정: 한 화면에 한 개의 그래프 
plot(fit2) # display dendogram
groups <- cutree(fit2, k=3) # cut tree into 3 clusters
rect.hclust(fit2, k=3, border="red") # # draw dendogram with red borders around the 3 clusters


### 5. 군집 결과 비교 및 기존 데이터와 연결
df4 <- data.frame(df4, # 군집 결과를 기존 데이터와 합치기
                  fit$cluster)
table(df4$fit.cluster) # 계층적 군집 결과 
table(df4$cluster.kmeans, # 이원빈도분포표: kmeans 군집결과 
      df4$fit.cluster) # 계층적 군집 결과
summary(df4)

#***************** 연습문제 03
#* 시군구별 데이터인 "data_by_sigungu_2018.xlsx"를 불러들여, 다음과 같은 변수들만 추출하여 군집분석을 실시하고자 한다. 
#* 최적의 군집의 갯수를 몇 개로 하는 것이 가장 바람직한 지 논의하시오.
### 1. 데이터 불러오기와 탐색
library(readxl)
df <- read_excel("data_by_sigungu_2018.xlsx", 1) # 엑셀 파일 불러오기
df2 <- df %>%  # 필요한 변수 추출하기 
  select(pop_density, # 인구밀도 
         r_aged, # 65세 이상 인구 비율
         pop_net_move, # 순인구 이동수
         apt_sale_price, # 아파트 거래가격지수
         accident_per_1000car) # 1000대 차량당 사고건수

summary(df2) # 요약 통계

### 2. 데이터 준비: 결측치 제거와 정규화
df3 <- na.omit(df2) # listwise deletion of missing
df3 <- scale(df2) # standardize variables
summary(df3) # 데이터 요약

### 3. 군집의 갯수 설정Determine number of clusters
library(NbClust) # install.packages("NbClust")
nc1 <- NbClust(df2,  # 군집화할 데이터
               min.nc=2, # 최소군집의 수
               max.nc=15, # 최대군집의 수
               distance = "euclidean", # 거리계산
               method="kmeans") # 군집 방법론

nc2 <- NbClust(df3,  # 군집화할 데이터
               min.nc=2, # 최소군집의 수
               max.nc=15, # 최대군집의 수
               distance = "euclidean", # 거리계산
               method="kmeans") # 군집 방법론