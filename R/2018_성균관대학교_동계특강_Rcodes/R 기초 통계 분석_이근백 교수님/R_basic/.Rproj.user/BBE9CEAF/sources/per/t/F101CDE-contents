# hypothesis testing
library(MASS)
head(survey)
height.response <- na.omit(survey$Height) # na.omit = delete "NA"

# z-test - one sample
install.packages("TeachingDemos")
library(TeachingDemos)
sigma <- 9.48                   # (known) population standard deviation
z.test(height.response, mu=160, sd=sigma)

# t-test - one sample_mu
t.test(height.response, mu=170)  # default : alternative = "two.sided"
t.test(height.response, mu=170, alternative="greater")  # H1 : mu > 170
t.test(height.response, mu=170, alternative="less")     # H1 : mu < 170

x <- c(0.593, 0.142, 0.329, 0.691, 0.231, 0.793, 0.519, 0.392, 0.418)
t.test(x, alternative="greater", mu=0.3)

# t-test - one sample_prop
library(MASS)
survey
gender.response <- na.omit(survey$Sex)
n <- length(gender.response)
k <- sum(gender.response=="Female")
pbar <- k/n
pbar
prop.test(k, n)

# Chi-Squared test
var.interval <- function(data, conf.level=0.9){    # make a function
  df=length(data)-1
  chilower=qchisq((1-conf.level)/2, df)
  chiupper=qchisq((1-conf.level)/2, df, lower.tail=F)
  v <- var(data)
  c(df*v/chiupper, df*v/chilower)
}
x <- c(59, 54, 53, 52, 51, 39, 49, 46, 49, 48)    # example
var.interval(x)
sqrt(var.interval(x))

# Paired t-test
pre <- c(77,56,64,60,57,53,72,62,65,66)
pos <- c(88,74,83,68,58,50,67,64,74,60)
t.test(pre, pos, paired=T, alt="less")

# Two samples t-test
x <- c(284,279,289,292,287,295,285,279,306,298)
y <- c(298,307,297,279,291,335,299,300,306,291)
t.test(x, y, alt="two.sided", var.equal=T)     # var.equal=T
t.test(x, y, alt="two.sided", var.equal=F)     # var.equal=F

Control <- c(91,87,99,77,88,91)
Treat <- c(101,110,103,93,99,104)
t.test(Control, Treat, alt="less", var.equal=T)   # var.equal=T
t.test(Control, Treat, alt="less", var.equal=F)   # var.equal=F

# F-test to compare two variances
group1 <- c(9,6,8,1,2,-2,4,-3,4,5)
group2 <- c(5,3,-1,2,6,3,-1,-3,-1,-4)
var.test(group1, group2)
t.test(group1, group2, var.equal=T)   # Because two variances are same

# Two-samples test for proportions
prop.test(x=c(560,570), n=c(1000,1200), conf.level=0.95)

# goodness of fit test(with nominal data) using Chi-Squared test
y <- c(35,40,25)
p <- c(35,35,30)
p <- p/sum(p)
n <- sum(y)
chisq.test(y, p=p)

library(UsingR)
samhda
attach(samhda)
y <- table(amt.smoke[amt.smoke < 98])
y
p <- c(.15, .05, .05, .05, .10, .20, .40)
chisq.test(y, p=p)

library(MASS)
survey
tbl <- table(survey$Smoke,survey$Exer)
tbl
chisq.test(tbl)                       # method 1
chisq.test(survey$Smoke,survey$Exer)  # method 2

# Shapiro-Wilk test for normality test
library(UsingR)
stud.recs
attach(stud.recs)
shapiro.test(sat.m)
shapiro.test(sat.v)
detach(stud.recs) # opposite of attach