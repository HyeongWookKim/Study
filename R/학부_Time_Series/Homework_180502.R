### Homework_180502 ###

## p.36 ex_3 by exponential smoothing ##
# data
money <- read.csv("D:/Time Series/월별통화량자료.txt", header=F)
colnames(money)[colnames(money) == 'V1'] <- 'money'
money
money_ts <- ts(money, frequency=12, start=c(1979,1))
money_ts
plot.ts(money_ts, main="Korean Money from 1979 to 1988", xlab="Date", ylab="Money")

# Holt's exponential smoothing method
money_tsf1 <- HoltWinters(money_ts, gamma=FALSE)
money_tsf1
money_tsf1$fitted
money_tsf1$SSE
plot(money_tsf1, xlab="Date")

# Decomposition by multiplicative model
library(TTR)
money_ts_dc <- decompose(money_ts, type=c("multiplicative"))
money_ts_dc
money_ts_dc$seasonal
plot(money_ts_dc, xlab="Date")

# seasonally adjusted
money_ts_adj <- money_ts/money_ts_dc$seasonal
plot(money_ts_adj, main="Korean Money from 1979 to 1988", xlab="Date", ylab="Money")

# Holt's exponential smoothing method(with seasonally adjusted)
money_tsf2 <- HoltWinters(money_ts_adj, gamma=FALSE)
money_tsf2
money_tsf2$fitted
money_tsf2$SSE
plot(money_tsf2, xlab="Date")

# forecast future value
library(forecast)
money_tsf22 <- forecast(money_tsf2, h=12)
money_tsf22
plot(forecast(money_tsf22), xlab="Date", ylab="Money")

###########################################################################################

## p.36 ex_3 by Time series regression ##
# data
money <- read.csv("D:/Time Series/월별통화량자료.txt", header=F)
colnames(money)[colnames(money) == 'V1'] <- 'money'
money
money_ts <- ts(money, frequency=12, start=c(1979,1))
money_ts
plot.ts(money_ts, main="Korean Money from 1979 to 1988", xlab="Date", ylab="Money")

# remove trend
plot.ts(log(money_ts), main="Korean Money from 1979 to 1988", xlab="Date", ylab="Money")

# orthogonal polynomial
t <- time(1:length(money_ts))
n <- length(money_ts)
n2 <- n*n
n4 <- n2*n2
O1 <- t-(n+1)/2
O2 <- O1**2-(n2-1)/12
O3 <- O1**3-(3*n2-7)*O1/20
O4 <- O1**4-(3*n2-13)*O1**2/14+3*(n2-1)*(n2-9)/560
O5 <- O1**5-5*(n2-7)*O1**3/18+(15*n4-230*n2+407)*O1/1008
money_data <- data.frame(O1,O2,O3,O4,O5)

install.packages("leaps")
library(leaps)
m <- regsubsets(log(money_ts)~., data=money_data)
summary(m)
summary(m)$bic
m2 <- lm(log(money_ts)~O1+O3+O4)
summary(m2)
ts.plot(resid(m2))

# seasonal function model for residual(without trend)
season <- cycle(money_ts)
m3 <- lm(resid(m2)~0+factor(season))
summary(m3)

# trend + seasonal
m4 <- lm(log(money_ts)~0+O1+O3+O4+factor(season))
summary(m4)

# checkup the model
par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))
plot(resid(m4))
acf(resid(m4))
install.packages("car")
library(car)
durbinWatsonTest(m4, alternative="positive")

# prediction of next 12 months
newt <- length(money_ts)+time(length(money_ts):(length(money_ts)+11))
O11 <- newt-(n+1)/2
O22 <- O11*2-(n2-1)/12
O33 <- O11**3-(3*n2-7)*O11/20
O44 <- O11**4-(3*n2-13)*O11**2/14+3*(n2-1)*(n2-9)/560
O55 <- O11**5-5*(n2-7)*O11**3/18+(15*n4-230*n2+407)*O11/1008
newdata <- data.frame(O1=O11, O3=O33, O4=O44, season=rep(1:12,1))
newdata
money.pred.ts <- exp(ts((predict(m4, newdata)), st=1989, fr=12))
ts.plot(log(money_ts), log(money.pred.ts), lty=1:2)

###########################################################################################

## accident data by exponential smoothing ##
# data
accident <- read.csv("D:/Time Series/accident.csv", header=T)
accident
accident_ts <- ts(accident, frequency=12, start=c(2012,1))
accident_ts
plot.ts(accident_ts, main="Traffic Accident", xlab="Date", ylab="Cases")

# simple exponential smoothing method
accident_tsf <- HoltWinters(accident_ts, beta=FALSE, gamma=FALSE)
accident_tsf
accident_tsf$fitted
accident_tsf$SSE
plot(accident_tsf, xlab="Date")

# decomposition by additive model
library(TTR)
accident_ts_dc <- decompose(accident_ts)
accident_ts_dc
accident_ts_dc$seasonal
plot(accident_ts_dc, xlab="Date")

# seasonally adjusted
accident_ts_adj <- accident_ts + accident_ts_dc$seasonal
plot(accident_ts_adj, main="Traffic Accident", xlab="Date", ylab="Cases")

# Holt's exponential smoothing method(with seasonally adjusted)
accident_tsf2 <- HoltWinters(accident_ts, gamma=FALSE)
accident_tsf2
accident_tsf2$fitted
accident_tsf2$SSE
plot(accident_tsf2, xlab="Date")

# forecast future value
library(forecast)
accident_tsf22 <- forecast(accident_tsf2, h=12)
accident_tsf22
plot(forecast(accident_tsf22), xlab="Date", ylab="Cases")

###########################################################################################

## accident data by Time series regression ##
# data
accident <- read.csv("D:/Time Series/accident.csv", header=T)
accident
accident_ts <- ts(accident, frequency=12, start=c(2012,1))
accident_ts
plot.ts(accident_ts, main="Traffic Accident", xlab="Date", ylab="Cases")

# remove trend
plot.ts(log(accident_ts), main="Traffic Accident", xlab="Date", ylab="Cases")

# orthogonal polynomial
t <- time(1:length(accident_ts))
n <- length(accident_ts)
n2 <- n*n
n4 <- n2*n2
O1 <- t-(n+1)/2
O2 <- O1**2-(n2-1)/12
O3 <- O1**3-(3*n2-7)*O1/20
O4 <- O1**4-(3*n2-13)*O1**2/14+3*(n2-1)*(n2-9)/560
O5 <- O1**5-5*(n2-7)*O1**3/18+(15*n4-230*n2+407)*O1/1008
accident_data <- data.frame(O1,O2,O3,O4,O5)

install.packages("leaps")
library(leaps)
m <- regsubsets(log(accident_ts)~., data=accident_data)
summary(m)
summary(m)$bic
m2 <- lm(log(accident_ts)~O1)
summary(m2)
ts.plot(resid(m2))

# seasonal function model for residual(without trend)
season <- cycle(accident_ts)
m3 <- lm(resid(m2)~0+factor(season))
summary(m3)

# trend + seasonal
m4 <- lm(log(accident_ts)~0+O1+factor(season))
summary(m4)

# checkup the model
par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))
plot(resid(m4))
acf(resid(m4))
install.packages("car")
library(car)
durbinWatsonTest(m4, alternative="positive")

# prediction of next 12 months
newt <- length(accident_ts)+time(length(accident_ts):(length(accident_ts)+11))
O11 <- newt-(n+1)/2
O22 <- O11*2-(n2-1)/12
O33 <- O11**3-(3*n2-7)*O11/20
O44 <- O11**4-(3*n2-13)*O11**2/14+3*(n2-1)*(n2-9)/560
O55 <- O11**5-5*(n2-7)*O11**3/18+(15*n4-230*n2+407)*O11/1008
newdata <- data.frame(O1=O11, season=rep(1:12,1))
newdata
accident.pred.ts <- exp(ts((predict(m4, newdata)), st=2017, fr=12))
ts.plot(log(accident_ts), log(accident.pred.ts), lty=1:2)