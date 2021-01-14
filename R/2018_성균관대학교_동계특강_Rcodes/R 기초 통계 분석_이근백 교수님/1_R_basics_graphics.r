### I. R Basics############################

# page 18
a=c(1:10)
a

mat3=matrix(a);mat3
mat4=matrix(a,nrow=5);mat4
mat5=matrix(a,ncol=5);mat5
mat6=matrix(a,ncol=5,byrow=T);mat6

dim(a)=c(2,5);a

mat4
mat5
mat6

mat4%*%mat5
mat4*mat5
mat5*mat6


#page 21
getwd()
a=c(1:10)
getwd()
write(a,"a.txt")

setwd("c:/Users/erlee/Desktop/")
getwd()
write(a,"a.txt")

#page 23
setwd("c:/Users/erlee/Desktop/특강_R기초/R_lab")
read.table("test.txt")

read.table("c:/Users/erlee/Desktop/특강_R기초/R_lab/test.txt")

read.table("test.txt",header=T)
read.table("test.txt",header=F)

#page 26
a=rnorm(20,0,2)
a
length(a)
write(a,"a.txt",ncol=2)


# page 27
setwd('e:/course/응통소-특강/R특강/2018년겨울/이근백')
# read/write data
data=read.table("MPG.txt",header=T)
data=read.csv("MPG.csv",header=T)
write.table(data,file="new_data.txt")
write.csv(data,file="new_data.csv")


# page 29
# list
grade=list(midterm=35,final=86,
           homework=c(18,20,17,19,12))
grade$midterm
grade$final
grade$homework
total=0.3*grade$midterm+0.4*grade$final+0.3*sum(grade$homework)
total


#page 32
2+3
2^3
1/2
(3-2)*(1+4)

x=1:5;x
x[x>=3]
x[x>=3]=20;x
0<x<1
0<x &x<1


#page 34-35
sqrt(2)
sin(pi)
exp(1)
log(10,base=10)
log(10,base=2)         # 2^log(10,base=2)
log(10)       # exp(log(10))
abs(-3)
factorial(5)
choose(5,2)

a=c(-2.456,3.6789,5.23445676);a
ceiling(a)
floor(a)
trunc(a)
round(a)

aa=round(a,digits=2)
aa

#page 36
k_score=c(96,80,76,96,88,75,78,89,92,70)
k_score
sum(k_score)
mean(k_score)
min(k_score)
range(k_score)
var(k_score)
sd(k_score)
median(k_score)
length(k_score)


#page 40-42
is.double(2.2)
is.integer(2.2)
is.integer(1)
is.integer(as.integer(2.2))

mode(3)
mode(pi)
mode(1+2i)
mode("A")
mode(TRUE)
is.numeric(1/3)
as.character(1/3)
a="A"
as.numeric("A")

b=as.character(2)
b-5
c="11"
c-5
as.numeric(c)-5


#page 45-46
1:5.5
1:5
-5:5
c(1,3,5,8)
c("a","b","c")

seq(1,9,length=12)
a=c(1:10)
seq(1,5,along.with=a)


#page 47
rep(1:3,times=2)
rep(c(1,2,3),times=2,each=3)
rep(c(1,2,3),times=2,each=3,length.out=10)
rep(c(1,2,3),times=2,each=3,length.out=3)

#page 48
paste("A",1:5,sep="")
paste("Today is", date())

#page 49
vec1=c(1:3);vec1
vec2=c(3,6,9);vec2
vec3=c(4,8,2);vec3
mat1=rbind(vec1,vec2,vec3)
mat2=cbind(vec1,vec2,vec3)
mat1
mat2

#page51-52
a=c(1:10)
a
mat3=matrix(a);mat3
mat4=matrix(a,nrow=5);mat4

mat5=matrix(a,ncol=5);mat5
mat6=matrix(a,ncol=5, byrow=T);mat6
a
dim(a)=c(2,5);a
as.vector(mat5)
as.vector(mat6)

#page 54
mat4
mat5
mat6
mat4%*%mat5
mat4*mat5
mat5*mat6

#page 55
m=rep(1:3,times=2);m
mm=diag(m)
mm
det(mm)

#page 57
exam=c(90,80,70,80,90, 50,70,60,40,10,80,50,60,70,40,90)
table(exam)
table(exam,exclude=70)
summary(exam)
quantile(exam)
quantile(exam, c(0.15,0.44))

#page 58
data1=seq(1,15,by=3)
data1
data1[3]
data1[c(1,4)]
data1[-c(1,2)]
data1[data1>5]
data1[3]=10
data1
data1=c(data1,9)
data1

#page 59-61
x=c(1,1,3:1,1:4,9)
y=c(9,9:1)
z=c(2,1:9)
rbind(x,y,z)
ii=order(x,y,z)
ii
rbind(x,y,z)[,ii]

rbind(x,y,z)[,order(x,-y,z)]
x=c(5:1,6:8,12:9);x
y=(x-5)^2;y
o=order(x);o
rbind(x[o],y[o])

a=c(4,3,2,NA,1)
b=c(4,NA,2,7,1)
z=cbind(a,b);z
o=order(a,b);z[o,]
o=order(a,b,na.last=TRUE);z[o,]
o=order(a,b,na.last=FALSE);z[o,]
o=order(a,b,na.last=NA);z[o,]

#page 62-63
x1=c(3,1,4,15,92);x1
r1=rank(x1);r1
x2=c(3,1,4,1,5,9,2,6,5,3,5);x2
names(x2)=letters[1:11];x2
r2=rank(x2);r2

x2=c(3,1,4,1,5,9,2,6,5,3,5);x2
rank(x2,ties.method="first") #first occurance wins
rank(x2,ties.method="max")
rank(x2,ties.method="min")
rank(x2,ties.method="average")
rank(x2,ties.method="random")    

#pag 64
x1=seq(1,10,length=8);x1
x2=round(x1,digits=3);x2
x3=rep(15:3,length.out=8);x3
x4=rbind(x2,x3);x4
sort(x4)
x5=rbind(sort(x2),sort(x3));x5

#page 65
# apply
mat.l<-matrix(c(1:12),ncol=4)
mat.l
apply(mat.l,1,sum)
apply(mat.l,2,sum)
apply(mat.l,1,min)
apply(mat.l,2,max)
apply(mat.l,2,prod)
apply(mat.l,2,mean)
apply(mat.l,1,quantile)

# lapply
lst <-list(x=c(1:10),y=c(T,F,T,T,F),z=c(3,5,7,11,13,17))
lst
lapply(lst,mean)
lapply(lst,quantile,probs=1:3/4)

# sapply
sapply(lst,mean)
sapply(lst,mean,simplify=F)
sapply(lst,quantile,prob=1:3/4)
sapply(lst,quantile,prob=1:3/4,simplify=F)

# tapply
head(warpbreaks)
dim(warpbreaks)
levels(warpbreaks$wool)
levels(warpbreaks$tension)
tapply(warpbreaks$breaks,warpbreaks[,-1],sum)
tapply(warpbreaks$breaks,warpbreaks[,3,drop=F],max)

 

#page 70-71
x=runif(1)-0.5;x
if(x<0) print(abs(x))
if(!(x>=0)) print(abs(x)) else print(x)
ifelse(x<0,abs(x),x)

x=rnorm(1);x
if(x>0){y=x;ylog=log(y);yr=sqrt(y);print(c(y,ylog,yr))
} else {y=-x;ylog=log(y);yr=sqrt(y);print(c(y,ylog,yr))}

x=runif(1)+0.5;x
if(x>=-0.5 && x<=0.5){
if (x< 0) {print(x);print("x is negative");print(abs(x))
} else {print(x);print("x is positive")}
} else {print(x);print("x is wrong number")}


# page 73
# for(), while(), repeat()
for(i in 1:4) print(i)

start=100; end=200
isum=0
for(i in start:end){
 isum=isum+i
}
print(isum)

transport=c("bus","subway", "car", "bike")
for(vehicle in transport){
 print(vehicle)
}

# while()
n=0
sum.sofar=0
while(sum.sofar<=100){
 n=n+1
 sum.sofar=sum.sofar+n
}
print(c(n,sum.sofar))

# repeat()
n=0
sum.sofar=0
repeat{
 n=n+1
 sum.sofar=sum.sofar+n
 if(sum.sofar>100) break
}
print(c(n,sum.sofar))


#page 66
f=function(x){
(-x^2)+5
}
f(0)
f(1)
f(2)


###########################################################
#     Graphics
###########################################################

#page 84-86
x=c(38, 52, 24, 8, 3)
names(x)=c("Excellent", "Very good", "Good", "Fail", "Poor")
x
x11()
barplot(x)

y=c(1,2,3,3,4,3,4,1,1,3,3,3,2,4,4,3,4,3,1,3,1,2,3,3,4,4,3,2,3,4)
barplot(y);x11()
barplot(table(y), xlab="Beverage", ylab="Frequency");x11()
barplot(table(y)/length(y), xlab="Beverage", ylab="Proportion")

sales=c(45,44,46)
names(sales)=c("Park","Kim","Lee")
barplot(sales,main="Sales",ylab="Thousands");x11()
barplot(sales,main="Sales",ylab="Thousands",ylim=c(42,46),xpd=F)

#page 87-88
sales=c(45,44,46)
names(sales)=c("Park","Kim","Lee")
pie(sales, main="Sales",col=gray(c(.7,.8,.95)))

I90=c(299,71,577,207,412,276,
188,103,157,243,47,383,161)
names(I90)=c("WA","ID","MO","WY",
"S.D","MI","WI","II","IN","OH","PE","N.Y","MA") 
dotchart(I90)

#page 89-90
attach(faithful) #detach
hist(waiting)

hist(waiting, breaks=10)
hist(waiting, breaks=seq(43, 108, by=10))
hist(waiting, prob=T)


#page 91-92
density(iris$Sepal.Width)

par(mfrow=c(1,2))
hist(iris$Sepal.Width)
plot(density(iris$Sepal.Width))

qqnorm(rnorm(40,100,15))


#page 93-94
library(UsingR)
attach(alltime.movies)
boxplot(Gross, horizontal=TRUE)
X11()
boxplot(Gross)

acc=c(28.8,25.3,26.2,27.9,27,26.2,28.1,24.7,25.2,29.2,29.7,29.3)
fin=c(26.3,23.6,25,23,27.9,24.5,29,27.4,23.5,26.9,26.2,24)
boxplot(acc,fin,names=c("Accounting","Finance"))

#page 95
library(MASS)
attach(Rubber)
plot(tens, loss,xlab="Tensile strength",ylab="Abrasion loss")

#page 97-99
iris=data.frame(iris)
attach(iris)
plot(iris$Petal.Length,iris$Petal.Width)
x11()
plot(iris$Petal.Length,iris$Petal.Width,col=as.integer(Species))

plot(iris$Petal.Length,iris$Petal.Width,pch=as.integer(Species))
legend(1.5,2.4,c("setosa","versicolor","viginica"),pch=1:3)

#page 100-101
x=seq(-5,5,by=0.01)
df=1
plot(x,dnorm(x,0,1),col="red",ylab="Density")
par(new=T)
plot(x,dt(x,df),col="blue",ylab="Density")


x=c(2,5,8,5,7,10,11,3,4,7,12,15)
y=c(1,2,3,4,5,6,7,8,9,10,11,12)
par(mfrow=c(2,3))
plot(x,y,type="p")
plot(x,y,type="l")
plot(x,y,type="b")
plot(x,y,type="c")
plot(x,y,type="o")
plot(x,y,type="s")


X11()
par(bg="orange")
plot(x,y,type="p")


#page 102
 attach(iris)
 plot(density(Sepal.Length[Species=="setosa"]),
 xlim=c(4,8.5),axes=F,xlab="",ylab="Density", main="Sepal length")
 axis(1,pos=0)
 axis(2,pos=4)
 lines(density(Sepal.Length[Species=="versicolor"]),lty=2)
 lines(density(Sepal.Length[Species=="virginica"]),lty=3)
 legend(locator(1),c("setosa","versicolor","virginica"),lty=1:3)
 
#page 104
 x11()
 plot(iris[,1:4])

#page 95
library(lattice)
data(quakes)
str(quakes)
attach(quakes)
xyplot(lat~long,main="Earthquakes in Fiji")


# codes for 3D graphs
library(rgl) #Before it, you should install the package "rgl" from the CRAN mirror
head(quakes)
plot3d(lat,long,quakes$depth)
plot3d(lat,long,depth,aspect=c(1,2,1))

library(MASS);data(geyser);attach(geyser)
hist(duration,freq=F,xlim=c(0,6));lines(density(duration),lty=2)
x11()
hist(waiting,freq=F);lines(density(waiting),lty=2)

density1=kde2d(waiting,duration,n=25)
density2=kde2d(waiting,duration,n=100)
density3=kde2d(waiting,duration,n=400)
image(density1,xlab="waiting",ylab="duration")
x11()
image(density2,xlab="waiting",ylab="duration")

par(mfrow=c(1,3))
persp(density1,phi=30,theta=30,xlab="waiting",ylab="duration",zlab="density")
persp(density1,phi=30,theta=45,xlab="waiting",ylab="duration",zlab="density")
persp(density1,phi=30,theta=60,xlab="waiting",ylab="duration",zlab="density")

density1=kde2d(waiting,duration,n=25)
open3d()
bg3d("white")
material3d(col="blue")
persp3d(density1$x,density1$y,density1$z,col="lightblue")

x=10*(1:87)
y=10*(1:61)
contour(x,y,volcano,main="Maunga Whau")
X11()
image(x,y,volcano,main="Maunga Whau")

filled.contour(x,y,volcano,main="Maunga Whau")
persp3d(x,y,volcano,col="lightgreen",main="Maunga Whau")









