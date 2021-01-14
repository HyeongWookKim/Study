### Homework_1 ###

# Install a package
install.packages("ggplot2")
library(ggplot2)

# Use "economics" data
head(economics,10)
View(economics)

eco <- economics[7:570,]
View(eco)
attach(eco)

# Time series plot_1(unemploy)
eco_ts1 <- ts(unemploy, frequency=12, start=c(1968,1))
eco_ts1
plot.ts(eco_ts1, main="Economics", xlab="Year", ylab="Unemploy")

# Time series plot_2(personal saving rate)
eco_ts2 <- ts(psavert, frequency=12, start=c(1968,1))
eco_ts2
plot.ts(eco_ts2, main="Economics", xlab="Year", ylab="Psavert")

### Homeword_2 - p.10 ###
y <- c(139,137,174,142,141,
       162,180,164,171,206,
       193,207,218,229,225,
       204,227,223,242,239)
f1 <- c(153,148,144,156,152,
        148,154,165,166,170,
        186,192,202,213,224,
        230,225,230,232,240)
f2 <- c(170,171,169,176,172,
        167,168,172,172,173,
        183,189,198,208,220,
        229,230,236,239,245)

# (1)
e <- y-f1
abse <- abs(e)
e2 <- e*e
pe <- ((y-f1)/y)*100
abspe <- abs(pe)

me <- mean(e)
me
mae <- mean(abse)
mae
mse <- mean(e2)
mse
sde <- sqrt(sum(e2)/(length(e)-1))
sde
mpe <- mean(pe)
mpe
mape <- mean(abspe)
mape

# (2)
e <- y-f2
abse <- abs(e)
e2 <- e*e
pe <- ((y-f2)/y)*100
abspe <- abs(pe)

me <- mean(e)
me
mae <- mean(abse)
mae
mse <- mean(e2)
mse
sde <- sqrt(sum(e2)/(length(e)-1))
sde
mpe <- mean(pe)
mpe
mape <- mean(abspe)
mape