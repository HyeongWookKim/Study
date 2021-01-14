# practice p.106
x <- seq(-3, 3, by=0.01)
plot(x, dnorm(x, mean=0, sd=1), col="black", ylab="pdf", main="Normal distribution")
lines(x, dnorm(x, mean=1, sd=1), col="red", ylab="pdf")
help(curve) # also can use "curve" function instead of "lines" function

# practice p.174_1
x <- c(148,150,149,144,152,150,155,147,148,151,
       150,149,150,144,147,150,153,147,152,150,
       151,149,149,153,147,152,160,165,140,141)
Mu0 <- 150
sd0 <- sd(x)
z.test(x, mu=150, sd=sd0)

# practice p.174_2
after <- c(70,62,54,82,75,64,58,57,80,63)
before <- c(68,62,50,75,76,57,60,53,74,60)
t.test(before, after, mu=0, paired=T)

# practice p.176
p.hat.placebo <- 0.4
p.hat.vitamin <- 0.2
prop.test(x=c(40,20), n=c(100,100))

# practice p.226
iris
attach(iris)
plot(Petal.Width, Petal.Length)          # plot(x, y)
result <- lm(Petal.Length ~ Petal.Width) 
result
summary(result)
abline(result)

# practice p.227
data_y <- c(87,93,91,85,86,97,90,93,88,96,86,89,94,91,95)
data_x1 <- c(9.2,9.4,9.5,8.7,8.8,9.6,9.2,9.5,8.5,9.6,9.4,8.7,9.6,9.2,9.7) 
data_x2 <- c(8.4,9.3,9.2,7.9,8.1,9.8,9.0,9.4,8.6,9.7,8.3,8.7,9.2,9.0,9.3)
data_x3 <- c(8.7,9.4,9.6,8.9,8.6,9.3,9.0,9.2,8.9,9.5,8.8,9.0,9.1,9.5,9.1)

par(mfrow=c())
plot(data_x1, data_y)
plot(data_x2, data_y)
plot(data_x3, data_y)

data_reg <- data.frame(cbind(data_y, data_x1, data_x2, data_x3))
plot(data_reg, panel=panel.smooth)  # similar with "abline()"
fit_data_reg <- lm(data_y~data_x1+data_x2+data_x3, data=data_reg)
summary(fit_data_reg)

install.packages("car")
library(car)
vif(fit_data_reg) # checking Multicollinearity

# practice p.274
yy <- c(8,8,7,9,8,7,9,8,6,8,7,6,
        6,5,7,7,6,7,6,8,7,6,8,7,
        8,8,8,5,6,7,6,7,7,6,7,8,
        9,4,6,5,4,4,5,6,7,5,8,4)
xx <- c(rep("A", 12), rep("B", 12), rep("C", 12), rep("D", 12))
orange <- data.frame(yy, xx)
anova <- aov(yy~xx, data=orange)
summary(anova)
TukeyHSD(anova)
plot(TukeyHSD(anova))