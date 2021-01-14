### Assignment_final report ###

## MICE data ##

## Method 1 : Winter's exponential smoothing method ##

# Data
mice <- read.csv("D:/Time Series/MICE.csv", header=T)
mice
attach(mice)

# Time series graph
mice_ts <- ts(participant, frequency=12, start=c(2012,1))
mice_ts
plot.ts(mice_ts, main="MICE 산업 컨벤션 참가자 수", xlab="date", ylab="participant_num")

# Winter's exponential smoothing method
mice_ts1 <- HoltWinters(mice_ts)
mice_ts1
mice_ts1$SSE
mice_ts1$fitted
plot(mice_ts1, xlab="date")

# Prediction of next 12 months
library(forecast)
mice_pred1 <- forecast(mice_ts1, h=12)
mice_pred1
plot(forecast(mice_pred1), xlab="date", ylab="participant_num")

#########################################################################################################

## Method 2 : Regression Time Series method ##

# Data
mice <- read.csv("D:/Time Series/MICE.csv", header=T)
mice
attach(mice)

# Time series graph
mice_ts <- ts(participant, frequency=12, start=c(2012,1))
mice_ts
plot.ts(mice_ts, main="MICE 산업 컨벤션 참가자 수", xlab="date", ylab="participant_num")

# Log transform -> 로그변환 굳이 안 해도 될듯..? 불확실하니까 일단 패스
#plot.ts(log(mice_ts), main="Log Transform", xlab="date", ylab="participant_num")

# Decomposition by multiplicative model 
library(TTR)
mice_dec <- decompose(mice_ts, type=c("multiplicative"))
plot(mice_dec)

# Seasonally adjusted -> 이 방법은 정확히 모르겠음...일단 패스
#mice_dec$seasonal
#mice_adj <- mice_ts/mice_dec$seasonal
#plot(mice_adj)

# Orthogonal polynomial
t <- time(1:length(mice_ts))
n <- length(mice_ts)
n2 <- n*n
n4 <- n2*n2
O1 <- t-(n+1)/2
O2 <- O1**2-(n2-1)/12
O3 <- O1**3-(3*n2-7)*O1/20
O4 <- O1**4-(3*n2-13)*O1**2/14+3*(n2-1)*(n2-9)/560
O5 <- O1**5-5*(n2-7)*O1**3/18+(15*n4-230*n2+407)*O1/1008
mice_data <- data.frame(O1,O2,O3,O4,O5)

library(leaps)
m <- regsubsets(mice_ts~., data=mice_data)
summary(m)
summary(m)$bic
m2 <- lm(mice_ts~O1+O3)
summary(m2)
ts.plot(resid(m2))

# Seasonal function model for residual(without trend)
season <- cycle(mice_ts)
m3 <- lm(resid(m2)~0+factor(season))
summary(m3)

# Trend + Seasonal
m4 <- lm(mice_ts~0+O1+O3+factor(season))
summary(m4)

# Check the normality and the homogeneity of variance
par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))

# Check the independence
plot(resid(m4))
acf(resid(m4))
library(car)
durbinWatsonTest(m4, alternative="positive")

# Prediction of next 12 months
newt <- length(mice_ts)+time(length(mice_ts):(length(mice_ts)+11))
O11 <- newt-(n+1)/2
O22 <- O11*2-(n2-1)/12
O33 <- O11**3-(3*n2-7)*O11/20
O44 <- O11**4-(3*n2-13)*O11**2/14+3*(n2-1)*(n2-9)/560
O55 <- O11**5-5*(n2-7)*O11**3/18+(15*n4-230*n2+407)*O11/1008
mice_newdata <- data.frame(O1=O11, O3=O33, season=rep(1:12,1))
mice_newdata

mice_pred2 <- ts(predict(m4, mice_newdata), st=2017, fr=12)
mice_pred2
ts.plot(mice_ts, mice_pred2, lty=1:2)

#########################################################################################################

## Method 3 : ARIMA model ##

# Data
mice <- read.csv("D:/Time Series/MICE.csv", header=T)
mice
attach(mice)

# Time series graph
mice_ts <- ts(participant, frequency=12, start=c(2012,1))
mice_ts
plot.ts(mice_ts, main="MICE 산업 컨벤션 참가자 수", xlab="date", ylab="participant_num")

# acf and pacf of mice_ts data
acf(mice_ts, lag.max=30)
pacf(mice_ts, lag.max=30)

# Check the stationary and seasonal difference
mice_diff <- diff(mice_ts, differences=12)
plot.ts(mice_diff, main="계절 차분 결과", xlab="date")

# Model identification
par(mfrow=c(2,1))
acf(mice_diff, lag.max=30)
pacf(mice_diff, lag.max=30)
par(mfrow=c(1,1))

# Use auto.arima() to estimate the model
library(forecast)
mice_auto <- auto.arima(mice_ts) # auto.arima에서도 계절 차분을 1번한 모델을 추천해 줌 
mice_auto

# Check the independence
par(mfrow=c(2,1))
acf(mice_auto$residual)
Box.test(mice_auto$residual, type="Ljung-Box")

# Check the homogeneity of variance
plot.ts(mice_auto$residual, main="잔차에 대한 시계열 그래프")
par(mfrow=c(1,1))

# Prediction of next 12 months
mice_pred3 <- forecast(mice_auto, h=12)
mice_pred3
plot(forecast(mice_pred3), xlab="date", ylab="participant_num")