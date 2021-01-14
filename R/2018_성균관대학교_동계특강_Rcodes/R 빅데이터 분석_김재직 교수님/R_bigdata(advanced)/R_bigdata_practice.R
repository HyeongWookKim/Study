## Q1 -  Ridge & Lasso regression ##
library(MASS)
Boston
install.packages("glmnet")
library(glmnet)
x <- as.matrix(Boston[,1:13])
y <- Boston[,14]

# Ridge regression
cv.out1 <- cv.glmnet(x, y, alpha=0, nfolds=10)
opt.lam1 <- cv.out1$lambda.min
fit <- glmnet(x, y, alpha=0, lambda=opt.lam1)
fit
fit$beta

yhat <- predict(fit, s=opt.lam1, newx=x)
yhat

# Lasso regression
cv.out2 <- cv.glmnet(x, y, alpha=1, nfolds=10)
opt.lam2 <- cv.out2$lambda.min
fit <- glmnet(x, y, alpha=1, lambda=opt.lam2)
fit
fit$beta

## Q2 - LDA & QDA, Logistic Regression ##
bankruptcy <- read.csv("D:/R_bigdata(advanced)/bankruptcy.csv", header=T)
bankruptcy
n <- nrow(bankruptcy)
n1 <- 40
n2 <- n - n1

idx <- sample(1:n, n1)
tr.bank <- bankruptcy[idx,]
te.bank <- bankruptcy[-idx,]

# LDA
library(MASS)
fit.lda <- lda(Y ~ ., data=bankruptcy)
pred <- predict(fit.lda, newdata=te.bank)
yhat <- pred$class
yhat
phat <- pred$posterior
phat
sum(te.bank$Y != yhat)/nrow(te.bank)

# QDA
library(MASS)
fit.qda <- qda(Y ~ ., data=bankruptcy)
pred <- predict(fit.qda, newdata=te.bank)
pred
yhat <- pred$class
yhat
phat <- pred$posterior
phat
sum(te.bank$Y != yhat)/nrow(te.bank)

# Logistic Regression
fit <- glm(Y~X1+X2+X3, data=bankruptcy, family="binomial")
summary(fit)

pred_y <- ifelse(fit$fit>0.5, 1, 0)
table(bankruptcy$Y, pred_y, dnn=c("Observed", "Predicted"))

## Q2_2 ##

# LDA
new <- data.frame(X1=40, X2=6, X3=1.8)
pred1 <- predict(fit.lda, newdata=new)
pred1

# QDA
new <- data.frame(X1=40, X2=6, X3=1.8)
pred2 <- predict(fit.qda, newdata=new)
pred2

# Logistic Regression
new <- data.frame(X1=40, X2=6, X3=1.8)
predict(fit, newdata=new, type="link") 
pred3 <- predict(fit, newdata=new, type="response", se.fit=TRUE)
pred3$fit
pred3$se.fit

## Q3_1 ??? ##
# classification tree
data <- read.table("D:/R_bigdata(advanced)/credit.txt", header=T)
data
n <- nrow(data)
n1 <- 500
n2 <- n - n1

idx <- sample(1:n, n1)
tr.data <- data[idx,]
te.data <- data[-idx,]

library(tree)
tree.fit <- tree(Y~., data=tr.data)
summary(tree.fit)
plot(tree.fit)
text(tree.fit, pretty=0)

cv.fit <- cv.tree(tree.fit)
cv.fit

sz <- cv.fit$size[which(cv.fit$dev == min(cv.fit$dev))]
sz

cv.fit$k[which(cv.fit$dev == min(cv.fit$dev))]

prune.fit <- prune.tree(tree.fit, best=sz)
plot(prune.fit)
text(prune.fit, pretty=0)

yhat <- predict(prune.fit, newdata=te.data)
mean((te.data$Y - yhat)^2)

# Random Forest
library(randomForest)

rf.fit <- randomForest(Y~., data=tr.data, mtry=3, importance=TRUE) 
rf.fit
yhat.rf <- predict(rf.fit, newdata=te.data)
mean((te.data$Y - yhat.rf)^2)

importance(rf.fit)
varImpPlot(rf.fit)

## Q3_2 ??? ##
# Neural Network
data <- read.table("D:/R_bigdata(advanced)/credit.txt", header=T)
data
n <- nrow(data)
n1 <- 500
n2 <- n - n1

idx <- sample(1:n, n1)
tr.data <- data[idx,]
te.data <- data[-idx,]

## Q3_3 ##
# PCA 
data_pca <- USArrests
pca <- princomp(data_pca, cor=T)
summary(pca)
pca$scores[,1:3]

pev <- pca$sdev^2 / sum(pca$sdev^2)
pev
plot(1:4, pev, type="l", xlab='# of PCs', ylab='PEV')

## Q3_4 ##
# K-means clustering
data_km <- USArrests
km1 <- kmeans(data_km, 3, nstart=20)  # k=3
km1
km1$cluster
plot(data_km, col=(km1$cluster+1), pch=20, cex=2)

km2 <- kmeans(data_km, 4, nstart=20)  # k=4
km2
km2$cluster
plot(data_km, col=(km2$cluster+1), pch=20, cex=2)

km3 <- kmeans(data_km, 5, nstart=20)  # k=5
km3
km3$cluster
plot(data_km, col=(km3$cluster+1), pch=20, cex=2)

## Q3_5 ##
# Hierarchical Clustering (Agglomerative)
hc.a1 <- hclust(dist(data_km), method="average")
cutree(hc.a1, 3)
plot(hc.a1, main="Average Linkage", cex=0.8)

hc.a2 <- hclust(dist(data_km), method="average")
cutree(hc.a2, 4)
plot(hc.a2, main="Average Linkage", cex=0.8)