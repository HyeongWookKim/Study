y <- c(13,8,15,4,4,12,11,7,14,12)
yts <- ts(y)
lag1yts <- lag(yts)
lag1yts

y11 <- yts - mean(y)
y11
y12 <- lag1yts - mean(y)
y12

y112 <- y11*y11
y112

r1 <- sum(y11*y12)/sum(y112)
r1
# calculate the auto-correlation
acf <- acf(yts)
acf
# graph of auto-correlation function
acf(yts)

### p.211 6-2 ###
time <- c(1:10)
y <- c(800,820,840,890,830,860,800,780,820,840)
x <- c(160,162,165,170,160,165,155,154,165,168)
stock <- data.frame(time,y,x)
stock

plot(y~x)
m <- lm(y~x)
summary(m)

par(mfrow=c(2,2))
plot(m)

par(mfrow=c(1,1))
# residual graph
plot(resid(m)~time)
# graph of auto-correlation function
acf(resid(m))
# Durbin-Watson test
# install.packages("car")
library(car)
durbinWatsonTest(m)

### practice 6-2 ###
rdata <- read.csv("D:/Time Series/실습6-2(회귀분석).csv")
rdata
attach(rdata)

plot(y1~x1)
plot(y1~x2)
# to check the multicollinearity
plot(x2~x1)

m2 <- lm(y1~., data=rdata)
m22 <- step(m2, direction="both")

# Best subsets regression
install.packages("leaps")
library(leaps)
m3 <- regsubsets(y1~., data=rdata)
summary(m3)
summary(m3)$bic

m4 <- lm(y1~., data=rdata)
par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))
# graph of auto-correlation function
acf(resid(m4))
# Durbin-Watson test
# install.packages("car")
library(car)
# to check the positive correlation
durbinWatsonTest(m4, alternative="positive")

### practice 6-3 ###
data6.3 <- read.csv("D:/Time Series/실습6-3(회귀분석).csv", header=T)
data6.3
attach(data6.3)

y5t <- ts(y5, frequency=4)
y5t
plot(y5~x5)
seas <- cycle(y5t)
factor(seas)

# without intercept(this way is good)
lm1 <- lm(y5~0+x5+factor(seas))
summary(lm1)
# with intercept
lm2 <- lm(y5t~x5+factor(seas))
summary(lm2)

par(mfrow=c(2,2))
plot(lm1)
#install.packages("car")
library(car)
durbinWatsonTest(lm1, alternative="positive")

##################################################################################
### ex_1 ###
## general polynomial ##
gnp <- c(485.5,506.9,540.2,589.0,637.4,692.7,745.3,821.6,906.3,981.3)
t <- ts(1:10)
t2 <- t^2
t3 <- t^3
t4 <- t^4
t5 <- t^5
gnpdata <- data.frame(gnp,t,t2,t3,t4,t5)

m <- lm(gnp~., data=gnpdata)
summary(m)

#install.packages("leaps")
library(leaps)
m2 <- regsubsets(gnp~., data=gnpdata)
summary(m2)
summary(m2)$bic

m3 <- lm(gnp~., data=gnpdata)
summary(m3)

par(mfrow=c(2,2))
plot(m3)
par(mfrow=c(1,1))
plot(gnp~resid(m3))
acf(resid(m3))
#install.packages("car")
library(car)
durbinWatsonTest(m3, alternative="positive")

## orthogonal polynomial ##
gnp <- c(485.5,506.9,540.2,589.0,637.4,692.7,745.3,821.6,906.3,981.3)
t <- ts(1:10)
n <- 10
n2 <- n*n
n4 <- n2*n2
O1 <- t-(n+1)/2
O2 <- O1**2-(n2-1)/12
O3 <- O1**3-(3*n2-7)*O1/20
O4 <- O1**4-(3*n2-13)*O1**2/14+3*(n2-1)*(n2-9)/560
O5 <- O1**5-5*(n2-7)*O1**3/18+(15*n4-230*n2+407)*O1/1008

gnp1data <- data.frame(gnp,O1,O2,O3,O4,O5)

m <- lm(gnp~., data=gnp1data)
summary(m)

m2 <- step(m, data=gnp1data, direction="both")

#install.packages("leaps")
library(leaps)
m3 <- regsubsets(gnp~., data=gnp1data)
summary(m3)
summary(m3)$bic

m4 <- lm(gnp~O1+O2+O5, data=gnp1data)
summary(m4)

par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))
plot(gnp~resid(m4))
acf(resid(m4))
#install.packages("car")
library(car)
durbinWatsonTest(m4, alternative="positive")

### ex_2 ###
y <- c(-7.1,-1.4,5.7,11.9,15.9,21.8,25.4,24.5,20.0,13.4,3.6,0.1,
       -3.6,0.6,5.9,12.3,17.9,21.9,25.1,25.4,20.8,15.8,7.9,-0.1,
       -1.7,-1.7,6.4,13.6,18.5,22.2,23.6,26.0,22.0,14.2,6.7,-1.1,
       -5.9,-3.5,2.5,12.1,18.2,22.6,25.2,26.3,20.1,13.8,8.1,-0.9,
       -5.9,-0.3,4.3,11.6,18.1,22.1,25.3,26.3,20.2,14.7,5.6,-3.4,
       -5.4,-3.3,4.9,11.9,17.1,21.9,23.5,24.5,19.9,12.7,5.2,1.9)
temp <- ts(y, frequency=12, start=c(2005,1))
plot.ts(temp)
points(temp)
T <- time(1:length(temp))

## 1.Using seasonal trigonometric function model ##
TS1 <- sin(2*pi*T/12)
TC1 <- cos(2*pi*T/12)
m <- lm(temp~TS1+TC1)
summary(m)
plot(ts(fitted(m), freq=12, start=c(2005,1)), ylab="Temperature", type="l",
     ylim=range(c(fitted(m),temp)))
points(temp)
#help(fitted)

## 2.Using dummy variables(seasonal average function model) ##
Seas <- cycle(temp)
temp.lm <- lm(temp~0+factor(Seas))
summary(temp.lm)
plot(ts(fitted(temp.lm), freq=12, start=c(2005,1)), ylab="Temperature", type="l",
     ylim=range(c(fitted(m),temp)))
points(temp)

## prediction by seasonal trigonometric function model ##
newt <- time(73:84)
TS2 <- sin(2*pi*newt/12)
TC2 <- cos(2*pi*newt/12)
newdata <- data.frame(T=newt, TS1=TS2, TC1=TC2)
predtemp <- ts(predict(m, newdata), st=2011, fr=12)
predtemp
ts.plot(temp, predtemp, lty=1:2)

### ex_3 ###
data(AirPassengers)
AP <- AirPassengers
plot(AP)
plot(log(AP))

## 2.Using dummy variables(seasonal average function model) ##
t <- time(1:length(AP))
n <- length(AP)
n2 <- n*n
n4 <- n2*n2
O1 <- t-(n+1)/2
O2 <- O1**2-(n2-1)/12
O3 <- O1**3-(3*n2-7)*O1/20
O4 <- O1**4-(3*n2-13)*O1**2/14+3*(n2-1)*(n2-9)/560
O5 <- O1**5-5*(n2-7)*O1**3/18+(15*n4-230*n2+407)*O1/1008
APdata <- data.frame(O1,O2,O3,O4,O5)

#install.packages("leaps")
library(leaps)
m <- regsubsets(log(AP)~., data=APdata)
summary(m)
summary(m)$bic

m2 <- lm(log(AP)~O1+O2)
summary(m2)
ts.plot(resid(m2))

# seasonal model for residual(without trend) 
Seas <- cycle(AP)
m3 <- lm(resid(m2)~0+factor(Seas))
summary(m3)

# "trend + seasnal" model
m4 <- lm(log(AP)~0+O1+O2+factor(Seas))
summary(m4)

# checkup the model
par(mfrow=c(2,2))
plot(m4)
par(mfrow=c(1,1))
plot(resid(m4))
acf(resid(m4))
#install.packages("car")
library(car)
durbinWatsonTest(m4, alternative="positive")

# prediction of next two years
newt <- length(AP)+time(length(AP):(length(AP)+23))
O11 <- newt-(n+1)/2
O22 <- O11*2-(n2-1)/12
newdat <- data.frame(O1=O11, O2=O22, Seas=rep(1:12,2))
AP.pred.ts <- exp(ts(predict(m4, newdat), st=1961, fr=12))
ts.plot(log(AP), log(AP.pred.ts), lty=1:2)
ts.plot(AP, AP.pred.ts, lty=1:2, ylab="Air Passengers")
points(AP)