## 1. Clustering Case Study

    load('./data/samsungData.rda')
    names(samsungData)[1:12]

    ##  [1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"
    ##  [4] "tBodyAcc-std()-X"  "tBodyAcc-std()-Y"  "tBodyAcc-std()-Z" 
    ##  [7] "tBodyAcc-mad()-X"  "tBodyAcc-mad()-Y"  "tBodyAcc-mad()-Z" 
    ## [10] "tBodyAcc-max()-X"  "tBodyAcc-max()-Y"  "tBodyAcc-max()-Z"

    dim(samsungData)

    ## [1] 7352  563

    table(samsungData$activity)

    ## 
    ##   laying  sitting standing     walk walkdown   walkup 
    ##     1407     1286     1374     1226      986     1073

    table(samsungData$subject)

    ## 
    ##   1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29 
    ## 347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 
    ##  30 
    ## 383

### Plotting the average acceleration for first subject

    par(mfrow = c(1,2), 
        mar = c(5,4,1,1))
    samsungData <- transform(samsungData, activity = factor(activity))
    sub1 <- subset(samsungData, subject == 1)
    plot(sub1[, 1], 
         col = sub1$activity, 
         ylab = names(sub1)[1])
    legend("bottomright", 
           legend = unique(sub1$activity), 
           col = unique(sub1$activity), pch = 1)
    plot(sub1[, 2], 
         col = sub1$activity, 
         ylab = names(sub1)[2]) 
    legend("bottomright", 
           legend = unique(sub1$activity), 
           col = unique(sub1$activity), pch = 1)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-2-1.png)

### Clustering based just on average acceleration

    distanceMatrix <- dist(sub1[, 1:3])
    hClustering <- hclust(distanceMatrix)
    plot(hClustering)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-3-1.png)

### Plotting max acceleration for first subject

    par(mfrow = c(1,2), 
        mar = c(5,4,1,1))
    samsungData <- transform(samsungData, activity = factor(activity))
    sub1 <- subset(samsungData, subject == 1)
    plot(sub1[, 10], 
         col = sub1$activity, 
         ylab = names(sub1)[10])
    legend("bottomright", 
           legend = unique(sub1$activity), 
           col = unique(sub1$activity), pch = 1)
    plot(sub1[, 11], 
         col = sub1$activity, 
         ylab = names(sub1)[11]) 
    legend("bottomright", 
           legend = unique(sub1$activity), 
           col = unique(sub1$activity), pch = 1)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-4-1.png)

### Clustering based just on max acceleration

    distanceMatrix <- dist(sub1[, 10:12])
    hClustering <- hclust(distanceMatrix)
    plot(hClustering)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-5-1.png)

### Singular value decomposition

    svd1 <- svd(scale(sub1[, -c(562,563)]))
    par(mfrow = c(1, 2), mar = c(14,4,2,2))
    plot(svd1$u[, 1], 
         col = sub1$activity,
         pch = 19)
    plot(svd1$u[, 2], 
         col = sub1$activity,
         pch = 19)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-6-1.png)

### Finding maximum contributor

    plot(svd1$v[,2], pch = 19)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-7-1.png)

### New clustering with maximum contributer

    maxContrib <- which.max(svd1$v[,2])
    distanceMatrix <- dist(sub1[, c(10:12, maxContrib)])
    hClustering <- hclust(distanceMatrix)
    plot(hClustering)

![](Notes4_files/figure-markdown_strict/unnamed-chunk-8-1.png)

    names(samsungData)[maxContrib]

    ## [1] "fBodyAcc.meanFreq...Z"

### K-means clustering (nstart = 1, first try)

    kClust <- kmeans(sub1[, -c(562,563)], centers = 6)
    table(kClust$cluster, sub1$activity)

    ##    
    ##     laying sitting standing walk walkdown walkup
    ##   1      0       0        0    0       49      0
    ##   2      0       0        0   95        0      0
    ##   3     29       0        0    0        0      0
    ##   4     18      10        2    0        0      0
    ##   5      3       0        0    0        0     53
    ##   6      0      37       51    0        0      0

### K-means clustering (nstart = 1, second try)

    kClust <- kmeans(sub1[, -c(562,563)], centers = 6, nstart = 1)
    table(kClust$cluster, sub1$activity)

    ##    
    ##     laying sitting standing walk walkdown walkup
    ##   1     26      34       48    0        0      0
    ##   2      0       0        0    0        0     34
    ##   3     19      13        5    0        0      0
    ##   4      5       0        0    0        0     19
    ##   5      0       0        0   95        0      0
    ##   6      0       0        0    0       49      0

### K-means clustering (nstart = 100, first try)

    kClust <- kmeans(sub1[, -c(562,563)], centers = 6, nstart = 100)
    table(kClust$cluster, sub1$activity)

    ##    
    ##     laying sitting standing walk walkdown walkup
    ##   1      3       0        0    0        0     53
    ##   2     29       0        0    0        0      0
    ##   3     18      10        2    0        0      0
    ##   4      0      37       51    0        0      0
    ##   5      0       0        0    0       49      0
    ##   6      0       0        0   95        0      0

### K-means clustering (nstart = 100, second try)

    kClust <- kmeans(sub1[, -c(562,563)], centers = 6, nstart = 100)
    table(kClust$cluster, sub1$activity)

    ##    
    ##     laying sitting standing walk walkdown walkup
    ##   1      0       0        0    0       49      0
    ##   2      3       0        0    0        0     53
    ##   3     29       0        0    0        0      0
    ##   4     18      10        2    0        0      0
    ##   5      0       0        0   95        0      0
    ##   6      0      37       51    0        0      0

### Cluster 1 variable centers (Laying)

    plot(kClust$center[1, 1:10], pch = 19,
         ylab = 'Cluster Center', xlab = "")

![](Notes4_files/figure-markdown_strict/unnamed-chunk-14-1.png)

    plot(kClust$center[4, 1:10], pch = 19,
         ylab = 'Cluster Center', xlab = "")

![](Notes4_files/figure-markdown_strict/unnamed-chunk-14-2.png)

## 2. Air Pollution Case Study

### Reading the 1999 data

    ## Reading the 99 file 
    pm99 <- read.table("./data/RD_501_88101_1999-0.txt", 
                       comment.char = '#', 
                       header = FALSE,
                       sep = '|',
                       na.strings = '')
    dim(pm99)

    ## [1] 117421     28

    head(pm99)

    ##   V1 V2 V3 V4 V5    V6 V7 V8  V9 V10      V11   V12    V13  V14 V15 V16  V17
    ## 1 RD  I  1 27  1 88101  1  7 105 120 19990103 00:00     NA   AS   3  NA <NA>
    ## 2 RD  I  1 27  1 88101  1  7 105 120 19990106 00:00     NA   AS   3  NA <NA>
    ## 3 RD  I  1 27  1 88101  1  7 105 120 19990109 00:00     NA   AS   3  NA <NA>
    ## 4 RD  I  1 27  1 88101  1  7 105 120 19990112 00:00  8.841 <NA>   3  NA <NA>
    ## 5 RD  I  1 27  1 88101  1  7 105 120 19990115 00:00 14.920 <NA>   3  NA <NA>
    ## 6 RD  I  1 27  1 88101  1  7 105 120 19990118 00:00  3.878 <NA>   3  NA <NA>
    ##   V18 V19 V20 V21 V22 V23 V24 V25 V26 V27 V28
    ## 1  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 2  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 3  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 4  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 5  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 6  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA

    # Get the variable names from the first row of the file via readlines
    cnames <- readLines("./data/RD_501_88101_1999-0.txt",1)
    # Split cnames via strsplit
    cnames <- strsplit(cnames, "|", fixed = TRUE)
    cnames

    ## [[1]]
    ##  [1] "# RD"                              "Action Code"                      
    ##  [3] "State Code"                        "County Code"                      
    ##  [5] "Site ID"                           "Parameter"                        
    ##  [7] "POC"                               "Sample Duration"                  
    ##  [9] "Unit"                              "Method"                           
    ## [11] "Date"                              "Start Time"                       
    ## [13] "Sample Value"                      "Null Data Code"                   
    ## [15] "Sampling Frequency"                "Monitor Protocol (MP) ID"         
    ## [17] "Qualifier - 1"                     "Qualifier - 2"                    
    ## [19] "Qualifier - 3"                     "Qualifier - 4"                    
    ## [21] "Qualifier - 5"                     "Qualifier - 6"                    
    ## [23] "Qualifier - 7"                     "Qualifier - 8"                    
    ## [25] "Qualifier - 9"                     "Qualifier - 10"                   
    ## [27] "Alternate Method Detectable Limit" "Uncertainty"

    # Assign the cnames to the dataframe names; first transform the cnames into names via makenames
    names(pm99) <- make.names(cnames[[1]])
    head(pm99)

    ##   X..RD Action.Code State.Code County.Code Site.ID Parameter POC
    ## 1    RD           I          1          27       1     88101   1
    ## 2    RD           I          1          27       1     88101   1
    ## 3    RD           I          1          27       1     88101   1
    ## 4    RD           I          1          27       1     88101   1
    ## 5    RD           I          1          27       1     88101   1
    ## 6    RD           I          1          27       1     88101   1
    ##   Sample.Duration Unit Method     Date Start.Time Sample.Value Null.Data.Code
    ## 1               7  105    120 19990103      00:00           NA             AS
    ## 2               7  105    120 19990106      00:00           NA             AS
    ## 3               7  105    120 19990109      00:00           NA             AS
    ## 4               7  105    120 19990112      00:00        8.841           <NA>
    ## 5               7  105    120 19990115      00:00       14.920           <NA>
    ## 6               7  105    120 19990118      00:00        3.878           <NA>
    ##   Sampling.Frequency Monitor.Protocol..MP..ID Qualifier...1 Qualifier...2
    ## 1                  3                       NA          <NA>            NA
    ## 2                  3                       NA          <NA>            NA
    ## 3                  3                       NA          <NA>            NA
    ## 4                  3                       NA          <NA>            NA
    ## 5                  3                       NA          <NA>            NA
    ## 6                  3                       NA          <NA>            NA
    ##   Qualifier...3 Qualifier...4 Qualifier...5 Qualifier...6 Qualifier...7
    ## 1            NA            NA            NA            NA            NA
    ## 2            NA            NA            NA            NA            NA
    ## 3            NA            NA            NA            NA            NA
    ## 4            NA            NA            NA            NA            NA
    ## 5            NA            NA            NA            NA            NA
    ## 6            NA            NA            NA            NA            NA
    ##   Qualifier...8 Qualifier...9 Qualifier...10 Alternate.Method.Detectable.Limit
    ## 1            NA            NA             NA                                NA
    ## 2            NA            NA             NA                                NA
    ## 3            NA            NA             NA                                NA
    ## 4            NA            NA             NA                                NA
    ## 5            NA            NA             NA                                NA
    ## 6            NA            NA             NA                                NA
    ##   Uncertainty
    ## 1          NA
    ## 2          NA
    ## 3          NA
    ## 4          NA
    ## 5          NA
    ## 6          NA

### Summary for 1999 data pm levels

    x99 <- pm99$Sample.Value
    class(x99)

    ## [1] "numeric"

    str(x99)

    ##  num [1:117421] NA NA NA 8.84 14.92 ...

    summary(x99)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    7.20   11.50   13.74   17.90  157.10   13217

    # Compute the proportion of missing values
    mean(is.na(x99))

    ## [1] 0.1125608

### Reading the 2012 data

    ## Reading the 2012 file 
    pm12 <- read.table("./data/RD_501_88101_2012-0.txt", 
                       comment.char = '#', 
                       header = FALSE,
                       sep = '|',
                       na.strings = '')
    dim(pm12)

    ## [1] 1304287      28

    head(pm12)

    ##   V1 V2 V3 V4 V5    V6 V7 V8  V9 V10      V11   V12 V13  V14 V15 V16  V17  V18
    ## 1 RD  I  1  3 10 88101  1  7 105 118 20120101 00:00 6.7 <NA>   3  NA <NA> <NA>
    ## 2 RD  I  1  3 10 88101  1  7 105 118 20120104 00:00 9.0 <NA>   3  NA <NA> <NA>
    ## 3 RD  I  1  3 10 88101  1  7 105 118 20120107 00:00 6.5 <NA>   3  NA <NA> <NA>
    ## 4 RD  I  1  3 10 88101  1  7 105 118 20120110 00:00 7.0 <NA>   3  NA <NA> <NA>
    ## 5 RD  I  1  3 10 88101  1  7 105 118 20120113 00:00 5.8 <NA>   3  NA <NA> <NA>
    ## 6 RD  I  1  3 10 88101  1  7 105 118 20120116 00:00 8.0 <NA>   3  NA <NA> <NA>
    ##    V19 V20 V21 V22 V23 V24 V25 V26 V27 V28
    ## 1 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 2 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 3 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 4 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 5 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA
    ## 6 <NA>  NA  NA  NA  NA  NA  NA  NA  NA  NA

    # Get the variable names from the first row of the file via readlines
    cnames <- readLines("./data/RD_501_88101_2012-0.txt", 1)
    # Split cnames via strsplit
    cnames <- strsplit(cnames, "|", fixed = TRUE)
    cnames

    ## [[1]]
    ##  [1] "# RD"                              "Action Code"                      
    ##  [3] "State Code"                        "County Code"                      
    ##  [5] "Site ID"                           "Parameter"                        
    ##  [7] "POC"                               "Sample Duration"                  
    ##  [9] "Unit"                              "Method"                           
    ## [11] "Date"                              "Start Time"                       
    ## [13] "Sample Value"                      "Null Data Code"                   
    ## [15] "Sampling Frequency"                "Monitor Protocol (MP) ID"         
    ## [17] "Qualifier - 1"                     "Qualifier - 2"                    
    ## [19] "Qualifier - 3"                     "Qualifier - 4"                    
    ## [21] "Qualifier - 5"                     "Qualifier - 6"                    
    ## [23] "Qualifier - 7"                     "Qualifier - 8"                    
    ## [25] "Qualifier - 9"                     "Qualifier - 10"                   
    ## [27] "Alternate Method Detectable Limit" "Uncertainty"

    # Assign the cnames to the dataframe names; first transform the cnames into names via makenames
    names(pm12) <- make.names(cnames[[1]])
    head(pm12)

    ##   X..RD Action.Code State.Code County.Code Site.ID Parameter POC
    ## 1    RD           I          1           3      10     88101   1
    ## 2    RD           I          1           3      10     88101   1
    ## 3    RD           I          1           3      10     88101   1
    ## 4    RD           I          1           3      10     88101   1
    ## 5    RD           I          1           3      10     88101   1
    ## 6    RD           I          1           3      10     88101   1
    ##   Sample.Duration Unit Method     Date Start.Time Sample.Value Null.Data.Code
    ## 1               7  105    118 20120101      00:00          6.7           <NA>
    ## 2               7  105    118 20120104      00:00          9.0           <NA>
    ## 3               7  105    118 20120107      00:00          6.5           <NA>
    ## 4               7  105    118 20120110      00:00          7.0           <NA>
    ## 5               7  105    118 20120113      00:00          5.8           <NA>
    ## 6               7  105    118 20120116      00:00          8.0           <NA>
    ##   Sampling.Frequency Monitor.Protocol..MP..ID Qualifier...1 Qualifier...2
    ## 1                  3                       NA          <NA>          <NA>
    ## 2                  3                       NA          <NA>          <NA>
    ## 3                  3                       NA          <NA>          <NA>
    ## 4                  3                       NA          <NA>          <NA>
    ## 5                  3                       NA          <NA>          <NA>
    ## 6                  3                       NA          <NA>          <NA>
    ##   Qualifier...3 Qualifier...4 Qualifier...5 Qualifier...6 Qualifier...7
    ## 1          <NA>            NA            NA            NA            NA
    ## 2          <NA>            NA            NA            NA            NA
    ## 3          <NA>            NA            NA            NA            NA
    ## 4          <NA>            NA            NA            NA            NA
    ## 5          <NA>            NA            NA            NA            NA
    ## 6          <NA>            NA            NA            NA            NA
    ##   Qualifier...8 Qualifier...9 Qualifier...10 Alternate.Method.Detectable.Limit
    ## 1            NA            NA             NA                                NA
    ## 2            NA            NA             NA                                NA
    ## 3            NA            NA             NA                                NA
    ## 4            NA            NA             NA                                NA
    ## 5            NA            NA             NA                                NA
    ## 6            NA            NA             NA                                NA
    ##   Uncertainty
    ## 1          NA
    ## 2          NA
    ## 3          NA
    ## 4          NA
    ## 5          NA
    ## 6          NA

### Summary for 2012 data pm levels

    x12 <- pm12$Sample.Value
    class(x12)

    ## [1] "numeric"

    str(x12)

    ##  num [1:1304287] 6.7 9 6.5 7 5.8 8 7.9 8 6 9.6 ...

    summary(x12)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -10.00    4.00    7.63    9.14   12.00  908.97   73133

    # Compute the proportion of missing values
    mean(is.na(x12))

    ## [1] 0.05607125

### Comparison between 1999 and 2012 data

    summary(x99)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    7.20   11.50   13.74   17.90  157.10   13217

    summary(x12)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -10.00    4.00    7.63    9.14   12.00  908.97   73133

    par(mfrow = c(1,2))
    boxplot(x99, x12)
    boxplot(log10(x99), log10(x12))

![](Notes4_files/figure-markdown_strict/unnamed-chunk-20-1.png)

### The negative values in 2012

    negatives <- x12 < 0
    str(negatives)

    ##  logi [1:1304287] FALSE FALSE FALSE FALSE FALSE FALSE ...

    sum(negatives, na.rm = TRUE)

    ## [1] 26474

    mean(negatives, na.rm = TRUE)

    ## [1] 0.0215034

### Dates of the measurements

    dates99 <- pm99$Date
    dates12 <- pm12$Date

    str(dates99)

    ##  int [1:117421] 19990103 19990106 19990109 19990112 19990115 19990118 19990121 19990124 19990127 19990130 ...

    class(dates99)

    ## [1] "integer"

    dates99 <- as.Date(as.character(dates99), format="%Y%m%d")
    str(dates99)

    ##  Date[1:117421], format: "1999-01-03" "1999-01-06" "1999-01-09" "1999-01-12" "1999-01-15" ...

    class(dates99)

    ## [1] "Date"

    str(dates12)

    ##  int [1:1304287] 20120101 20120104 20120107 20120110 20120113 20120116 20120119 20120122 20120125 20120128 ...

    class(dates12)

    ## [1] "integer"

    dates12 <- as.Date(as.character(dates12), format="%Y%m%d")
    str(dates12)

    ##  Date[1:1304287], format: "2012-01-01" "2012-01-04" "2012-01-07" "2012-01-10" "2012-01-13" ...

    class(dates12)

    ## [1] "Date"

### Histogram of the dates

    par(mfrow= c(1,3),
        mar = c(24,4,1,1))
    hist(dates99, 'months')
    hist(dates12, 'months')
    hist(dates12[negatives], 'months')

![](Notes4_files/figure-markdown_strict/unnamed-chunk-23-1.png)

### Exploring change at one monitor

    site99 <- unique(subset(pm99, State.Code == 36, c(County.Code, Site.ID)))
    head(site99)

    ##       County.Code Site.ID
    ## 65873           1       5
    ## 65995           1      12
    ## 66056           5      73
    ## 66075           5      80
    ## 66136           5      83
    ## 66197           5     110

    site99 <- paste(site99[,1], site99[,2], sep = '.')
    str(site99)

    ##  chr [1:33] "1.5" "1.12" "5.73" "5.80" "5.83" "5.110" "13.11" "27.1004" ...

    site12 <- unique(subset(pm12, State.Code == 36, c(County.Code, Site.ID)))
    head(site12)

    ##        County.Code Site.ID
    ## 835337           1       5
    ## 835401           1      12
    ## 835432           5      80
    ## 835463           5     133
    ## 835494          13      11
    ## 835525          29       5

    site12 <- paste(site12[,1], site12[,2], sep = '.')
    str(site12)

    ##  chr [1:18] "1.5" "1.12" "5.80" "5.133" "13.11" "29.5" "31.3" "47.122" ...

    both <- intersect(site99, site12)
    both

    ##  [1] "1.5"     "1.12"    "5.80"    "13.11"   "29.5"    "31.3"    "63.2008"
    ##  [8] "67.1015" "85.55"   "101.3"

### Number of observations per common monitors in NY

    pm99$county.site <- with(pm99, paste(County.Code, Site.ID, sep = '.'))
    # New York subset 99
    nyc99 <- subset(pm99, State.Code == 36 & county.site %in% both)
    dim(nyc99)

    ## [1] 952  29

    pm12$county.site <- with(pm12, paste(County.Code, Site.ID, sep = '.'))
    # New York subset 12
    nyc12 <- subset(pm12, State.Code == 36 & county.site %in% both)
    dim(nyc12)

    ## [1] 328  29

    sapply(split(nyc99, nyc99$county.site), nrow)

    ##    1.12     1.5   101.3   13.11    29.5    31.3    5.80 63.2008 67.1015   85.55 
    ##      61     122     152      61      61     183      61     122     122       7

    sapply(split(nyc12, nyc12$county.site), nrow)

    ##    1.12     1.5   101.3   13.11    29.5    31.3    5.80 63.2008 67.1015   85.55 
    ##      31      64      31      31      33      15      31      30      31      31

### Mean trend for monitor 63.2008

    nyc99ch <- subset(pm99, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
    nyc12ch <- subset(pm12, State.Code == 36 & County.Code == 63 & Site.ID == 2008)

    dim(nyc99ch)

    ## [1] 122  29

    dim(nyc12ch)

    ## [1] 30 29

    dates99 <- as.Date(as.character(nyc99ch$Date), "%Y%m%d")
    x99 <- nyc99ch$Sample.Value

    dates12 <- as.Date(as.character(nyc12ch$Date), "%Y%m%d")
    x12 <- nyc12ch$Sample.Value

    rng <- range(x99, x12, na.rm = T)
    par(mfrow = c(1,2),
        mar = c(5,4,1,1))
    plot(dates99, x99, pch = 20, ylim  = rng)
    abline(h = median(x99, na.rm = T))
    plot(dates12, x12,  pch = 20, ylim  = rng)
    abline(h = median(x12, na.rm = T))

![](Notes4_files/figure-markdown_strict/unnamed-chunk-28-1.png)

### Exploring change in a state

    mn99 <- with(pm99, tapply(Sample.Value, State.Code, mean, na.rm = T))
    str(mn99)

    ##  num [1:53(1d)] 19.96 6.67 10.8 15.68 17.66 ...
    ##  - attr(*, "dimnames")=List of 1
    ##   ..$ : chr [1:53] "1" "2" "4" "5" ...

    summary(mn99)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   4.862   9.519  12.315  12.406  15.640  19.956

    mn12 <- with(pm12, tapply(Sample.Value, State.Code, mean, na.rm = T))
    str(mn12)

    ##  num [1:52(1d)] 10.13 4.75 8.61 10.56 9.28 ...
    ##  - attr(*, "dimnames")=List of 1
    ##   ..$ : chr [1:52] "1" "2" "4" "5" ...

    summary(mn12)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   4.006   7.355   8.729   8.759  10.613  11.992

    df99 <- data.frame(state = names(mn99), mean99 = mn99)
    head(df99)

    ##   state    mean99
    ## 1     1 19.956391
    ## 2     2  6.665929
    ## 4     4 10.795547
    ## 5     5 15.676067
    ## 6     6 17.655412
    ## 8     8  7.533304

    df12 <- data.frame(state = names(mn12), mean12 = mn12)
    head(df99)

    ##   state    mean99
    ## 1     1 19.956391
    ## 2     2  6.665929
    ## 4     4 10.795547
    ## 5     5 15.676067
    ## 6     6 17.655412
    ## 8     8  7.533304

    df <- merge(df99, df12, by = 'state')
    head(df)

    ##   state    mean99    mean12
    ## 1     1 19.956391 10.126190
    ## 2    10 14.492895 11.236059
    ## 3    11 15.786507 11.991697
    ## 4    12 11.137139  8.239690
    ## 5    13 19.943240 11.321364
    ## 6    15  4.861821  8.749336

    rng <- range(df[, 2], df[, 3])
    par(mfrow = c(1,1))
    with(df, plot(rep(1999, 52), df[, 2], xlim = c(1998, 2013), ylim = rng))
    with(df, points(rep(2012, 52), df[, 3]), ylim = rng)
    segments(rep(1999, 52), df[, 2], rep(2012, 52), df[, 3])

![](Notes4_files/figure-markdown_strict/unnamed-chunk-30-1.png)
