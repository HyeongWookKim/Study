# 베이지언 분류 모델을 지원해 주는 e1071, STAN같은 다양한 패키지
library(e1071) # 미설치시 install.packages("e1071")
library(caret) # 미설치시 install.packages("caret")
library(klaR) # 미설치시 install.packages("klaR")
library(ggplot2)
library(dplyr)

## 실습 1: 지난 1년간 자원봉사활동 참여 여부(e1071 패키지 활용)
### 1. 데이터 탐색 및 전처리
setwd("K:\\기타\\2019년2학기\\수치해석\\실습데이터")
list.files() # 현재 작업폴더 파일 확인
df<-read.csv("df.seoul.worker.csv") # 데이터 불러오기
str(df) # 데이터 구조 확인

attach(df) # df 객체 바로 접근하기 색인 
table(voluntary.working) # 지난 1년간 자원봉사 활동 참여: 1 = yes, 2 = no
table(com.2modes) # 통근수단: 1 = 승용차, 0 = 기타
table(gender) # 성별: 1=남성, 2=여성
table(edu.level) # 교육수준: 1=중학교 이하, 2=고졸 이하, 3=대졸이하, 4=대학원 이상
table(job.type) # 직업 유형: 1=관리전문직, 2=사무직, 3=생산판매직, 4=기타
table(job.position) # 고용형태: 1=상용근로, 2=임시일용근로, 3=고용없는자영업, 4=고용원 있는 자영업, 5=무급가족종사자
table(income.level) # 개인소득: 1 ' 100만원 미만', 2 '100-200만원 미만', 3 '200-300만원 미만', 4 '300-400만원 미만', 5 '400-500만원 미만', 6 '500만원 이상'
table(hhm.no) # 가구원수: 1인, 2인,....
table(marriage.status) # 혼인상태: 1=기혼, 2=미혼, 3=이혼/별거, 5=사별, 6=동거
detach() # 바로가기 색인 해제

df <- df %>%
  mutate(  # mutate() 함수로 숫자 변수를 요인으로 변환
    voluntary.working = factor(voluntary.working), # 자원봉사 활동 참여 여부
    gender = factor(gender), # 성별
    com.2modes = factor(com.2modes), # 통근수단
    edu.level = factor(edu.level), # 교육수준
    job.type = factor(job.type), # 직업유형
    job.position = factor(job.position), # 고용형태
    income.level = factor(income.level), # 개인소득
    hhm.no = factor(hhm.no), # 가구원수
    marriage.status = factor(marriage.status) # 혼인상태
  )

df2 <- df %>% # select() 함수로 필요한 변수들만 추출하여 df2에 할당 
  select(voluntary.working, # 자원보상활동 변수
         com.2modes:hh.income, # com.2modes 부터 hh.income까지 변수들
         area.living) # 주거지역 대생활권 
str(df2)

### 3. 데이터 분할
set.seed(1234) # 난수 생성 규칙 설정(재현성 확보)

?createDataPartition() # 데이터 분할 함수(Data Splitting functions)

yes.train <- createDataPartition(y=df2$voluntary.working, # 자원봉사활동 변수 기준
                               p=0.7, # 0.7의 비율로 무작의 추출
                               list=FALSE) # 리스타 아닌 행렬로
class(yes.train) # 해당 객체 속성 확인

### 4. 훈련데이터 학습모델링
train <- df2[yes.train, ] # df2를 intrain에 해당하는 행들만 추출
test <- df2[-yes.train, ] # df2를 intrain에 해당하지 않는 행들만 추출

?naiveBayes() # 나이브 베이즈 분류기(Naive Bayes Classifier) 함수: laplace=0 기본 값임
m.nb <- naiveBayes(voluntary.working ~ # 종속변수
                         ., # 이외 나머지 변수들은 특징(독립) 변수
                       data = train) # 훈련데이터 셋으로 학습모델링
m.nb # 실행결과 확인


### 5. 예측 및 교차타당성
nbpred <- predict(m.nb, # 훈련 학습모델 기반 예측
                  test, # test 데이터셋 활용
                  type='class') # 예측값을 확률이 아닌 분류로 

?confusionMatrix() # 혼동행렬 생성 함수
cm.01 <- confusionMatrix(nbpred, # nbpred 실행결과
                         test$voluntary.working) # test 데이터셋의 voluntary.working
cm.01 # 혼동행렬 실행결과 확인


ggplot(test, # 정답과 오답 분류표 그래프화
       aes(voluntary.working, # 미학요인: x 축
           nbpred, # y축
           color = voluntary.working)) + # 색상
  geom_jitter(width = 0.3, # jitter 그래프, 폭은 0.3배
              height = 0.4, # 높이는 0.4배
              size = 0.2) + # 점의 크기는 0.2배
  labs(title = "Confusion Matrix", # 제목
          subtitle = "Predicted vs. Observed from 봉사활동 데이터", # 하위 제목
          y = "Predicted", # y축: 1=yes, 2=no
          x = "Obseerved") # x 축: 1=yes, 2=no

## 실습 2: 연속변수를 모두 요인으로 변환하여 모델링(e1071 caret 패키지 둘 다 사용)
### 1.데이터 탐색
str(df2)


### 2. 요인 변환
df2 <- df2 %>% 
  mutate(age_group = ifelse(age <=29, "20s_less", # age_group: 20대 또는 이하
                            ifelse(age>=30 & age < 40, "30s", # 30대
                                   ifelse(age>=40 & age < 50, "40s", # 40대 
                                          ifelse(age>=50 & age < 60, "50s", "60s_over"))))) # 50대, 60대 이상
df2$age_group <- as.factor(df2$age_group) # 요인으로 변환
summary(df2$age_group)

quantile(df2$commuting.time) # 통근시간 분위 통계량 확인
df2 <- df2 %>%  mutate(com.time2 = 
                         ifelse(commuting.time <20, "less", # 20분 미만
                                            ifelse(commuting.time > 40, "more", "median"))) # 40분 초과, 기타 중간
df2$com.time2 <- as.factor(df2$com.time2) # 요인으로 변환


quantile(df2$hh.income) # 총 가구소득
df2 <- df2 %>% 
  mutate(hh.income2 = ifelse(hh.income <8, "low", # 8구간 미만 
                                         ifelse(hh.income >13, "high", "median"))) # 13구간 초과
df2$hh.income2 <- as.factor(df2$hh.income2) # 요인으로 변환

df2 <- df2 %>% 
  mutate(area.living = factor(area.living), # mutate()함수로 요인 변환
         commuting.area = factor(commuting.area))

df3 <- df2 %>% 
  select(-age, -commuting.time, -hh.income) # 3가지 연속변수 모두 제외하고 새 객체에 할당

str(df3) # 데이터 구조로 모든 변수 요인 확인

### 3. 데이터 분할
set.seed(1234) # 난수생성 규칙 설정(재현성)
yes.train2 <- createDataPartition(y=df3$voluntary.working, # 분할 기준 변수
                                p=0.7, # 확률 0.7
                                list=FALSE) # 리스트가 아닌 행렬로
train2 <-df3[yes.train2, ] # 훈련 데이터셋
test2 <-df3[-yes.train2, ] # 시험 데이터셋


### 4. 나이브 베이즈 학습모델링
m.nb2 <- naiveBayes(voluntary.working ~ # 예측 변수
                      ., # 나머지는 모두 특징(설명)변수
                    data = train2) # 사용할 데이터 객체
m.nb2


?train() # caret 패키지: Fit Predictive Models over Different Tuning Parameters
ctrl <- trainControl(method="cv", 10) # cross-validataion, 10-fold 데이터 분할
m.nb3 <- train(train2[ , -1], 
               train2[ , 1], # 예측 변수, 나머지는 모두 특징(설명)변수
               method = 'nb', # Naive Bayes: 사용가능 모델링(http://topepo.github.io/caret/train-models-by-tag.html)
               trControl=ctrl) # cross-validataion, 10-fold 데이터 분할

# trControl() # Control parameters for train
# method	= The resampling method: "boot", "boot632", "optimism_boot", "boot_all", "cv", "repeatedcv", "LOOCV", "LGOCV" 
# number	= Either the number of folds or number of resampling iterations

### 5. 예측 및 교차 타당성
nbpred2 <- predict(m.nb2, # Predict testing set
                   newdata = test2, # 시험 데이터셋 활용
                   type = 'class') # 수준으로 예측

cm.02 <- confusionMatrix(nbpred2, # e1071 패키지 활용 훈련 학습모델 결과 예측치
                         test2[ , 1]) # 시험 데이터셋 실측치
cm.02 # 혼동행렬 결과 보기

nbpred3 <- predict(m.nb3, # caret 패키지 훈련 학습모델로 예측
                   newdata = test2) # 시험 데이터셋 
cm.03 <- confusionMatrix(nbpred3, test2$voluntary.working)
cm.03

#Plot Variable performance
?varImp() # Calculation of variable importance for regression and classification models
v.i <- varImp(m.nb3) # caret 패키지: "e1071' 패키지의 함수 결과로는 작동하지 않음
v.i
plot(v.i)


# 실습3: marriage.status(LaPlase 추정통계량 적용)
### 1. 데이터 탐색 및 요인 변환
table(df3$marriage.status) # 혼인상태: 1=기혼, 2=미혼, 3=이혼/별거, 5=사별, 6=동거

?recode() # dlpyr:: Recoding factors using recode
df3$marriage.status <- recode(df3$marriage.status, "6" = "2") # 동거를 미혼과 합침
table(df3$marriage.status) # 혼인상태: 1=기혼, 2=비혼, 3=이혼/별거, 5=사별


### 2. 데이터 분할
set.seed(1234) 
yes.train4 <- createDataPartition(y=df3$marriage.status, 
                                p=0.7, 
                                list=FALSE) 
train4 <-df3[yes.train4, ] # 훈련용 데이터셋
test4 <-df3[-yes.train4, ] # 시험용 데이터셋


### 3. 훈련 데이터 셋으로 학습모델링
m.nb4 <- naiveBayes(marriage.status ~ # 종속변수
                     ., # 이외 나머지 변수들은 특징(독립) 변수
                   data = train4) # 훈련데이터 셋으로 학습모델링
m.nb4 # 실행결과 확인

### 4. 예측 및 교차 타당성 검증
nbpred4 <- predict(m.nb4, # 훈련 학습모델 기반 예측
                  test4, # test 데이터셋 활용
                  type='class') # 예측값을 확률이 아닌 분류로 

?confusionMatrix() # 혼동행렬 생성 함수
cm.04 <- confusionMatrix(nbpred4, # nbpred 실행결과
                         test4$marriage.status) # test 데이터셋의 voluntary.working
cm.04 # 혼동행렬 실행결과 확인

### 5. Lapace 추정량=0.1 모델링 및 예측 
m.nb5 <- naiveBayes(marriage.status ~ # 예측 변수
                      ., # 모든 변수 
                      laplace = 0.1, # laplace = 0.1
                      data = train4) # 사용할 데이터 객체
nbpred5 <- predict(m.nb5, 
                   test4, 
                   type='class')
cm.05 <- confusionMatrix(nbpred4, 
                test4$marriage.status)
cm.05

ggplot(test4, aes(marriage.status, nbpred4, color = marriage.status)) +
  geom_jitter(width = 0.3, height = 0.3, size=0.3) +
  labs(title="혼동행렬(Confusion Matrix)", 
       subtitle="결혼 상태 분류 실제와 예측 결과", 
       y="Predicted", 
       x="Observed") # 1=기혼, 2=비혼, 3=이혼/별거, 5=사별

#********* 연습문제 03
# 위의 결혼상태 훈련모델에서 laplace = 0.3으로 주고, laplace = 0.1과 0일 대의 결과와 비교하시오.
### 5. Lapace 추정량=0.1 모델링 및 예측 
m.nb6 <- naiveBayes(marriage.status ~ # 예측 변수
                      ., # 모든 변수 
                    laplace = 0.3, # laplace = 0.3
                    data = train4) # 사용할 데이터 객체
nbpred6 <- predict(m.nb6, 
                   test4, 
                   type='class')
cm.06 <- confusionMatrix(nbpred6, 
                         test4$marriage.status)
cm.06 # laplace = 0.3
cm.05 # laplace = 0.1