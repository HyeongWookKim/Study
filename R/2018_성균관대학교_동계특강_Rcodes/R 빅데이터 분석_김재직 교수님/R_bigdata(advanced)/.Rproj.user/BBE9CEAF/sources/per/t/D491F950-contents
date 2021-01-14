### Supervised learning ###

## Decision Tree ## ------------------------------------

# Data
train <- read.table("D:/R_bigdata(advanced)/train.txt", header=T)
test <- read.table("D:/R_bigdata(advanced)/test.txt", header=T)

# Decision Tree
install.packages("tree")
library(tree)
tree.fit <- tree(medv~., data=train)
summary(tree.fit)
plot(tree.fit)
text(tree.fit, pretty=0)

# Pruning 
cv.fit <- cv.tree(tree.fit)  # CV to find "alpha"
cv.fit

# Size corresponding to the smallest cv statistic.
sz <- cv.fit$size[which(cv.fit$dev == min(cv.fit$dev))]
sz

# Alpha corresponding to the smallest cv statistic.
cv.fit$k[which(cv.fit$dev == min(cv.fit$dev))]

prune.fit <- prune.tree(tree.fit, best=sz)
plot(prune.fit)
text(prune.fit, pretty=0)

yhat <- predict(prune.fit, newdata=test)
mean((test$medv - yhat)^2)  # Test MSE

# Random Forests
install.packages("randomForest")
library(randomForest)

rf.fit <- randomForest(medv~., data=train, mtry=4, importance=TRUE) 
# mtry=value of "m", importance="important variables"
rf.fit
yhat.rf <- predict(rf.fit, newdata=test)
mean((test$medv - yhat.rf)^2)  # Test MSE

# Importance of variables
importance(rf.fit)  # calculate the importance of variables
varImpPlot(rf.fit)  # draw the importance of variables

## Neural Networks ## -----------------------------------------

# Data
train <- read.table("D:/R_bigdata(advanced)/train.txt", header=T)
test <- read.table("D:/R_bigdata(advanced)/test.txt", header=T)

# Scaling
maxs <- apply(train, 2, max)  # apply(matrix, 1(row)/2(column), function)
mins <- apply(train, 2, min)
train.s <- as.data.frame(scale(train, center = mins, scale = maxs - mins))
test.s <- as.data.frame(scale(test, center = mins, scale = maxs - mins))

# Neural networks
install.packages('neuralnet')
library(neuralnet)
nn <- neuralnet(medv ~ crim + zn + indus + chas + nox + rm + age + 
                  dis + rad + tax + ptratio + black + lstat, 
                data=train.s, hidden=c(5,3), linear.output=T)
# hidden=c(hidden units of hidden layer1, hidden units of hidden layer2) 
# linear.output=T : "Regression", linear.output=F : "Classification"

# Result
plot(nn)

#Prediction
pr.nn <- compute(nn, test.s[,1:13]) # medvhat with scaling
medvhat <- pr.nn$net.result*(maxs[14]-mins[14])+mins[14] # medvhat with no scaling
medvhat

# Test error
sum((test$medv - medvhat)^2)/nrow(test.s)

### Unsupervised learning ###

## Principal Component Analysis(PCA) ## ------------------------------------

# Data
total <- read.table("D:/R_bigdata(advanced)/train.txt", header=T)
p <- ncol(total)
pca <- princomp(total, cor=T)  # cor=T : Needs to standardization in data
summary(pca)
pca$scores[, 1:3]  # original coordinates at new axis

# Scree plot(to find "elbow point")
pev <- pca$sdev^2 / sum(pca$sdev^2)
pev
plot(1:p, pev, type="l", xlab='# of PCs', ylab='PEV')

# PC scores for Test data
test <- read.table("D:/R_bigdata(advanced)/test.txt", header=T)
te.pc <- predict(pca, test)

## Cluster Analysis ##    

## K-means clustering(Non Hierarchical Clustering) ## --------------------------------------------

# Data
iris
x <- iris[,1:4]

km <- kmeans(x, 3, nstart=20)  # nstart="numbers of repeating k-means algorithm"
km

# result
km$cluster
iris[km$cluster==1,] # shows data which is "cluster=1"
plot(x, col=(km$cluster+1), pch=20, cex=2)

# Hierarchical Clustering (Agglomerative) ----------------------
hc.s <- hclust(dist(x), method="single")
cutree(hc.s, 3)

hc.c <- hclust(dist(x), method="complete")
cutree(hc.c, 3)

hc.a <- hclust(dist(x), method="average")
cutree(hc.a, 3)

# dendogram
par(mfrow=c(1,3))
plot(hc.s, main='Single linkage', cex=0.5)
plot(hc.c, main='Complete linkage', cex=0.5)
plot(hc.a, main='Average linkage', cex=0.5)



### Text Mining ### ---------------------------------------------------

install.packages("tm")
install.packages("SnowballC")
library(tm)
library(SnowballC)

# Locate and load the Corpus.
cname <- file.path(".", "data", "txt")  # folder containg documents
docs <- Corpus(DirSource(cname))        # Create corpus
summary(docs)                           # List of documents
inspect(docs[1])                        # Attribute of the 1st document

# See each document
# Creat view document function
install.packages("dplyr")
library(dplyr)
library(magrittr)
viewDocs <- function(d, n){
  d %>% 
    extract2(n) %>% 
    as.character() %>% 
    writeLines()}
viewDocs(docs, 1)

# Transformation (Preprocessing) #

# content_transformer(): 
#     Function to achieve the user defined transformation.

# Remove special characters 
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "<>")    # Remove '<' & '>'

# Convert to lowercase:
docs <- tm_map(docs, content_transformer(tolower))

# Remove numbers:
docs <- tm_map(docs, removeNumbers)

# Remove punctuation:
docs <- tm_map(docs, removePunctuation)

# Remove English stop words:
stopwords("english")
docs <- tm_map(docs, removeWords, stopwords("english"))

# Remove user defined words:
docs <- tm_map(docs, removeWords, c("said", "says"))
# -> user defined words: "said", "says"

# Remove white space:
docs <- tm_map(docs, stripWhitespace)

# Specific transformation
toString <- content_transformer(function(x, from, to) gsub(from, to, x))
# 'inc' -> 'company'
docs <- tm_map(docs, toString, "inc", "company")  

# Stemming
docs <- tm_map(docs, stemDocument)

# Document term matrix.
dtm <- DocumentTermMatrix(docs)
dim(dtm)
inspect(dtm[1:3,1:5])

# Remove sparse terms
dtms <- removeSparseTerms(dtm, sparse=0.4)
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
findAssocs(dtm, c("group","rumor"), corlimit=0.8)

# Word frequency plot
install.packages("ggplot2")
library(ggplot2)

freq <-  sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
p <- ggplot(subset(wf, freq > 20), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# Correlation plot
source("https://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")
library(Rgraphviz)
plot(dtm,terms=findFreqTerms(dtm, lowfreq=20), corThreshold=0.5)

# Word cloud
install.packages("wordcloud")
library(wordcloud)
wordcloud(names(freq), freq, min.freq=10, colors=brewer.pal(6, "Dark2"))

# Clustering documents
# Using sparse DTM
hc <- hclust(dist(as.matrix(dtms)), method='average')
plot(hc)