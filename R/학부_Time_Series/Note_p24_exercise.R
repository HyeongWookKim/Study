### Exercise p.24 ###

## Q1 ##
y <- c(362,385,432,341,382,409,498,387,473,513,582,474,
       544,582,681,557,628,707,773,592,627,725,854,661)
yts <- ts(y, frequency=4, start=c(2000,1))
yts
plot.ts(yts)
# Simple exponential smoothing method
ytsf1 <- HoltWinters(yts, beta=FALSE, gamma=FALSE)
ytsf1
ytsf1$fitted
ytsf1$SSE
plot(ytsf1)

library(forecast)
ytsf11 <- forecast(ytsf1, h=4)
ytsf11
plot(forecast(ytsf11))

# Holt's exponential smoothing method
ytsf2 <- HoltWinters(yts, gamma=FALSE)
ytsf2
ytsf2$fitted
ytsf2$SSE
plot(ytsf2)

library(forecast)
ytsf22 <- forecast(ytsf2, h=4)
ytsf22
plot(forecast(ytsf22))

# Winter's exponential smoothing method
ytsf3 <- HoltWinters(yts)
ytsf3
ytsf3$fitted
ytsf3$SSE
plot(ytsf3)

library(forecast)
ytsf33 <- forecast(ytsf3, h=4)
ytsf33
plot(forecast(ytsf33))


## Q2(Textbook p.68_#4) ##
# (1)
y <- c(189,229,249,289,260,431,660,777,915,613,485,277,
       244,296,319,370,313,556,831,960,1152,759,607,371,
       298,378,373,443,374,660,1004,1153,1388,904,715,441,
       352,445,453,541,457,762,1194,1361,1615,1059,824,495)
yts <- ts(y, frequency=12, start=c(2013,1))
yts
plot.ts(yts)

# (2)
ytsf2 <- HoltWinters(yts, gamma=FALSE)
ytsf2
ytsf2$fitted
ytsf2$SSE
plot(ytsf2)

library(forecast)
ytsf22 <- forecast(ytsf2, h=12)
ytsf22
plot(forecast(ytsf22))

# (3)
ytsf3 <- HoltWinters(yts)
ytsf3
ytsf3$fitted
ytsf3$SSE
plot(ytsf3)

library(forecast)
ytsf33 <- forecast(ytsf3, h=12)
ytsf33
plot(forecast(ytsf33))


## Q3 ##
# (a)
rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat", skip=1)
raint <- ts(rain, start=c(1813))
raint
plot.ts(raint)

raint1 <- HoltWinters(raint, beta=FALSE, gamma=FALSE)
raint1
raint1$fitted
raint1$SSE
plot(raint1)

library(forecast)
raint11 <- forecast(raint1, h=10)
raint11
plot(forecast(raint11))

# (b)
skirts <- scan("http://robjhyndman.com/tsdldata/roberts/skirts.dat", skip=5)
skirtsts <- ts(skirts, start=c(1866))
skirtsts
plot.ts(skirtsts)

skirtsts2 <- HoltWinters(skirtsts, gamma=FALSE)
skirtsts2
skirtsts2$fitted
skirtsts2$SSE
plot(skirtsts2)

library(forecast)
skirtsts22 <- forecast(skirtsts2, h=10)
skirtsts22
plot(forecast(skirtsts22))

# (c)
souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirts <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirts
plot(souvenirts)

souvenirts3 <- HoltWinters(souvenirts)
souvenirts3
souvenirts3$fitted
souvenirts3$SSE
plot(souvenirts3)

library(forecast)
souvenirts33 <- forecast(souvenirts3, h=12)
souvenirts33
plot(forecast(souvenirts33))