# Organizing, merging and managing the data - Week 1 Quiz

## Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using download.file() from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv>

and load the data into R. The code book, describing the variable names
is here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf>

How many properties are worth $1,000,000 or more?

    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
    download.file(fileUrl, destfile = './data/quiz11.csv', method = 'curl')
    dateDownloaded <- date()
    df <- read.csv('./data/quiz11.csv')
    length(df$VAL[df$VAL == 24 & !is.na(df$VAL)])

    ## [1] 53

Or, using the `which()` function which takes care of the missing values:

    length(df$VAL[which(df$VAL == 24)])

    ## [1] 53

In fact, to get the number of properties it’s enough to compute

    length(which(df$VAL == 24))

    ## [1] 53

Via the `dplyr` package, using the the `filter()` function:

    #install.packages('dplyr', repos = "http://cran.us.r-project.org")
    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    nrow(filter(df, VAL == 24))

    ## [1] 53

## Question 2

Use the data you loaded from Question 1. Consider the variable FES in
the code book. Which of the “tidy data” principles does this variable
violate?

The principle stating that each column should represent *strictly* one
variables. For this datafarame, the column FES is coding combination of
multiple variables.

## Question 3

Download the Excel spreadsheet on Natural Gas Aquisition Program here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx>

Read rows 18-23 and columns 7-15 into R and assign the result to a
variable called `dat`. What is the value of
`sum(dat$Zip*dat$Ext,na.rm=T)`

    library(xlsx)
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
    download.file(fileUrl, destfile = './data/quiz13.csv', method = 'curl')
    dat <- read.xlsx('./data/quiz13.xlsx', sheetIndex = 1, 
                    rowIndex = 18:23, colIndex = 7:15, header = TRUE)
    sum(dat$Zip * dat$Ext, na.rm=T)

    ## [1] 36534720

## Question 4

Read the XML data on Baltimore restaurants from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml>

How many restaurants have zipcode 21231?

        # Load the XML package
        library(XML)
        # The target zipcode 
        targetZipCode <- 21231
        # The xml documnet url
        fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
        # Reading the XML document via xmlTreeParse
        xmlDoc <- xmlTreeParse(fileUrl, useInternal = TRUE)
        # Getting the root node
        rootNode <- xmlRoot(xmlDoc)
        # Extract the list of (numeric, via as.numeric) values (just the values, via the third parameter xmlValue) from the rootNode corresponding to nodes with label "zipcode" via xpathSApply
        zipCodesList <- as.numeric(xpathSApply(rootNode, "//zipcode", xmlValue))
        # Compute the number of matches 
        length(which(zipCodesList==targetZipCode))

    ## [1] 127

## Question 5

5The American Community Survey distributes downloadable data about
United States communities. Download the 2006 microdata survey about
housing for the state of Idaho using download.file() from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv>

using the `fread()` command load the data into an R object. The
following are ways to calculate the average value of the variable
*pwgtp15* broken down by sex. Using the data.table package, which will
deliver the fastest user time?

        # Load the data.table package
        library(data.table)

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

        # The .csv file url
        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
        # Read the csv via the fread() (directly from the url, without downloading the .csv first) into the data table dt
        dt <- fread(fileUrl)
        # The (first columns) of the header 
        head(dt,5)[,1:8]

    ##    RT SERIALNO SPORDER PUMA ST  ADJUST PWGTP AGEP
    ## 1:  P      186       1  700 16 1015675    89   43
    ## 2:  P      186       2  700 16 1015675    92   42
    ## 3:  P      186       3  700 16 1015675   107   16
    ## 4:  P      186       4  700 16 1015675    91   14
    ## 5:  P      306       1  700 16 1015675   309   29

        # The system times for each option:
        #system.time(rowMeans(dt)[dt$SEX==1], rowMeans(dt)[dt$SEX==2])
        times <- c()
        i <- 1
        t <- system.time(repeat{
                          tapply(dt$pwgtp15, dt$SEX, mean)
                          i <- i+1
                          if (i == 20) break
                                })[['elapsed']]
        times <- c(times, t)
        
        i <- 1
        t <- system.time(repeat{
                          mean(dt$pwgtp15, by=dt$SEX)
                          i <- i+1
                          if (i == 20) break
                                })[['elapsed']]
        times <- c(times, t)    
        
        i <- 1
        t <- system.time(repeat{
                          mean(dt[dt$SEX==1, ]$pwgtp15)
                          mean(dt[dt$SEX==2, ]$pwgtp15)
                          i <- i+1
                          if (i == 20) break
                                })[['elapsed']]
        times <- c(times, t)

        i <- 1
        t <- system.time(repeat{
                          dt[,mean(pwgtp15), by=SEX]
                          i <- i+1
                          if (i == 20) break
                                })[['elapsed']]
        times <- c(times, t)

        i <- 1
        t <- system.time(repeat{
                          sapply(split(dt$pwgtp15, dt$SEX), mean)
                          i <- i+1
                          if (i == 20) break
                                })[['elapsed']]
        times <- c(times, t)
        times

    ## [1] 0.008 0.002 0.081 0.011 0.006
