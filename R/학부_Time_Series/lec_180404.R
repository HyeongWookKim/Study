### Correlation analysis ###

# plot
plot(dist~speed, data=cars)
# covariance
cov(cars)
# correlation
cor(cars)
# correlation test
cor.test(cars$speed, cars$dist)
# change(sqrt) data
sq <- sqrt(cars$dist)
plot(sq~speed, data=cars)
cor(sq, cars$speed, method="pearson")
cor(sq, cars$speed, method="spearman")

# practice1_advertisement
ad <- read.csv("F:/시계열 분석/Data(시계열)/광고액자료.csv", header=T)
ad

plot(y~x, data=ad)
cor(ad$y, ad$x, method="pearson")
cor.test(ad$y, ad$x, method="pearson")

### Regression ###
ex01 <- data.frame(abc=c(1,3,2,1,3),
                   csn=c(14,24,18,17,27))
ex01
plot(ex01)
out <- lm(csn~abc, data=ex01)
summary(out)
plot(csn~abc, data=ex01, main="Vehicle Sales by Number of Advertisements", 
     xlab="Number of ads", ylab="Sales of cars")
abline(out, col="blue")