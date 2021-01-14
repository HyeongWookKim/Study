# Correlation analysis
library(UsingR)
homedata
attach(homedata)
homedata[1:3,]
cor(y1970, y2000)
cor(y1970, y2000, method="spearman")

x1 <- c(6, 9, 8, 3, 10, 4, 5, 2, 11, 9, 10, 2)
x2 <- c(3, 11, 4, 1, 11, 1, 7, 4, 8, 10, 8, 5)
y <- c(10, 12, 12, 4, 12, 6, 8, 2, 18, 9, 17, 2)
data1 <- cbind(x1, x2, y)
a1 <- apply(data1, 2, mean)   # apply(?, 1, ?) : row / apply(?, 2, ?) : column
a2 <- apply(data1, 2, sd)
a3 <- apply(data1, 2, length)
cbind(mean=a1, sd=a2, N=a3)

pairs(data1)

cor(data1)
cor.test(x1,x2)
cor.test(x1,y)
cor.test(x2,y)

library(Hmisc)
rcorr(data1, type="pearson")  # Shows each p-values for correalation

# Regression analysis

# simple linear regression
mother <- c(71,67,83,64,91,68,72,82,71,67,69,72)
baby <- c(77,66,70,65,90,64,74,79,66,61,68,66)
plot(mother, baby)
cow <- lm(baby~mother)
cow
abline(cow)  # draw a linear regression line on the plot
summary(cow)
anova(cow)   # make an anova table

x <- c(2,2,3,3,4,4,5,5,6,6)
y <- c(12,13,13,14,15,15,14,16,17,18)
plot(x,y)
result <- lm(y~x)
result
abline(result)
summary(result)
yhat <- predict(result, new=data.frame(x=x))  # calculate each "yhat"
yhat
cbind(x, y, yhat)

x <- c(0.19, 0.15, 0.57, 0.4, 0.7, 0.67, 0.63, 0.47, 0.75, 0.6,
       0.78, 0.81, 0.78, 0.69, 1.3, 1.05, 1.52, 1.06, 1.74, 1.62)
y <- c(3.8, 5.9, 14.1, 10.4, 14.6, 14.5, 15.1, 11.9, 15.5, 9.3,
       15.6, 20.8, 14.6, 16.6, 25.6, 20.9, 29.9, 19.6, 31.3, 32.7)
plot(x,y)
result <- lm(y~x)
summary(result)
abline(result, col="blue")

# multiple linear regression
mpg <- read.csv("D:/R_basic/MPG.csv", header=T)
mpg
mpg_fit <- lm(MPG ~ Weight + Odometer, data=mpg)
summary(mpg_fit)
anova(mpg_fit)
newx <- data.frame(Weight=10, Odometer=30)
predict.lm(mpg_fit, newx, interval="confidence")  # 신뢰구간
predict.lm(mpg_fit, newx, interval="prediction")  # 예측구간

# ex_1_method 1
turkey <- read.csv("D:/R_basic/Turkey.csv", header=T)
turkey
fit1 <- lm(Y ~ X + Origin, data=turkey)  # fit1 <- lm(Y ~ X + factor(Origin), data=turkey)
summary(fit1)
# ex_1_method 2
turkey$Vir <- ifelse(turkey$Origin=="V", 1, 0)
turkey$Wis <- ifelse(turkey$Origin=="W", 1, 0)
turkey
fit2 <- lm(Y ~ X + Vir + Wis, data=turkey)
summary(fit2)

# ex_2
mother <- c(71,67,83,64,91,68,72,82,71,67,69,72)
baby <- c(77,66,70,65,90,64,74,79,66,61,68,66)
plot(mother, baby)
cow <- lm(baby ~ mother)
abline(cow)
summary(cow)
residual <- resid(cow)  # calculate residuals

par(mfrow=c(2,2))
plot(mother, baby, main="weight")
hist(residual)
qqnorm(residual)
plot(mother, residual, main="residual")

install.packages("lmtest")
library(lmtest)
dwtest(baby ~ mother)  # Durbin-Watson variance test

# Multicollinearity and Variance inflation factor(VIF)

edu <- read.csv("D:/R_basic/achv.csv", header=T)
edu
plot(edu)
fit <- lm(ACHV ~ FAM + PEER + SCHOOL, data=edu)
summary(fit)

install.packages("car")
library(car)
vif(fit)     # If vif>=10, there is a multicollinearity

# Checking "outlier", "leverage", "influential observation"
resid(mpg_fit)
rstudent(mpg_fit)
cbind(resid(mpg_fit), rstudent(mpg_fit))
hatvalues(mpg_fit)
cooks.distance(mpg_fit)

plot(mpg_fit, which=1)  # which=1 : Residuals vs Fitted
plot(mpg_fit, which=2)  # which=2 : Normal Q-Q
plot(mpg_fit, which=3)  # which=3 : Scale-Location
plot(mpg_fit, which=4)  # which=4 : Cook's distance
plot(mpg_fit, which=5)  # which=5 : Residuals vs Leverage

# Choosing variables
null <- lm(ACHV ~ 1, edu)
full <- lm(ACHV ~ ., edu)
# Choosing variables with "forward selection"
res.forward <- step(null, scope=list(lower=null, upper=full),
                    direction="forward")
summary(res.forward)
# Choosing variables with "backward elimination"
res.backward <- step(full, scope=list(lower=null, upper=full),
                     direction="backward")
summary(res.backward)
# Choosing variables with "stepwise"
res.both <- step(null, scope=list(lower=null, upper=full),
                 direction="both")
summary(res.both)

# Logistic Regression

# ex_1
mydata <- read.csv("D:/R_basic/admit.csv", header=T)
mydata
fit <- glm(admit~gre+gpa+factor(rank), data=mydata, family="binomial")
summary(fit)
pred_y <- ifelse(fit$fit>0.5, 1, 0)
table(mydata$admit, pred_y)
mean(mydata$admit==pred_y)
new <- data.frame(gre=500, gpa=3.25, rank=1)
predict(fit, newdata=new, type="link")
pred <- predict(fit, newdata=new, type="response", se.fit=TRUE)
pred$fit
pred$se.fit
c(pred$fit-1.96*pred$se.fit, pred$fit+1.96*pred$se.fit)

# ex_2
install.packages("nnet")
library(nnet)
diabetes <- read.csv("D:/R_basic/diabetes.csv", header=T)
diabetes
fit <- multinom(CC~RW+IR+SSPG, diabetes)
summary(fit)
predict(fit, type="probs")
pred_CC <- predict(fit, type="class")
pred_CC
table(diabetes$CC, pred_CC, dnn=c("Observed","Predicted"))