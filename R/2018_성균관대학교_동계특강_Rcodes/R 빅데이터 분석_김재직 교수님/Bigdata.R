#####################
# Big Data Analysis #
#####################


# Ridge & Lasso regression -------------------------
fire = read.csv('forestfires.csv',header=T)

install.packages('glmnet')
library(glmnet)

x = as.matrix(fire[,-9])
y = fire[,9]

# Ridge
cv.out = cv.glmnet(x,y,alpha=0,nfolds=10)
opt.lam = cv.out$lambda.min
fit = glmnet(x,y,alpha=0,lambda=opt.lam)
fit$beta

yhat = predict(fit, s=opt.lam, newx=x)

mean((y-yhat)^2)

# Lasso 
cv.out = cv.glmnet(x,y,alpha=1,nfolds=10)
opt.lam = cv.out$lambda.min
fit = glmnet(x,y,alpha=1,lambda=opt.lam)
fit$beta

yhat = predict(fit, s=opt.lam, newx=x)

mean((y-yhat)^2)

# KNN ---------------------------------------
# Data
dat = read.table('D:/.../credit.txt')
n = nrow(dat)
n1 = 500
n2 = n - n1

# Training & Test data:
idx = sample(1:n,n1)
tr.x = dat[idx,1:6]; tr.y = dat[idx,7]; 
te.x = dat[-idx,1:6]; te.y = dat[-idx,7]

# KNN
library(class)
k = 3
te.yhat = knn(tr.x, te.x, tr.y, k)

# Test error
te.error = sum(te.y != te.yhat) / n2  

# Selection of K
TE = NULL
for (k in 1:10)
{
  te.yhat = knn(tr.x, te.x, tr.y, k)
  te.error = sum(te.y != te.yhat) / n2
  TE = c(TE,te.error)
}
which.min(TE)

# Cross-validation
install.packages('cvTools')
library(cvTools)

x = dat[,1:6]
y = dat[,7]
K = 5 # K-fold
k = 3 # kNN

cvf = cvFolds(n, K)
cvstat = numeric(K)
for (i in 1:K)
{
  index = cvf$subsets[cvf$which == i]
  tr.x = x[-index,]; tr.y = y[-index]
  te.x = x[index,]; te.y = y[index]
  n2 = length(te.y)
  te.yhat = knn(tr.x, te.x, tr.y, k)
  cvstat[i] = sum(te.y != te.yhat) / n2
}  
mean(cvstat)






# Discriminant Analysis ----------------------------
# Data
dat = read.table('credit.txt')
n = nrow(dat)
n1 = 500
n2 = n - n1

# Training & Test data:
idx = sample(1:n,n1)
tr.dat = dat[idx,]
te.dat = dat[-idx,]

# LDA
library(MASS)
fit.lda = lda(Y ~ ., data=tr.dat)
pred = predict(fit.lda, newdata=te.dat)
yhat = pred$class
phat = pred$posterior
sum(te.dat$Y != yhat)/nrow(te.dat)

# QDA
fit.qda = qda(Y ~ ., data=tr.dat)
pred = predict(fit.qda, newdata=te.dat)
yhat = pred$class
phat = pred$posterior
sum(te.dat$Y != yhat)/nrow(te.dat)


# Logistic Regression -------------------------------

mydata=read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
fit=glm(admit~gre+gpa+factor(rank),data=mydata,family="binomial")
summary(fit)

pred_y=ifelse(fit$fit>0.5,1,0)
table(mydata$admit,pred_y,dnn=c("Observed","Predicted"))

new=data.frame(gre=500,gpa=3.25,rank=1)
predict(fit,newdata=new,type="link")
predict(fit,newdata=new,type="response")

pred=predict(fit,newdata=new,type="response",se.fit=TRUE)
pred$fit

# Multinomial Logit regression -----------------------
install.packages("nnet")
library("nnet")
diabetes=read.csv(file("e:/diabetes.csv"),header=T)
fit=multinom(CC~RW+IR+SSPG,diabetes)
summary(fit)

predict(fit,type="probs")

pred_CC=predict(fit,type="class")
pred_CC

table(diabetes$CC,pred_CC,dnn=c("Observed","Predicted"))


# Decision Tree ------------------------------------

train = read.table('train.txt')
test = read.table('test.txt')

install.packages('tree')
library(tree)

tree.fit = tree(medv~.,data=train)
summary(tree.fit)
plot(tree.fit)
text(tree.fit,pretty=0)

# Pruning 
cv.fit = cv.tree(tree.fit)

# Size corresponding to the smallest cv statistic.
sz = cv.fit$size[which(cv.fit$dev == min(cv.fit$dev))]

# Alpha corresponding to the smallest cv statistic.
cv.fit$k[which(cv.fit$dev == min(cv.fit$dev))]

prune.fit = prune.tree(tree.fit,best=sz)
plot(prune.fit)
text(prune.fit,pretty=0)

yhat = predict(prune.fit,newdata=test)
mean((test$medv - yhat)^2)

# Random Forests
install.packages('randomForest')
library(randomForest)

rf.fit = randomForest(medv~., data=train, mtry=4, importance=TRUE)
yhat.rf = predict(rf.fit,newdata=test)
mean((test$medv - yhat.rf)^2)

# Importance of variables
importance(rf.fit)
varImpPlot(rf.fit)

# Neural Networks -----------------------------------------

# Data
train = read.table('train.txt')
test = read.table('test.txt')

# Scaling
maxs = apply(train, 2, max) 
mins = apply(train, 2, min)
train.s = as.data.frame(scale(train, center = mins, scale = maxs - mins))
test.s = as.data.frame(scale(test, center = mins, scale = maxs - mins))

# Neural networks
install.packages('neuralnet')
library(neuralnet)
nn = neuralnet(medv ~ crim + zn + indus + chas + nox + rm + age + dis + rad + tax + ptratio + black + lstat, data=train.s,hidden=c(5,3),linear.output=T)
# linear.output=T: Regression; =F: Classification.

# Result
plot(nn)

#Prediction
pr.nn = compute(nn,test.s[,1:13])
medvhat = pr.nn$net.result*(maxs[14]-mins[14])+mins[14]

# Test error
sum((test$medv - medvhat)^2)/nrow(test.s)

# Principal Component Analysis ------------------------------------
p = ncol(train)
pca = princomp(train,cor=T)
summary(pca)

# Scree plot
pev = pca$sdev^2 / sum(pca$sdev^2)
plot(1:p,pev,type='l',xlab='# of PCs',ylab='PEV')

# PC scores for Test data
te.pc = predict(pca,test)


# K-means clustering --------------------------------------------
# Data
x = iris[,1:4]

km = kmeans(x, 3, nstart=20)
km

km$cluster

plot(x, col=(km$cluster+1), pch=20, cex=2)


# Hierarchical Clustering (Agglomerative) ----------------------
hc.s = hclust(dist(x), method='single')
cutree(hc.s, 3)

hc.c = hclust(dist(x), method='complete')
cutree(hc.c, 3)

hc.a = hclust(dist(x), method='average')
cutree(hc.a, 3)

par(mfrow=c(1,3))
plot(hc.s, main='Single linkage', cex=0.5)
plot(hc.c, main='Complete linkage', cex=0.5)
plot(hc.a, main='Average linkage', cex=0.5)

# Text Mining ---------------------------------------------------

install.packages('tm')
install.packages('SnowballC')

library(tm)
library(SnowballC)

# Locate and load the Corpus.
cname = file.path('.', 'data', 'txt')   # folder containg documents
docs = Corpus(DirSource(cname))         # Create corpus
summary(docs)                           # List of documents
inspect(docs[1])                        # Attribute of the 1st document

# See each document
# Creat view document function
install.packages('dplyr')
library(dplyr)
library(magrittr)
viewDocs = function(d, n) {d %>% extract2(n) %>% as.character() %>% writeLines()}

viewDocs(docs, 1)

# Transformation (Preprocessing)

# content_transformer(): 
#     Function to achieve the user defined transformation.

# Remove special characters 
toSpace = content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs = tm_map(docs, toSpace, "<>")    # Remove '<' & '>'

# Convert to lowercase:
docs = tm_map(docs, content_transformer(tolower))

# Remove numbers:
docs = tm_map(docs, removeNumbers)

# Remove punctuation:
docs = tm_map(docs, removePunctuation)

# Remove English stop words:
stopwords("english")
docs = tm_map(docs, removeWords, stopwords("english"))

# Remove user defined words:
docs = tm_map(docs, removeWords, c("said", "says"))
  # -> user defined words: "said", "says"

# Remove white space:
docs = tm_map(docs, stripWhitespace)

# Specific transformation
toString = content_transformer(function(x, from, to) gsub(from, to, x))
  # 'inc' -> 'company'
docs = tm_map(docs, toString, "inc", "company")  


# Stemming
docs = tm_map(docs, stemDocument)


# Document term matrix.
dtm = DocumentTermMatrix(docs)
dim(dtm)
inspect(dtm[1:3,1:5])


# Remove sparse terms
dtms = removeSparseTerms(dtm,sparse=0.4)
  # sparse: a value between 0 and 1. 
  #         As it close to 0, sparsity increases.
dim(dtms)
inspect(dtms)


# Identify frequent terms
  # Show words with freq. >= 20
findFreqTerms(dtm, lowfreq=20)


# Identify associated words
  # If two words always appear together then 
  # the correlation would be 1 and if they never 
  # appear together the correlation would be 0.
findAssocs(dtm,c('group','rumor') , corlimit=0.8)
  

# Word frequency plot
install.packages('ggplot2')
library(ggplot2)

freq = sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf = data.frame(word=names(freq), freq=freq)
p = ggplot(subset(wf, freq > 20), aes(word, freq))
p = p + geom_bar(stat="identity")
p = p + theme(axis.text.x=element_text(angle=45, hjust=1))
p



# Correlation plot
source("https://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")
library(Rgraphviz)
plot(dtm,terms=findFreqTerms(dtm, lowfreq=20), corThreshold=0.5)


# Word cloud
install.packages('wordcloud')
library(wordcloud)
wordcloud(names(freq), freq, min.freq=10, colors=brewer.pal(6, "Dark2"))

# Clustering documents
# Using sparse DTM
hc = hclust(dist(as.matrix(dtms)), method='average')
plot(hc)




