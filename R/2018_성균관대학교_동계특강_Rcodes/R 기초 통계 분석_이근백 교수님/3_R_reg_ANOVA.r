#################################################################
### Correlation 
#################################################################
library(UsingR)
attach(homedata)
homedata[1:3,]
cor(y1970,y2000)
cor(y1970,y2000,method="spearman")


# generate data
x1=scan() 
6 9 8 3 10 4 5 2 11 9 10 2

x2=scan()
3 11 4 1 11 1 7 4 8 10 8 5

y=scan()
10 12 12 4 12 6 8 2 18 9 17 2

# description of data
data1=cbind(x1,x2,y)
a1=apply(data1,2,mean)
a2=apply(data1,2,sd)
a3=apply(data1,2,length)
cbind(mean=a1,sd=a2,N=a3)

# scatter plot
pairs(data1)

# correlation analysis
cor(data1)
cor.test(x1,x2)
cor.test(x1,y)
cor.test(x2,y)

library(Hmisc)
rcorr(data1,type="pearson")




#################################################################
### REGRESSION 
#################################################################

## page 196-198
mother=c(71,67,83,64,91,68,72,82,71,67,69,72)
baby=c(77,66,70,65,90,64,74,79,66,61,68,66)
plot(mother,baby)
cow=lm(baby~mother)
abline(cow)
summary(cow)
anova(cow)

# residual analysis
residual=resid(cow)
par(mfrow=c(2,2)))
plot(mother,baby,main="weight")
hist(residual)
qqnorm(residual)
plot(mother,residual,main="residual")


##page 200-202
x=c(2,2,3,3,4,4,5,5,6,6)
y=c(12,13,13,14,15,15,14,16,17,18)
plot(x,y)
result=lm(y~x)
abline(result)
result

yhat=predict(result,new=data.frame(x=x))
yhat

summary(result)

##page 209
residual2=resid(result)
par(mfrow=c(2,2))
plot(x,y,main="wheat",xlab="fertilizer",ylab="production")
hist(residual2)
qqnorm(residual2)
plot(x,residual2,main="residual",xlab="fertilizer")

#page 220-222
y=c(80.5,67.5,79.0,90.0,78.3,70.0,82.3)
x1=c(37,40,38,42,38,35,41)
x2=c(3,1,3,7,3,2,4)
xy=cbind(x1,x2,y)
pairs(xy,main="scatterplot matrix")

summary(lm(y~x1+x2))     

y_n=c(80.5,67.5,79.0,90.0,78.3,70.0,82.3)
x2_n=c(3,1,3,7,3,2,4)
summary(lm(y_n~x2_n))


#page 223-227
head(swiss)
out=lm(Fertility~Agriculture+Examination+Education+Catholic+Infant.Mortality,data=swiss)
out=lm(Fertility~.,data=swiss)
summary(out)

library(alr3)
vif(out)

out2=step(out,direction="backward")
summary(out2)
pairs(swiss,panel=panel.smooth)



#################################################################
### ANOVA
#################################################################

##page 242
weight=c(30,35,28,29,25,29,34,25,31,28,27,23,24,31,20,16,17,18,18,17,20)
feed=c(rep("A",7),rep("B",7),rep("C",7))
pig=data.frame(weight,feed)
anova(lm(weight~feed,data=pig))
result0=aov(weight~feed,data=pig)
summary(result0)


## page 244
A=c(2250,2410,2260,2200,2360,2320,2240,2300,2090)
B=c(1920,2020,1960,1960,2280,2010,2090,2140,2400)
C=c(2030,2390,2000,2060,2260,2180,2190,2250,2310)
y=c(A,B,C)
treatment=as.factor(c(rep("A",9),rep("B",9),rep("C",9)))
anova(lm(y~treatment))

result1=aov(y~treatment) # Using aov()
summary(result1)

## page 246
score=c(76,64,85,75,58,75,81,66,49,63,62,46,74,71,85,90,66,74,81,79)
employee=c(rep("A",4),rep("B",4),rep("C",4),rep("D",4),rep("E",4))
selection=data.frame(score,employee)
anova(lm(score~employee,data=selection))

## page 254-255
yy=c(24.54,23.97,22.85,24.34,24.47,24.36,23.37,24.46,
22.73,22.28,23.99,23.23,23.94,23.52,24.41,22.80,
22.02,21.97,21.34,22.83,22.90,22.28,21.14,21.85,
20.83,24.40,23.01,23.54,21.60,21.86,24.57,22.81)
xx=c(rep("w1",8),rep("w2",8),rep("w3",8),rep("w4",8))
water=data.frame(yy,xx)

bartlett.test(yy~xx) # Bartlett test for equal variance
anova(lm(yy~xx,data=water))
result2=aov(yy~xx,data=water)
summary(result2)

pairwise.t.test(yy,xx,p.adjust="none",pool.sd=TRUE) # Fisher's LSD
pairwise.t.test(yy,xx,p.adjust="bonferroni",pool.sd=FALSE) # Bonferroni
#pairwise.t.test(yy,xx,p.adjust="bonferroni",pool.sd=TRUE) # Bonferroni

TukeyHSD(aov(yy~xx,water)) # Tukey's HSD





##page 221-222
y1=c(8,8,7,9,8,7,9,8,6,8,7,6,
6,5,7,7,6,7,6,8,7,6,8,7,
8,8,8,5,6,7,6,7,7,6,7,8,
9,4,6,5,4,4,5,6,7,5,8,4)
x1=c(rep("A",12),rep("B",12),rep("C",12),rep("D",12))
orange=data.frame(y1,x1)
anova(lm(y1~x1,data=orange))
result3=aov(y1~x1,data=orange)
summary(result3)
TukeyHSD(aov(y1~x1,orange))


####################################################
#     ANOVA
####################################################

# page 263
sales=c(30,24,16,34,10,26,18,26,34,44,24,42)
type=c("A1","A2","A3")
fir=c("B1","B2","B3","B4")
km=data.frame(sales,type,fir)
anova(lm(sales~type+fir,data=km))
result4=aov(sales~type+fir,data=km)

# page 270-275
salt=c(rep(1,4),rep(2,4),rep(3,4))
salt=rep(salt,2)
day=c(rep(4,12),rep(8,12))
hardness=c(5,6,8,7,4,5,5,5,7,4,4,6,2,2,6,2,4,5,3,4,3,4,7,5)
daikon=data.frame(salt,day,hardness)
fit=anova(lm(hardness~factor(salt)+factor(day),data=daikon))
fit
fit1=anova(lm(hardness~factor(salt)+factor(day)+factor(salt)*factor(day),data=daikon))
fit1

fit=aov(hardness~factor(salt)+factor(day),data=daikon)
summary(fit)
fit1=aov(hardness~factor(salt)+factor(day)+factor(salt)*factor(day),data=daikon)
summary(fit1)


# page 266
salt=c(rep(1,4),rep(2,4),rep(3,4))
salt=rep(salt,2)
day=c(rep(4,12),rep(8,12))
hardness=c(5,6,8,7,4,5,5,5,7,4,4,6,2,2,6,2,4,5,3,4,3,4,7,5)
interaction=c(rep(1,4),rep(2,4),rep(3,4),rep(4,4),rep(5,4),rep(6,4))
daikon=data.frame(salt,day,hardness,interaction)
fit=anova(lm(hardness~factor(salt)+factor(day)+factor(interaction),data=daikon))
fit

fit1=aov(hardness~factor(salt)+factor(day)+factor(interaction),data=daikon)
fit1
