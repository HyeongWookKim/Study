# lec2_3.r
# Vector, matrix calculation
# transpose, determinant, inverse

# calcualtion
2^3
4**3

7%%5
7%/%5

# example lec2_1.r
m2<-matrix(1:6, ncol=3)
m2

# transpose of m2
tm2<-t(m2)
tm2

# determinant of matrix, 

d1<-matrix(1:4, nrow=2, byrow=T)
d1
det(d1)

#inverse of matrix
d1_inv<-solve(d1)
d1_inv

# d1*inv(d1)=identity matrix
d1%*%d1_inv

# solve 5x=10

solve(5,10)

#solve equation
# 3x+2y=8, x+y=2

# matrix a, b
a <- matrix(c(3,1,2,1),nrow=2,ncol=2)
b <- matrix(c(8,2),nrow=2,ncol=1)
a
b
# x=4,  y=-2
solve(a,b)
# to see solve
help(solve)


# example for eigen value and eigen vector
# already centered matrix 
x<-matrix(c(-3,-2,0, 1, 2, 2, -3, -3, 0, 2, 2, 2, 5,7,4,0,-5,-11), nrow =6, ncol=3)
x
dim(x)

# centered matrix (x-mean(x)), not scaled 
# x<-scale(x, scale=F)

# eigen value and eigen vector
e1<-eigen(t(x)%*%x)
e1


# higher order of array
a1<-array(c(1:18), dim=c(3,3,2))
a1
a1[, ,1]
a1[, ,2]

#
x <- matrix(1:4, ncol = 2)
unlist(determinant(x))


# dimension 
dim(a1)