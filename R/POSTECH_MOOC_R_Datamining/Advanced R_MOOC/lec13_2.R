# lec13_2_clus.R
# Clustering
# Hierarchical Clustering
# Linkage method, Dendrogram

# needs "lattice", "DAAG" package for loading dataset
install.packages("lattice")
install.packages("DAAG")
library(lattice)
library(DAAG)

# load data in DAAG package
# the wages of Lancashire cotton factory workers in 1833
data(wages1833)
help(wages1833)
head(wages1833, n=10)

# remove observations with the missing values
dat1 <- wages1833
dat1 <- na.omit(dat1)
str(dat1)

# calculate distance between each nodes
dist_data <- dist(dat1)

# prepare hierarchical cluster
# complete linkage method
hc_a <- hclust(dist_data, method="complete")
hc_a
plot(hc_a, hang=-1, cex=0.8, main="complete")

# average linkage method
# check how different from complete method
hc_c <- hclust(dist_data, method="average")
hc_c
plot(hc_c, hang=-1, cex=0.8, main="average")

# Ward's method
hc_w <- hclust(dist_data, method="ward.D2")
hc_w
plot(hc_c, hang=-1, cex=0.8, main="Ward's method")