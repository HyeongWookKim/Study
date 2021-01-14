# lec12_3_rf.R
# Random Forest using R

# random forest package
install.packages("randomForest")
library(randomForest)
help(randomForest)

# load caret package for confusion matrix
library(caret)

# set working directory
setwd("D:/tempstore/moocr/wk12")

# read csv file
iris<-read.csv("iris.csv")
attach(iris)

# training/ test data : n = 150
set.seed(1000)
N<-nrow(iris)
tr.idx<-sample(1:N, size=N*2/3, replace=FALSE)

# split training and test data
train<-iris[tr.idx,]
test<-iris[-tr.idx,]
#dim(train)
#dim(test)

#Random Forest
rf_out<-randomForest(Species~.,data=train,importance=T)
rf_out

# important variables for RF
round(importance(rf_out), 2)


#predict(rf_out,newdata=test)

#print(rf_out)

#round(importance(rf_out), 2)

randomForest::importance(randommod)
varImpPlot(randommod)

#measuring accuracy(rf)
randompred<-predict(randommod,test)
confusionMatrix(randompred,test$Species)