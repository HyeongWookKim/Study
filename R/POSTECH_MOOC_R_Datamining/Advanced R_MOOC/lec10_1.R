# lec10_12_knn.R

# lec10_1_knn.R
# Classification
# k-Nearest Neighbor

# packages
install.packages("class") # no weighted value knn
install.packages("gtools")
install.packages("gmodels") # crosstable
install.packages("scales") # for graph
library(class)
library(gtools)
library(gmodels)
library(scales)

# read csv file
iris <- read.csv("iris.csv")
# head(iris)
# str(iris)
attach(iris)

# training/ test data : n=150
set.seed(1000)
N <- nrow(iris)
tr.idx <- sample(1:N, size=N*2/3, replace=FALSE)

# attributes in training and test
iris.train <- iris[tr.idx,-5]
iris.test <- iris[-tr.idx,-5]
# target value in training and test
trainLabels <- iris[tr.idx,5]
testLabels <- iris[-tr.idx,5]

train <- iris[tr.idx,]
test <- iris[-tr.idx,]

# knn (5-nearest neighbor)
md1 <- knn(train=iris.train, test=iris.test, cl=trainLabels, k=5)
md1
help(knn)
# accuracy of 5-nearest neighbor classification
CrossTable(x=testLabels, y=md1, prop.chisq=FALSE)
help(CrossTable)