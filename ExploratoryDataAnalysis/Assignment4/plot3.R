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



## 3. Of the four types of sources indicated by the type (point, nonpoint, 
## onroad, nonroad) variable, which of these four sources have seen decreases
## in emissions from 1999–2008 for Baltimore City? Which have seen increases
## in emissions from 1999–2008? Use the ggplot2 plotting system to make a 
## plot answer this question.

NEIMaryland <- subset(NEI, fips == 24510)

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

ggsave(file = "./plot3.png", g + gl + ggtheme)


