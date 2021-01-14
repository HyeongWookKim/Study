#### Big data analysis ####

### Supervised learning ###

## Ridge & Lasso regression ##

# ex_1
fire <- read.csv("D:/R_bigdata(advanced)/forestfires.csv", header=T)
fire
install.packages("glmnet")
library(glmnet)
x<- as.matrix(fire[,-9])
y <- fire[,9]

# ex_1_Ridge - rarely use this one
cv.out <- cv.glmnet(x, y, alpha=0, nfolds=10)  # alpha=0 : Ridge, nfolds="k"
opt.lam <- cv.out$lambda.min
fit <- glmnet(x, y, alpha=0, lambda=opt.lam)
fit
fit$beta

yhat <- predict(fit, s=opt.lam, newx=x)
yhat
mean((y-yhat)^2)  # Training MSE

# ex_1_Lasso - usually use this one
cv.out <- cv.glmnet(x, y, alpha=1, nfolds=10)  # alpha=1 : Lasso, nfolds="k"
opt.lam <- cv.out$lambda.min
fit <- glmnet(x, y, alpha=1, lambda=opt.lam)
fit
fit$beta

yhat <- predict(fit, s=opt.lam, newx=x)
yhat
mean((y-yhat)^2)

## KNN(K-Nearest Neighbor) ##
dat <- read.table("D:/R_bigdata(advanced)/credit.txt", header=T)
dat
help(nrow)
n <- nrow(dat)
n1 <- 500     # Training dataset
n2 <- n - n1  # Test dataset

# Training & Test data
idx <- sample(1:n, n1) # randomly choose "n1" numbers in "1~n" 
tr.x <- dat[idx,1:6]   # Training data_x 
tr.y <- dat[idx,7]     # Training data_y
te.x <- dat[-idx,1:6]  # Test data_x
te.y <- dat[-idx,7]    # Test data_y

# KNN
library(class)
k <- 3
te.yhat <- knn(tr.x, te.x, tr.y, k) # knn(train, test, cl, k = 1), cl="factor of true classification of training set"
te.error <- sum(te.y != te.yhat) / n2  # Test error(= Miss Classification Rate, MCR)
te.error

# Selection of K
TE <- NULL
for(k in 1:10)
{
  te.yhat <- knn(tr.x, te.x, tr.y, k)
  te.error <- sum(te.y != te.yhat) / n2
  TE <- c(TE, te.error)
}
TE
which.min(TE)

# Cross-validation
install.packages("cvTools")
library(cvTools)

x <- dat[,1:6]
y <- dat[,7]
K <- 5  # K-fold
k <- 3  # kNN

cvf <- cvFolds(n, K)
cvstat <- numeric(K)  # numeric(length = 5)
for(i in 1:K)
{
  index <- cvf$subsets[cvf$which == i]
  tr.x <- x[-index,]
  tr.y = y[-index]
  te.x <- x[index,]
  te.y = y[index]
  n2 <- length(te.y)
  te.yhat <- knn(tr.x, te.x, tr.y, k)
  cvstat[i] <- sum(te.y != te.yhat) / n2
}  
mean(cvstat)

## Discriminant Analysis
dat <- read.table("D:/R_bigdata(advanced)/credit.txt", header=T)
dat
n <- nrow(dat)
n1 <- 500
n2 <- n - n1

# Training & Test data
idx <- sample(1:n, n1)
tr.dat <- dat[idx,]
te.dat <- dat[-idx,]

# LDA
library(MASS)
fit.lda <- lda(Y ~ ., data=tr.dat)  # put every variables into X except for Y
pred <- predict(fit.lda, newdata=te.dat)
yhat <- pred$class      # class : shows either "+" or "-"
yhat
phat <- pred$posterior  # posterior : show each values in "+" and "-"
phat
sum(te.dat$Y != yhat)/nrow(te.dat)

# QDA
fit.qda <- qda(Y ~ ., data=tr.dat)
pred <- predict(fit.qda, newdata=te.dat)
yhat <- pred$class
yhat
phat <- pred$posterior
phat
sum(te.dat$Y != yhat)/nrow(te.dat)

## Logistic Regression ##
mydata <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
mydata
fit <- glm(admit~gre+gpa+factor(rank), data=mydata, family="binomial")  # family="binomial" : logistic regression
summary(fit)

pred_y <- ifelse(fit$fit>0.5, 1, 0)  # fit : predicted value
table(mydata$admit, pred_y, dnn=c("Observed","Predicted")) # "observations" vs "predicted values" / dnn : put list names

# an example observation of "mydata" dataset
new <- data.frame(gre=500, gpa=3.25, rank=1)
predict(fit, newdata=new, type="link")      # type="link" : calculate "predicted log odds"
pred <- predict(fit, newdata=new, type="response", se.fit=TRUE) # type="response" : probability of pass the exam
pred$fit     # shows probability of pass the exam
pred$se.fit  # se.fit : calculate the "standard error"

## Multinomial Logit regression
install.packages("nnet")
library(nnet)
diabetes <- read.csv(file("D:/R_bigdata(advanced)/diabetes.csv"), header=T)
diabetes
fit <- multinom(CC~RW+IR+SSPG, data=diabetes)
summary(fit)

predict(fit, type="probs")  # type="probs" : probability of prediction
pred_CC <- predict(fit, type="class")  # type="class" : classification
pred_CC
table(diabetes$CC, pred_CC, dnn=c("Observed","Predicted")) # "observations" vs "predicted values"