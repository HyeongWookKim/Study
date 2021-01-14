# lec14_3_ass.r
# Association Rule
# Sequence Pattern Analysis

# Sequence Pattern analysis package
install.packages("arulesSequences")
library(arulesSequences)

data(zaki)

summary(zaki)

# to see data frame
as(zaki,"data.frame" )

seq_rule1 <- cspade(zaki,
                  parameter=list(support = 0.3,
                                 maxsize = 5, maxlen =4),
                  control = list(verbose=TRUE))

#analyzing results
summary(seq_rule1)
as(seq_rule1, "data.frame")

#selecting rules(size>2)
seq_rule1_df <- as(seq_rule1, "data.frame")
seq_rule1_size <- size(seq_rule1)

seq_rule1_df <- cbind(seq_rule1_df, seq_rule1_size)
seq_rule1_df
seq_rule_1_df_size2 <- subset(seq_rule1_df, 
                              subset=seq_rule1_size>=2)
seq_rule_1_df_size2

# Question 2(exercise)
seq_rule2 <- cspade(zaki,
                    parameter=list(support = 0.3,
                                   maxsize = 3, maxlen =4),
                    control = list(verbose=TRUE))

seq_rule2_df <- as(seq_rule2, "data.frame")
seq_rule2_size <- size(seq_rule2)

seq_rule2_df <- cbind(seq_rule2_df, seq_rule2_size)
seq_rule2_df
seq_rule_2_df_size <- subset(seq_rule2_df, 
                              subset=seq_rule2_size>=3)
seq_rule_2_df_size