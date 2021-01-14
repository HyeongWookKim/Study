setwd('e:/course/통계학회특강/회귀분석/R-codes')

################################################
#              상관분석                        #
################################################
x=c(0.19, 0.15, 0.57, 0.4, 0.7, 0.67, 0.63, 0.47, 0.75, 0.6,
     0.78, 0.81, 0.78, 0.69, 1.3, 1.05, 1.52, 1.06, 1.74, 1.62)
y=c(3.8, 5.9, 14.1, 10.4, 14.6, 14.5, 15.1, 11.9, 15.5, 9.3,
     15.6, 20.8, 14.6, 16.6, 25.6, 20.9, 29.9, 19.6, 31.3, 32.7)
cov(x,y)
cor.test(x,y)

x1=c(1:100)
y1=2+2*x1
y2=2+100*x1
cor(x1,y1) # correlation=1
cor(x1,y2) # correlation=1

error=rnorm(100)
y3=2+2*x1+error
y4=2+100*x1+error
cor(x1,y3) # correlation=0.99
cor(x1,y4) # correlation=0.99


################################################
#              회귀분석                        #
################################################

# 강물염도
x<-c(0.19, 0.15, 0.57, 0.4, 0.7, 0.67, 0.63, 0.47, 0.75, 0.6,
     0.78, 0.81, 0.78, 0.69, 1.3, 1.05, 1.52, 1.06, 1.74, 1.62)
y<-c(3.8, 5.9, 14.1, 10.4, 14.6, 14.5, 15.1, 11.9, 15.5, 9.3,
     15.6, 20.8, 14.6, 16.6, 25.6, 20.9, 29.9, 19.6, 31.3, 32.7)
plot(x,y) 
lm(y~x) 
abline(lm(y~x),col="blue")


#연비
mpg=read.csv(file("./데이터파일/MPG.csv"),header=T) 
mpg_fit=lm(MPG~Weight+Odometer,mpg) 
summary(mpg_fit)
newx=data.frame(Weight=10,Odometer=30)
predict.lm(mpg_fit,newx,interval="confidence")
predict.lm(mpg_fit,newx,interval="predict")


# 칠면조
turkey=read.csv(file("./데이터파일/Turkey.csv"),header=T)
fit1=lm(Y~X+Origin,turkey)
summary(fit1)
turkey$Vir=ifelse(turkey$Origin=="V",1,0)
turkey$Wis=ifelse(turkey$Origin=="W",1,0)
fit2=lm(Y~X+Vir+Wis,turkey)
summary(fit2)


# 어미소와 새끼소 몸무게
mother=c(71,67,83,64,91,68,72,82,71,67,69,72)
baby=c(77,66,70,65,90,64,74,79,66,61,68,66)
plot(mother,baby)
cow=lm(baby~mother)
abline(cow)
summary(cow)
residual=resid(cow)
par(mfrow=c(2,2))
plot(mother,baby,main="weight")
hist(residual)
qqnorm(residual)
plot(mother,residual, main="residual")

# Durbin-Watson test
library(lmtest)
dwtest(baby~mother)


# 학습성취도지수
edu=read.csv(file("./데이터파일/achv.csv"),header=T)
fit=lm(ACHV~FAM+PEER+SCHOOL,edu)
summary(fit)
plot(edu)

install.packages("car")
library("car")
vif(fit)


# 연비: 회귀진단
mpg=read.csv(file("./데이터파일/MPG.csv"),header=T) 
mpg_fit=lm(MPG~Weight+Odometer,mpg) 
rstudent(mpg_fit)
hatvalues(mpg_fit)
cooks.distance(mpg_fit)
plot(mpg_fit, which=5)


# 변수선택
edu=read.csv(file("./데이터파일/achv.csv"),header=T)
null=lm(ACHV~1,edu) # null model
full=lm(ACHV~.,edu) # full model

res.forward=step(null,scope=list(lower=null,upper=full),
                 direction="forward")
summary(res.forward)
res.backward=step(full,scope=list(lower=null,upper=full),
                  direction="backward")
summary(res.backward)
res.both=step(null,scope=list(lower=null,upper=full),
                  direction="both")
summary(res.both)


################################################
#              로짓회귀                        #
################################################

# Admission
mydata=read.csv("./데이터파일/admit.csv")
fit=glm(admit~gre+gpa+factor(rank),data=mydata,family="binomial")
summary(fit)
pred_y=ifelse(fit$fit>0.5,1,0)
table(mydata$admit,pred_y)
mean(mydata$admit==pred_y)
new=data.frame(gre=500,gpa=3.25,rank=1)
predict(fit,newdata=new,type="link")
pred=predict(fit,newdata=new,type="response",se.fit=TRUE)
pred$fit
pred$se.fit
c(pred$fit-1.96*pred$se.fit,pred$fit+1.96*pred$se.fit)

# 당뇨병
install.packages("nnet")
library("nnet")
diabetes=read.csv(file("./데이터파일/diabetes.csv"),header=T)
fit=multinom(CC~RW+IR+SSPG,diabetes)
summary(fit)
predict(fit,type="probs")
pred_CC=predict(fit,type="class")
pred_CC
table(diabetes$CC,pred_CC,dnn=c("Observed","Predicted"))



