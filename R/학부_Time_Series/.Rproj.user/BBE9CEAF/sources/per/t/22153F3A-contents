#### Homework_3 ###

earthquake <- read.csv("D:/Time Series/earthquake.csv", header=T)
earthquake
attach(earthquake)

eq <- ts(earthquake, start=c(1978))
eq
plot.ts(eq, main="Earthquake", xlab="Year", ylab="Count")

# Simple exponential smoothing method
eq_ts2 <- HoltWinters(eq, alpha=0.2, beta=FALSE, gamma=FALSE) # alpha=0.2
eq_ts2
eq_ts2$fitted
plot(eq_ts2)
eq_ts2$SSE

eq_ts8 <- HoltWinters(eq, alpha=0.8, beta=FALSE, gamma=FALSE) # alpha=0.8
eq_ts8
eq_ts8$fitted
plot(eq_ts8)
eq_ts8$SSE

library(forecast)
eq_ts22 <- forecast(eq_ts2, h=3)
eq_ts22
plot(forecast(eq_ts22), main="Earthquake", xlab="Year", ylab="Count")

eq_ts88 <- forecast(eq_ts8, h=3)
eq_ts88
plot(forecast(eq_ts88), main="Earthquake", xlab="Year", ylab="Count")

eq_tsoptimal1 <- HoltWinters(eq, beta=FALSE, gamma=FALSE) # Use an optimal alpha which makes minimum of SSE
eq_tsoptimal1
eq_tsoptimal1$SSE
plot(eq_tsoptimal1)

# Holt's exponential smoothing method
eq_ts <- HoltWinters(eq, alpha=0.2, beta=0.3, gamma=FALSE) # alpha=0.2, beta=0.3
eq_ts
plot(eq_ts)

eq_tsoptimal2 <- HoltWinters(eq, gamma=FALSE)
eq_tsoptimal2$fitted
plot(eq_tsoptimal2)

library(forecast)
eq_tsoptimal22 <- forecast(eq_tsoptimal2, h=6)
eq_tsoptimal22
plot(forecast(eq_tsoptimal22), main="Earthquake", xlab="Year", ylab="Count")