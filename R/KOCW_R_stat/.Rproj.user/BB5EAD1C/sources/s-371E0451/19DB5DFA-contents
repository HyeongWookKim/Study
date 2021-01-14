# R 정형데이터 분석 02: 분류와 예측

## Cross-validation methods
### The Validation set Approach
#* 1. Build (train) the model on the training data set
#* 2. Apply the model to the test data set to predict the outcome of new unseen observations
#* 3. Quantify the prediction error as the mean squared difference between the observed and the predicted outcome values.

### 사용하게 될 패키지와 작업 폴더 파일 확인
library(dplyr) # dplyr 패키지 
library(ggplot2) # 데이터 시각화 ggplot2 패키지
install.packages("caret")
library(caret)

df <- read.table("df.seoul.worker.csv", header = TRUE, sep = ",") # csv 파일 불러오기
str(df) # 데이터 구조 확인

df2 <- df %>% 
  select(commuting.time, gender, age, commuting.area) # 4개 변수(열)만 추출
str(df2)

### 1. Split the data into training and test set
?createDataPartition() # 비율 생성 함수
?set.seed() # 난수 생성

set.seed(123) # 123 코드로 난수생성 

training.samples <- df2$commuting.time %>% # df2의 통근시간
  createDataPartition(p = 0.8, list = FALSE) # 비율 0.8로 데이터 분할 생성 명령

train.data <- df[training.samples, ] # 80% 훈련 데이터 생성
test.data <- df[-training.samples,]  # 20% 시험 데이터 생성(-x)

nrow(df2); nrow(train.data); nrow(test.data)

### 2. Build the model
model <- lm(commuting.time ~ # 선형회귀모델: 종속변수=통근시간
              as.factor(gender) + # 설명변수: gender를 요인으로
              age + # 설명변수: age 연속변수
              as.factor(commuting.area), # 설명변수: 요인으로
              data = train.data) # 훈련 데이터셋
summary(model)

### 3.  Make predictions and compute the R2, RMSE and MAE
predictions <- model %>% # 훈련데이터 모델 결과 
  predict(test.data) # 시험 데이터 예측값 생성

data.frame(R2 = R2(predictions, test.data$commuting.time),
           RMSE = RMSE(predictions, test.data$commuting.time),
           MAE = MAE(predictions, test.data$commuting.time))

## Leave one out cross validation - LOOCV
### Define training control
?trainControl() # Control parameters for train
train.control <- trainControl(method = "LOOCV") # 훈련데이터 통제방법 = "LOOCV"

### Train the model: 시간이 오래 걸림
?train() # Fit Predictive Models over Different Tuning Parameters
model <- train(commuting.time ~ # 선형회귀모델: 종속변수=통근시간
                 as.factor(gender) + # 설명변수: gender를 요인으로
                 age + # 설명변수: age 연속변수
                 as.factor(commuting.area), # 설명변수: 요인으로, 
               data = df2, # 사용할 데이터셋
               method = "lm", # 선형회귀모델
               trControl = train.control) # 훈련데이터 통제방법

### Summarize the results
print(model)

## K-fold cross-validation
### 1. Define training control
set.seed(123) # 난수 생성 
train.control <- trainControl(method = "cv", # cross validation
                              number = 5) # 5-fold 설정
### 2. Train the model
model <- train(commuting.time ~ # 선형회귀모델: 종속변수=통근시간
                 as.factor(gender) + # 설명변수: gender를 요인으로
                 age + # 설명변수: age 연속변수
                 as.factor(commuting.area), # 설명변수: 요인으로, 
               data = df2, # 사용할 데이터셋
               method = "lm", # 선형회귀모델
               trControl = train.control) # 훈련데이터 통제방법

### 3. Summarize the results
print(model)

## Repeated K-fold cross-validation
### 1. Define training control
set.seed(123)
train.control <- trainControl(method = "repeatedcv", # 훈련데이터 통제 = "repeatedcv" 
                              number = 5, # 5-fold 설정
                              repeats = 3) # 반복횟수 설정

### 2. Train the model
model <- train(commuting.time ~ # 선형회귀모델: 종속변수=통근시간
                 as.factor(gender) + # 설명변수: gender를 요인으로
                 age + # 설명변수: age 연속변수
                 as.factor(commuting.area), # 설명변수: 요인으로, 
               data = df2, # 사용할 데이터셋
               method = "lm", # 선형회귀모델
               trControl = train.control) # 훈련데이터 통제방법

### 3. Summarize the results
print(model)
print(model$results)

#******************** 연습문제 01: 분류 모델의 결과로 다음과 같은 혼동행렬의 값을 얻었다. 아래의 질문에 답하시오.
x1 <- 1000; x2 <- 150 ; y1 <- 55 ; y2 <- 10000

y2 / (y2 + 100) # Precision = 0.99
(x1 + x2) / (x1 + x2 + y1 + y2) # Accuracy = 0.10
y2 / (y2 + y1) # Recall = 0.99
x1 / (x1 + x2) # Specificity = 0.87
x2 / (x2 + x1) # FP Rate = 0.13
2 * (y2 / (y2 + 100)) - (y2 / (y2 + y1)) /  (y2 / (y2 + 100)) + (y2 / (y2 + y1)) # F1 score = 1.97
  
#******************** 연습문제 02: 
# caret 패키지의 createDataPartition()함수로 "df.seoul.worker.csv" 데이터를 불러들여 df 객체에 할당한 후, com.2modes 변수를 기준으로 훈련 데이터셋(train.data)을 70%로, 시험 데이터셋(test.data)으로 30%를 무작위로 추출하고자 한다.
# 이렇게 하였을 경우에 전체 데이터의 관측치수, 훈련데이터의 관측치수, 시험데이터의 관측치의 갯수는 얼마인가?
df <- read.csv('df.seoul.worker.csv')
str(df)

training.samples <- df$com.2modes %>% 
  createDataPartition(p = 0.7, list = FALSE)

train.data <- df[training.samples, ]
test.data <- df[-training.samples, ]
nrow(df); nrow(train.data); nrow(test.data)


################ 이항 로지스틱 모델 
# 실습 1: 실제 소요되는 통근시간의 특성에 따라  통근수단(승용차=1, 기타 수단 =0) 중 승용차를 선택할 확률 결정
## 1. 데이터 불러오기와 탐색
df <- read.csv("df.seoul.worker.csv")
str(df)
attach(df) # 데이터 객체 바로 접근하기

table(com.2modes) # 통근수단: 1 = 승용차, 0 = 기타

df %>% 
  group_by(com.2modes) %>%  # 통근수단별 집단화
  summarize(m_time = mean(commuting.time), # 평균 통근시간
            sd_time = sd(commuting.time), # 표준편차
            max_time = max(commuting.time), # 최댓값
            min_time = min(commuting.time)) # 최솟값

ggplot(data = df, aes(x = as.factor(com.2modes), y = commuting.time, group = com.2modes)) +
  geom_boxplot(fill = 'slategrey', color = 'darkslategrey', width = 0.3) +
  stat_summary(fun = 'mean', geom = 'point', size = 3, fill = 'blue') +
  labs(title = "통근수단별 통근시간 박스 그래프",
       x = "통근수단(1 = 승용차, 0 = 기타 수단)",
       y = "통근시간(분)")

ggplot(data = df, aes(x = commuting.time, y = as.factor(com.2modes)))+
  geom_jitter(cex = 0.3, col = "blue") +
  labs(title = "통근수단별 통근시간 jitter 그래프",
       x = "통근시간(분)",
       y = "통근수단(1 = 승용차, 0 = 기타 수단)")

## 2.데이터 분리(구분)
### Split the data into training and test set
?floor()
sample.size = floor(0.8 * nrow(df)) # df에서 80%의 데이터만 샘플로 사용할 것

set.seed(123) # 난수생성

?sample # Random Samples, x 객체, size = 추출할 갯수
train.id <- sample(seq_len(nrow(df)), # 1, 2, ...., n까지의 번호 생성, 무작위 표본 추출
                   size = sample.size)  # 무작위 표본 추출, size = 추출할 갯수(여기서는 p = 0.8)

train <- df[train.id, ] # 훈련 데이터 
test <- df[-train.id, ] # 시험 데이터
nrow(train); nrow(test) # 추출된 객체 갯수 확인

## 3. Logistic Regression Model
?glm() # Fitting Generalized Linear Models
m.slogit <- glm(com.2modes ~ # 통근수단: 1 = 승용차, 0 = 기타수단
                commuting.time, # 통근시간 설명면수
                data = train, # 데이터 셋
                family = binomial) # 이항로짓모형 설정
summary(m.slogit) # 결과 요약

round(summary(m.slogit)$coef, 4) # 회귀계수 소숫점 4자리로 반올림
round(exp(m.slogit$coef), 4) # 오즈비(odds ratio) 계산 (해석: 승용차를 통근수단으로 사용할 확률이 1.01배 더 높다)

anova(m.slogit, test = "Chisq") # NULL 모형과 commuting.time이 포함된 모형 비교 진단

library(pscl)
?pR2() # compute various pseudo-R2 measures
round(pR2(m.slogit), 4) # 모형 통계량 산출 

## 4. Making predictions on Training set
library(ROCR) # Function to create prediction objects
p <- predict(m.slogit, # 훈련 모델 
             newdata = test, # 시험 데이터셋
             type = "response")  # 종속변수 예측
?prediction() # Function to create prediction objects
pr <- prediction(p, # 시험 데이터로부터 예측된 예측값
                 test$com.2modes) # 시험 데이터의 실제값
?performance() # 인수 내용 확인 필요: Function to create performance objects
# y축: True positive rate(TPR)
# x축: False positive rate(FPR)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
# ROC Curve 그리기
plot(prf,
     main = "Area under curve by TPR vs FPR in the simple logistic model",
     xlab = "False positive rate(FPR)",
     ylab = "True positive rate(TPR)",
     lwd = 3,
     col = "blue")
abline(a = 0, b = 1, col = 'red', lwd = 3, lty = 2)

# AUC(Area under the ROC curve) 확인
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

## 실습 2: 다양한 특성들에 의하여 직장인들이 통근수단(승용차 = 1, 기타 수단 = 0) 중 승용차를 선택할 확률 결정
### 3. 훈련 모델(데이터 탐색과 데이터 분리는 앞서와 동일)
m.mlogit <- glm(com.2modes ~ commuting.time + as.factor())

m.mlogit <- glm(com.2modes ~ # 통근수단 종속변수
                  commuting.time + # 통근시간(분)
                  as.factor(commuting.area) + # 통근지역(1: 현재 살고 있는 동 내, 2: 현재 살고 있는 구 내 다른 동, 3: 다른 구, 4: 다른 시/도)
                  as.factor(gender) + # 성별(1 = 남성, 2 = 여성)
                  age + # 만 나이
                  edu.level + # 교육 수준(1: '중학교 이하', 2: '고졸 이하', 3: '대졸 이하', 4: '대학원 이상')
                  as.factor(job.type) + # 직업 유형(1: '관리 전문직’, 2: '화이트 칼라’, 3: '블루 칼라’, 4: '기타)
                  hhm.no + # 가구원 수
                  as.factor(h.type) +  # 주택 유형(1: 단독, 2: 아파트, 3: 다세대, 4: 연립/빌라, 5: 기타)
                  hh.income + # 가구 총소득
                  as.factor(area.living) + # 서울 거주지역(1: 도심, 2: 동북, 3: 서북, 4: 서남, 5: 동남)
                  feel.walk.reside  +  # 거주지 걷기와 달리기 적합도
                  feel.bus + # 버스 이용환경 만족도
                  feel.subway, # 지하철 이용환경 만족도
                family = binomial,
                data = train)
summary(m.mlogit) # 모형 결과 요약

round(m.mlogit$coef, 3) # 회귀계수
round(exp(m.mlogit$coef), 3) # odds ratio(오즈비)

library(car)
# 다중공선성(Multicollinearity) 진단: vif
?vif
round(vif(m.mlogit), 3) # 분산팽창계수(vif): 일반적으로 10보다 크면 문제가 있다고 판단함

anova(m.mlogit, test = "Chisq") # NULL 모형과 다른 변수들을 추가한 모형을 비교 진단

library(pscl)
round(pR2(m.mlogit), 4) # 모형 통계량 

### 4. 예측과 교차검증
library(ROCR)
p <- predict(m.mlogit, # 훈련 모델
             newdata = test,# 시험 데이터 셋 사용
             type = "response") 
pr <- prediction(p, # 예측값
                 test$com.2modes) #  실제값
prf2 <- performance(pr, # 성능평가할 객체
                    measure = "tpr", # 평가지표 = True positive rate
                    x.measure = "fpr") # A second performance measure = False positive rate
# 1) 다양한 변수들을 추가한 로지스틱 회귀모형의 ROC Curve
plot(prf2, # TPR과 FPR로 ROC Curve 작성
     main = "Area under curve by TPR vs FPR in the multiple logistic model",
     xlab = "False positive rate(FPR)",
     ylab = "True positive rate(TPR)",
     lwd = 3, # 선의 두께 = 3
     col = "blue") # 색 = 파란색
# 2) commuting.time 변수만 추가한 로지스틱 회귀모형의 ROC Curve
plot(prf, # prf 객체 활용 그래프: 이전 이항 로지스틱 모델 결과
     add = TRUE, # 앞의 그래프에 추가
     col = "red", lwd = 3)
abline(a = 0, b = 1, # a = 절편, b = 기울기
       col = "black", lwd = 3, lty = 2)

# AUC(Area under the ROC curve) 확인
auc <- performance(pr, measure = "auc") 
auc <- auc@y.values[[1]]
auc

## 일반화가법모델: Logistic Regression Model using GAM
# 실습3: 통근수단 중, 승용차를 선택할 확률에 영향을 주는 섦명변수들의 대부분은 선형의 관계일까?
library(gam)
gam.logit <-gam(com.2modes ~ 
                  s(commuting.time, df = 6) + # 통근시간 knots = 6
                  s(commuting.area) + # 통근지역과 주거지 일치
                  as.factor(gender) + # 성별(여성 = 2)
                  s(age, df = 6) + # 만 나이
                  s(hhm.no) + # 가구원 수
                  s(hh.income, df = 6), # 가구 총소득
                family = binomial,
                data = train)
summary(gam.logit) # 결과 요약

par(mfrow = c(2, 3))
plot(gam.logit, # gam 결과 그래프
     se = T, # 표준오차 그래프 
     col = "red", # 색은 빨간색
     lwd = 2) # 선 두께는 2

par(mfrow = c(1, 1))
detach()

#******************** 연습문제 03: "df.seoul.worker.csv“를 불러들여 df 객체에 할당한 다음, 종속변수로 com.2modes, 독립변수로 as.factor(commuting.area)와 hh.income으로 이항 로지스틱 모델링을 수행하였다. 실행 결과 분석을 통하여 다음의 질문에 답하시오.
#* hh.income의 회귀계수 추정값은 얼마인가요?
#*  commmuting.area 변수의 4수준 요인에 대한 오즈비(odds ratio)는 얼마인가요?
#*  hh.income의 일반화 분산팽창계수(generalized VIF)는 얼마인가요?
df <- read.csv("df.seoul.worker.csv")
str(df)

m2 <- glm(com.2modes ~ as.factor(commuting.area) + hh.income,
          family = binomial, 
          data = df)
summary(m2) # 정답: hh.income의 회귀계수 추정값 >> 0.062454

# odds ratio(오즈비)
round(exp(m2$coef), 3) # 정답: 23.831

# 분산팽창계수(VIF)
vif(m2) # 정답: 1.004748


########################## 판별 분석 ###############################################
## 데이터 불러오기 및 확인
df <- read.csv("df.seoul.worker.csv")
str(df)
table(df$marriage.status) # 결혼상태 일원빈도분포표

df$marriage[df$marriage.status == 1 ] <- "기혼" # 기혼
df$marriage[df$marriage.status == 2 | df$marriage.status == 6] <- "비혼" # 비혼(미혼+동거)
df$marriage[df$marriage.status == 3 | df$marriage.status == 5] <- "사별/별거" # 사별/별거 

table(df$marriage.status, df$marriage) # 이원빈도분포표
str(df$marriage) # 데이터 구조: 문자
df$marriage <- as.factor(df$marriage) # 요인으로 전환 
attach(df) # 데이터 객체 바로 접근하기
lda.df <- df %>% dplyr::select(marriage, 
                          gender, # 성별 
                          age, # 만나이
                          edu.level, # 교육수준
                          hh.income, # 가구 총소득
                          feel.stress, # 스트레스 정도
                          s.reside.year, # 서울 거주년수
                          h.reside.year, # 현 주택 거주년수
                          commuting.area) # 통근 목적지 분류
str(lda.df) # 데이터 구조 확인하기
summary(lda.df) # 요약 통계량

## 데이터 분리하기: train-test split
library(caTools)
set.seed(1234) # 난수 생성
?sample.split() # Split Data into Test and Train Set
split <- sample.split(marriage, # 결혼요인 기준
                      SplitRatio = 0.7) # 비율 0.7:03
split %>% head(15) # 15줄 내용확인

train <- subset(df, # 하위 데이터 셋 추출
                split == TRUE) # TRUE이면 추출
test <- subset(df, split == FALSE) # FALSE이면 추출
test.y <- test[ ,"marriage"] # test 데이터 중, marriage 변수만 추출
nrow(train) ; nrow(test)

### 3. 선형판별분석: lda modeling
library(MASS)
df.lda <- lda(marriage ~ # 결혼상태
                as.factor(gender) + # 성별 
                age + # 만나이
                edu.level + # 교육수준
                hh.income + # 가구 총소득
                feel.stress + # 스트레스 정도
                s.reside.year + # 서울 거주년수
                h.reside.year + # 현 주택 거주년수
                as.factor(commuting.area), # 통근지 유형
              data = train)
df.lda # 결과 확인

### 4. Prediction Accuracy
lda.pred <- predict(df.lda, data = test) # 모델 예측
class(lda.pred)
#*** Stacked Histogram of the LDA Values
ldahist(lda.pred$x[,1], g = test$marriage) # first discriminant function 
ldahist(lda.pred$x[,2], g = test$marriage)

#convert to data frame 
newdata <- data.frame(type = train[,"marriage"], lda = lda.pred$x)
head(newdata)

library(ggplot2)
ggplot(newdata) + 
  geom_point(aes(lda.LD1, lda.LD2, 
                 colour = train$marriage), 
             size = 1.2) +
  labs(title = "Linear discriminant analysis",
       x = "LD1",
       y = "LD2")


table(train$marriage, lda.pred$class) # 실측치와 예측치 이원빈도분포표 

library(caret)
confusionMatrix(train$marriage, lda.pred$class)


## 분산-공분산 행렬이 동일한지 체크
library(biotools)
boxM(train[ , c("gender", "age", "edu.level", "hh.income", 
                "feel.stress", "s.reside.year", "h.reside.year", "commuting.area")], train$marriage)  

## 분산-공분산 행렬이 동일한 경우, LDA
## 분산-공분산 행렬이 동일하지 않은 경우, QDA -> 이 경우 p < .05 이므로 이 케이스임

## qda modeling
df.qda <- qda(marriage ~ # 결혼상태
                as.factor(gender) + # 성별 
                age + # 만나이
                edu.level + # 교육수준
                hh.income + # 가구 총소득
                feel.stress + # 스트레스 정도
                s.reside.year + # 서울 거주년수
                h.reside.year + # 현 주택 거주년수
                as.factor(commuting.area), # 통근지 유형,
                data = train)
df.qda


# Prediction Accuracy
qda.pred <- predict(df.qda, data = train) # 모델 예측
class(qda.pred)

table(train$marriage, qda.pred$class) # 실측치와 예측치 이원빈도분포표 

library(caret)
confusionMatrix(train$marriage, qda.pred$class)

############################################################
# http://www.sthda.com/english/articles/36-classification-methods-essentials/146-discriminant-analysis-essentials-in-r/
#* tidyverse for easy data manipulation and visualization
#* caret for easy machine learning workflow
install.packages("tidyverse")
library(tidyverse)
install.packages("caret")
library(caret)
library(dplyr)
# 1. Split the data into training and test set:
# Load the data
lda.df <- df %>% dplyr::select(marriage, 
                               gender, # 성별 
                               age, # 만나이
                               edu.level, # 교육수준
                               hh.income, # 가구 총소득
                               feel.stress, # 스트레스 정도
                               s.reside.year, # 서울 거주년수
                               h.reside.year, # 현 주택 거주년수
                               commuting.area) # 통근 목적지 분류

# Split the data into 
library(caTools)
set.seed(1234)
split <- sample.split(lda.df$marriage, SplitRatio = 0.7)
split %>% head(15)

train.data <- subset(lda.df, split == T)
test.data <- subset(lda.df, split == F)
test.y <- test.data[,"marriage"]
str(train.data)

# 2. Normalize the data. 
# Estimate preprocessing parameters
?preProcess() # Pre-Processing of Predictors
preproc.param <- train.data %>% 
  preProcess(method = c("center", "scale"))
# Transform the data using the estimated parameters
train.transformed <- preproc.param %>% predict(train.data)
test.transformed <- preproc.param %>% predict(test.data)
summary(train.transformed); summary(train.data)

# 3. Linear discriminant analysis - LDA
library(MASS)
# Fit the model
model <- lda(marriage ~ # 결혼상태
               gender + # 성별 
               age + # 만나이
               edu.level + # 교육수준
               hh.income + # 가구 총소득
               feel.stress + # 스트레스 정도
               s.reside.year + # 서울 거주년수
               h.reside.year + # 현 주택 거주년수
               commuting.area, # 통근지 유형
             data = train.transformed)
model

### 4. 예측 및 교차 검증
# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class==test.transformed$marriage)

# Compute LDA:
plot(model, dimen = 1)

## 만들어진 lda 함수를 가지고 시험 데이터로 predict
testpred <- predict(model, test.transformed)


## misclass error 확인
misclass.error <- mean(test.y != testpred$class)
misclass.error

## cross-table
install.packages("gmodels")
library(gmodels)
CrossTable(x=test.y, y=testpred$class, prop.chisq = TRUE)

# 실측치와 예측치 자료 합치기
lda.data <- cbind(train.transformed, predict(model)$x)
ggplot(lda.data, # ggplot 그래픽 틀 설정
       aes(LD1, LD2)) + # x, y 축 설정
  geom_point(aes(color = marriage), # marriage 별 색상
             cex=0.5) + # 점의 크기
  theme(legend.position = "bottom") # 범례 위치


predictions <- model %>% predict(test.transformed) # 훈련 모델로 시험 데이터 예측
class(predictions)
names(predictions) # 리스트 이름 확인

# Predicted classes
head(predictions$class, 6)
# Predicted probabilities of class memebership.
head(predictions$posterior, 6) 
# Linear discriminants
head(predictions$x, 3) 

mean(predictions$class==test.transformed$marriage) # 일치 확률 계산


library(caret)
confusionMatrix(test.transformed$marriage, predictions$class)

## 분산-공분산 행렬이 동일한지 체크
library(biotools)

xx <- test.transformed %>% dplyr::select(-marriage)
boxM(xx, test.transformed$marriage)  

## 분산-공분산 행렬이 동일한 경우, LDA
## 분산-공분산 행렬이 동일하지 않은 경우, QDA -> 이 경우 p < .05 이므로 이 케이스임

### Quadratic discriminant analysis - QDA
library(MASS)
# Fit the model
model <- qda(marriage ~  # 결혼상태
               gender + # 성별 
               age + # 만나이
               edu.level + # 교육수준
               hh.income + # 가구 총소득
               feel.stress + # 스트레스 정도
               s.reside.year + # 서울 거주년수
               h.reside.year + # 현 주택 거주년수
               commuting.area, # 통근지 유형
             data = train.transformed)
model
# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class == test.transformed$marriage)

library(caret)
confusionMatrix(test.transformed$marriage, predictions$class)

# Mixture discriminant analysis - MDA
install.packages("mda")
library(mda)
?mda() # Mixture Discriminant Analysis
# Fit the model
model <- mda(marriage ~   # 결혼상태
               gender + # 성별 
               age + # 만나이
               edu.level + # 교육수준
               hh.income + # 가구 총소득
               feel.stress + # 스트레스 정도
               s.reside.year + # 서울 거주년수
               h.reside.year + # 현 주택 거주년수
               commuting.area, # 통근지 유형
             data = train.transformed)
model
# Make predictions
predicted.classes <- model %>% predict(test.transformed)
# Model accuracy
mean(predicted.classes == test.transformed$marriage)


# Flexible discriminant analysis - FDA
library(mda)
# Fit the model
model <- fda(marriage ~   # 결혼상태
               as.factor(gender) + # 성별 
               age + # 만나이
               edu.level + # 교육수준
               hh.income + # 가구 총소득
               feel.stress + # 스트레스 정도
               s.reside.year + # 서울 거주년수
               h.reside.year + # 현 주택 거주년수
               as.factor(commuting.area), # 통근지 유형
             data = train.transformed)
# Make predictions
predicted.classes <- model %>% predict(test.transformed)
# Model accuracy
mean(predicted.classes == test.transformed$marriage)

# Regularized discriminant analysis : 시간이 오래 걸림
install.packages("klaR")
library(klaR)
# Fit the model
model <- rda(marriage ~   # 결혼상태
               as.factor(gender) + # 성별 
               age + # 만나이
               edu.level + # 교육수준
               hh.income + # 가구 총소득
               feel.stress + # 스트레스 정도
               s.reside.year + # 서울 거주년수
               h.reside.year + # 현 주택 거주년수
               as.factor(commuting.area), # 통근지 유형
             data = train.transformed)
# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class == test.transformed$marriage)

#******************** 연습문제 04:

# 3. Linear discriminant analysis - LDA
library(MASS)
# Fit the model
model <- lda(marriage ~ # 결혼상태
               age + # 만나이
               edu.level + # 교육수준
               hh.income, # 가구 총소득
             data = train.transformed)
model

# Make predictions
predictions <- model %>% predict(test.transformed)
# Model accuracy
mean(predictions$class==test.transformed$marriage)

# Compute LDA:
plot(model, dimen = 1)

## 만들어진 lda 함수를 가지고 시험 데이터로 predict
testpred <- predict(model, test.transformed)


## misclass error 확인
misclass.error <- mean(test.y != testpred$class)
misclass.error

## cross-table
install.packages("gmodels")
library(gmodels)
CrossTable(x=test.y, y=testpred$class, prop.chisq = TRUE)

# 실측치와 예측치 자료 합치기
lda.data <- cbind(train.transformed, predict(model)$x)
ggplot(lda.data, # ggplot 그래픽 틀 설정
       aes(LD1, LD2)) + # x, y 축 설정
  geom_point(aes(color = marriage), # marriage 별 색상
             cex=0.5) + # 점의 크기
  theme(legend.position = "bottom") # 범례 위치


predictions <- model %>% predict(test.transformed) # 훈련 모델로 시험 데이터 예측
class(predictions)
names(predictions) # 리스트 이름 확인

# Predicted classes
head(predictions$class, 6)
# Predicted probabilities of class memebership.
head(predictions$posterior, 6) 
# Linear discriminants
head(predictions$x, 3) 

mean(predictions$class==test.transformed$marriage) # 일치 확률 계산


library(caret)
confusionMatrix(test.transformed$marriage, predictions$class)



##################### 최근접 이웃 분류: knn

### 1. 데이터 불러오기와 탐색
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기
str(df) # 데이터 구조 확인

df$marriage[df$marriage.status == 1 ] <- "기혼" # 분류모델 반응변수 설정: 기혼
df$marriage[df$marriage.status == 2 | df$marriage.status == 6] <- "비혼" # 비혼(미혼+동거)
df$marriage[df$marriage.status == 3 | df$marriage.status == 5] <- "사별/별거" # 사별/별거 

table(df$marriage.status, df$marriage) # 결혼 유형 재분류 확인: 이원빈도분포표
str(df$marriage) # 데이터 구조: 문자
df$marriage <- as.factor(df$marriage) # 요인으로 전환

df2 <- df %>%  # 파이프 연산자
  select(marriage, age, commuting.time, hhm.no, hh.income, h.reside.year) # 6개 변수(열)만 추출
str(df2) # 데이터 구조 확인
summary(df2) # 요약 통계
df2 %>% # 파이크 연산자 활용: df2 객체
  group_by(marriage) %>% # 결혼상태 여부로 집단별 요약통계 구하기 
  summarize(age_mean = mean(age), # 각각 설명변수 평균값 요약
            commuting.time_mean = mean(commuting.time),
            hhm.no_mean = mean(hhm.no),
            hh.income_mean = mean(hh.income),
            h.reside.year_mean = mean(h.reside.year))
round(var(df2[ , -1]), 3) # 수치형 변수만 분산 확인: 반올림 적용

#### 참조 산점도 매트릭스
my_cols <- c("#00AFBB", "#E7B800", "#FC4E07")  # 3개 색상 설정
pairs(df3[,2:6], # 산점도 매트릭스 그래프: 분류모델 예측(설명)변수
      cex = 0.3, # 점의 크기 0.3배
      col = my_cols[df3$marriage], # marriage 수준별 색상 다르게 적용
      upper.panel=NULL) # 위 패널은 제거 

install.packages("psych")
library(psych)
?pairs.panels() # histograms and correlations for a data matrix
pairs.panels(df3[,-1], 
             col = my_cols[df3$marriage],
             method = "pearson", # 피어슨 correlation method
             hist.col = "Gold", # 히스토 그램 색상
             density = TRUE)  # show density plots

### 2. 표준화: 분산의 편차의 큰 경우, scale() 함수 활용 표준화 필요
df2.z <- scale(df2[ ,-1]) # 표준화: 첫번째 요인 변수 제외
class(df2.z) # 속성확인
df2.z <- as.data.frame(df2.z) # 데이터 프레임으로 변환
class(df2.z) # 속성 결과 확인
round(var(df2.z), 3) # 표준화 후의 분산 확인
df3 <- cbind(df2[ , "marriage"], df2.z)
head(df3, 3) # 데이터 형태 확인
colnames(df3) # 변수명 확인
df3 <- df3 %>% rename(marriage = "df2[, \"marriage\"]") # 변수명 변환
head(df3, 3) # 데이터 형태 확인


### 3. Split the data into training and test set
library(caTools) # 데이터 분할 패키지
set.seed(123) # 난수 생성 규칙 설정: 재현성을 위해 seed를 설정
split <- sample.split(df3$marriage, # 데이터 분할기준: df3$marriage
                      SplitRatio = 0.7) # 분할 비율: 70%
split %>% head(5) # 생성된 객체 내용 확인
train.data <- subset(df3, split == TRUE) # 조건에 맞는 데이터 추출: dplyr의 filter() 이용 가능
test.data <- subset(df3, split == FALSE) # 조건에 맞는 데이터 추출: dplyr의 filter() 이용 가능
test.y <- test.data[,1] # 시험 데이터셋에서 분류 변수 추출
nrow(df3); nrow(train.data); nrow(test.data)

### 4. 훈련데이터로 모델 학습
library(class)  # knn을 돌리기 위한 패키지, install.packages("class")
library(gmodels)  # 분류분석 후 검증에 사용되는 cross table을 위한 패키지

k <- sqrt(nrow(train.data)) # 일반적인 k값 설정 규칙 = 관측치의 제곱근
k

?knn # k-Nearest Neighbour Classification: knn(train, test, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)
knn.y <- knn(train.data[ , -1], # 훈련 데이터(분류 종속변수 제외)
             test.data[  , -1], # 시험 데이터(분류 종속변수 제외)
             train.data[  , 1], # 훈련 데이터의 분류 종속변수
             k = floor(sqrt(nrow(train.data)))) # k값 관측치 객수의 제곱근의 가장 가까운 정수로 설정
summary(knn.y)
head(knn.y, 10)

### 5. 예측 및 교차 타당성 검증
table(test.y, knn.y)
mean(test.y !=knn.y) # 불일치(오류) 확률 계산
mean(test.y ==knn.y) # 일치 확률 계산


?CrossTable() # Cross Tabulation with Tests for Factor Independence
CrossTable(x=test.y, # 분류 독립성 검증 및 분포표 작성, 행은 시험 데이터셋 실측값
           y=knn.y,  # 예측 분류 값
           prop.chisq = FALSE) #  If TRUE, the results of a chi-square test will be included

library(caret)
?confusionMatrix() # Create a confusion matrix
confusionMatrix(knn.y, # 예측값
                test.y) # 시험 데이터 실측값

### 6. 최적의 k값 찾기
#### choosing a K value
knn.y <- NULL # 예측값 NULL 설정
accuracy.rate <- NULL # 일치율 

for (i in 1:150){ # 1:150 시간 소모 많음. 
  set.seed(123) # 난수 규칙 설정(재현성 확보)
  knn.y <- knn(train.data[ ,-1],  # 훈련데이터셋 예측(설명)변수 설정
               test.data[,-1], # 시힘 데이터셋 예측(설명)변수 설정
               train.data[,1], k = i) # 훈련데이터셋 반응(종속) 분류 변수 설정
  accuracy.rate[i] <- mean(test.y == knn.y) # 평균 일치율
}
accuracy.rate # K값 변화에 따른 일치율 벡터 확인

which(accuracy.rate==max(accuracy.rate)) # 일치율 최댓값(k) 확인

library(ggplot2) # visualization
k.values <- 1:150 # x값 색인 설정
accuracy.df <- data.frame(accuracy.rate, # 데이터 프레임 할당
                          k.values)
accuracy.df %>% # 파이프 연산자 활용
  ggplot(aes(k.values, # ggplot 그래픽 틀 설정: x, y
             accuracy.rate)) + 
  geom_point() + # 산점도(또는 점) 그래프
  geom_line(lty='dotted', color='red') + # 선그래프: 선유형, 색상
  labs(title = "K-NN 분류모델의 일치율 변화", # 제목 설정
       x = "K-값",
       y = "일치율(accuracy rate)")


### 7. 최적의 k값으로 knn 모델 학습과 평가
knn.y <- knn(train.data[ , -1], # 훈련 데이터(분류 종속변수 제외)
             test.data[  , -1], # 시험 데이터(분류 종속변수 제외)
             train.data[  , 1], # 훈련 데이터의 분류 종속변수
             k = 15) # 최적 k값 = 15로 설정
library(caret)
confusionMatrix(knn.y, # 예측값
                test.y) # 시험 데이터 실측값


### caret 패키지 활용 대안: 표준화와 데이터 분리
set.seed(123) # 데이터 추출 난수 규칙 설정(재현성)
?trainControl() # Control parameters for train
ctrl <- trainControl(method="repeatedcv", # 훈련데이터 반복 교차검증
                     number = 5, # k-fold = 5
                     repeats = 3) # 반복 = 3회
?train() # Fit Predictive Models over Different Tuning Parameters
knn.fit <- train(marriage ~ ., # formula는 marriage 반응변수, 기타 설명변수
                 data = train.data, # 사용할 훈련 데이터 셋
                 method = "knn", # 방법: K-NN
                 trControl = ctrl, # 교차타당성 데이터 분리 방법
                 preProcess = c("center","scale"), # 데이터 전처리 작업 동시 진행: 
                                                   # 표준화 방법: 평균중심화와 표준화 모두 적용
                 tuneLength = 20) # 조율모수??

knn.fit # K-NN 분류 모델 할당 결과 확인
plot(knn.fit) # k값과 일치율 점선 그래프 작성

knn.fit.y <- predict(knn.fit, newdata = test.data ) # 훈련데이터 모델로 시험 데이터 예측
confusionMatrix(knn.fit.y, # 혼동행렬: a factor of predicted classes
                test.y) # a factor of classes to be used as the true results

### 거리 가중 최근접 이웃 분류법(kknn)
library(kknn) # 미설치시 install.packages("kknn")
?kknn() # Weighted k-Nearest Neighbor Classifier


#### choosing a K value
kknn.y <- NULL # 예측값 NULL 설정
accuracy.rate <- NULL # 일치율 

for (i in 1:50){ # 1:150 시간 소모 많음. 
  set.seed(123) # 난수 규칙 설정(재현성 확보)
  kknn.y <- kknn(marriage~., # 분류 실측치 
                 train=train.data, # 훈련데이터 셋
                 test=test.data, # 시험 데이터 셋
                 k=i, # k-값 1:150 반복
                 distance = 2, # 유틀리디안 거리 설정
                 kernel = "inv") # 커널밀도함수 추정방법: inverse
  kknn.y.fit <- fitted(kknn.y) # 해당 객체로 예측치 산출
  accuracy.rate[i] <- mean(test.y == kknn.y.fit) # 평균 일치율
}

which(accuracy.rate==max(accuracy.rate)) # 일치율 최댓값(k) 확인
plot(accuracy.rate) # k값과 일치율 점선 그래프 작성

kknn.y <- kknn(marriage~., # 분류 실측치 
               train=train.data, # 훈련데이터 셋
               test=test.data, # 시험 데이터 셋
               k=21, # k-값
               distance = 2, # 유틀리디안 거리 설정
               kernel = "inv") # 커널밀도함수 추정방법: inverse 
?fitted() # Extract Model Fitted Values
kknn.y.fit <- fitted(kknn.y) # 해당 객체로 예측치 산출

table(test.y, kknn.y.fit) # 실측과 예측 분류 이원빈도분포표 
mean(test.y != kknn.y.fit) # 불일치(오류) 확률 계산
mean(test.y == kknn.y.fit) # 일치 확률 계산

CrossTable(x=test.y, # 분류 독립성 검증 및 분포표 작성, 행은 시험 데이터셋 실측값
           y=kknn.y.fit,  # 예측 분류 값
           prop.chisq = FALSE) #  If TRUE, the results of a chi-square test will be included

library(caret)
confusionMatrix(test.y, # 혼동행렬: 실측값
                kknn.y.fit) # 예측값

#********************** 연습문제 05: 
#* "df.seoul.worker.csv" 실습파일을 불러들여 df에 할당하고, marriage.status 변수를 "기혼", 미혼(==2), 이외는 NA로 새로운 변수인 marriage에 할당하여 일원빈도분포표를 작성하시오.
#* 이 때, 미혼 직장인은 몇명인지 적으시오. 
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기

df$marriage[df$marriage.status == 1 ] <- "기혼" # 분류모델 반응변수 설정: 기혼
df$marriage[df$marriage.status == 2 ] <- "미혼" # 미혼
df$marriage[df$marriage.status >= 3 ] <- NA # 기타

table(df$marriage.status, df$marriage) # 결혼 유형 재분류 확인: 이원빈도분포표
str(df$marriage) # 데이터 구조: 문자
#* marriage의 변수형태(유형)를 요인으로 변환하는 명령문을 또한 작성하시오.
df$marriage <- as.factor(df$marriage) # 요인으로 전환


#********************** 연습문제 06: 
#* 할당된 df 객체에서 marriage, age, commuting.time, hhm.no, hh.income, h.reside.year를 추출하고, marriage가 "기혼"이거나 "미혼"인 경우만 추출하여 df2에 할당하는 명령문을 작성하시오.
#* 이 때 dplyr패키지의 select()와 filter() 함수를 사용하시오.
df2 <- df %>%  # 파이프 연산자
  select(marriage, age, commuting.time, hhm.no, hh.income, h.reside.year) %>% # 6개 변수(열)만 추출
  filter(marriage == "기혼" | marriage =="미혼")
str(df2) # 데이터 구조 확인
summary(df2) # 요약 통계
table(df2$marriage)

#********************** 연습문제 07:
#* df2의 데이터셋 중에서 첫번째 열에 있는 marriage 변수를 제외한 나머지의 분산행렬을 구하시오.
var(df2[ , -1])
var(df2[ , 2:6])

#********************** 연습문제 08: 
#* createDataPartition() 함수를 활용하여 df2의 데이터셋에서 무작위로 분리하여 
#* 훈련데이터(train.data)로 전체의 70%, 나머지를 시험데이터(test.data)으로 할당하라는 일련의 명령문을 작성하시오.
?createDataPartition() # 비율 생성 함수
?set.seed() # 난수생성
set.seed(123) # 123 코드로 난수생성 
training.samples <- df2$marriage %>% # df2의 결혼상태 기준
  createDataPartition(p = 0.7, list = FALSE) # 비율 0.7로 데이터 분할 생성 명령
train.data  <- df2[training.samples, ] # 80% 훈련 데이터 생성
test.data <- df2[-training.samples, ] # 20% 시험 데이터 생성(-x)

#* 이 때 훈련데이터 셋의 갯수는 얼마인 지 적으시오.
nrow(df2); nrow(train.data); nrow(test.data)
summary(train.data)
str(train.data)
#********************** 연습문제 09:  Control parameters for train
#* knn() 함수를 활용하여 훈련데이터와 시험데이터로 marriage에 대하여 일치율(accuracy) 기준으로 최적의 k-값을 구하고자 한다.
#* k를 1부터 30까지 반복하는 for 반복문을 활용하여 이 k-값을 구하시오.
#### choosing a K value
for (i in 1:30){ # 1:30
  set.seed(123) # 난수 규칙 설정(재현성 확보)
  knn.y <- knn(train.data[ ,-1],  # 훈련데이터셋 예측(설명)변수 설정
               test.data[,-1], # 시힘 데이터셋 예측(설명)변수 설정
               train.data[,1], k = i) # 훈련데이터셋 반응(종속) 분류 변수 설정
  accuracy.rate[i] <- mean(test.data[ , 1] == knn.y) # 평균 일치율
}
accuracy.rate # K값 변화에 따른 일치율 벡터 확인

which(accuracy.rate==max(accuracy.rate)) # 일치율 최댓값(k) 확인

#********************** 연습문제 10:
#* 위의 k-값을 활용한 knn 훈련모델로 시험모델을 예측하였을 때, accruacy값을 얼마인지 적으시오. 
knn.y <- knn(train.data[ ,-1],  # 훈련데이터셋 예측(설명)변수 설정
             test.data[,-1], # 시힘 데이터셋 예측(설명)변수 설정
             train.data[,1], k = 5) # 훈련데이터셋 반응(종속) 분류 변수 설정


table(test.data[ , 1], knn.y)
mean(test.data[ , 1] !=knn.y) # 불일치(오류) 확률 계산
mean(test.data[ , 1] ==knn.y) # 일치 확률 계산


?CrossTable() # Cross Tabulation with Tests for Factor Independence
CrossTable(x=test.data[ , 1], # 분류 독립성 검증 및 분포표 작성, 행은 시험 데이터셋 실측값
           y=knn.y,  # 예측 분류 값
           prop.chisq = FALSE) #  If TRUE, the results of a chi-square test will be included

library(caret)
?confusionMatrix() # Create a confusion matrix
confusionMatrix(test.data[ , 1], # 실측값
                knn.y) # 예측값


################################### 결정트리 학습 #############################

### 1. 데이터 불러오기와 탐색
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기

df$marriage[df$marriage.status == 1 ] <- "기혼" # 분류모델 반응변수 설정: 기혼
df$marriage[df$marriage.status == 2 | df$marriage.status == 6] <- "비혼" # 비혼(미혼+동거)
df$marriage[df$marriage.status == 3 | df$marriage.status == 5] <- "사별/별거" # 사별/별거 

table(df$marriage.status, df$marriage) # 결혼 유형 재분류 확인: 이원빈도분포표
str(df$marriage) # 데이터 구조: 문자
df$marriage <- as.factor(df$marriage) # 요인으로 전환

df2 <- df %>%  # 파이프 연산자
  select(marriage, age, commuting.time, hhm.no, hh.income, h.reside.year) # 6개 변수(열)만 추출
str(df2) # 데이터 구조 확인
df2 %>% # 파이크 연산자 활용: df2 객체
  group_by(marriage) %>% # 결혼상태 여부로 집단별 요약통계 구하기 
  summarize(age_mean = mean(age), # 각각 설명변수 평균값 요약
            commuting.time_mean = mean(commuting.time),
            hhm.no_mean = mean(hhm.no),
            hh.income_mean = mean(hh.income),
            h.reside.year_mean = mean(h.reside.year))

### 2. 데이터 분리
set.seed(123) # 난수생성 규칙 설정: 재현성
?sample() # Random Samples and Permutations
          # sample(x, size, replace = FALSE, prob = NULL)
df.split.s <-sample (x = 1:2, # 1과 2의 숫자 벡터를 무작위 표본 추출
                     size = nrow(df2), # df2의 객체 관측치 갯수 만큼
                     replace = TRUE, # 복원 추출
                     prob = c(0.8,0.2)) # 각각 80%와 20%로 차등 추출
head(df.split.s) 
train <- df2[df.split.s == 1,  ] # 1인 경우만 추출
test <- df2[df.split.s == 2,  ] # 2인 경우만 추출
nrow(train); nrow(test) # 추출된 하위데이터셋 갯수 확인

### 3. Creating a Decision Tree in R with the package party
library(rpart) # 미설치시 install.packages("rpart")
?rpart() # Recursive Partitioning and Regression Trees
         # rpart(formula, data, weights, subset, na.action = na.rpart, method, ...)
         # method = one of "anova", "poisson", "class" or "exp"
         #If method is missing then the routine tries to make an intelligent guess. 
m.tree <- rpart(marriage ~ # marriage를 분류 반응(예측) 변수로
              ., # 데이터셋에 있는 예측변수 제외 모두
            method="class", # 수준 방식
            data = train) # train 데이터 활용
m.tree # 결정트리 학습모델 결과 확인
summary(m.tree) # # 결정트리 학습모델 결과 요약

### 4. 결정트리 그래프 작성
library (rpart.plot) # 미설치시: install.packages("rpart.plot")
?rpart.plot() # Plot an rpart model
par(mfrow=c(1,1))
rpart.plot(m.tree)  # 결정트리 결과 그래프: 분류 비율 제시 
           
par(mfrow = c(2,2)) # 한 화면에 2*2 그래프 창 환경 설정
rpart.plot(m.tree, # 결정트리 결과 객체
           extra=104)  # show fitted class, probs, percentages
           

rpart.plot(m.tree, # 결정트리 결과 객체
           extra=2, # 분류되는 각각의 관측치 수 제시
           type=5) # Type of plot: Show the split variable name in the interior nodes.
           
           
rpart.plot(m.tree, # 결정트리 결과 객체
           box.palette="RdBu", # Palette for coloring the node boxes based on the fitted value
           branch.lty = 3, # dotted branch lines
           shadow.col="gray", # Color of the shadow under the boxes.
           nn=TRUE) # display the node numbers
rpart.plot(m.tree, # 결정트리 결과 객체
           box.palette="RdBu", # Palette for coloring the node boxes based on the fitted value
           branch.lty = 3, # dotted branch lines
           type=5, # Type of plot: Show the split variable name in the interior nodes.
           shadow.col="gray", # Color of the shadow under the boxes.
           nn=TRUE) # display the node numbers
par(mfrow=c(1,1))



### 5. 예측과 교차타당성 검증
?predict()
rpartpredy <- predict(m.tree, # 훈련모델
                  data = test, # 예측을 위한 시험 데이터셋:
                  type='prob') # 분류확률로 예측
head(rpartpredy, 3) # 확률 예측값 

rpartpred <- predict(m.tree, # 훈련모델
                     test, # 예측을 위한 시험 데이터셋
                     type='class') # 뿐류수준(항목)으로 예측

library(caret) # caret 패키지의 혼동행렬
confusionMatrix(rpartpred, # 혼동 행렬: 예측치
                test$marriage) # 시험데이터 실측치

## 결정트리 학습모델 실습2: 가지치기(Pruning)
### 1.과 2.는 위와 동일 과정으로 생략
### 3. 결정트리 학습모델링
library(tree) # 미설치시 install.packages("tree")
?tree() # Fit a Classification or Regression Tree
        # tree(formula, data, weights, subset,
                   # method = "recursive.partition",
                   # split = c("deviance", "gini")

m.tree2 <- tree(marriage ~ # marriage를 분류 반응(예측) 변수로
                  ., # 데이터셋에 있는 예측변수 제외 모두
                data = train) # train 데이터 활용
m.tree2

### 4. 결정트리 그래프 작성  
plot(m.tree2) # m.tree2 그래프
text(m.tree2) # 텍스트 추가



### 5. 가지치기
?cv.tree() # a K-fold cross-validation experiment to find the deviance or number of misclassifications 
           # as a function of the cost-complexity parameter k.

cv.trees <- cv.tree(m.tree2, # 교차타당성 검정: 훈련 결정트리 모델
                  FUN=prune.misclass ) # The function to do the pruning.

plot(cv.trees) # 교차타당성 검정 실행결과 그래프 작성: 7개의 가지이상이면 오분류 수준이 가장 낮음

# 가지치기 진단 후 학습 모델링 
?prune.misclass() # prune.misclass is an abbreviation for prune.tree(method = "misclass") for use with cv.tree
prune.trees <- prune.misclass(m.tree2, # 훈련 결정트리 모델
                              best=7)  # best =integer requesting the size (i.e. number of terminal nodes)
plot(prune.trees) # 실행결과 그래프 작성, 7개
text(prune.trees) # 텍스트 추가

### 6. 예측하기 & 모델 평가
treepred <- predict(prune.trees, test, type='class')
confusionMatrix(treepred, test$marriage) # caret 패키지

## 결정트리 학습모델 실습3: party 패키지
#***** party패키지는 significance를 사용해서 하기 때문에 별도의 pruning 과정이 필요 없습니다
### 1.과 2.는 위와 동일 과정으로 생략
### 3. 결정트리 학습모델링
library(party)
?ctree() # Conditional Inference Trees
         # Recursive partitioning for continuous, censored, ordered, nominal and multivariate response variables 
party.tree <- ctree(marriage ~ # marriage를 분류 반응(예측) 변수로
                      ., # 데이터셋에 있는 예측변수 제외 모두
                    data = train) # train 데이터 활용

party.tree # 실행결과 확인

### 4. 결정트리 그래프 작성  
plot(party.tree) # 실행결과 그래프 작성: 가지수가 너무 많음

### 5. 예측하기 & 모델 평가
party.pred <- predict(party.tree, # 훈련모델로 예측
                      test) # 예측할 데이터셋 = test

confusionMatrix(party.pred, # 시험데이터 훈련모델 예측값
                test$marriage) # 실측값 혼동행렬


## 결정트리 학습모델 실습 4: 분류회귀
### 1. 데이터 불러오기와 탐색하기 
list.files() # 현재 작업폴더 파일 열람
apt <- read.csv("apt3.csv") # 데이터 불러오기

df.apt <- apt %>% 
  dplyr::select(price_pyung, # 종속변수: 평당 거래가격(만원)
         area_m2, # 설명변수1: 전용면적(m2)
           floor_no, # 설명변수2: 층수
           built_age, # 설명변수3: 건축연령(년)
           urban) # 설명변수4: 읍면동 거래지역(요인)
str(df.apt) # 추출된 데이터 구조 확인

### 2. 데이터 분할하기 
set.seed(123)
d.s <-sample(x = 1:2, # 1과 2의 숫자
           size = nrow(df.apt), # df.apt의 관측치수
           replace = TRUE, # 복원 추출
           prob=c (0.8,0.2)) # 추출 확률을 80%와 20%로 차등 
train <- apt[d.s == 1, ] # 1인 경우 훈련데이터
test <- apt[d.s == 2, ] # 2인 경우 시험 데이터 
nrow(train); nrow(test) # 행의 갯수 확인


### 3. 훈련데이터 학습모델링
library(rpart) # rpart 패키지 불러오기 
fit <- rpart(price_pyung ~ # 분류회귀 종속변수
               area_m2 + # 설명변수1: 전용면적(m2)
               floor_no + # 설명변수2: 층수
               built_age + # 설명변수3: 건축연령(년)
               urban, # 설명변수4: 읍면동 거래지역(요인)
             method="anova", # 방법론 = anova
             data=apt) # 데이터 객체

# plot tree 
plot(fit, # 분류 회귀 실행결과 
     uniform=TRUE, # 균등분포
     main="Regression Tree for 평당 거래가격")
text(fit, use.n=TRUE, all=TRUE, cex=.7)

### 4. 가지치기 
?printcp() # Displays complexity parameter (cp) table for Fitted Rpart Object
           # to control the size of the decision tree and to select the optimal tree size.
           # If the cost of adding another variable to the decision tree 
           # from the current node is above the value of cp, then tree building does not continue.
printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# create additional plots 
?rsq.rpart() # Plots the Approximate R-Square for the Different Splits
             # Produces 2 plots.
par(mfrow=c(1,2)) # two plots on one page
rsq.rpart(fit) # visualize cross-validation results   
par(mfrow=c(1,1)) # one plot on one page

### 5. 예측 모델링
# prune the tree 
?prune() # Cost-complexity Pruning of an Rpart Object
pfit <- prune(fit, cp=0.015168) # cp 표로 가지치기 n 결정
pfit

# plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Regression Tree for 평당거래가격(만원)")
text(pfit, use.n=TRUE, all=TRUE, cex=.7)

#********************** 연습문제 11:
#* "df.seoul.worker.csv“데이터 파일을 불러들여, 
#* 아래와 같은 데이터만 추출하여 훈련(80%)과 시험(20%)로 대별하여 com.mode 를 분류항목으로 하고, 
#* 나머지를 설명변수로 하여 결정트리 학습모델링을 실습하시오. 

### 1. 데이터 불러오기와 탐색
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기
str(df)
table(as.factor(df$com.mode))
df2 <- df %>%  # 파이프 연산자
  select(com.mode, commuting.time, commuting.area, gender, age,  marriage.status, hhm.no, hh.income, h.reside.year) # 6개 변수(열)만 추출
df2$com.mode <- as.factor(df2$com.mode) # 요인으로 ...0= 승용차, 1=버스, 2=지하철, 3=기타(도보)
df2$commuting.area <- as.factor(df2$commuting.area) # 요인으로 ...
df2$marriage.status <- as.factor(df2$marriage.status) # 요인으로 ...
str(df2) # 데이터 구조 재확인

### 2. 데이터 분리
set.seed(123) # 난수생성 규칙 설정: 재현성
?sample() # Random Samples and Permutations
# sample(x, size, replace = FALSE, prob = NULL)
df.split.s <-sample (x = 1:2, # 1과 2의 숫자 벡터를 무작위 표본 추출
                     size = nrow(df2), # df2의 객체 관측치 갯수 만큼
                     replace = TRUE, # 복원 추출
                     prob = c(0.8,0.2)) # 각각 80%와 20%로 차등 추출
head(df.split.s) 
train <- df2[df.split.s == 1,  ] # 1인 경우만 추출
test <- df2[df.split.s == 2,  ] # 2인 경우만 추출
nrow(train); nrow(test) # 추출된 하위데이터셋 갯수 확인

### 3. Creating a Decision Tree in R with the package party
library(rpart) # 미설치시 install.packages("rpart")
m.tree <- rpart(com.mode ~ # marriage를 분류 반응(예측) 변수로
                  ., # 데이터셋에 있는 예측변수 제외 모두
                method="class", # 수준 방식
                data = train) # train 데이터 활용
m.tree # 결정트리 학습모델 결과 확인
summary(m.tree) # # 결정트리 학습모델 결과 요약

### 4. 결정트리 그래프 작성
library (rpart.plot) # 미설치시: install.packages("rpart.plot")


rpart.plot(m.tree)  # 결정트리 결과 그래프: 분류 비율 제시 

rpart.plot(m.tree, # 결정트리 결과 객체
           box.palette="RdBu", # Palette for coloring the node boxes based on the fitted value
           branch.lty = 3, # dotted branch lines
           type=5, # Type of plot: Show the split variable name in the interior nodes.
           shadow.col="gray", # Color of the shadow under the boxes.
           nn=TRUE) # display the node numbers



### 5. 예측과 교차타당성 검증
?predict()
rpartpredy <- predict(m.tree, # 훈련모델
                      data = test, # 예측을 위한 시험 데이터셋:
                      type='prob') # 분류확률로 예측
head(rpartpredy, 3) # 확률 예측값 

rpartpred <- predict(m.tree, # 훈련모델
                     test, # 예측을 위한 시험 데이터셋
                     type='class') # 뿐류수준(항목)으로 예측

library(caret) # caret 패키지의 혼동행렬
confusionMatrix(rpartpred, # 혼동 행렬: 예측치
                test$com.mode) # 시험데이터 실측치

##################### 앙상블 학습 ###############################

### 1. 데이터 불러오기와 탐색
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기

df$marriage[df$marriage.status == 1 ] <- "기혼" # 분류모델 반응변수 설정: 기혼
df$marriage[df$marriage.status == 2 | df$marriage.status == 6] <- "비혼" # 비혼(미혼+동거)
df$marriage[df$marriage.status == 3 | df$marriage.status == 5] <- "사별/별거" # 사별/별거 

str(df$marriage) # 데이터 구조: 문자
df$marriage <- as.factor(df$marriage) # 요인으로 전환

df2 <- df %>%  # 파이프 연산자
  select(marriage, age, commuting.time, hhm.no, hh.income, h.reside.year) # 6개 변수(열)만 추출
str(df2) # 데이터 구조 확인


### 2. 랜덤포레스트 모델링
library(randomForest) # 미설치시 install.packages("randomForest")
?randomForest() # Classification and Regression with Random Forest
m.rf <- randomForest(marriage ~ # 분류항목 종속변수
                       ., # 이외 설명변수
                     data=df2, # 사용할 데이터 객체
                     importance = TRUE) # 변수 중요도 측정 여부
m.rf # 모델 훈련에 사용되지 않은 데이터를 사용한 에러 추정치가 ‘OOBOut of Bag estimate of error rate’ 항목으로 출력

### 3. 변수 중요도 평가
?importance() # Extract variable importance measure
importance(m.rf) # 정확도MeanDecreaseAccuracy, 노드 불순도 개선MeanDecreaseGini,  
# 다수의 의사 결정 나무로부터 변수가 정확도와 노드 불순도 개선에 기여하는 측면을 평가하므로 평균(Mean)이 언급

?varImpPlot() # Variable Importance Plot
varImpPlot(m.rf, main="varImpPlot of 결혼상태")

### 4. 예측
pred.y <- predict(m.rf, # 학습모델
                     data=df2 # 사용할 데이터
                     , type = "class") # 분류항목으로 에측
# Checking classification accuracy
table(pred.y, # 빈도분포표: 예측치
      df2$marriage)  # 실측치

library(caret) # caret 패키지의 혼동행렬
confusionMatrix(pred.y, # 혼동 행렬: 예측치
                df2$marriage) # 시험데이터 실측치


#************************ 연습문제 12: 분류 회귀: 랜덤포레스트
# "apt3.csv"의 데이터에서 아래와 같은 데이터만 추출하여 평당 거래가격(price_pyung)에 대한 분류회귀를 랜덤 포레스트 학슬 모델링을 실행하시오.
# 이 때, 어느 변수가 가장 중요한 변수인 지 진단하시오.

### 1. 데이터 불러오기와 탐색하기 
apt <- read.csv("apt3.csv") # 데이터 불러오기

df.apt <- apt %>% 
  dplyr::select(price_pyung, # 종속변수: 평당 거래가격(만원)
                area_m2, # 설명변수1: 전용면적(m2)
                floor_no, # 설명변수2: 층수
                built_age, # 설명변수3: 건축연령(년)
                urban) # 설명변수4: 읍면동 거래지역(요인)
str(df.apt) # 추출된 데이터 구조 확인

### 2. 랜덤포레스트 모델링
library(randomForest) # 미설치시 install.packages("randomForest")
?randomForest() # Classification and Regression with Random Forest
m.rf.apt <- randomForest(price_pyung ~ # 분류항목 종속변수
                       ., # 이외 설명변수
                     data=df.apt, # 사용할 데이터 객체
                     importance = TRUE) # 변수 중요도 측정 여부
m.rf.apt # 모델 훈련에 사용되지 않은 데이터를 사용한 에러 추정치가 ‘OOBOut of Bag estimate of error rate’ 항목으로 출력

### 3. 변수 중요도 평가
?importance() # Extract variable importance measure
importance(m.rf.apt) # 정확도MeanDecreaseAccuracy, 노드 불순도 개선MeanDecreaseGini,  
# 다수의 의사 결정 나무로부터 변수가 정확도와 노드 불순도 개선에 기여하는 측면을 평가하므로 평균(Mean)이 언급

?varImpPlot() # Variable Importance Plot
varImpPlot(m.rf.apt, main="varImpPlot of 평당 거래가격")

### 4. 예측
pred.y <- predict(m.rf, # 학습모델
                  data=df.apt # 사용할 데이터
                  , type = "class") # 분류항목으로 에측
# Checking classification accuracy
table(pred.y, # 빈도분포표: 예측치
      df.apt$price_pyung)  # 실측치


########################### 부스팅: XGBoost example ################################
#* 출처: XGBoost Multinomial Classification Iris Example in R, Dale Kube, 2019-02-26
#* https://rpubs.com/dalekube/XGBoost-Iris-Classification-Example-in-R

### 1. 패키지와 데이터 불러오기
library(xgboost) # 미설치시 install.packages("xgboost")
data(iris) # iris 데이터 불러오기

### 2. 라벨(분류) 변환: xgboost는 0으로 시작하는 정수 수준을 요구함.
# Convert the Species factor to an integer class starting at 0
# This is picky, but it's a requirement for XGBoost
species <- iris$Species # 분류(종속)변수 
table(species) # 일원빈도분포표
label <- as.integer(iris$Species)-1 # 0으로 시작하는 정수로 라벨 할당
str(label) # 구조 확인
table(label) # 일원빈도분포표로 확인
iris$Species <-  NULL # 원 자료의 분류변수 NULL 할당

### 3. 데이터 분할: validate the performance of our model (known as “hold one out cross-validation”)
n <- nrow(iris) # iris의 행의 갯수(관측치수) 할당
set.seed(123) # 무작위 추출 규칙 설정(재현성)
train.index <- sample(n, # n개 
                      floor(0.75*n)) # 0.75 비율 색인 할당
train.index # 비율 색인 할당 결과 확인
train.data<- as.matrix(iris[train.index, ]) # 비율 색인을 이용하여 훈련 데이터 할당
head(train.data, 4) # 데이터 확인
train.label <- label[train.index] # 훈련 라벨(분류변수) 색인으로 할당
train.label # 훈련 라벨 결과 확인
test.data <- as.matrix(iris[-train.index,]) # 훈련 라벨이 아닌 색인에 해당하는 데이터를 시험 데이터로 할당
head(test.data, 4) # 확인
test.label <- label[-train.index] # 훈련 라벨 색인이 아닌 라벨을 시험 데이터로 할당
test.label # 확인

### 4. xgb.DMatrix 객체들 생성
#*  training and testing data sets into xgb.DMatrix objects 
#* that are used for fitting the XGBoost model and predicting new outcomes.
# Transform the two data sets into xgb.Matrix
?xgb.DMatrix() # Construct xgb.DMatrix object
xgb.train <- xgb.DMatrix(data=train.data, # 훈련 데이터
                         label=train.label) # 라벨은 훈련 라벨
xgb.test <- xgb.DMatrix(data=test.data, # 시험 데이터
                        label=test.label) # 시험 데이터 라벨

### 5. 주요 패러미터의 정의(Define the main parameters)
#* XGBoost, like most other algorithms, works best when its parameters are hypertuned for optimal performance. 
#* The algorithm requires that we define the booster, objective, learning rate, and other parameters.
# Define the parameters for multinomial classification
?levels() # Levels Attributes: returns the value of the levels of its argument 
num_class <- length(levels(species)) # 분류수준(3수준) 길이 할당
num_class # 확인

params <- list( # 패러미터 리스트 작성
  booster="gbtree", # 트리 부스터 설정
  eta=0.001, # 과적합 방지 목적: 과적합 최소화(범위 = 0/1)
  max_depth=5, # 한 트리의 최대 깊이: 숫자가크면 과적합 확률 높아짐(default=6)
  gamma=3, # 정보획득: 숫자가 크면 보수적 모델링
  subsample=0.75, # 위의 비율로 설정
  colsample_bytree=1, # 트리 건설시 고려할 변수비율: 모든 설명변수(특징)들 활용(범위 = 0/1)
  objective="multi:softprob", #  algorithm to calculate probabilities for every possible outcome 
                              # (in this case, a probability for each of the three flower species), for every observation.
  eval_metric="mlogloss", # multiclass logloss: 다수준(항) 로그우도 값으로 평가
  num_class=num_class) # "multi:softprob"를 선택하였을 때 위에서 할당한 num_class 설정 필요 

### 6. 학습모델 훈련
# Train the XGBoost classifer
?xgb.train() # eXtreme Gradient Boosting Training
xgb.fit <- xgb.train( # 훈련모델 함수
  params=params, # param 리스트 적용
  data=xgb.train, # 훈련 행렬 데이터셋
  nrounds=10000, # 부스팅 횟수
  nthreads=1, # 병렬처리 횟수(여기서는 데이터가 적어 1로 설정)
  early_stopping_rounds=10, # stop early if the performance does not improve after 10 consecutive rounds
  watchlist=list(val1=xgb.train, val2=xgb.test), # 설명 없음
  verbose=0) # 부스팅 단계마다 결과 확인 하지 않음(set to 1 so we can see the results for each round.)

xgb.fit # Review the final model and results

### 7. 예측과 평가

# 7.1 Predict outcomes with the test data
#* multi:softprob same as softmax, but output a vector of ndata * nclass, which can be further reshaped to ndata, nclass matrix. 
#* The result contains predicted probabilities of each data point belonging to each class.
?predict()
xgb.pred1 <- predict(xgb.fit, # 학습모델
                    test.data, # 시험데이터 셋
                    reshape=FALSE) # 예측시 ndata * nclass를 ndata로 데이터 형태 변환하지 않았을 경우
head(xgb.pred1, 3) # 확인
xgb.pred <- predict(xgb.fit, # 학습모델
                    test.data, # 시험데이터 셋
                    reshape=TRUE) # 예측시 ndata * nclass를 ndata로 데이터 형태 변환
class(xgb.pred) # 속성 확인
head(xgb.pred, 3) # 확인

xgb.pred <- as.data.frame(xgb.pred) # 행렬 데이터를 데이터 프레임으로 변환
colnames(xgb.pred) <- levels(species) # 종속변수 분류 수준의 이름을 xgb.pred객체의 열이름으로 할당
head(xgb.pred, 3) # 확인 

# 7.2 Use the predicted label with the highest probability
?apply()
xgb.pred$prediction <- apply(xgb.pred, # Apply Functions Over Array Margins
                             1, # 행기준
                             function(x) colnames(xgb.pred)[which.max(x)]) # x가 최대인 열이름을 할당
xgb.pred$label <- levels(species)[test.label+1] # 시험 데이터셋의 0, 1, 2 수준을 1, 2, 3으로 변환하여 할당

# 7.3 Calculate the final accuracy
table(xgb.pred$prediction, xgb.pred$label) # 예측값과 시험 데이터 실측값 이원빈도분포표
mean(xgb.pred$prediction == xgb.pred$label) # 일치율 계산
result <- sum(xgb.pred$prediction==xgb.pred$label)/nrow(xgb.pred) # 일치율 계산 2
result # 결과 
print(paste("Final Accuracy =",sprintf("%1.2f%%", 100*result))) # 프린트

#*************** 실습 2: 결혼 상태 분류 학습 모델링************************************************
### 1. 패키지와 데이터 불러오기
library(xgboost) # 미설치시 install.packages("xgboost")
library(dplyr)
setwd("K:\\기타\\2019년2학기\\수치해석\\실습데이터") # 실습데이터가 있는 폴더로 작업폴더 변경
df <- read.table("df.seoul.worker.csv", header = TRUE, sep=",") # csv 파일 불러오기

df$marriage[df$marriage.status == 1 ] <- "기혼" # 분류모델 반응변수 설정: 기혼
df$marriage[df$marriage.status == 2 | df$marriage.status == 6] <- "비혼" # 비혼(미혼+동거)
df$marriage[df$marriage.status == 3 | df$marriage.status == 5] <- "사별/별거" # 사별/별거 

str(df$marriage) # 데이터 구조: 문자
df$marriage <- as.factor(df$marriage) # 요인으로 전환

df2 <- df %>%  # 파이프 연산자
  select(marriage, age, commuting.time, hhm.no, hh.income, h.reside.year) # 6개 변수(열)만 추출
str(df2) # 데이터 구조 확인

### 2. 라벨(분류) 변환: xgboost는 0으로 시작하는 정수 수준을 요구함.
marriage <- df2$marriage # 분류(종속)변수 
table(marriage) # 일원빈도분포표
label <- as.integer(df2$marriage)-1 # 0으로 시작하는 정수로 라벨 할당
table(label) # 일원빈도분포표로 확인
df2$marriage <-  NULL # 원 자료의 분류변수 NULL 할당
df2$marriage

### 3. 데이터 분할: validate the performance of our model (known as “hold one out cross-validation”)
n <- nrow(df2) # iris의 행의 갯수(관측치수) 할당
set.seed(123) # 무작위 추출 규칙 설정(재현성)
train.index <- sample(n, # n개 
                      floor(0.75*n)) # 0.75 비율 색인 할당
train.data<- as.matrix(df2[train.index, ]) # 비율 색인을 이용하여 훈련 데이터 할당
head(train.data, 4) # 데이터 확인
train.label <- label[train.index] # 훈련 라벨(분류변수) 색인으로 할당

test.data <- as.matrix(df2[-train.index,]) # 훈련 라벨이 아닌 색인에 해당하는 데이터를 시험 데이터로 할당
head(test.data, 4) # 확인
test.label <- label[-train.index] # 훈련 라벨 색인이 아닌 라벨을 시험 데이터로 할당

### 4. xgb.DMatrix 객체들 생성
xgb.train <- xgb.DMatrix(data=train.data, # 훈련 데이터
                         label=train.label) # 라벨은 훈련 라벨
xgb.test <- xgb.DMatrix(data=test.data, # 시험 데이터
                        label=test.label) # 시험 데이터 라벨

### 5. 주요 패러미터의 정의(Define the main parameters)
num_class <- length(levels(marriage)) # 분류수준(3수준) 길이 할당
num_class # 확인

params <- list( # 패러미터 리스트 작성
  booster="gbtree", # 트리 부스터 설정
  eta=0.001, # 과적합 방지 목적: 과적합 최소화(범위 = 0/1)
  max_depth=5, # 한 트리의 최대 깊이: 숫자가크면 과적합 확률 높아짐(default=6)
  gamma=3, # 정보획득: 숫자가 크면 보수적 모델링
  subsample=0.75, # 위의 비율로 설정
  colsample_bytree=1, # 트리 건설시 고려할 변수비율: 모든 설명변수(특징)들 활용(범위 = 0/1)
  objective="multi:softprob", #  algorithm to calculate probabilities for every possible outcome 
  # (in this case, a probability for each of the three flower species), for every observation.
  eval_metric="mlogloss", # multiclass logloss: 다수준(항) 로그우도 값으로 평가
  num_class=num_class) # "multi:softprob"를 선택하였을 때 위에서 할당한 num_class 설정 필요 

### 6. 학습모델 훈련
xgb.fit <- xgb.train( # 훈련모델 함수
  params=params, # param 리스트 적용
  data=xgb.train, # 훈련 행렬 데이터셋
  nrounds=10000, # 부스팅 횟수
  nthreads=100, # 병렬처리 횟수(100개 설정)
  early_stopping_rounds=5, # 5회 연속 반복되어도 성능개선이 이루어지 않는 경우 중단
  watchlist=list(val1=xgb.train, val2=xgb.test), # 설명 없음
  verbose=0) # 부스팅 단계마다 결과 확인 하지 않음(set to 1 so we can see the results for each round.)

xgb.fit # Review the final model and results

### 7. 예측과 평가

# 7.1 Predict outcomes with the test data
xgb.pred <- predict(xgb.fit, # 학습모델
                    test.data, # 시험데이터 셋
                    reshape=TRUE) # 예측시 ndata * nclass를 ndata로 데이터 형태 변환
class(xgb.pred) # 속성 확인
head(xgb.pred, 3) # 확인

xgb.pred <- as.data.frame(xgb.pred) # 행렬 데이터를 데이터 프레임으로 변환
colnames(xgb.pred) <- levels(marriage) # 종속변수 분류 수준의 이름을 xgb.pred객체의 열이름으로 할당
head(xgb.pred, 3) # 확인 

# 7.2 Use the predicted label with the highest probability
xgb.pred$prediction <- apply(xgb.pred, # Apply Functions Over Array Margins
                             1, # 행기준
                             function(x) colnames(xgb.pred)[which.max(x)]) # x가 최대인 열이름을 할당
xgb.pred$label <- levels(marriage)[test.label+1] # 시험 데이터셋의 0, 1, 2 수준을 1, 2, 3으로 변환하여 할당

# 7.3 Calculate the final accuracy
table(xgb.pred$prediction, xgb.pred$label) # 예측값과 시험 데이터 실측값 이원빈도분포표
mean(xgb.pred$prediction == xgb.pred$label) # 일치율 계산
result <- sum(xgb.pred$prediction==xgb.pred$label)/nrow(xgb.pred) # 일치율 계산 2
result # 결과 
print(paste("Final Accuracy =",sprintf("%1.2f%%", 100*result))) # 프린트