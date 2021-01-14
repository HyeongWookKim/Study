### Homework 180328 ###

# Data
accident <- read.csv("D:/Time Series/accident.csv", header=T)
accident
accident_ts <- ts(accident, frequency=12, start=c(2012,1))
accident_ts
plot.ts(accident_ts, main="Traffic Accident", xlab="Date", ylab="Cases")

# Simple exponential smoothing method
accident_tsf1 <- HoltWinters(accident_ts, beta=FALSE, gamma=FALSE)
accident_tsf1
accident_tsf1$fitted
accident_tsf1$SSE
plot(accident_tsf1, xlab="Date")

# Forecast future values
library(forecast)
accident_tsf11 <- forecast(accident_tsf1, h=12)
accident_tsf11
plot(forecast(accident_tsf11), xlab="Date", ylab="Cases")

# Decomposition by additive model
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