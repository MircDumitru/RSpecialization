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


## 1. Have total emissions from PM2.5 decreased in the United States 
## from 1999 to 2008? Using the base plotting system, make a plot 
## showing the total PM2.5 emission from all sources for each of the 
## years 1999, 2002, 2005, and 2008.

yearTotal <- with(NEI, tapply(Emissions, year, sum, na.rm = T))
print(yearTotal)

png(file = "./plot1.png")
par(mfrow = c(1,1), mar = c(6,4,4,1))
plot(as.numeric(names(yearTotal)), yearTotal, 
     pch = 19, cex = 1.5, col = 'brown4',
     main = 'PM Emissions Trend in USA',
     xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
lines(as.numeric(names(yearTotal)), yearTotal,
      lwd = 2, col = 'brown4')
axis(1, at = as.numeric(names(yearTotal)), 
     labels = as.numeric(names(yearTotal)))     
dev.off()
