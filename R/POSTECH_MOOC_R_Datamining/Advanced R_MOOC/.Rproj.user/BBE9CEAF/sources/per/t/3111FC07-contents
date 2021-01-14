# lec10_2_knn.R
# optimal k
# Weighted knn

# optimal k selection 
accuracy_k <- NULL
for(kk in c(1:nrow(iris.train)))
{
  set.seed(1234)
  knn_k <- knn(train=iris.train, test=iris.test, cl=trainLabels, k=kk)
  
  accuracy_k <- c(accuracy_k, sum(knn_k==testLabels)/length(testLabels))
  
}
# test_k<-data.frame(k=c(1:nrow(iris.train)),accuracy=accuracy_k)
test_k <- data.frame(k=c(1:nrow(iris.train)/2), accuracy=accuracy_k)

plot(formula=accuracy~k, data=test_k, type="o", pch=20, col=3, main="validation-optimal k")
with(test_k, text(accuracy~k, labels=rownames(test_k), pos=1, cex=0.7))
min(test_k[test_k$accuracy %in% max(accuracy_k), "k"])

# k=7 knn
md1 <- knn(train=iris.train, test=iris.test, cl=trainLabels, k=7)
CrossTable(x=testLabels, y=md1, prop.chisq=FALSE)

# graphic display
plot(formula=Petal.Length ~ Petal.Width,
     data=iris.train, col=alpha(c("purple","blue","green"),0.7)[trainLabels],
     main="knn(k=7)")
points(formula = Petal.Length~Petal.Width,
       data=iris.test,
       pch = 17,
       cex= 1.2,
       col=alpha(c("purple","blue","green"), 0.7)[md1]
)
legend("bottomright",
       c(paste("train", levels(trainLabels)), paste("test", levels(testLabels))),
       pch=c(rep(1,3), rep(17,3)),
       col=c(rep(alpha(c("purple","blue","green"), 0.7),2)),
       cex=0.9
)

## Weighted KNN packages
install.packages("kknn") # weighted value knn
library(kknn)
help("kknn")

# weighted knn
md2 <- kknn(Species~., train=train, test=test, k=5, distance=1, kernel="triangular")
md2
# to see results for weighted knn
md2_fit <- fitted(md2)
md2_fit
# accuracy of weighted knn
CrossTable(x=testLabels, y=md2_fit, prop.chisq=FALSE, prop.c=FALSE)


# weighted knn (k=7, distance=2)
md3 <- kknn(Species~., train=train,test=test, k=7, distance=2, kernel="triangular")
md3
# to see results for weighted knn
md3_fit <- fitted(md2)
md3_fit
# accuracy of weighted knn
CrossTable(x=testLabels, y=md3_fit, prop.chisq=FALSE, prop.c=FALSE)