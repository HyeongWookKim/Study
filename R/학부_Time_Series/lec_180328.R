### Decomposition ###

## ex_1 ##
auto <- read.csv("D:/Time Series/Data(Time Series)/autocycle.csv")
auto
autots <- ts(auto, frequency=12, start=c(1981,1))
autots
plot.ts(autots)
# Decomposition by additive model
library(TTR)
autots_dc <- decompose(autots)
autots_dc
autots_dc$seasonal
plot(autots_dc)
# Seasonally adjusted
autots_s_adj <- autots - autots_dc$seasonal
autots_s_adj
plot(autots_s_adj)


## ex_2 ##
house <- read.csv("D:/Time Series/Data(Time Series)/house.csv")
house
housets <- ts(house, frequency=4, start=c(1980,1))
housets
plot.ts(housets)
# Decompositon by multiple model
housets_dc <- decompose(housets, type=c("multiplicative"))
housets_dc
housets_dc$seasonal
plot(housets_dc)
# Seasonally adjusted_by multiple model
housets_adj <- housets/housets_dc$seasonal
housets_adj
plot(housets_adj)