Fine particulate matter (PM2.5) is an ambient air pollutant for which
there is strong evidence that it is harmful to human health. In the
United States, the Environmental Protection Agency (EPA) is tasked with
setting national ambient air quality standards for fine PM and for
tracking the emissions of this pollutant into the atmosphere.
Approximatly every 3 years, the EPA releases its database on emissions
of PM2.5. This database is known as the National Emissions Inventory
(NEI). You can read more information about the NEI at the EPA National
Emissions Inventory web site
<http://www.epa.gov/ttn/chief/eiinformation.html>

For each year and for each type of PM source, the NEI records how many
tons of PM2.5 were emitted from that source over the course of the
entire year. The data that you will use for this assignment are for
1999, 2002, 2005, and 2008.

## Data

The data for this assignment are available from the course web site as a
single zip file:

<https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip>

The zip file contains two files:

PM2.5 Emissions Data (summarySCC\_PM25.rds): This file contains a data
frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and
2008. For each year, the table contains number of tons of PM2.5 emitted
from a specific type of source for the entire year. Here are the first
few rows.

-   fips: A five-digit number (represented as a string) indicating the
    U.S. county
-   SCC: The name of the source as indicated by a digit string (see
    source code classification table)
-   Pollutant: A string indicating the pollutant
-   Emissions: Amount of PM2.5 emitted, in tons
-   type: The type of source (point, non-point, on-road, or non-road)
-   year: The year of emissions recorded

Source Classification Code Table (Source\_Classification\_Code.rds):
This table provides a mapping from the SCC digit strings in the
Emissions table to the actual name of the PM2.5 source. The sources are
categorized in a few different ways from more general to more specific
and you may choose to explore whatever categories you think are most
useful. For example, source “10100101” is known as “Ext Comb /Electric
Gen /Anthracite Coal /Pulverized Coal”.

## Assignment

The overall goal of this assignment is to explore the National Emissions
Inventory database and see what it say about fine particulate matter
pollution in the United states over the 10-year period 1999–2008. You
may use any R package you want to support your analysis.

## Questions

You must address the following questions and tasks in your exploratory
analysis. For each question/task you will need to make a single plot.
Unless specified, you can use any plotting system in R to make your
plot.

### Question 1

Have total emissions from PM2.5 decreased in the United States from 1999
to 2008? Using the base plotting system, make a plot showing the total
PM2.5 emission from all sources for each of the years 1999, 2002, 2005,
and 2008.

    NEI <- readRDS('./data/summarySCC_PM25.rds')

    ## Setting the dataframe so that 
    ##   a) the numerical variables are in the numeric format.
    ##   b) the categorical variables are in the factor format 

    NEI <- transform(NEI, fips = as.numeric(fips), SCC = factor(SCC),
                     Emissions = as.numeric(Emissions), type = factor(type))

    yearTotal <- with(NEI, tapply(Emissions, year, sum, na.rm = T))

    par(mfrow = c(1,1), mar = c(6,4,4,1))
    plot(as.numeric(names(yearTotal)), yearTotal, 
         pch = 19, cex = 1.5, col = 'brown4',
         main = 'PM Emissions Trend in USA',
         xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
    lines(as.numeric(names(yearTotal)), yearTotal,
           lwd = 2, col = 'brown4')
    axis(1, at = as.numeric(names(yearTotal)), 
         labels = as.numeric(names(yearTotal)))     

![](Project2_files/figure-markdown_strict/unnamed-chunk-1-1.png)

### Question 2

Have total emissions from PM2.5 decreased in the Baltimore City,
Maryland (fips == “24510”) from 1999 to 2008? Use the base plotting
system to make a plot answering this question.

    NEIMaryland <- subset(NEI, fips == 24510)

    yearTotalMaryland <- with(NEIMaryland, 
                              tapply(Emissions, year, sum, na.rm = T))

    par(mfrow = c(1,1), mar = c(6,4,4,1))
    plot(as.numeric(names(yearTotalMaryland)), yearTotalMaryland, 
         pch = 19, cex = 1.5, col = 'tomato1',
         main = 'PM Emissions Trend in Maryland',
         xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
    lines(as.numeric(names(yearTotalMaryland)), yearTotalMaryland,
          lwd = 2, col = 'tomato1')
    axis(1, at = as.numeric(names(yearTotalMaryland)), 
         labels = as.numeric(names(yearTotalMaryland)))     

![](Project2_files/figure-markdown_strict/unnamed-chunk-2-1.png)

### Question 3

Of the four types of sources indicated by the type (point, nonpoint,
onroad, nonroad) variable, which of these four sources have seen
decreases in emissions from 1999–2008 for Baltimore City? Which have
seen increases in emissions from 1999–2008? Use the ggplot2 plotting
system to make a plot answer this question.

    library(ggplot2)
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

    g + gl + ggtheme

![](Project2_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    ## ggsave(file = "./Figures4/plot3.png", g + gl + ggtheme)

### Question 4

Across the United States, how have emissions from coal
combustion-related sources changed from 1999–2008?

    SCC <- readRDS("./data/Source_Classification_Code.rds")

    ## Get the row indices that contain "[Cc]oal" by inspecting SCC.Level.Three and 
    ## SCC.Level.Four information 
    coalL3 <- grep('[Cc]oal',SCC$SCC.Level.Three)
    coalL4 <- grep('[Cc]oal',SCC$SCC.Level.Four)
    ## Get the union of the two for coal index positions
    coalL <- sort(union(coalL3, coalL4))
    ## Get the row indexes that contain "[Cc]omb" by inspecting SCC.Level.One for 
    ## for combustion index positions
    combL <- grep('[Cc]omb',SCC$SCC.Level.One)
    ## Get the intersection of the two for coal-combustion correspondng indices
    coalCombL <- intersect(coalL, combL)
    ## Get the corresponding SSC codes for coal-combustion related emissions
    coalCombLSCC <- SCC$SCC[coalCombL]
    ## Get the dataframe subset corresponding to rows that contain the codes for
    ## coal-combustion related emissions
    NEICC <- subset(NEI, SCC %in% coalCombLSCC)
    head(NEICC)

    ##      fips        SCC Pollutant Emissions     type year
    ## 149  9001 2104001000  PM25-PRI     1.134 NONPOINT 1999
    ## 2277 9003 2104001000  PM25-PRI     3.842 NONPOINT 1999
    ## 4204 9005 2104001000  PM25-PRI     1.447 NONPOINT 1999
    ## 5967 9007 2104001000  PM25-PRI     1.574 NONPOINT 1999
    ## 7998 9009 2104001000  PM25-PRI     2.183 NONPOINT 1999
    ## 9979 9011   10100217  PM25-PRI   479.907    POINT 1999

    yearTotalCC <- with(NEICC, tapply(Emissions, year, sum, na.rm = T))
    print(yearTotalCC)

    ##     1999     2002     2005     2008 
    ## 575206.5 547380.1 553549.4 343979.3

    par(mfrow = c(1,1), mar = c(6,4,4,1))
    plot(as.numeric(names(yearTotalCC)), yearTotalCC, 
         pch = 19, cex = 1.5, col = 'brown4',
         main = 'PM Coal-Comb Emissions Trend in USA',
         xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
    lines(as.numeric(names(yearTotalCC)), yearTotalCC,
          lwd = 2, col = 'brown4')
    axis(1, at = as.numeric(names(yearTotalCC)), 
         labels = as.numeric(names(yearTotalCC)))     

![](Project2_files/figure-markdown_strict/unnamed-chunk-4-1.png)

### Question 5

How have emissions from motor vehicle sources changed from 1999–2008 in
Baltimore City?

    vehicle <- grep('[Vv]ehicle',SCC$SCC.Level.Two)
    vehicleSCC <- SCC$SCC[vehicle]

    NEIMarylandVehicle <- subset(NEI, fips == 24510 & SCC %in% vehicleSCC)
    head(NEIMarylandVehicle)

    ##         fips        SCC Pollutant Emissions    type year
    ## 114470 24510 220100123B  PM25-PRI      7.38 ON-ROAD 1999
    ## 114472 24510 220100123T  PM25-PRI      2.78 ON-ROAD 1999
    ## 114477 24510 220100123X  PM25-PRI     11.76 ON-ROAD 1999
    ## 114479 24510 220100125B  PM25-PRI      3.50 ON-ROAD 1999
    ## 114481 24510 220100125T  PM25-PRI      1.32 ON-ROAD 1999
    ## 114486 24510 220100125X  PM25-PRI      5.58 ON-ROAD 1999

    yearTotalMarylandVehicle <- with(NEIMarylandVehicle, 
                                   tapply(Emissions, year, sum, na.rm = T))

    par(mfrow = c(1,1), mar = c(6,4,4,1))
    plot(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle, 
         pch = 19, cex = 1.5, col = 'brown4',
         main = 'PM Vehicle Emissions Trend in Maryland',
         xlab = 'Year', ylab = 'PM Emission (tones)', xaxt = "n")
    lines(as.numeric(names(yearTotalMarylandVehicle)), yearTotalMarylandVehicle,
          lwd = 2, col = 'brown4')
    axis(1, at = as.numeric(names(yearTotalMarylandVehicle)), 
         labels = as.numeric(names(yearTotalMarylandVehicle)))     

![](Project2_files/figure-markdown_strict/unnamed-chunk-5-1.png)

### Question 6

Compare emissions from motor vehicle sources in Baltimore City with
emissions from motor vehicle sources in Los Angeles County, California
(fips == “06037”). Which city has seen greater changes over time in
motor vehicle emissions?

    vehicle <- grep('[Vv]ehicle',SCC$SCC.Level.Two)
    vehicleSCC <- SCC$SCC[vehicle]

    NEIMarylandVehicle <- subset(NEI, fips == 24510 & SCC %in% vehicleSCC)
    NEICaliforniaVehicle <- subset(NEI, fips == 06037 & SCC %in% vehicleSCC)

    yearTotalMarylandVehicle <- with(NEIMarylandVehicle, 
                                     tapply(Emissions, year, sum, na.rm = T))
    yearTotalCaliforniaVehicle <- with(NEICaliforniaVehicle, 
                                     tapply(Emissions, year, sum, na.rm = T))

    rng <- range(yearTotalCaliforniaVehicle, yearTotalMarylandVehicle)


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

![](Project2_files/figure-markdown_strict/unnamed-chunk-6-1.png)
