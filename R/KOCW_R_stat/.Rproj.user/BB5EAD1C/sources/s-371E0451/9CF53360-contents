### 날짜와 시간
# R에서 날짜와 시간 클래스
d <- Sys.Date()
print(d)

t <- Sys.time()
print(t)

unclass(d)
unclass(t)

# 날짜 형식(포맷)
#* 문자열을 날짜로 변환
as.Date('1/21/2020', format = '%m/%d/%Y')
as.Date('April 26, 2020', format = '%B %d, %Y')
as.Date('4월 26, 2020', format = '%B %d, %Y')

?Sys.setlocale
Sys.setlocale('LC_ALL', 'English') # KST 타입으로 지정되어 있으므로, 영어로 변경이 필요함
# Sys.setlocale('LC_ALL', 'Korean') # KST 타입를 다시 사용하려면, 이 코드를 넣어주면 됨
as.Date('April 26, 2020', format = '%B %d, %Y')

# 날짜와 시간 표기
?Sys.time()
x <- Sys.time()
format(x, '%Y-%m-%d %H:%M:%S') # 날짜를 문자열로 변환

# 날짜와 시간 연산
d1 <- as.Date('2019-11-17')
d2 <- as.Date('2019-12-11')

d2 > d1
d1 - d2
d1 + d2
d1 * d2
d1 / d2
d1 - 7
d1 + 7
d1 * 7
d1 / 7

t <- Sys.time()
class(t)

# 날짜를 문자열로 변환
format(t, format = '%H시 %M분')
format(t, format = '%Y년 %m월 %d일 %H시 %M분')

as.numeric(format(t, '%Y')) # 년
as.numeric(format(t, '%m')) # 월
as.numeric(format(t, '%d')) # 일
as.numeric(format(t, '%H')) # 시
as.numeric(format(t, '%M')) # 분

# 시간대(zone) 속성을 변경
attributes(t)$tzone <- 'Asia/Seoul'
t

t - 3600
t + 3600
t * 3600
t / 3600


#################### Time Series Analysis(시계열 분석) ####################

# 실습 1: AirPassengers
?AirPassengers # 내장 데이터 설명: 단위 천명

## 1. Loading the Data Set
data(AirPassengers) # 데이터 불러오기
class(AirPassengers) # 데이터 속성 확인하기
View(AirPassengers)

start(AirPassengers) # 시작 시점 확인
end(AirPassengers) # 종료 시점 확인
frequency(AirPassengers) # 주기 확인
summary(AirPassengers) # 요약 통계
str(AirPassengers) # 데이터 구조 확인

## 2. 시계열 시각화와 패턴 분석
plot(AirPassengers) # a trend component which grows the passenger year by year. -> address the trend component
                    # a seasonal component which has a cycle less than 12 months.
                    # The variance in the data keeps on increasing with time. ->  remove unequal variances using log of the series
abline(reg = lm(AirPassengers ~ time(AirPassengers))) # 회귀직선 추가하기

?aggregate() # Compute Summary Statistics of Data Subsets
             # a function to compute the summary statistics which can be applied to all data subsets.
plot(aggregate(AirPassengers, FUN = mean)) # 평균값으로 집계화하여 그래프 작성

?cycle() # the positions in the cycle of each observation.
cycle(AirPassengers) # 주기 확인: 주기에서의 결측치 확인
boxplot(AirPassengers ~ cycle(AirPassengers)) # 주기(월)별 박스 그래프

plot(decompose(AirPassengers)) # 시계열 분해 그래프 생성

## 3. 시계열 안정성 진단 및 검증
library(tseries) # install.packages("tseries")
?adf.test() # Augmented Dickey-Fuller Test for the null hypothesis of a unit root of a univariate time series 
adf.test(AirPassengers,
         alternative = "stationary", #  stationary enough to do any kind of time series modeling.
         k = 0) # the lag order to calculate the test statistic
?Box.test() # Box-Pierce and Ljung-Box Tests
Box.test(AirPassengers, type = 'Ljung-Box') # H0: 자기상관성이 존재하지 않는다(Random Walk)

?diff() # Lagged Differences, suitably lagged and iterated differences.
plot(diff(log(AirPassengers))) # 로그 차분

adf.test(diff(log(AirPassengers)),
         alternative = 'stationary',
         k = 0)
Box.test(diff(log(AirPassengers)), type = 'Ljung-Box')

## 4. ARIMA모델 파라미터 탐색
#### 차분(d = ?) 정상화 시도
d1 <- diff(log(AirPassengers), differences = 1)
d2 <- diff(log(AirPassengers), differences = 2)
d3 <- diff(log(AirPassengers), differences = 3)
d4 <- diff(log(AirPassengers), differences = 4)

par(mfrow = c(2, 3))
plot(AirPassengers) 
plot(log(AirPassengers))
plot(d1)
plot(d2)
plot(d3)
plot(d4)
par(mfrow = c(1, 1))

### p, q 탐색: 직접 확인하기(예: q)
#### 이동평균 평활화 >> 이 부분은 참고 정도만 하자(ACF와 PACF로 p, q 값을 결정할 수 있기 때문에)
library(TTR) # 미설치시 install.packages("TTR")
?SMA() # Calculate various moving averages (MA) of a series.
ma1 <- SMA(log(AirPassengers), n = 1) # q = ?
ma2 <- SMA(log(AirPassengers), n = 2)
ma3 <- SMA(log(AirPassengers), n = 3)
ma4 <- SMA(log(AirPassengers), n = 4)

par(mfrow = c(2, 2))
plot(ma1)
plot(ma2)
plot(ma3)
plot(ma4)
par(mfrow = c(1, 1))

### ACF와 PACF로 확인
par(mfrow = c(2, 2))
acf(log(AirPassengers)) # the decay of ACF chart is very slow, which means that the population is not stationary.
pacf(log(AirPassengers))
acf(diff(log(AirPassengers))) #  # lag 2부터 점선 안에 존재. lag 절단값 = 2. --> MA(1): after regressing on the difference. value of p should be 0 as the ACF is the curve getting a cut off
pacf(diff(log(AirPassengers))) # value of q should be 1 or 2. 
par(mfrow = c(1, 1))

## 5. ARIMA 모델링
?arima() # ARIMA Modelling of Time Series
(fit <- arima(log(AirPassengers), c(0, 1, 1))) # "p=0, d=1, q=1"로 설정한 ARIMA 모델
Box.test(fit$residuals, type = 'Ljung-Box')

library(forecast) #install.packages("forecast")
?auto.arima() # Fit best ARIMA model to univariate time series
fit2 <- auto.arima(log(AirPassengers)) # 자동으로 ARIMA 모형 p,d,q 확인
summary(fit2)
Box.test(fit2$residuals, type = 'Ljung-Box')

## 6. 시계열 예측
?predict()
pred <- predict(fit2, n.ahead = 5 * 12) # 5년 후까지 예측

?ts.plot() # Plot Multiple Time Series
ts.plot(AirPassengers,
        exp(pred$pred), # 앞에서 로그변환을 해줬으므로, exp를 통해 다시 원복시켜줘야 함
        log = "y",
        lty = c(1, 3), # 선형태(1 = 실측치, 3 = 예측치)
        gpars = list(xlab = "Month", ylab = "Int. Air Passengers(단위: 천명)"))

# 실습 2:한국 월별 주택매매가격 지수  
### 1. 데이터 불러오기와 탐색하기
library(readxl)
# 주택매매가격지수: 주택매매가격을 기준시점(2017.11=100.0)과 조사시점의 가격비를 이용하여 기준시점이 100인 수치로 환산한 값
df.h <- read_xlsx("월별_주택매매가격지수_시도.xlsx", 1) # 엑셀자료 불러오기
str(df.h) # 데이터 구조 확인하기
summary(df.h) # 요약 통계

?ts() # to create time-series objects
ts.h <-  ts(df.h$전국, # 시계열 자료로 변환: "전국" 데이터 열 할당
            start = c(2003, 11), # 시작 주기
            frequency = 12) # 빈도
class(ts.h) # 시계열 자료형으로 변환되었는지 확인
start(ts.h)
end(ts.h)
frequency(ts.h)
summary(ts.h)

## 2. 시계열 시각화와 패턴 분석
plot(ts.h) # 그래프 작성
abline(reg = lm(ts.h ~ time(ts.h)), col = 'red') # 회귀직선 추가
plot(decompose(ts.h)) # 시계열 분해 그래프 작성

## 3. 시계열 안정성 진단 및 검증
# 단위근 검정
adf.test(ts.h, alternative = 'stationary', k = 0)
# 로그 차분 그래프 작성
plot(diff(log(ts.h)))
# 로그 차분 단위근 검정
adf.test(diff(log(ts.h)), alternative = 'stationary', k = 0)

## 4. ARIMA모델 파라미터 탐색
# 4-1. 차분 정상화
?diff() # Lagged Differences, suitably lagged and iterated differences.
d1 <- diff(log(ts.h), differences = 1)
d2 <- diff(log(ts.h), differences = 2)

par(mfrow = c(2, 2))
plot(ts.h)
plot(log(ts.h))
plot(d1)
plot(d2)

acf(log(ts.h))
pacf(log(ts.h))
acf(diff(log(ts.h)))
pacf(diff(log(ts.h)))
par(mfrow = c(1, 1))

# 4-2. 자동으로 ARIMA 모형 확인
auto.arima(log(ts.h)) 

## 5. ARIMA 모델링
fit <- arima(log(ts.h), c(0, 2, 0),
             seasonal = list(order = c(0, 0, 0), period = 12))
summary(fit)
Box.test(fit$residuals)

## 6. 시계열 예측
pred <- predict(fit, n.ahead = 5 * 12) # 5년 후까지 예측

ts.plot(ts.h,
        exp(pred$pred), # 앞에서 로그변환을 해줬으므로, exp를 통해 다시 원복시켜줘야 함
        log = 'y',
        lty = c(1, 3),
        col = c('black', 'red'))

# 실습 3: 다중시계열 분석: 서울시 지하철 이용자수 (실습 파일을 제공받지 못함..)
df.subway <- read.csv("seoul_subway_total_ridership.csv")
summary(df.subway)

## 1. 시계열 자료로 변환
ts.subway <- msts(df.subway$total, 
                  seasonal.periods = c(7,365.25),
                  start = c(2013, 1, 1))
plot(ts.subway, main = "Daily subway ridership", xlab = "Year", ylab = "Daily Admissions")

class(ts.subway)
start(ts.subway)
end(ts.subway)
frequency(ts.subway)
summary(ts.subway)

## 2. 시계열 시각화와 패턴 분석
plot(ts.subway) 
plot(decompose(ts.subway))

library(forecast)
?tbats() # TBATS model (Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components)
tbats <- tbats(ts.subway)
plot(tbats, main = "Multiple Season Decomposition") # 시간이 오래 걸림

?mstl() # Multiple seasonal decomposition
head(mstl(ts.subway))
?autoplot() #  ggplot2 to draw a particular plot for an object of a particular class in a single command.
autoplot(mstl(ts.subway)) # tbats() + plot()을 사용하는 것보다 mstl() + autoplot()을 사용하는 것이 보기 좋음!! 

## 3. 시계열 안정성 진단 및 검증
# 단위근 검정
adf.test(ts.subway, 
         alternative = "stationary", #  stationary enough to do any kind of time series modelling.
         k = 0)
Box.test(ts.subway)

## 4. ARIMA모델 파라미터 탐색
auto.arima(ts.subway) # 자동으로 ARIMA 모형 파라미터 확인: 시간이 오래 걸림

## 5. ARIMA 모델링 (시간 오래 걸림)
fit <- arima(ts.subway, c(5, 0, 0),
             seasonal = list(order = c(0, 1, 0), period = 365))
fit
Box.test(fit$residuals, lag = 1, type = "Ljung-Box")

## 6. 시계열 예측
?stlf() # Forecasting using stl objects
forecast <- stlf(ts.subway)
summary(forecast)
autoplot(stlf(ts.subway))

##*************** 연습 문제 05
# 서울시 일별 지하철 이용자수 데이터 중에서 오전첨두시(tot_amPeak) 승하차수를 7일 주기가 아닌 1년 주기(365.25)로만 설정하여 ARIMA의 적합한 패터미터 값이 얼마 인지 auto.arima()함수를 활용하여 확인하시오.
df.subway <- read.csv("seoul_subway_total_ridership.csv")
summary(df.subway)

ts.subway2 <- ts(df.subway$tot_amPeak,
                 frequency = 365.25, # 1년 주기
                 start = c(2013, 1, 1))

adf.test(ts.subway2)

fit <- auto.arima(ts.subway2)
summary(fit)

Box.test(fit$residuals)

##*************** 연습 문제 06
# 서울시 월별 주택매매가격지수(df.h$서울특별시)를 이용하여, ARIMA의 적합한 파라미터 값이 얼마인지 auto.arima() 함수를 활용하여 확인하시오.
summary(df.h)
ts.h.seoul <-  ts(df.h$서울특별시, # 시계열 자료로 변환: "서울특별시" 데이터 열 할당
                  start = c(2003, 11), # 시작 주기
                  frequency = 12) # 빈도

adf.test(ts.h.seoul)

fit <- auto.arima(ts.h.seoul)
summary(fit)

adf.test(fit$residuals)
Box.test(fit$residuals)

##*************** 연습 문제 07 (실습 파일을 제공받지 못함..)
# 서울시 일별 버스 이용자 수 데이터 중, 일별 승차자 수(on_bus) 자료를 활용하여 ARIMA 모형의 p, d, q를 적합하게 auto.arima() 함수를 구축한 후, 모델링 후의 잔차에 대한 자기상관성 검정을 실시하시오.
df.bus <- read.csv("seoul_bus_ridership.csv")
summary(df.bus)

ts.bus <- ts(df.bus$on_bus,
             frequency = 365.25,
             start = c(2015, 1, 1))

adf.test(ts.bus)

fit <- auto.arima(ts.bus)
summary(fit)

adf.test(fit$residuals)
Box.test(fit$residuals, type = "Box-Pierce")
Box.test(fit$residuals, type = "Ljung-Box")