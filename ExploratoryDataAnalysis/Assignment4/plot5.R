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


## 5. How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?


SCC <- readRDS("../data/Source_Classification_Code.rds")
print(dim(SCC))
print(names(SCC))
for(i in 1:dim(SCC)[2]){
    print(c(names(SCC)[i], class(SCC[,i])))
}


vehicle <- grep('[Vv]ehicle',SCC$SCC.Level.Two)
vehicleSCC <- SCC$SCC[vehicle]

NEIMarylandVehicle <- subset(NEI, fips == 24510 & SCC %in% vehicleSCC)
head(NEIMarylandVehicle)

yearTotalMarylandVehicle <- with(NEIMarylandVehicle, 
                                 tapply(Emissions, year, sum, na.rm = T))
print(yearTotalMarylandVehicle)

png(file = "./plot5.png")
par(mfrow = c(1,1), mar = c(6,4,4,1))
plot(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle, 
     pch = 19, cex = 1.5, col = 'brown4',
     main = 'PM Vehicle Emissions Trend in Maryland',
     xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
lines(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle,
      lwd = 2, col = 'brown4')
axis(1, at = as.numeric(names(yearTotalMarylandVehicle)), 
     labels = as.numeric(names(yearTotalMarylandVehicle)))     
dev.off()

