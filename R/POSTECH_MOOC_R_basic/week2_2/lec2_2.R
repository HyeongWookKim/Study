# lec2_2.r 
# Naming vector and matrix, Data frame 

# Give name to a vector
gender<-c(0,1)
names(gender)<-c("female", "male")
gender

length(gender)

#categorical varaiables : factor
size<-c("S", "M","L","XL")
# define size as a factor (categorical variable)
size_factor<-factor(size)

size_factor
is.factor(size_factor)


# or in same output
size_factor2 <- factor(size, 
                       levels = c("S", "M","L","XL")) 
size_factor2

# give order for categorical variable
size_factor3 <- factor(size, ordered = TRUE, 
                       levels = c("S", "M","L","XL")) 
size_factor3

# naming a matrix
# generate matrix from normal 
x<-matrix(rnorm(12),nrow=4)
x
# check dimension of x
dim(x)

# add variable names 
dimnames(x)[[2]]<-paste("x",1:3,sep="")
x
# or use colnames
y<-matrix(rnorm(12),nrow=4)
colnames(y) <- c("y1", "y2", "y3")
y

# add observation names
dimnames(x)[[1]]<-paste("id",1:4,sep="")
# rwonames(x) <- c("id1", "id2", "id3", "id4")
x

# data frame
is.data.frame(x)
# matrix x is not data frame

# define x as a data frame
x<-as.data.frame(x)
# then x is a data frame
is.data.frame(x)
# use x1 as a variable of data set (x)
x$x1

mean(x$x1)
sd(x$x1)

summary(x)









