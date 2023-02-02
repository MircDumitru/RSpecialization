## Data

This assignment uses data from the UC Irvine Machine Learning
Repository, <http://archive.ics.uci.edu/ml/>, a popular repository for
machine learning datasets. In particular, we will be using the
“Individual household electric power consumption Data Set” which I have
made available on the course web site:

-   Dataset: Electric power consumption
    <https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip>
-   Description: Measurements of electric power consumption in one
    household with a one-minute sampling rate over a period of almost 4
    years. Different electrical quantities and some sub-metering values
    are available.

The following descriptions of the 9 variables in the dataset are taken
from the UCI web site:

-   **Date**: Date in format dd/mm/yyyy
-   **Time**: time in format hh:mm:ss
-   **Global\_active\_power**: household global minute-averaged active
    power (in kilowatt)
-   **Global\_reactive\_power**: household global minute-averaged
    reactive power (in kilowatt)
-   **Voltage**: minute-averaged voltage (in volt)
-   **Global\_intensity**: household global minute-averaged current
    intensity (in ampere)
-   **Sub\_metering\_1**: energy sub-metering No. 1 (in watt-hour of
    active energy). It corresponds to the kitchen, containing mainly a
    dishwasher, an oven and a microwave (hot plates are not electric but
    gas powered).
-   **Sub\_metering\_2**: energy sub-metering No. 2 (in watt-hour of
    active energy). It corresponds to the laundry room, containing a
    washing-machine, a tumble-drier, a refrigerator and a light.
-   **Sub\_metering\_3**: energy sub-metering No. 3 (in watt-hour of
    active energy). It corresponds to an electric water-heater and an
    air-conditioner.

## Loading the data

When loading the dataset into R, please consider the following:

-   The dataset has 2,075,259 rows and 9 columns. First calculate a
    rough estimate of how much memory the dataset will require in memory
    before reading into R. Make sure your computer has enough memory
    (most modern computers should be fine).
-   We will only be using data from the dates 2007-02-01 and 2007-02-02.
    One alternative is to read the data from just those dates rather
    than reading in the entire dataset and subsetting to those dates.
-   You may find it useful to convert the Date and Time variables to
    Date/Time classes in R using the `strptime()` and `as.Date()`
    functions.
-   Note that in this dataset missing values are coded as `?`

## Making Plots

Our overall goal here is simply to examine how household energy usage
varies over a 2-day period in February, 2007. Your task is to
reconstruct the following plots below, all of which were constructed
using the base plotting system.

First you will need to fork and clone the following GitHub repository:
<https://github.com/rdpeng/ExData_Plotting1>

For each plot you should

-   Construct the plot and save it to a PNG file with a width of 480
    pixels and a height of 480 pixels.

-   Name each of the plot files as *plot1.png*, *plot2.png*, etc. Create
    a separate R code file ( *plot1.R*, *plot2.R*, etc.) that constructs
    the corresponding plot, i.e. code in *plot1.R* constructs the
    *plot1.png* plot. Your code file should include code for reading the
    data so that the plot can be fully reproduced. You must also include
    the code that creates the PNG file.

-   Add the PNG file and R code file to the top-level folder of your git
    repository (no need for separate sub-folders)

-   When you are finished with the assignment, push your git repository
    to GitHub so that the GitHub version of your repository is up to
    date. There should be four PNG files and four R code files, a total
    of eight files in the top-level folder of the repo.

### Reading the dataframe

    df <- read.table('./data/household_power_consumption.txt', header = TRUE, sep = ';')
    ## print(dim(df))
    ## print(head(df))
    ## print(names(df))

    ## Get the concatenation of the Date and Time columns
    datecol <- paste(df$Date, df$Time)
    ## Check the class
    ## print(class(datecol))
    ## Check the dimension
    ## print(dim(df))
    ## Check the first elements 
    ## print(datecol[1:10])

    ## Transform it into date class
    datecol <- strptime(datecol, "%d/%m/%Y %H:%M:%S", tz = "EST")
    ## Check the class
    ## print(class(datecol))
    ## Check the dimension
    ## print(dim(df))
    ## Check the first elements 
    ## print(datecol[1:10])

    ## Drop the Date $ Time variables, add the new DataTime variable 
    df <- df[,-(1:2)]
    df$DateTime <- datecol
    ## Check the dimension
    ## print(dim(df))
    ## print(head(df))

    start_point <- strptime("2007-02-01 00:00:01", "%Y-%m-%d %H:%M:%S", tz = "EST")
    end_point <- strptime("2007-02-02 23:59:59", "%Y-%m-%d %H:%M:%S", tz = "EST")


    df<-df[which (start_point < df$DateTime & df$DateTime < end_point), ]
    ## Check the dimension
    ## print(dim(df))
    ## print(head(df))

### Plot 1

    ## Plot 1 - Histogram
    ##  hist(as.numeric(df$Global_active_power), col = 'red', 
    ##       main = 'Global Active Power',
    ##       xlab = 'Global Active Power (kilowats)')

    ## Plot 1 - Histogram via with
    ## png(file = "./Figures/plot1.png")
    with(df,{
    hist(as.numeric(Global_active_power), col = 'red', 
         main = 'Global Active Power',
         xlab = 'Global Active Power (kilowats)')
    })

![](Project1_files/figure-markdown_strict/unnamed-chunk-2-1.png)

    ## dev.off()

### Plot 2

    ## Plot 2 - Lines
    ## plot(df$DateTime, as.numeric(df$Global_active_power), 
    ##      type = 'n', 
    ##     ylab = 'Global Active Power (kilowats)',
    ##      xlab = '')
    ## lines(df$DateTime, as.numeric(df$Global_active_power))

    ## Plot 2 - Lines via with
    ## png(file = "./Figures/plot2.png")
    plot(df$DateTime, as.numeric(df$Global_active_power), 
         type = 'n', 
         ylab = 'Global Active Power (kilowats)',
         xlab = '')
    with(df,{
        lines(DateTime, as.numeric(Global_active_power))
        })

![](Project1_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    ## dev.off()

### Plot 3

    ## Plot 3 - Lines
    ## plot(df$DateTime, as.numeric(df$Sub_metering_1), 
    ##      type = 'n', 
    ##      ylab = 'Energy sub metering',
    ##      xlab = '')
    ## lines(df$DateTime, as.numeric(df$Sub_metering_1), 
    ##       col = 'black')
    ## lines(df$DateTime, as.numeric(df$Sub_metering_2), 
    ##       col = 'red')
    ## lines(df$DateTime, as.numeric(df$Sub_metering_3), 
    ##       col = 'blue')
    ## legend("topright", 
    ##        legend = c("Sub_metering_1", 'Sub_metering_2', 'Sub_metering_3'), 
    ##        lwd = 1, cex=0.6, 
    ##        col = c('black', 'red', 'blue'))

### Plot 4

    ## Plot 3 - Lines via with
    ## png(file = "./Figures/plot3.png")
    with(df,{
    plot(DateTime, as.numeric(Sub_metering_1), 
         type = 'n', 
         ylab = 'Energy sub metering',
         xlab = '')
        lines(DateTime, as.numeric(Sub_metering_1), 
              col = 'black')
        lines(DateTime, as.numeric(Sub_metering_2), 
              col = 'red')
        lines(DateTime, as.numeric(Sub_metering_3), 
              col = 'blue')
    })
    legend("topright", 
           legend = c("Sub_metering_1", 'Sub_metering_2', 'Sub_metering_3'), 
           lwd = 1, cex=1, 
           col = c('black', 'red', 'blue'))

![](Project1_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    ## dev.off()

    ## Plot 4 - Multiple plots
    ## png(file = "./Figures/plot4.png")
    par(mfcol = c(2,2), mar = c(5,4,2,0.5))

    plot(df$DateTime, as.numeric(df$Global_active_power), 
         type = 'n', 
         ylab = 'Global Active Power',
         xlab = '')
    with(df,{
        lines(DateTime, as.numeric(Global_active_power))
    })

    with(df,{
        plot(DateTime, as.numeric(Sub_metering_1), 
             type = 'n', 
             ylab = 'Energy sub metering',
             xlab = '')
        lines(DateTime, as.numeric(Sub_metering_1), 
              col = 'black')
        lines(DateTime, as.numeric(Sub_metering_2), 
              col = 'red')
        lines(DateTime, as.numeric(Sub_metering_3), 
              col = 'blue')
    })
    legend("topright", 
           legend = c("Sub_metering_1", 'Sub_metering_2', 'Sub_metering_3'), 
           lwd = 1, cex=1, box.lwd = 0, 
           col = c('black', 'red', 'blue'))


    plot(df$DateTime, as.numeric(df$Voltage), 
         type = 'n', 
         ylab = 'Voltage',
         xlab = 'datetime')
    with(df,{
        lines(DateTime, as.numeric(df$Voltage))
    })

    plot(df$DateTime, as.numeric(df$Global_reactive_power), 
         type = 'n', 
         ylab = 'Global_reactive_power',
         xlab = 'datetime')
    with(df,{
        lines(DateTime, as.numeric(df$Global_reactive_power))
    })

![](Project1_files/figure-markdown_strict/unnamed-chunk-6-1.png)

    ## dev.off()
