
SF = read.csv(file='sanfrancisco_incidents_summer_2014.csv', header=TRUE, sep=",")


# get the top 8 crime categories (categories with the most incidents)
library(plyr)
a <- count(SF$Category)
top8Categ <- tail(a[order(a$freq),],8)$x

# get the crime data (rows in SF dataframe) that belong to the top 8 categories
topCrimes <- SF[SF$Category %in% top8Categ,]

# This plot does not work well, because it still print all categories in the legend
plot(topCrimes$X, topCrimes$Y, col = topCrimes$Category)
legend('topleft', legend = levels(topCrimes$Category), col=1:length(topCrimes$Category),pch=1)

# this plot works. Still too much data
require(ggplot2)
qplot(X, Y, data = topCrimes, colour = Category)