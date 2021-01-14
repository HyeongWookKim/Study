# lec3_3.r
# Data handling
# Data analysis with autompg.txt

# set working directory
# change working directory 
setwd("D:/tempstore/moocr")

# 2.Read txt file with variable name
# http://archive.ics.uci.edu/ml/datasets/Auto+MPG

# 1. Data reading in R
car<-read.table(file="autompg.txt", na=" ", header=TRUE)

#car<-read.csv(file="autompg.csv")

head(car)
dim(car)

# 2. Data checking : numeric factor integer variables
str(car)

# 3. Data summary
summary(car)

# 4. basic statistics & graph
attach(car)

# frequency
table(origin)
table(year)

# mean and standard deviation
mean(mpg)
mean(hp)
mean(wt)

# mean of some variables
apply (car[, 1:6], 2, mean)

# barplot using frequency
freq_cyl<-table(cyl)
names(freq_cyl) <- c ("3cyl", "4cyl", "5cyl", "6cyl",
                        "8cyl")
barplot(freq_cyl)
barplot(freq_cyl, main="Cylinders Distribution")

# histogram of MPG
hist(mpg, main="Mile per gallon:1970-1982", 
     col="lightblue")

# scatterplot3d
# install.packages("scatterplot3d")
library(scatterplot3d)

scatterplot3d(wt,hp,mpg, type="h", highlight.3d=TRUE,
               angle=55, scale.y=0.7, pch=16, main="3dimensional plot for autompg data")

# apply a function over a list
lapply (car[, 1:6], mean)

a1<-lapply (car[, 1:6], mean)
a2<-lapply (car[, 1:6], sd)
a3<-lapply (car[, 1:6], min)
a4<-lapply (car[, 1:6], max)
table1<-cbind(a1,a2,a3,a4)
colnames(table1) <- c("mean", "sd", "min", "max")
table1

#################################



