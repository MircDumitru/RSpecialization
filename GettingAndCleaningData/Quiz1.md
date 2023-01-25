# Organizing, merging and managing the data - Week 1 Quiz

1.  The American Community Survey distributes downloadable data about
    United States communities. Download the 2006 microdata survey about
    housing for the state of Idaho using download.file() from here:

    <https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv>

    and load the data into R. The code book, describing the variable
    names is here:

    <https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf>

    How many properties are worth $1,000,000 or more?

            fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
            download.file(fileUrl, destfile = './data/quiz11.csv', method = 'curl')
            dateDownloaded <- date()
            df <- read.csv('./data/quiz11.csv')
            length(df$VAL[df$VAL == 24 & !is.na(df$VAL)])

        ## [1] 53

    Or, using the `which()` function which takes care of the missing
    values:

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

2.  Use the data you loaded from Question 1. Consider the variable FES
    in the code book. Which of the “tidy data” principles does this
    variable violate?

    The principle stating that each column should represent *strictly*
    one variables. For this datafarame, the column FES is coding
    combination of multiple variables.

3.  Download the Excel spreadsheet on Natural Gas Aquisition Program
    here:

    <https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx>

    Read rows 18-23 and columns 7-15 into R and assign the result to a
    variable called `dat`. What is the value of
    `sum(dat$Zip*dat$Ext,na.rm=T)`

<!--    ```{r quiz13a, echo = TRUE}
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
        download.file(fileUrl, destfile = './data/quiz13.csv', method = 'curl')
        dateDownloaded <- date()
        df <- read.xlsx('./data/quiz13.xlsx', sheetIndex = 1, header = TRUE)
        length(df$VAL[df$VAL == 24 & !is.na(df$VAL)])
    ```-->

1.  Read the XML data on Baltimore restaurants from here:

    <https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml>

    How many restaurants have zipcode 21231?

2.  The American Community Survey distributes downloadable data about
    United States communities. Download the 2006 microdata survey about
    housing for the state of Idaho using download.file() from here:

    <https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv>

    using the fread() command load the data into an R object
