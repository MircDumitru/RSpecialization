NEI <- readRDS('../data/summarySCC_PM25.rds')
print(dim(NEI))
print(names(NEI))
for(i in 1:dim(NEI)[2]){
    print(c(names(NEI)[i], class(NEI[,i])))
}
print(head(NEI))

## Setting the dataframe so that 
##   a) the numerical variables are in the numeric format.
##   b) the categorical variables are in the factor format 

NEI <- transform(NEI, fips = as.numeric(fips), SCC = factor(SCC),
                 Emissions = as.numeric(Emissions), type = factor(type))

for(i in 1:dim(NEI)[2]){
    print(c(names(NEI)[i], class(NEI[,i])))
}
print(head(NEI))


## 2. Have total emissions from PM2.5 decreased in the Baltimore City,
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
## system to make a plot answering this question.

NEIMaryland <- subset(NEI, fips == 24510)

yearTotalMaryland <- with(NEIMaryland, 
                          tapply(Emissions, year, sum, na.rm = T))
print(yearTotalMaryland)


png(file = "./plot2.png")
par(mfrow = c(1,1), mar = c(6,4,4,1))
plot(as.numeric(names(yearTotalMaryland)), yearTotalMaryland, 
     pch = 19, cex = 1.5, col = 'tomato1',
     main = 'PM Emissions Trend in Maryland',
     xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
lines(as.numeric(names(yearTotalMaryland)), yearTotalMaryland,
      lwd = 2, col = 'tomato1')
axis(1, at = as.numeric(names(yearTotalMaryland)), 
     labels = as.numeric(names(yearTotalMaryland)))     
dev.off()

