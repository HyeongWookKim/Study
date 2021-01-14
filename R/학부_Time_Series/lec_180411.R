## Review(linear regression) ##
ex01 <- data.frame(ad=c(1,3,2,1,3),
                   cs=c(14,24,18,17,27))
ex01
output <- lm(cs~ad, data=ex01)
plot(ex01)
abline(output, col="red")
summary(output)
anova(output)

## practice with data="cars" ##
head(cars)
plot(cars)
cor(cars)

out <- lm(dist~speed, data=cars)
summary(out)

par(mfrow=c(2,2))
plot(out)
par(mfrow=c(1,1))

sqrt_dist <- sqrt(cars$dist)
plot(sqrt_dist~speed, data=cars)
cor(sqrt_dist, cars$speed)

model <- lm(sqrt_dist~speed, data=cars)
summary(model)

par(mfrow=c(2,2))
plot(model)
par(mfrow=c(1,1))

shapiro.test(resid(model))
shapiro.test(cars$dist)
shapiro.test(sqrt_dist)

# without intercept
new_model <- lm(sqrt_dist~0+speed, data=cars)
# new_model <- lm(sqrt_dist~speed-1, data=cars) #
summary(new_model)