### Time Series ###

## Multiple Regression ##
# ex_1
install.packages("UsingR")
library(UsingR)

head(cfb)

hist(cfb$INCOME, breaks=500, freq=TRUE)

cfb <- transform(cfb, INCOME_log=log(INCOME+1))
hist(cfb$INCOME_log, breaks=500, freq=TRUE)

plot(cfb$EDUC, cfb$INCOME)

cfb_lm <- lm(INCOME~., data=cfb)
summary(cfb_lm)

cfb_step <- step(cfb_lm, direction="both")

# ex_2
head(stackloss)

m <- lm(stack.loss~., data=stackloss)
summary(m)

m_step <- step(m, direction="both")

# ex_3
y <- c(78.5,74.3,104.3,87.6,95.9,109.2,102.7,
       72.5,93.1,115.9,83.8,113.3,109.4)
x1 <- c(7,1,11,11,7,11,3,1,2,21,1,11,10)
x2 <- c(26,29,56,31,52,55,71,31,54,47,40,66,68)
x3 <- c(6,15,8,8,6,9,17,22,18,4,23,9,8)
x4 <- c(60,52,20,47,33,22,6,44,22,26,34,12,12)

cement <- data.frame(y,x1,x2,x3,x4)
cement

cement_lm <- lm(y~., data=cement)
cement_step <- step(cement_lm, direction="both")

install.packages("leaps")
library(leaps)

all <- regsubsets(y~., data=cement)
summary(all)
summary(all)$bic

lm(y~x1+x2)
summary(lm(y~x1+x2))