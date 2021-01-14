# Analysis of variance(ANOVA)

# One-way ANOVA

# ex_1
weight <- c(30,35,28,29,25,29,34,
            25,31,28,27,23,24,31,
            20,16,17,18,18,17,20)
feed <- c(rep("A", 7), rep("B", 7), rep("C", 7))
pig <- data.frame(weight, feed)
# ex_1_method 1
anova(lm(weight~feed, data=pig))
# ex_1_method 2
result0 <- aov(weight~feed, data=pig)  # aov = only for "ANOVA", recommend this way
summary(result0)

# ex_2
A <- c(2250,2410,2260,2200,2360,2320,2240,2300,2090)
B <- c(1920,2020,1960,1960,2280,2010,2090,2140,2400)
C <- c(2030,2390,2000,2060,2260,2180,2190,2250,2310)
y <- c(A, B, C)
treatment <- as.factor(c(rep("A", 9), rep("B", 9), rep("C", 9)))
cbind(y,treatment)
result1 <- aov(y~treatment)
summary(result1)

# ex_3
A <- c(76,64,85,75)
B <- c(58,75,81,66)
C <- c(49,63,62,46)
D <- c(74,71,85,90)
E <- c(66,74,81,79)
score <- c(A, B, C, D, E)
employee <- as.factor(c(rep("A", 4), rep("B", 4), 
                        rep("C", 4), rep("D", 4), rep("E", 4)))
selection <- data.frame(score, employee)
result2 <- aov(score~employee)
summary(result2)

# multiple comparison
yy <- c(24.54,23.97,22.85,24.34,24.47,24.36,23.37,24.46,
        22.73,22.28,23.99,23.23,23.94,23.52,24.41,22.80,
        22.02,21.97,21.34,22.83,22.90,22.28,21.14,21.85,
        20.83,24.40,23.01,23.54,21.60,21.86,24.57,22.81)
xx <- c(rep("w1",8), rep("w2",8), rep("w3",8), rep("w4",8))
water <- data.frame(yy,xx)
bartlett.test(yy~xx)      # Bartlett test for equal variance
result3 <- aov(yy~xx, data=water)
summary(result3)

pairwise.t.test(yy,xx, p.adjust="none", pool.sd=TRUE)        # Fisher's LSD
pairwise.t.test(yy,xx, p.adjust="bonferroni", pool.sd=FALSE) # Bonferroni, pool.sd=equal variance
pairwise.t.test(yy,xx, p.adjust="bonferroni", pool.sd=TRUE)  # Bonferroni
TukeyHSD(aov(yy~xx, data=water))  # Tukey's HSD
plot(TukeyHSD(aov(yy~xx, data=water)))  # Visualization

# Two-way ANOVA

# Two-way ANOVA with no interaction
data <- c(30,24,16,34,10,26,18,26,34,44,24,42)  # easy way => using excel to import data
# method 1
type <- factor(rep(1:3,c(4,4,4)))     # make a factor_1
levels(type) <- c("A1", "A2", "A3")   # naming a factors
fir <- factor(rep(1:4, 3))
levels(fir) <- c("B1", "B2", "B3", "B4")
# method 2
type <- c(rep("A1", 4), rep("A2", 4), rep("A3", 4))
fir <- c("B1", "B2", "B3", "B4")

result4 <- aov(data~type+fir)
summary(result4)
TukeyHSD(result4, conf.level=0.95) # we can decide conf.level
par(mfrow=c(2,1))
plot(TukeyHSD(result4))

# Two-way ANOVA with interaction
salt <- c(rep(1,4),rep(2,4),rep(3,4))  # salt : 1 1 1 1 2 2 2 2 3 3 3 3
salt <- rep(salt,2)
day <- c(rep(4,12), rep(8,12))
hardness <- c(5,6,8,7,
              4,5,5,5,
              7,4,4,6,
              2,2,6,2,
              4,5,3,4,
              3,4,7,5)
daikon <- data.frame(salt, day, hardness)
fit <- aov(hardness~factor(salt)+factor(day), data=daikon)
fit
fit1 <- aov(hardness~factor(salt)+factor(day)+factor(salt)*factor(day),
            data=daikon)
summary(fit1)
# interaction.plot(data$factor1, data$factor2, data$response)
interaction.plot(daikon$salt, daikon$day, daikon$hardness)