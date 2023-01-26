# Organizing, merging and managing the data - Week 3 Quiz

## Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using download.file() from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv>

and load the data into R. The code book, describing the variable names
is here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf>

Create a logical vector that identifies the households on greater than
10 acres who sold more than $10,000 worth of agriculture products.
Assign that logical vector to the variable agricultureLogical. Apply the
which() function like this to identify the rows of the data frame where
the logical vector is TRUE.

`which(agricultureLogical)`

What are the first 3 values that result?

        if(!file.exists('./data')){dir.create("./data")}
        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
        download.file(fileUrl, destfile = './data/question1.csv', method = 'curl')
        df <- read.csv('./data/question1.csv')
        names(df)[1:10]

    ##  [1] "RT"       "SERIALNO" "DIVISION" "PUMA"     "REGION"   "ST"      
    ##  [7] "ADJUST"   "WGTP"     "NP"       "TYPE"

        agricultureLogical <- rep(FALSE, nrow(df))
        # From the code book, the variable coding for the lot sizes is ACR and ACR==3 corresponds to households on greater than 10 acres and the variable coding for the sales is AGS and AGS==6 corresponds to sales worth more than $10.000
        agricultureLogical[which(df$ACR == 3 & df$AGS == 6)] <- TRUE
        which(agricultureLogical)[1:3]

    ## [1] 125 238 262

The above solution is following the requirements, i.e. first creating
the logical vector. However, in order to find the (row) positions
corresponding to households that fulfil the two logical conditions, it
is enough to apply the `which()` function on the two conditions

          which(df$ACR == 3 & df$AGS == 6)[1:3]

    ## [1] 125 238 262

## Question 2

Using the jpeg package read in the following picture of your instructor
into R

<https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg>

Use the parameter native=TRUE. What are the 30th and 80th quantiles of
the resulting data? (some Linux systems may produce an answer 638
different for the 30th quantile)

        library(jpeg)
        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'
        download.file(fileUrl, './data/picture.jpg', method = 'curl')
        picture <- readJPEG('./data/picture.jpg', native=TRUE)
        quantile(picture, probs = c(.3,.8))

    ##       30%       80% 
    ## -15259150 -10575416

## Question 3

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>

Load the educational data from this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv>

Match the data based on the country shortcode. How many of the IDs
match? Sort the data frame in descending order by GDP rank (so United
States is last). What is the 13th country in the resulting data frame?

Original data sources:

<http://data.worldbank.org/data-catalog/GDP-ranking-table>

<http://data.worldbank.org/data-catalog/ed-stats>

       if(!file.exists('./data')){dir.create("./data")}
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

       df_ordered <- df[order(df$X.1, decreasing = TRUE),]
       df_ordered[13,4]

    ## [1] "St. Kitts and Nevis"

## Question 4

What is the average GDP ranking for the “High income: OECD” and “High
income: nonOECD” group?

       library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

       df_gp <- group_by(df, Income.Group)
       summarise(df_gp, mean(X.1))

    ## # A tibble: 5 × 2
    ##   Income.Group         `mean(X.1)`
    ##   <chr>                      <dbl>
    ## 1 High income: nonOECD        91.9
    ## 2 High income: OECD           33.0
    ## 3 Low income                 134. 
    ## 4 Lower middle income        108. 
    ## 5 Upper middle income         92.1

## Question 5

Cut the GDP ranking into 5 separate quantile groups. Make a table versus
Income.Group. How many countries are Lower middle income but among the
38 nations with highest GDP?

       df$GDPQ <- cut(df$X.1, breaks = quantile(df$X.1, probs = c(0, .2, .4, .6, .8, 1.)))
       table(df$GDPQ, df$Income.Group)

    ##              
    ##               High income: nonOECD High income: OECD Low income
    ##   (1,38.6]                       4                17          0
    ##   (38.6,76.2]                    5                10          1
    ##   (76.2,114]                     8                 1          9
    ##   (114,152]                      4                 1         16
    ##   (152,190]                      2                 0         11
    ##              
    ##               Lower middle income Upper middle income
    ##   (1,38.6]                      5                  11
    ##   (38.6,76.2]                  13                   9
    ##   (76.2,114]                   11                   8
    ##   (114,152]                     9                   8
    ##   (152,190]                    16                   9
