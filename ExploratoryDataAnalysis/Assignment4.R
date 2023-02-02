NEI <- readRDS('./data/summarySCC_PM25.rds')
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

png(file = "./Figures4/plot1.png")
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


## 2. Have total emissions from PM2.5 decreased in the Baltimore City,
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
## system to make a plot answering this question.

NEIMaryland <- subset(NEI, fips == 24510)

yearTotalMaryland <- with(NEIMaryland, 
                          tapply(Emissions, year, sum, na.rm = T))
print(yearTotalMaryland)


png(file = "./Figures4/plot2.png")
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


## 3. Of the four types of sources indicated by the type (point, nonpoint, 
## onroad, nonroad) variable, which of these four sources have seen decreases
## in emissions from 1999–2008 for Baltimore City? Which have seen increases
## in emissions from 1999–2008? Use the ggplot2 plotting system to make a 
## plot answer this question.


NEIMarylandAgg <- aggregate(Emissions ~ year + type, data = NEIMaryland, sum)

ggtheme <- theme(axis.text.x = element_text(colour='black'),
                 axis.text.y = element_text(colour='black'),
                 panel.background = element_blank(),
                 panel.grid.minor = element_blank(),
                 panel.grid.major = element_blank(),
                 panel.border = element_rect(colour='black', fill=NA),
                 strip.background = element_blank(),
                 legend.justification = c(0, 1),
                 legend.position = c(0.8, 0.99),
                 legend.background = element_rect(colour = NA),
                 legend.key = element_rect(colour = "white", fill = NA),
                 legend.title = element_blank(),
                 plot.title = element_text(hjust = 0.5))

g <- ggplot(NEIMarylandAgg, 
            aes(x = year, y = Emissions, group = type)) + 
            geom_line(linewidth = 1.2,
                      alpha = 1,
                      aes(col = type)) +
            geom_point(size = 3,
                       alpha = 1,
                       aes(col = type))

gl <- labs(title = "PM Emissions Trend in Maryland Per Type",
           x = 'Year', 
           y = 'PM Emission (tones)')

ggsave(file = "./Figures4/plot3.png", g + gl + ggtheme)


## 4. Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?


SCC <- readRDS("./data/Source_Classification_Code.rds")
print(dim(SCC))
print(names(SCC))
for(i in 1:dim(SCC)[2]){
    print(c(names(SCC)[i], class(SCC[,i])))
}

# Get the row indices that contain "[Cc]oal" by inspecting SCC.Level.Three and 
# SCC.Level.Four information 
coalL3 <- grep('[Cc]oal',SCC$SCC.Level.Three)
coalL4 <- grep('[Cc]oal',SCC$SCC.Level.Four)
# Get the union of the two for coal index positions
coalL <- sort(union(coalL3, coalL4))
# Get the row indexes that contain "[Cc]omb" by inspecting SCC.Level.One for 
# for combustion index positions
combL <- grep('[Cc]omb',SCC$SCC.Level.One)
# Get the intersection of the two for coal-combustion correspondng indices
coalCombL <- intersect(coalL, combL)
# Get the corresponding SSC codes for coal-combustion related emissions
coalCombLSCC <- SCC$SCC[coalCombL]
# Get the dataframe subset corresponding to rows that contain the codes for
# coal-combustion related emissions
NEICC <- subset(NEI, SCC %in% coalCombLSCC)
head(NEICC)

yearTotalCC <- with(NEICC, tapply(Emissions, year, sum, na.rm = T))
print(yearTotalCC)

png(file = "./Figures4/plot4.png")
par(mfrow = c(1,1), mar = c(6,4,4,1))
plot(as.numeric(names(yearTotalCC)), yearTotalCC, 
     pch = 19, cex = 1.5, col = 'brown4',
     main = 'PM Coal-Comb Emissions Trend in USA',
     xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
lines(as.numeric(names(yearTotalCC)), yearTotalCC,
      lwd = 2, col = 'brown4')
axis(1, at = as.numeric(names(yearTotalCC)), 
     labels = as.numeric(names(yearTotalCC)))     
dev.off()


## 5. How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?


vehicle <- grep('[Vv]ehicle',SCC$SCC.Level.Two)
vehicleSCC <- SCC$SCC[vehicle]

NEIMarylandVehicle <- subset(NEI, fips == 24510 & SCC %in% vehicleSCC)
head(NEIMarylandVehicle)

yearTotalMarylandVehicle <- with(NEIMarylandVehicle, 
                               tapply(Emissions, year, sum, na.rm = T))
print(yearTotalMarylandVehicle)

png(file = "./Figures4/plot5.png")
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



## 6. Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, 
## California (fips == "06037"). Which city has seen greater changes 
## over time in motor vehicle emissions?


vehicle <- grep('[Vv]ehicle',SCC$SCC.Level.Two)
vehicleSCC <- SCC$SCC[vehicle]

NEIMarylandVehicle <- subset(NEI, fips == 24510 & SCC %in% vehicleSCC)
NEICaliforniaVehicle <- subset(NEI, fips == 06037 & SCC %in% vehicleSCC)

yearTotalMarylandVehicle <- with(NEIMarylandVehicle, 
                                 tapply(Emissions, year, sum, na.rm = T))
yearTotalCaliforniaVehicle <- with(NEICaliforniaVehicle, 
                                 tapply(Emissions, year, sum, na.rm = T))


rng <- range(yearTotalCaliforniaVehicle, yearTotalMarylandVehicle)
png(file = "./Figures4/plot6.png")
par(mfrow = c(1,1), mar = c(6,4,4,1))

plot(as.numeric(names(yearTotalCaliforniaVehicle)), yearTotalCaliforniaVehicle, 
     pch = 19, cex = 1.5, col = 'brown4',
     main = 'PM Vehicle Emissions Trend in Baltimore & L.A.',
     xlab = 'Year', ylab = 'PM Emission (tones)', 
     ylim = rng, xaxt = "n")
lines(as.numeric(names(yearTotalCaliforniaVehicle)), yearTotalCaliforniaVehicle,
      lwd = 2, col = 'brown4')

points(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle, 
     pch = 19, cex = 1.5, col = 'tomato1')
lines(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle,
      lwd = 2, col = 'tomato1')

axis(1, at = as.numeric(names(yearTotalMarylandVehicle)), 
     labels = as.numeric(names(yearTotalMarylandVehicle)))     

legend("right", legend = c("LA", "Maryland"),
       lwd = 3, col = c("brown4", "tomato1"))

dev.off()
