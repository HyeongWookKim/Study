## page 113
library(MASS)
head(survey)

height.response = na.omit(survey$Height) 

## page 115
sigma=9.48             #(known) population standard deviation
library(TeachingDemos) # before this, you should install the package 'TeachingDemos' first
z.test(height.response, mu=160,sd=sigma)

## page 121
t.test(height.response, mu=170)

##page 123
n=length(height.response)
sigma=9.48               #(known) population standard deviation
sem=sigma/sqrt(n);sem        #standard error of the mean
E=qnorm(.975)*sem;E      #margin of error
xbar=mean(height.response)  #sample mean
xbar+c(-E,E)

#page 125
n=length(height.response)
s=sd(height.response)     #sample standard deviation
SE=s/sqrt(n);sem        #standard error estimate
E=qt(.975,df=n-1)*SE;E      #margin of error
xbar=mean(height.response)  #sample mean
xbar+c(-E,E)

## page 127
library(MASS)
gender.response=na.omit(survey$Sex)
n=length(gender.response)
k=sum(gender.response=="Female")
pbar=k/n;pbar

#page 132
prop.test(k,n)

##page 135
gender.response=na.omit(survey$Sex)
n=length(gender.response)
k=sum(gender.response=="Female")
pbar=k/n;pbar
SE=sqrt(pbar*(1-pbar)/n);SE
E=qnorm(.975)*SE;E
pbar+c(-E,E)

## page 141
var.interval=function(data,conf.level=0.9){
df=length(data)-1
chilower=qchisq((1-conf.level)/2,df)
chiupper=qchisq((1-conf.level)/2,df,lower.tail=FALSE)
v=var(data)
c(df*v/chiupper,df*v/chilower)
}
x=c(59, 54, 53, 52, 51, 39, 49, 46, 49, 48)
var.interval(x)
sqrt(var.interval(x))

##page 144
pre=c(77,56,64,60,57,53,72,62,65,66)
pos=c(88,74,83,68,58,50,67,64,74,60)
t.test(pre,pos,paired=T,alt="less")

##page 147
x=c(284,279,289,292,287,295,285,279,306,298)
y=c(298,307,297,279,291,335,299,300,306,291)
t.test(x,y,var.equal=T,alt="two.sided")

## page 150
prop.test(x=c(560,570),n=c(1000,1200),conf.level=0.95)

#page 152
group1=c(9,6,8,1,2,-2,4,-3,4,5)
group2=c(5,3,-1,2,6,3,-1,-3,-1,-4)
var.test(group1,group2)

#page 161
y=c(35,40,25)
p=c(35,35,30)
p=p/sum(p)
n=sum(y)
chi2=sum(((y-n*p)^2)/(n*p))
chi2
pchisq(chi2,df=3-1,lower.tail=F)
chisq.test(y,p=p)

# page 162
library(UsingR)
attach(samhda)
y=table(amt.smoke[amt.smoke<98])
y
p=c(.15,.05,.05,.05,.10,.20,.40)
chisq.test(y,p=p)

# page 164
library(MASS) # load the MASS package
tbl=table(survey$Smoke,survey$Exer)
tbl           # contingency table
chisq.test(tbl)

# attach(stud.recs)
library(UsingR)
attach(stud.recs)
shapiro.test(sat.m)
shapiro.test(sat.v)
detach(stud.recs)

