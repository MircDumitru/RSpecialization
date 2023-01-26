# Organizing, merging and managing the data - Week 4 Quiz

## Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using `download.file()` from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv>

and load the data into R. The code book, describing the variable names
is here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf>

Apply `strsplit()` to split all the names of the data frame on the
characters “wgtp”. What is the value of the 123 element of the resulting
list?

        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
        download.file(fileUrl, './data/quiz41.csv', method = 'curl')
        df <- read.csv('./data/quiz41.csv')
        head(df)[, 1:6]

    ##   RT SERIALNO DIVISION PUMA REGION ST
    ## 1  H      186        8  700      4 16
    ## 2  H      306        8  700      4 16
    ## 3  H      395        8  100      4 16
    ## 4  H      506        8  700      4 16
    ## 5  H      835        8  800      4 16
    ## 6  H      989        8  700      4 16

        dim(df)

    ## [1] 6496  188

        strsplit(names(df), 'wgtp')[123]

    ## [[1]]
    ## [1] ""   "15"

## Question 2

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>

Remove the commas from the GDP numbers in millions of dollars and
average them. What is the average?

Original data sources:

<http://data.worldbank.org/data-catalog/GDP-ranking-table>

        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
        download.file(fileUrl, './data/quiz42.csv', method = 'curl')
        df <- read.csv('./data/quiz42.csv', skip = 4, nrows=190)
        head(df,4)[, 1:7]

    ##     X X.1 X.2           X.3          X.4 X.5 X.6
    ## 1 USA   1  NA United States  16,244,600       NA
    ## 2 CHN   2  NA         China   8,227,103       NA
    ## 3 JPN   3  NA         Japan   5,959,718       NA
    ## 4 DEU   4  NA       Germany   3,428,131       NA

        tail(df,4)[, 1:7]

    ##       X X.1 X.2              X.3   X.4 X.5 X.6
    ## 187 PLW 187  NA            Palau  228       NA
    ## 188 MHL 188  NA Marshall Islands  182       NA
    ## 189 KIR 189  NA         Kiribati  175       NA
    ## 190 TUV 190  NA           Tuvalu   40       NA

        dim(df)

    ## [1] 190  10

        mean(as.integer(gsub(',', '', df$X.4)), na.rm = TRUE)

    ## [1] 377652.4

        #mean(as.integer(gsub(',', '', gdp)), na.rm = TRUE)

## Question 3

In the data set from Question 2 what is a regular expression that would
allow you to count the number of countries whose name begins with
“United”? Assume that the variable with the country names in it is named
countryNames. How many countries begin with United?

        # This one counts the names ending in "United". 
        grep("United$",df$X.3)

    ## integer(0)

        # This one counts the names containing "United", with any number of repetiton
        grep("*United",df$X.3)

    ## [1]  1  6 32

        # This one counts the names containing "United", with any number of repetiton
        grep("*United",df$X.3)

    ## [1]  1  6 32

        # This one is correct, it counts the country names that _start_ with United.
        grep("^United",df$X.3)

    ## [1]  1  6 32

## Question 4

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>

Load the educational data from this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv>

Match the data based on the country shortcode. Of the countries for
which the end of the fiscal year is available, how many end in June?

Original data sources:

<http://data.worldbank.org/data-catalog/GDP-ranking-table>

<http://data.worldbank.org/data-catalog/ed-stats>

       fileUrlGdp <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
       fileUrlEdu <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
       download.file(fileUrlGdp, destfile = './data/gdp.csv', method = 'curl')
       download.file(fileUrlEdu, destfile = './data/edu.csv', method = 'curl')
       dfGdp <- read.csv('./data/gdp.csv', skip = 4, nrows=190)
       names(dfGdp)[1] <- 'CountryCode'
       dfEdu <- read.csv('./data/edu.csv')
       df <- merge(dfGdp, dfEdu, by = 'CountryCode')
       nrow(df)

    ## [1] 189

       table(grepl('June 30', df$Special.Notes))

    ## 
    ## FALSE  TRUE 
    ##   176    13

## Question 5

You can use the quantmod (<http://www.quantmod.com/>) package to get
historical stock prices for publicly traded companies on the NASDAQ and
NYSE. Use the following code to download data on Amazon’s stock price
and get the times the data was sampled. How many values were collected
in 2012? How many values were collected on Mondays in 2012?

    library(quantmod)
    amzn = getSymbols("AMZN",auto.assign=FALSE)
    sampleTimes = index(amzn)
    sampleTimes[1:10]

    ##  [1] "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-08" "2007-01-09"
    ##  [6] "2007-01-10" "2007-01-11" "2007-01-12" "2007-01-16" "2007-01-17"

    col2012 <- sampleTimes[grep("^2012-*", sampleTimes)]
    length(col2012)

    ## [1] 250

    length(which(weekdays(col2012)=="Monday"))

    ## [1] 47
