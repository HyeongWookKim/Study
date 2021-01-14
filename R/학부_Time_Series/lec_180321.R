### Moving average method ###

# Simple average method
y1 <- c(42,40,43,38,41,37,39,42,40,41,39,36,41,40,43,42,38,36)
ft <- y1
k <- length(y1)
for(i in 1:k-1) {ft[i+1] <- mean(y1[1:i])}
ft
et1 <- y1-ft
et1

# Simple moving average method
y <- c(200,135,195,197.5,310,175,155,130,220,277,235)
yts <- ts(y)
plot.ts(yts)

install.packages("TTR")
library(TTR)

yma3 <- SMA(yts, n=3) # MA(3)
yma5 <- SMA(yts, n=5) # MA(5)
ymat <- cbind(yts, yma3, yma5)

plot.ts(ymat, plot.type="single", lty=1:3, col=1:3)
plot.ts(ymat, plot.type="multiple")

### Exponential smoothing method ###

# Simple exponential smoothing method
y <- c(200,135,195,197.5,310,175,155,130,220,277,235)
yts <- ts(y)
plot.ts(yts)

ytsf1 <- HoltWinters(yts, alpha=0.1, beta=FALSE, gamma=FALSE) # alpha=0.1
ytsf1
ytsf1$fitted
plot(ytsf1)
ytsf1$SSE

ytsf5 <- HoltWinters(yts, alpha=0.5, beta=FALSE, gamma=FALSE) # alpha=0.9
ytsf5
ytsf5$fitted
plot(ytsf5)
ytsf5$SSE

ytsf9 <- HoltWinters(yts, alpha=0.9, beta=FALSE, gamma=FALSE) # alpha=0.9
ytsf9
ytsf9$fitted
plot(ytsf9)
ytsf9$SSE

ytsfini <- HoltWinters(yts, alpha=0.1, beta=FALSE, gamma=FALSE, l.start=200) # initial value(start value)=200
ytsfini

install.packages("forecast")
library(forecast)

ytsf11 <- forecast(ytsf1, h=3) # h = Number of data to calculate the predicted value
ytsf11
plot(forecast(ytsf11))

ytsf55 <- forecast(ytsf5, h=3)
ytsf55
plot(forecast(ytsf55))

ytsf99 <- forecast(ytsf9, h=3)
ytsf99
plot(forecast(ytsf99))

ytsfoptimal <- HoltWinters(yts, beta=FALSE, gamma=FALSE) # Use an optimal alpha which makes minimum of SSE
ytsfoptimal
ytsfoptimal$SSE
plot(ytsfoptimal)

# Holt's exponential smoothing method
y <- c(143,152,161,139,137,174,142,141,162,180,164,171,
       206,193,207,218,229,225,204,227,223,242,239,266)
yts <- ts(y)
plot.ts(yts)

ytsf <- HoltWinters(yts, alpha=0.2, beta=0.3, gamma=FALSE) # alpha=0.2, beta=0.3
ytsf

ytsfoptimal <- HoltWinters(yts, gamma=FALSE)
ytsfoptimal$fitted
plot(ytsfoptimal)

library(forecast)
ytsf2 <- forecast(ytsfoptimal, h=6)
ytsf2
plot(forecast(ytsf2))

# Winter's exponential smoothing method
y <- c(362,385,432,341,382,409,498,387,473,513,582,474,
       544,582,681,557,628,707,773,592,627,725,854,661)
yts <- ts(y, frequency=4, start=c(2000,1))
yts
plot.ts(yts)

ytsfoptimal <- HoltWinters(yts)
ytsfoptimal$fitted
plot(ytsfoptimal)

library(forecast)
ytsf2 <- forecast(ytsfoptimal, h=4)
ytsf2
plot(forecast(ytsf2))