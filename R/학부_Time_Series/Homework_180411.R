### Time Series Homework(180411) ###

# EDA
Orange
View(Orange)
attach(Orange)
plot(Orange)
cor(age, circumference)

# Regression(with intercept)
output1 <- lm(circumference~age, data=Orange)
output1
plot(circumference~age, data=Orange, main="The effect of Age on Circumference")
abline(output1, col="red")
summary(output1)

# Regression(without intercept)
output2 <- lm(circumference~age-1, data=Orange)
output2
plot(circumference~age, data=Orange, main="The effect of Age on Circumference")
abline(output2, col="red")
summary(output2)

# Check the normality and homogeneity of variacne
par(mfrow=c(2,2))
plot(output2)
shapiro.test(resid(output2))