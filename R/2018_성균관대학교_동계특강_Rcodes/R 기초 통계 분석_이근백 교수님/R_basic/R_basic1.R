# R graphics

# barplot
y <- c(1,2,3,3,4,3,4,1,1,3,3,3,2,4,4,3,4,3,1,3,1,2,3,3,4,4,3,2,3,4)
barplot(y)
barplot(table(y), xlab="Beverage", ylab="Frequency")
barplot(table(y)/length(y), xlab="Beverage", ylab="Proportion")

sales <- c(45,44,46)
names(sales) <- c("Park","Kim","Lee")
barplot(sales,main="Sales",ylab="Thousands")
barplot(sales,main="Sales",ylab="Thousands",ylim=c(42,46),xpd=F)

# piechart
sales <- c(45,44,46)
names(sales) <- c("Park","Kim","Lee")
pie(sales, main="Sales",col=gray(c(.7,.8,.95)))

# dotchart
I90 <- c(299,71,577,207,412,276,
         188,103,157,243,47,383,161)
names(I90) <- c("WA","ID","MO","WY",
                "S.D","MI","WI","II","IN","OH","PE","N.Y","MA") 
dotchart(I90)

# histogram
attach(faithful) # if you use "attach()", you don't have to write down "faithful$"
faithful
hist(faithful$waiting)
hist(waiting, breaks=10) # break = number of plot
hist(waiting, breaks=seq(43, 108, by=10))
hist(waiting, prob=T, main="Histogram") # prob = change "height" into "relative frequency"

# density()
attach(iris) # if you use "attach()", you don't have to write down "iris$"
iris
density(iris$Sepal.Width)
par(mfrow=c(1,2)) # similar with "matrix(1x2)" in showing
plot(density(Sepal.Width))
hist(Sepal.Width)

# Q-Q plot
par(mfrow=c(1,1))
qqnorm(rnorm(40,100,15)) # 40 random numbers in N(100,15^2)

# boxplot
install.packages("UsingR")
library(UsingR)
alltime.movies
attach(alltime.movies)
boxplot(Gross, horizontal=T)
boxplot(Gross)

# side-by-side boxplots
acc <- c(28.8,25.3,26.2,27.9,27,26.2,
         28.1,24.7,25.2,29.2,29.7,29.3)
fin <- c(26.3,23.6,25,23,27.9,24.5,29,
         27.4,23.5,26.9,26.2,24)
boxplot(acc, fin, names=c("Accounting","Finance"))

# scatterplot
library(MASS)
Rubber
attach(Rubber)
plot(tens, loss, main="Scatter Plot", xlab="Tensile strength", ylab="Abrasion loss")

iris <- data.frame(iris)
attach(iris)
par(mfrow=c(1,2))
plot(iris$Petal.Length, iris$Petal.Width)
plot(iris$Petal.Length, iris$Petal.Width, col=as.integer(Species)) # col=color
plot(iris$Sepal.Length, iris$Petal.Width, pch=as.integer(Species)) # pch=Marking
legend(1.5, 2.4, c("setosa", "versicolor", "viginica"), pch=1:3)   # legend=add introductory remarks

# Overlapping Graphs
x <- seq(-5, 5, by=0.01)
df <- 1 # df=degree of freedom
plot(x, dnorm(x,0,1), col="red", ylab="Density") # dnorm=normal distribution
par(new=T) # overlap, but recommend to use "lines" or "curve" instead of "par"
plot(x, dt(x,df), col="blue", ylab="Density")       # dt=t-distribution, df=degree of freedom

attach(iris)
plot(density(Sepal.Length[Species=="setosa"]),
     xlim=c(4, 8.5), axes=F, xlab="", ylab="Density",
     main="Sepal length")
axis(1, pos=0) # axis(1,)=x
axis(2, pos=4) # axis(2,)=y
lines(density(Sepal.Length[Species=="versicolor"]), lty=2)
lines(density(Sepal.Length[Species=="virginica"]), lty=3)
legend(locator(1), c("setosa", "versicolor", "virginica"), lty=4) 

# types of plots
x <- c(2,5,8,5,7,10,11,3,4,7,12,15)
y <- c(1,2,3,4,5,6,7,8,9,10,11,12)
par(mfrow=c(2,3))
plot(x, y, type="p")
plot(x, y, type="l")
plot(x, y, type="b")
plot(x, y, type="c")
plot(x, y, type="o")
plot(x, y, type="s")

# Change backgroud color
par(bg="white")
par(mfrow=c(1,2))
plot(x, y, type="p")

# matrix of scatter plots
plot(iris[,1:4])