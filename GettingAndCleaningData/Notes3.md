# Organizing, merging and managing the data - Week 3 Notes

## 1. Subsetting and Sorting

### 1.1 Subsetting - a quick review

Creating a dummy dataframe for exemplification of the basic subsetting
commands. The dataframe is created via the `data.frame()` function and
some `NA` values will be inserted in order to show how the subsetting
procedures for handling `NA` values are done.

    # Setting the seed for reproducibility 
    set.seed(13545)
    # A dataframe with three variables (columns) and seven observations (rows)
    df <- data.frame('var1' = sample(1:7),
                     'var2' = sample(8:14),
                     'var3' = sample(15:21))
    df

    ##   var1 var2 var3
    ## 1    5   10   19
    ## 2    6   12   17
    ## 3    7    8   20
    ## 4    1   13   18
    ## 5    4   14   16
    ## 6    3   11   15
    ## 7    2    9   21

    # Swaping the rows of the dataframe based on the `sample(1:7)` result
    df <- df[sample(1:7), ]
    df

    ##   var1 var2 var3
    ## 2    6   12   17
    ## 3    7    8   20
    ## 5    4   14   16
    ## 4    1   13   18
    ## 6    3   11   15
    ## 1    5   10   19
    ## 7    2    9   21

    # Inserting `NA` values in the second column (var2) for the first, third and fifth observations (row 1, 3 and 5).
    df$var2[c(1, 3, 5)] = NA
    df

    ##   var1 var2 var3
    ## 2    6   NA   17
    ## 3    7    8   20
    ## 5    4   NA   16
    ## 4    1   13   18
    ## 6    3   NA   15
    ## 1    5   10   19
    ## 7    2    9   21

Selecting a column can be done by considering (all the rows of the data
frame and) the column’s position index (i.e 1 for the first column, 2
for the second column, etc):

    df[, 1] # Selecting the first column of the dataframe by using its position index

    ## [1] 6 7 4 1 3 5 2

    i = sample(ncol(df), 1)
    i

    ## [1] 3

    df[, i] # Selecting a randomly chosen column index of the dataframe

    ## [1] 17 20 16 18 15 19 21

Selecting multiple columns can be done by considering (all the rows of
the data frame and) the column’s position indices:

    df[, c(1,3)] # Selecting the first and third column of the dataframe by using the column's position indices

    ##   var1 var3
    ## 2    6   17
    ## 3    7   20
    ## 5    4   16
    ## 4    1   18
    ## 6    3   15
    ## 1    5   19
    ## 7    2   21

    i = sample(ncol(df), 2)
    i

    ## [1] 3 2

    df[,i] # Selecting two randomly chosen column index of the dataframe

    ##   var3 var2
    ## 2   17   NA
    ## 3   20    8
    ## 5   16   NA
    ## 4   18   13
    ## 6   15   NA
    ## 1   19   10
    ## 7   21    9

Selecting a column or multiple columns can be done via the column’s
names, using the names instead of the indices. Note that the name has to
be passed in quotes:

    df[,"var1"] # Selecting the column with name "var1"

    ## [1] 6 7 4 1 3 5 2

    i = sample(names(df), 1)
    i

    ## [1] "var1"

    df[,i] # Selecting a randomly chosen column name of the dataframe

    ## [1] 6 7 4 1 3 5 2

    df[,c("var1","var2")] # Selecting the columns with name "var1" and "var2"

    ##   var1 var2
    ## 2    6   NA
    ## 3    7    8
    ## 5    4   NA
    ## 4    1   13
    ## 6    3   NA
    ## 1    5   10
    ## 7    2    9

    i = sample(names(df), 2)
    i

    ## [1] "var1" "var2"

    df[,i] # Selecting two randomly chosen column names of the dataframe

    ##   var1 var2
    ## 2    6   NA
    ## 3    7    8
    ## 5    4   NA
    ## 4    1   13
    ## 6    3   NA
    ## 1    5   10
    ## 7    2    9

Selecting a row or multiple rows and a column or multiple columns can be
done via row position indices and the column’s position indices or names

    df[4:6,2:3] # Selecting the fourth, fifth and sixth row and the second and third column

    ##   var2 var3
    ## 4   13   18
    ## 6   NA   15
    ## 1   10   19

    i = sample(nrow(df), 5)
    j = sample(ncol(df), 2)
    df[i,j] # Selecting a randomly chosen column name of the dataframe

    ##   var3 var2
    ## 3   20    8
    ## 7   21    9
    ## 5   16   NA
    ## 4   18   13
    ## 1   19   10

    df[3:4, c("var1","var3")] # Selecting the third and fourth rows and the columns with name "var1" and "var3"

    ##   var1 var3
    ## 5    4   16
    ## 4    1   18

    i = sample(nrow(df), 3)
    j = sample(names(df), 2)
    df[i,j] # Selecting three randomly chosen rows and two randomly column names of the dataframe

    ##   var3 var2
    ## 1   19   10
    ## 7   21    9
    ## 5   16   NA

### 1.2 Logical ands & logical ors

Subsetting based on conditions applied on row(s) or column(s) values can
be done by evaluation the conditons using the logical and and the
logical or.

Subsetting the dataframe that has the values of the first variable
(i.e.the first column) smaller or equal than 3 (i.e `df$var1 <= 3` or
`df[,"var1"] <= 3`) *and* the values of the thrid variable (i.e.the
third column) greater than 11 (i.e `df$var3 > 11` or `df[,"var1"] > 11`)
is done by considering the logical and (i.e. `&`) between the two
conditions to select the corresponding rows that fulfil both conditions
(i.e. the rows for which the first column has values greater or equal
than three and the for which the third column has values smaller than
eleven.)

    df[(df$var1 <= 3 & df$var3 > 11), ]

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 6    3   NA   15
    ## 7    2    9   21

The corresponding subsetting using the column indices:

    df[(df[, 1] <= 3 & df[, 3] > 11), ]

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 6    3   NA   15
    ## 7    2    9   21

Subsetting the dataframe that has the values of the first variable
smaller or equal than 3 *or* the values of the thrid variable greater
than 15 is done by consideriong the logical or (i.e. `|`)

    df[(df$var1 <= 3 & df$var3 > 15), ]

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 7    2    9   21

    df[(df[, 1] <= 3 & df[, 3] > 15), ]

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 7    2    9   21

### 1.3 Dealing with missing values (`NA`s)

Dealing with missing values (i.e. `NA`s) requires the use of the `which`
or `complete.cases()` functions.

. This stems for the fact that the logical (TRUE/FALSE) vector that is
returned by logical evaluations over non-missing values (i.e. no `NA`s)
does not work with logical values.

For the values corresponding to the first column of the dataframe (which
does not contain any missing values) the logical evaluation returns a
TRUE/FALSE vector:

    df$var1 <= 3 

    ## [1] FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE

But for the values corresponding to the second column of the dataframe
(which contains missing values) the result contains missing values,
i.e. it is not a binary TRUE/FALSE vector:

    df$var2 <= 10 

    ## [1]    NA  TRUE    NA FALSE    NA  TRUE  TRUE

Therefore, if we try to select the dataframe for which the second
column’s values (which contains `NA`s) are smaller or equal than ten
using the logical expressions, it won’t work.

    df[df$var2 <= 10, ]

    ##      var1 var2 var3
    ## NA     NA   NA   NA
    ## 3       7    8   20
    ## NA.1   NA   NA   NA
    ## NA.2   NA   NA   NA
    ## 1       5   10   19
    ## 7       2    9   21

Using the `which()` function returns a vector with the positions
corresponding to the TRUE positions in the logical vector, i.e. not
accounting for the presence of `NA` values:

    which(df$var2 <= 10)

    ## [1] 2 6 7

Selecting the dataframe for which the second column’s values (which
contains `NA`s) are smaller or equal than ten is done using `which()`
function, applied on the logical condition:

    df[which(df$var2 <= 10), ]

    ##   var1 var2 var3
    ## 3    7    8   20
    ## 1    5   10   19
    ## 7    2    9   21

Another way is to use the `complete.cases()` function. The function,
applied over a vector containing `NA` values will return `FALSE` for the
`NA` corresponding positions:

    complete.cases(c(1,2,NA,4,5))

    ## [1]  TRUE  TRUE FALSE  TRUE  TRUE

    complete.cases(c('a','b',NA,'d'))

    ## [1]  TRUE  TRUE FALSE  TRUE

    complete.cases(df$var2 <= 10)

    ## [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE

    df[complete.cases(df$var2 <= 10), ]

    ##   var1 var2 var3
    ## 3    7    8   20
    ## 4    1   13   18
    ## 1    5   10   19
    ## 7    2    9   21

The `NA` values in a column can be detected via the `is.na()` function:

    is.na(df$var2)

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE

Subsetting the dataframe that does not contain the missing values from a
column is done by using `!is.na()`:

    df[!is.na(df$var2),]

    ##   var1 var2 var3
    ## 3    7    8   20
    ## 4    1   13   18
    ## 1    5   10   19
    ## 7    2    9   21

For multiple columns:

    df2 <- data.frame("var1" = c(1,2,NA,4),
                      "var2" = c(5,NA,7,8),
                      "var3" = c(9,10,11,12),
                      "var4" = c(13,14,15,NA))
    df2

    ##   var1 var2 var3 var4
    ## 1    1    5    9   13
    ## 2    2   NA   10   14
    ## 3   NA    7   11   15
    ## 4    4    8   12   NA

    # removing the NA values form the first two columns of the data frame
    df2[(!is.na(df2[,1]) & !is.na(df2[,2])),]

    ##   var1 var2 var3 var4
    ## 1    1    5    9   13
    ## 4    4    8   12   NA

Removing *all* the `NA` values in a dataframe is done via `na.omit()`
function:

    na.omit(df2)

    ##   var1 var2 var3 var4
    ## 1    1    5    9   13

### 1.4 Sorting & ordering

Sorting the values in a column can be done via the function `sort()`.
Sorting the dataframe based on the values in a column can be done via
the `order()` function.

    sort(df$var1)

    ## [1] 1 2 3 4 5 6 7

    df$var1[order(df$var1)]

    ## [1] 1 2 3 4 5 6 7

    df[order(df$var1),]

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 7    2    9   21
    ## 6    3   NA   15
    ## 5    4   NA   16
    ## 1    5   10   19
    ## 2    6   NA   17
    ## 3    7    8   20

    df[order(df$var1,df$var3),] # This sorts first the first variable and then if there are multiple values of variable 1 that are the same will sort the variable in the variable 3 within those variables.

    ##   var1 var2 var3
    ## 4    1   13   18
    ## 7    2    9   21
    ## 6    3   NA   15
    ## 5    4   NA   16
    ## 1    5   10   19
    ## 2    6   NA   17
    ## 3    7    8   20

The sorting can be done in decreasing order.

    sort(df$var3, decreasing = TRUE)

    ## [1] 21 20 19 18 17 16 15

    df$var1[order(df$var1, decreasing = TRUE)]

    ## [1] 7 6 5 4 3 2 1

    df[order(df$var1, decreasing = TRUE),]

    ##   var1 var2 var3
    ## 3    7    8   20
    ## 2    6   NA   17
    ## 1    5   10   19
    ## 5    4   NA   16
    ## 6    3   NA   15
    ## 7    2    9   21
    ## 4    1   13   18

The sorting can be done such that the missing values are at the end.

    sort(df$var2, na.last = TRUE)

    ## [1]  8  9 10 13 NA NA NA

    df$var1[order(df$var2, na.last = TRUE)]

    ## [1] 7 2 5 1 6 4 3

    df[order(df$var2, na.last = TRUE),]

    ##   var1 var2 var3
    ## 3    7    8   20
    ## 7    2    9   21
    ## 1    5   10   19
    ## 4    1   13   18
    ## 2    6   NA   17
    ## 5    4   NA   16
    ## 6    3   NA   15

### 1.5 Ordering with the `plyr` library

The ordering can be done using the `plyr` library.

    library(plyr)
    arrange(df, var1) # The syntax here is using the column/variable name without the quotation symbol

    ##   var1 var2 var3
    ## 1    1   13   18
    ## 2    2    9   21
    ## 3    3   NA   15
    ## 4    4   NA   16
    ## 5    5   10   19
    ## 6    6   NA   17
    ## 7    7    8   20

    arrange(df, desc(var1))

    ##   var1 var2 var3
    ## 1    7    8   20
    ## 2    6   NA   17
    ## 3    5   10   19
    ## 4    4   NA   16
    ## 5    3   NA   15
    ## 6    2    9   21
    ## 7    1   13   18

### 1.6 Adding rows & columns to a dataframe

Adding a new column to a dataframe can be done by directly adding a new
column or via the `cbind()` function.

    df$var4 <- rnorm(7)
    df$var5 <- df$var3 + df$var4
    df

    ##   var1 var2 var3       var4     var5
    ## 2    6   NA   17 -0.1165139 16.88349
    ## 3    7    8   20  1.1653121 21.16531
    ## 5    4   NA   16 -1.1360704 14.86393
    ## 4    1   13   18 -0.9065470 17.09345
    ## 6    3   NA   15 -1.0673648 13.93264
    ## 1    5   10   19 -0.6216694 18.37833
    ## 7    2    9   21 -1.1620808 19.83792

    df <- cbind(df, var6 = rpois(7,2))
    df

    ##   var1 var2 var3       var4     var5 var6
    ## 2    6   NA   17 -0.1165139 16.88349    1
    ## 3    7    8   20  1.1653121 21.16531    4
    ## 5    4   NA   16 -1.1360704 14.86393    1
    ## 4    1   13   18 -0.9065470 17.09345    0
    ## 6    3   NA   15 -1.0673648 13.93264    1
    ## 1    5   10   19 -0.6216694 18.37833    0
    ## 7    2    9   21 -1.1620808 19.83792    4

## 2. Summarizing Data

The standard procedure for downloading the data via an *url* is the
following:

1.  Check if a *data* directory exitst in the workingspace and if not,
    created it:

<center>
`if(!file.exists("./data"))dir.create("./data")`
</center>

1.  Create a variable `fileUrl` with the link to the data:

<center>
`fileUrl <- 'https://link-to-the-data'`
</center>

1.  Download the file via the `download.file()`command using the the
    variable `fileUrl` into the *data* directory. For MAC, set the
    method to `method = 'curl'`:

<center>
`download.file(fileUrl, destfile = './data/name-of-the-file.csv', method = 'curl')`
</center>

1.  Read the downloaded file into a data frame via `read.csv()` if the
    file is a *.csv* file or `read.table()`:

<center>
`df <- read.csv("./data/name-of-the-file.csv")`
</center>

    if(!file.exists("./data")){
      dir.create("./data")
    }
    fileUrl <- 'https://gist.githubusercontent.com/slowteetoe/528c78213fcd80f05419/raw/e0a4a89476fca79e692df1a373e5025f5112a5f6/restaurants.csv'
    download.file(fileUrl, 
                  destfile = './data/restaurants.csv',
                  method = 'curl')
    df <- read.csv("./data/restaurants.csv")

    df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], as.factor) # transforming all non-numeric columns into factors.

### Looking at a bit of the data

Checking the dataframe dimension is done via the `dim()` function. The
number of rows is obtained via the `nrow()` function, the number of
columns via the `ncol()` function. The names of variables (i.e. the
column names) is obtained via `names()` function.

    dim(df) # dataframe dimension

    ## [1] 1327    6

    nrow(df) # dataframe's number of rows

    ## [1] 1327

    ncol(df) # dataframe's number of columns

    ## [1] 6

    names(df) # dataframe's variable names

    ## [1] "name"            "zipCode"         "neighborhood"    "councilDistrict"
    ## [5] "policeDistrict"  "Location.1"

Checking the first rows of the dataframe is done via the `head()`
function:

    head(df, n = 5) # the first 5 rows of the dataframe

    ##                    name zipCode neighborhood councilDistrict policeDistrict
    ## 1                   410   21206    Frankford               2   NORTHEASTERN
    ## 2                  1919   21231  Fells Point               1   SOUTHEASTERN
    ## 3                 SAUTE   21224       Canton               1   SOUTHEASTERN
    ## 4    #1 CHINESE KITCHEN   21211      Hampden              14       NORTHERN
    ## 5 #1 chinese restaurant   21223     Millhill               9   SOUTHWESTERN
    ##                            Location.1
    ## 1   4509 BELAIR ROAD\nBaltimore, MD\n
    ## 2      1919 FLEET ST\nBaltimore, MD\n
    ## 3     2844 HUDSON ST\nBaltimore, MD\n
    ## 4    3998 ROLAND AVE\nBaltimore, MD\n
    ## 5 2481 frederick ave\nBaltimore, MD\n

Checking the last rows of the dataframe is done via the `tail()`
function:

    tail(df, n = 5) # the last 5 rows of the dataframe

    ##                           name zipCode    neighborhood councilDistrict
    ## 1323 ZEN WEST ROADSIDE CANTINA   21212        Rosebank               4
    ## 1324                   ZIASCOS   21231 Washington Hill               1
    ## 1325          ZINK'S CAF\u0090   21213   Belair-Edison              13
    ## 1326              ZISSIMOS BAR   21211         Hampden               7
    ## 1327                    ZORBAS   21224       Greektown               2
    ##      policeDistrict                         Location.1
    ## 1323       NORTHERN      5916 YORK RD\nBaltimore, MD\n
    ## 1324   SOUTHEASTERN     1313 PRATT ST\nBaltimore, MD\n
    ## 1325   NORTHEASTERN 3300 LAWNVIEW AVE\nBaltimore, MD\n
    ## 1326       NORTHERN      1023 36TH ST\nBaltimore, MD\n
    ## 1327   SOUTHEASTERN  4710 EASTERN Ave\nBaltimore, MD\n

A summary of the dataframe is obtained via the `summary()` function. The
functions returns informations about each variable in the dataframe: 1.
If the variable is categorical (i.e factor, can appear in the dataframe
as text-based variable) the summary function gives the count 2. If the
variables are quantitative, the summary function gives the minimum, 1st
quantile, median, 3rd quantile and the maximum.

    summary(df) # the summary of the dataframe

    ##                            name         zipCode             neighborhood
    ##  MCDONALD'S                  :   8   Min.   :-21226   Downtown    :128  
    ##  POPEYES FAMOUS FRIED CHICKEN:   7   1st Qu.: 21202   Fells Point : 91  
    ##  SUBWAY                      :   6   Median : 21218   Inner Harbor: 89  
    ##  KENTUCKY FRIED CHICKEN      :   5   Mean   : 21185   Canton      : 81  
    ##  BURGER KING                 :   4   3rd Qu.: 21226   Federal Hill: 42  
    ##  DUNKIN DONUTS               :   4   Max.   : 21287   Mount Vernon: 33  
    ##  (Other)                     :1293                    (Other)     :863  
    ##  councilDistrict       policeDistrict                        Location.1      
    ##  Min.   : 1.000   SOUTHEASTERN:385    1101 RUSSELL ST\nBaltimore, MD\n:   9  
    ##  1st Qu.: 2.000   CENTRAL     :288    201 PRATT ST\nBaltimore, MD\n   :   8  
    ##  Median : 9.000   SOUTHERN    :213    2400 BOSTON ST\nBaltimore, MD\n :   8  
    ##  Mean   : 7.191   NORTHERN    :157    300 LIGHT ST\nBaltimore, MD\n   :   5  
    ##  3rd Qu.:11.000   NORTHEASTERN: 72    300 CHARLES ST\nBaltimore, MD\n :   4  
    ##  Max.   :14.000   EASTERN     : 67    301 LIGHT ST\nBaltimore, MD\n   :   4  
    ##                   (Other)     :145    (Other)                         :1289

A short description of the dataframe is obtained via the `str()`
function, which gives informations about the number of obervations,
number of variables and each variable class (e.g. factor, int,
character, etc…)

    str(df) # the description of the data

    ## 'data.frame':    1327 obs. of  6 variables:
    ##  $ name           : Factor w/ 1277 levels "#1 CHINESE KITCHEN",..: 9 3 992 1 2 4 5 6 7 8 ...
    ##  $ zipCode        : int  21206 21231 21224 21211 21223 21218 21205 21211 21205 21231 ...
    ##  $ neighborhood   : Factor w/ 173 levels "Abell","Arlington",..: 53 52 18 66 104 33 98 133 98 157 ...
    ##  $ councilDistrict: int  2 1 1 14 9 14 13 7 13 1 ...
    ##  $ policeDistrict : Factor w/ 9 levels "CENTRAL","EASTERN",..: 3 6 6 4 8 3 6 4 6 6 ...
    ##  $ Location.1     : Factor w/ 1210 levels "1 BIDDLE ST\nBaltimore, MD\n",..: 835 334 554 755 492 537 505 530 507 569 ...

### Data counts, spread & tables

The counts of a variable values is can be done with `table()` function
and the spread of a variable with via the `quantile()` function.

    table(df$councilDistrict)

    ## 
    ##   1   2   3   4   5   6   7   8   9  10  11  12  13  14 
    ## 312  85  32  30  40  36  62  18  75 172 277  89  45  54

    table(df$zipCode, useNA = 'ifany') # here the missing values are also considered and counted. By default, the missing values are not considedred by the table function.

    ## 
    ## -21226  21201  21202  21205  21206  21207  21208  21209  21210  21211  21212 
    ##      1    136    201     27     30      4      1      8     23     41     28 
    ##  21213  21214  21215  21216  21217  21218  21220  21222  21223  21224  21225 
    ##     31     17     54     10     32     69      1      7     56    199     19 
    ##  21226  21227  21229  21230  21231  21234  21237  21239  21251  21287 
    ##     18      4     13    156    127      7      1      3      2      1

    quantile(df$councilDistrict, na.rm = TRUE) # the spread of the variable "councilDistrict" from the dataframe

    ##   0%  25%  50%  75% 100% 
    ##    1    2    9   11   14

    quantile(df$councilDistrict, probs = c(0.5, 0.75, 0.9))

    ## 50% 75% 90% 
    ##   9  11  12

The `table()` function can be used to compute contingency tables, i.e
tables with counts at each combination of the (categorical) variables.

    table(df$councilDistrict, df$zipCode)[1:10,1:10] # this computes the table counting the restaurants of each councilDistrict in each zipCode

    ##     
    ##      -21226 21201 21202 21205 21206 21207 21208 21209 21210 21211
    ##   1       0     0    37     0     0     0     0     0     0     0
    ##   2       0     0     0     3    27     0     0     0     0     0
    ##   3       0     0     0     0     0     0     0     0     0     0
    ##   4       0     0     0     0     0     0     0     0     0     0
    ##   5       0     0     0     0     0     3     0     6     0     0
    ##   6       0     0     0     0     0     0     0     1    19     0
    ##   7       0     0     0     0     0     0     0     1     0    27
    ##   8       0     0     0     0     0     1     0     0     0     0
    ##   9       0     1     0     0     0     0     0     0     0     0
    ##   10      1     0     1     0     0     0     0     0     0     0

### Check for missing values

The number of missing values for a variable (i.e. a column):

    sum(is.na(df$councilDistrict))

    ## [1] 0

Checking if a variable has missing values:

    any(is.na(df$councilDistrict))

    ## [1] FALSE

Checking a conditon for a variable (i.e. a column) e.g. if all values of
the *zipCode* variable are postive:

    any(df$zipCode < 0)

    ## [1] TRUE

### Row and column sums

Checking all variables for missing values

    colSums(is.na(df))

    ##            name         zipCode    neighborhood councilDistrict  policeDistrict 
    ##               0               0               0               0               0 
    ##      Location.1 
    ##               0

Checking if there is at least one missing value in the dataframe

    all(colSums(is.na(df))==0)

    ## [1] TRUE

### Values with specific characteristics

The observations which have a variable *var* falling in a subset
*subset* of values (i.e. the row numbers)

<center>
which(df$var %in% subset)
</center>

the number of observations that fall in that subset vs. the number of
observations outside the subset

<center>
table(df$var %in% subset)
</center>

and the dataframe subset corresponding to those observations

<center>
df\[df$var %in% subset,\]
</center>

    which(df$zipCode %in% c("21212", "21213"))

    ##  [1]   29   39   92  111  187  220  266  276  289  291  362  373  383  417  475
    ## [16]  545  604  616  620  626  678  711  763  777  779  845  852  873  895  919
    ## [31]  940  949  957  976  994 1017 1018 1022 1053 1120 1122 1153 1155 1159 1186
    ## [46] 1187 1198 1209 1232 1246 1259 1287 1298 1304 1312 1319 1320 1323 1325

    table(df$zipCode %in% c("21212", "21213"))

    ## 
    ## FALSE  TRUE 
    ##  1268    59

    head(df[df$zipCode %in% c("21212", "21213"),])

    ##                           name zipCode              neighborhood
    ## 29           BAY ATLANTIC CLUB   21212                  Downtown
    ## 39                 BERMUDA BAR   21213             Broadway East
    ## 92                   ATWATER'S   21212 Chinquapin Park-Belvedere
    ## 111 BALTIMORE ESTONIAN SOCIETY   21213        South Clifton Park
    ## 187                   CAFE ZEN   21212                  Rosebank
    ## 220        CERIELLO FINE FOODS   21212 Chinquapin Park-Belvedere
    ##     councilDistrict policeDistrict                         Location.1
    ## 29               11        CENTRAL    206 REDWOOD ST\nBaltimore, MD\n
    ## 39               12        EASTERN    1801 NORTH AVE\nBaltimore, MD\n
    ## 92                4       NORTHERN 529 BELVEDERE AVE\nBaltimore, MD\n
    ## 111              12        EASTERN    1932 BELAIR RD\nBaltimore, MD\n
    ## 187               4       NORTHERN 438 BELVEDERE AVE\nBaltimore, MD\n
    ## 220               4       NORTHERN 529 BELVEDERE AVE\nBaltimore, MD\n

### Cross tabs

The summary of the UC Berkley admissions data set:

    data("UCBAdmissions")
    df <- as.data.frame(UCBAdmissions)
    summary(df)

    ##       Admit       Gender   Dept       Freq      
    ##  Admitted:12   Male  :12   A:4   Min.   :  8.0  
    ##  Rejected:12   Female:12   B:4   1st Qu.: 80.0  
    ##                            C:4   Median :170.0  
    ##                            D:4   Mean   :188.6  
    ##                            E:4   3rd Qu.:302.5  
    ##                            F:4   Max.   :512.0

    xt <- xtabs(Freq ~ Gender + Admit, data = df)
    xt

    ##         Admit
    ## Gender   Admitted Rejected
    ##   Male       1198     1493
    ##   Female      557     1278

Multiple cross tables when the variable of interest is broken by more
than two variables:

    # The header of the "warpbreaks" dataframe
    head(warpbreaks)

    ##   breaks wool tension
    ## 1     26    A       L
    ## 2     30    A       L
    ## 3     54    A       L
    ## 4     25    A       L
    ## 5     70    A       L
    ## 6     52    A       L

    # Adding a "replicate" variable to the dataframe
    warpbreaks$replicate <- rep(1:9, len = 54)
    # The cross tabs of breaks, broken by all other  variables (leading to multiple tables) 
    xt <- xtabs(breaks ~ ., data = warpbreaks)
    xt

    ## , , replicate = 1
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 26 18 36
    ##    B 27 42 20
    ## 
    ## , , replicate = 2
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 30 21 21
    ##    B 14 26 21
    ## 
    ## , , replicate = 3
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 54 29 24
    ##    B 29 19 24
    ## 
    ## , , replicate = 4
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 25 17 18
    ##    B 19 16 17
    ## 
    ## , , replicate = 5
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 70 12 10
    ##    B 29 39 13
    ## 
    ## , , replicate = 6
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 52 18 43
    ##    B 31 28 15
    ## 
    ## , , replicate = 7
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 51 35 28
    ##    B 41 21 15
    ## 
    ## , , replicate = 8
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 26 30 15
    ##    B 20 39 16
    ## 
    ## , , replicate = 9
    ## 
    ##     tension
    ## wool  L  M  H
    ##    A 67 36 26
    ##    B 44 29 28

### Flat tables

    ftable(xt)

    ##              replicate  1  2  3  4  5  6  7  8  9
    ## wool tension                                     
    ## A    L                 26 30 54 25 70 52 51 26 67
    ##      M                 18 21 29 17 12 18 35 30 36
    ##      H                 36 21 24 18 10 43 28 15 26
    ## B    L                 27 14 29 19 29 31 41 20 44
    ##      M                 42 26 19 16 39 28 21 39 29
    ##      H                 20 21 24 17 13 15 15 16 28

### Size of a data set

The size of an object can obtained via the `object.size()` function.

    data <- rnorm(1e6)
    object.size(data)

    ## 8000048 bytes

    print(object.size(data), units = 'Mb')

    ## 7.6 Mb

## 3. Creating New Variables

Why create new variables?

-   Often the raw data won’t have a variable you are looking for &
    you’ll need to transform the data to get the variables you want
-   Usually this is done by adding these variables to the data frame you
    are working with
-   Common variables to create:
    -   Missingness indicators
    -   “Cutting up” quantitative variables
    -   Applying transformations

Loading the Baltimore database restaurants *.csv* file:

    # Checking if the "./data" directory exists in the working space and creating it if it does not exist
    if(!file.exists('./data')){
      dir.create('./data')
    }
    # The link is saved in the "fileUrl" variable
    fileUrl <- 'https://gist.githubusercontent.com/slowteetoe/528c78213fcd80f05419/raw/e0a4a89476fca79e692df1a373e5025f5112a5f6/restaurants.csv'
    # The csv file is downloaded in the "./data" directory via the link
    download.file(fileUrl, 
                  destfile = './data/restaurants.csv',
                  method = 'curl'
                  )
    # The downloaded .csv file is read into the df variable as a dataframe
    df <- read.csv('./data/restaurants.csv')
    # A short description of the dataframe
    str(df)

    ## 'data.frame':    1327 obs. of  6 variables:
    ##  $ name           : chr  "410" "1919" "SAUTE" "#1 CHINESE KITCHEN" ...
    ##  $ zipCode        : int  21206 21231 21224 21211 21223 21218 21205 21211 21205 21231 ...
    ##  $ neighborhood   : chr  "Frankford" "Fells Point" "Canton" "Hampden" ...
    ##  $ councilDistrict: int  2 1 1 14 9 14 13 7 13 1 ...
    ##  $ policeDistrict : chr  "NORTHEASTERN" "SOUTHEASTERN" "SOUTHEASTERN" "NORTHERN" ...
    ##  $ Location.1     : chr  "4509 BELAIR ROAD\nBaltimore, MD\n" "1919 FLEET ST\nBaltimore, MD\n" "2844 HUDSON ST\nBaltimore, MD\n" "3998 ROLAND AVE\nBaltimore, MD\n" ...

    # The charcater variables are transformed into factors
    #df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], as.factor)
    str(df)

    ## 'data.frame':    1327 obs. of  6 variables:
    ##  $ name           : chr  "410" "1919" "SAUTE" "#1 CHINESE KITCHEN" ...
    ##  $ zipCode        : int  21206 21231 21224 21211 21223 21218 21205 21211 21205 21231 ...
    ##  $ neighborhood   : chr  "Frankford" "Fells Point" "Canton" "Hampden" ...
    ##  $ councilDistrict: int  2 1 1 14 9 14 13 7 13 1 ...
    ##  $ policeDistrict : chr  "NORTHEASTERN" "SOUTHEASTERN" "SOUTHEASTERN" "NORTHERN" ...
    ##  $ Location.1     : chr  "4509 BELAIR ROAD\nBaltimore, MD\n" "1919 FLEET ST\nBaltimore, MD\n" "2844 HUDSON ST\nBaltimore, MD\n" "3998 ROLAND AVE\nBaltimore, MD\n" ...

### Creating sequences

Sequences are created in order to index different operations that will
be done on the data.

Creating a sequence from 1 to 10 with step 2:

    s1 <- seq(1, 10, by = 2)
    s1

    ## [1] 1 3 5 7 9

Creating a sequence from 1 to 10 with length 3 and length 13
respectively:

    s2 <- seq(1, 10, length = 3)
    s2

    ## [1]  1.0  5.5 10.0

    s3 <- seq(1, 10, length = 13)
    s3

    ##  [1]  1.00  1.75  2.50  3.25  4.00  4.75  5.50  6.25  7.00  7.75  8.50  9.25
    ## [13] 10.00

    x <- c(1, 3, 8, 25, 100)
    seq(along = x)

    ## [1] 1 2 3 4 5

    seq_along(x)

    ## [1] 1 2 3 4 5

### Subsetting variables

    # Adding a TRUE/FALSE variable in the dataframe with the restaurants that are in "Roland Park" and "Homeland".
    df$nearMe <- df$neighborhood %in% c("Roland Park", "Homeland")
    head(df)

    ##                    name zipCode neighborhood councilDistrict policeDistrict
    ## 1                   410   21206    Frankford               2   NORTHEASTERN
    ## 2                  1919   21231  Fells Point               1   SOUTHEASTERN
    ## 3                 SAUTE   21224       Canton               1   SOUTHEASTERN
    ## 4    #1 CHINESE KITCHEN   21211      Hampden              14       NORTHERN
    ## 5 #1 chinese restaurant   21223     Millhill               9   SOUTHWESTERN
    ## 6             19TH HOLE   21218 Clifton Park              14   NORTHEASTERN
    ##                            Location.1 nearMe
    ## 1   4509 BELAIR ROAD\nBaltimore, MD\n  FALSE
    ## 2      1919 FLEET ST\nBaltimore, MD\n  FALSE
    ## 3     2844 HUDSON ST\nBaltimore, MD\n  FALSE
    ## 4    3998 ROLAND AVE\nBaltimore, MD\n  FALSE
    ## 5 2481 frederick ave\nBaltimore, MD\n  FALSE
    ## 6    2722 HARFORD RD\nBaltimore, MD\n  FALSE

    table(df$nearMe)

    ## 
    ## FALSE  TRUE 
    ##  1314    13

### Creating binay variables

Binary variables can be obtained using the `ifelse` function.

    df$zipWrong <- ifelse(df$zipCode < 0, TRUE, FALSE)
    table(df$zipWrong)

    ## 
    ## FALSE  TRUE 
    ##  1326     1

### Creating categorical variables

Categorical variables can be obtained using the `cut()` function

    df$zipGroups <- cut(df$zipCode, breaks = quantile(df$zipCode))
    table(df$zipGroups)

    ## 
    ## (-2.123e+04,2.12e+04]  (2.12e+04,2.122e+04] (2.122e+04,2.123e+04] 
    ##                   337                   375                   282 
    ## (2.123e+04,2.129e+04] 
    ##                   332

    table(df$zipGroups, df$zipCode)[1:4,1:6]

    ##                        
    ##                         -21226 21201 21202 21205 21206 21207
    ##   (-2.123e+04,2.12e+04]      0   136   201     0     0     0
    ##   (2.12e+04,2.122e+04]       0     0     0    27    30     4
    ##   (2.122e+04,2.123e+04]      0     0     0     0     0     0
    ##   (2.123e+04,2.129e+04]      0     0     0     0     0     0

Cutting can be done via the `Hmisc` library. The `cut2()` functions from
the `Hmisc` library can specify the number of groups according to the
quantiles.

    library(Hmisc)
    df$zipGroups <- cut2(df$zipCode, g = 4)
    table(df$zipGroups)

    ## 
    ## [-21226,21205) [ 21205,21220) [ 21220,21227) [ 21227,21287] 
    ##            338            375            300            314

### Creating factor variables

Using the function `factor` to create factor variables.

    df$zipFactor <- factor(df$zipCode)
    df$zipFactor[1:10]

    ##  [1] 21206 21231 21224 21211 21223 21218 21205 21211 21205 21231
    ## 32 Levels: -21226 21201 21202 21205 21206 21207 21208 21209 21210 ... 21287

    class(df$zipCode) 

    ## [1] "integer"

    class(df$zipFactor)

    ## [1] "factor"

### Levels of factor variables

    yesno <- sample(c('yes','no'),
                    size = 10,
                    replace = TRUE)
    yesnofact <- factor(yesno,
                        levels = c('yes', 'no'))
    relevel(yesnofact,
            ref = 'yes')

    ##  [1] yes no  yes no  yes no  yes no  yes yes
    ## Levels: yes no

    as.numeric(yesnofact)

    ##  [1] 1 2 1 2 1 2 1 2 1 1

### Cutting produces factor variables

    library(Hmisc)
    df$zipGroups <- cut2(df$zipCode, g = 4)
    table(df$zipGroups)

    ## 
    ## [-21226,21205) [ 21205,21220) [ 21220,21227) [ 21227,21287] 
    ##            338            375            300            314

### Using the mutate function

The `mutate()` function can be used to create a new version of the
variable and symultaneously add it to the dataframe.

    library(Hmisc)
    library(plyr)
    str(df)

    ## 'data.frame':    1327 obs. of  10 variables:
    ##  $ name           : chr  "410" "1919" "SAUTE" "#1 CHINESE KITCHEN" ...
    ##  $ zipCode        : int  21206 21231 21224 21211 21223 21218 21205 21211 21205 21231 ...
    ##  $ neighborhood   : chr  "Frankford" "Fells Point" "Canton" "Hampden" ...
    ##  $ councilDistrict: int  2 1 1 14 9 14 13 7 13 1 ...
    ##  $ policeDistrict : chr  "NORTHEASTERN" "SOUTHEASTERN" "SOUTHEASTERN" "NORTHERN" ...
    ##  $ Location.1     : chr  "4509 BELAIR ROAD\nBaltimore, MD\n" "1919 FLEET ST\nBaltimore, MD\n" "2844 HUDSON ST\nBaltimore, MD\n" "3998 ROLAND AVE\nBaltimore, MD\n" ...
    ##  $ nearMe         : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ zipWrong       : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ zipGroups      : Factor w/ 4 levels "[-21226,21205)",..: 2 4 3 2 3 2 2 2 2 4 ...
    ##  $ zipFactor      : Factor w/ 32 levels "-21226","21201",..: 5 27 21 10 20 17 4 10 4 27 ...

    df2 = mutate(df, zipGroups = cut2(zipCode, g=4))
    str(df2)

    ## 'data.frame':    1327 obs. of  10 variables:
    ##  $ name           : chr  "410" "1919" "SAUTE" "#1 CHINESE KITCHEN" ...
    ##  $ zipCode        : int  21206 21231 21224 21211 21223 21218 21205 21211 21205 21231 ...
    ##  $ neighborhood   : chr  "Frankford" "Fells Point" "Canton" "Hampden" ...
    ##  $ councilDistrict: int  2 1 1 14 9 14 13 7 13 1 ...
    ##  $ policeDistrict : chr  "NORTHEASTERN" "SOUTHEASTERN" "SOUTHEASTERN" "NORTHERN" ...
    ##  $ Location.1     : chr  "4509 BELAIR ROAD\nBaltimore, MD\n" "1919 FLEET ST\nBaltimore, MD\n" "2844 HUDSON ST\nBaltimore, MD\n" "3998 ROLAND AVE\nBaltimore, MD\n" ...
    ##  $ nearMe         : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ zipWrong       : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ zipGroups      : Factor w/ 4 levels "[-21226,21205)",..: 2 4 3 2 3 2 2 2 2 4 ...
    ##  $ zipFactor      : Factor w/ 32 levels "-21226","21201",..: 5 27 21 10 20 17 4 10 4 27 ...

    table(df2$zipGroups)

    ## 
    ## [-21226,21205) [ 21205,21220) [ 21220,21227) [ 21227,21287] 
    ##            338            375            300            314

## 4. Reshaping Data

The goal is tidy data. Some of the principles of tidy data are:

-   Each variable forms a column
-   Each observation forms a row
-   Each table/file stores data about one kind of observation.

When we are doing data reshaping, we focus on the first two principles.

The library `reshape2` can be used to reshape dataframes.

    library(reshape2)
    head(mtcars)

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

### Melting data frames

    mtcars$carname <- rownames(mtcars)
    head(mtcars)

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
    ##                             carname
    ## Mazda RX4                 Mazda RX4
    ## Mazda RX4 Wag         Mazda RX4 Wag
    ## Datsun 710               Datsun 710
    ## Hornet 4 Drive       Hornet 4 Drive
    ## Hornet Sportabout Hornet Sportabout
    ## Valiant                     Valiant

    nrow(mtcars)

    ## [1] 32

    carMelt1 <- melt(mtcars, 
                    id = c("carname", "gear", "cyl"),
                    measure.vars = c("mpg")
                    )
    head(carMelt1, 3)

    ##         carname gear cyl variable value
    ## 1     Mazda RX4    4   6      mpg  21.0
    ## 2 Mazda RX4 Wag    4   6      mpg  21.0
    ## 3    Datsun 710    4   4      mpg  22.8

    tail(carMelt1, 3)

    ##          carname gear cyl variable value
    ## 30  Ferrari Dino    5   6      mpg  19.7
    ## 31 Maserati Bora    5   8      mpg  15.0
    ## 32    Volvo 142E    4   4      mpg  21.4

    nrow(carMelt1)

    ## [1] 32

    carMelt2 <- melt(mtcars, 
                    id = c("carname", "gear", "cyl"),
                    measure.vars = c("mpg", "hp")
                    )
    head(carMelt2, 3)

    ##         carname gear cyl variable value
    ## 1     Mazda RX4    4   6      mpg  21.0
    ## 2 Mazda RX4 Wag    4   6      mpg  21.0
    ## 3    Datsun 710    4   4      mpg  22.8

    tail(carMelt2, 3)

    ##          carname gear cyl variable value
    ## 62  Ferrari Dino    5   6       hp   175
    ## 63 Maserati Bora    5   8       hp   335
    ## 64    Volvo 142E    4   4       hp   109

    nrow(carMelt2)

    ## [1] 64

    carMelt3 <- melt(mtcars, 
                    id = c("carname", "gear", "cyl"),
                    measure.vars = c("mpg", "hp", "qsec")
                    )
    head(carMelt3, 3)

    ##         carname gear cyl variable value
    ## 1     Mazda RX4    4   6      mpg  21.0
    ## 2 Mazda RX4 Wag    4   6      mpg  21.0
    ## 3    Datsun 710    4   4      mpg  22.8

    tail(carMelt3, 3)

    ##          carname gear cyl variable value
    ## 94  Ferrari Dino    5   6     qsec  15.5
    ## 95 Maserati Bora    5   8     qsec  14.6
    ## 96    Volvo 142E    4   4     qsec  18.6

    nrow(carMelt3)

    ## [1] 96

### Casting data frames

    cylData1 <- dcast(carMelt1, cyl ~ variable)
    cylData1

    ##   cyl mpg
    ## 1   4  11
    ## 2   6   7
    ## 3   8  14

    cylData2 <- dcast(carMelt2, gear ~ variable)
    cylData2

    ##   gear mpg hp
    ## 1    3  15 15
    ## 2    4  12 12
    ## 3    5   5  5

    cylData3 <- dcast(carMelt3, cyl ~ variable)
    cylData3

    ##   cyl mpg hp qsec
    ## 1   4  11 11   11
    ## 2   6   7  7    7
    ## 3   8  14 14   14

    cylData1 <- dcast(carMelt1, cyl ~ variable, mean)
    cylData1

    ##   cyl      mpg
    ## 1   4 26.66364
    ## 2   6 19.74286
    ## 3   8 15.10000

    cylData2 <- dcast(carMelt2, gear ~ variable, mean)
    cylData2

    ##   gear      mpg       hp
    ## 1    3 16.10667 176.1333
    ## 2    4 24.53333  89.5000
    ## 3    5 21.38000 195.6000

    cylData3 <- dcast(carMelt3, cyl ~ variable, mean)
    cylData3

    ##   cyl      mpg        hp     qsec
    ## 1   4 26.66364  82.63636 19.13727
    ## 2   6 19.74286 122.28571 17.97714
    ## 3   8 15.10000 209.21429 16.77214

### Averaging values

    head(InsectSprays)

    ##   count spray
    ## 1    10     A
    ## 2     7     A
    ## 3    20     A
    ## 4    14     A
    ## 5    14     A
    ## 6    12     A

    str(InsectSprays)

    ## 'data.frame':    72 obs. of  2 variables:
    ##  $ count: num  10 7 20 14 14 12 10 23 17 20 ...
    ##  $ spray: Factor w/ 6 levels "A","B","C","D",..: 1 1 1 1 1 1 1 1 1 1 ...

    tapply(InsectSprays$count, InsectSprays$spray, sum)

    ##   A   B   C   D   E   F 
    ## 174 184  25  59  42 200

    tapply(InsectSprays$count, InsectSprays$spray, mean)

    ##         A         B         C         D         E         F 
    ## 14.500000 15.333333  2.083333  4.916667  3.500000 16.666667

Via the `split()` function and then the `sum` function via `lapply`:

    sprIns = split(InsectSprays$count, InsectSprays$spray)
    sprIns

    ## $A
    ##  [1] 10  7 20 14 14 12 10 23 17 20 14 13
    ## 
    ## $B
    ##  [1] 11 17 21 11 16 14 17 17 19 21  7 13
    ## 
    ## $C
    ##  [1] 0 1 7 2 3 1 2 1 3 0 1 4
    ## 
    ## $D
    ##  [1]  3  5 12  6  4  3  5  5  5  5  2  4
    ## 
    ## $E
    ##  [1] 3 5 3 5 3 6 1 1 3 2 6 4
    ## 
    ## $F
    ##  [1] 11  9 15 22 15 16 13 10 26 26 24 13

    sprCount <- lapply(sprIns, sum)
    sprCount

    ## $A
    ## [1] 174
    ## 
    ## $B
    ## [1] 184
    ## 
    ## $C
    ## [1] 25
    ## 
    ## $D
    ## [1] 59
    ## 
    ## $E
    ## [1] 42
    ## 
    ## $F
    ## [1] 200

    unlist(sprCount)

    ##   A   B   C   D   E   F 
    ## 174 184  25  59  42 200

    sprMean <- lapply(sprIns, mean)
    sprMean

    ## $A
    ## [1] 14.5
    ## 
    ## $B
    ## [1] 15.33333
    ## 
    ## $C
    ## [1] 2.083333
    ## 
    ## $D
    ## [1] 4.916667
    ## 
    ## $E
    ## [1] 3.5
    ## 
    ## $F
    ## [1] 16.66667

    unlist(sprCount)

    ##   A   B   C   D   E   F 
    ## 174 184  25  59  42 200

### The plyr package

    library(dplyr)
    ddply(InsectSprays, .(spray), summarize, sum = sum(count))

    ##   spray sum
    ## 1     A 174
    ## 2     B 184
    ## 3     C  25
    ## 4     D  59
    ## 5     E  42
    ## 6     F 200

    spraySums <- ddply(InsectSprays, .(spray), summarize, sum = ave(count, FUN = sum))
    dim(spraySums)

    ## [1] 72  2

    head(spraySums)

    ##   spray sum
    ## 1     A 174
    ## 2     A 174
    ## 3     A 174
    ## 4     A 174
    ## 5     A 174
    ## 6     A 174

## 5. The `dplyr` package

The package is designed to help you work with data frames.

The data frame is a key structure in statistics and R

-   One observation per row
-   One variable per column
-   Primary implementation that you will use is the thefault `R`
    implementaton
-   Other implementations, particularly relational databases systems.

The `dplyr` package

-   An optimized version of `plyr` package
-   Greatly simplifies existing functionality in R
-   Provides a “grammar” (in particular verbs) for data manipulation
-   Is *very* vast, as many key operations are coded in C++

The `dplyr` verbs

-   `select()` - return a subset of the columns of a data frame
-   `filter()` - extract a subset of rows from a data frame based on
    logical conditions
-   `arrange()` - reorder rows of a data frame
-   `rename()` - rename variables in a data frame
-   `mutate()` - add new variables/columns or transform existing
    variables
-   `summarise() / summarize()` - generate summary statistics of
    different variables in the data frame, possible within strata.

The `dplyr` properties

-   The first argument is a data frame
-   The subsequent argument describe what to do with it, and you can
    refer to columns in the data frame directly without using the `$`
    operator
-   The result is a new data frame
-   Data frames must be properly formatted and annotated for this to all
    be useful

### The `select()` function

    library(dplyr)
    df <- readRDS("./data/chicago.rds")
    dim(df)

    ## [1] 6940    8

    str(df)

    ## 'data.frame':    6940 obs. of  8 variables:
    ##  $ city      : chr  "chic" "chic" "chic" "chic" ...
    ##  $ tmpd      : num  31.5 33 33 29 32 40 34.5 29 26.5 32.5 ...
    ##  $ dptp      : num  31.5 29.9 27.4 28.6 28.9 ...
    ##  $ date      : Date, format: "1987-01-01" "1987-01-02" ...
    ##  $ pm25tmean2: num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ pm10tmean2: num  34 NA 34.2 47 NA ...
    ##  $ o3tmean2  : num  4.25 3.3 3.33 4.38 4.75 ...
    ##  $ no2tmean2 : num  20 23.2 23.8 30.4 30.3 ...

    head(df)

    ##   city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 3 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 6 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233

    names(df)

    ## [1] "city"       "tmpd"       "dptp"       "date"       "pm25tmean2"
    ## [6] "pm10tmean2" "o3tmean2"   "no2tmean2"

Apply select function to select the dataframe corresponding to the
*varn* to *varm* (*varx* representing the name of the column) using

<center>
`select(df, varn:varm)`
</center>

    head(select(df, city:date))

    ##   city tmpd   dptp       date
    ## 1 chic 31.5 31.500 1987-01-01
    ## 2 chic 33.0 29.875 1987-01-02
    ## 3 chic 33.0 27.375 1987-01-03
    ## 4 chic 29.0 28.625 1987-01-04
    ## 5 chic 32.0 28.875 1987-01-05
    ## 6 chic 40.0 35.125 1987-01-06

The equivalent code in regular `R` implies finding the correspnding
indices:

    i <- match("city", names(df))
    j <- match("date", names(df))
    head(df[,i:j])

    ##   city tmpd   dptp       date
    ## 1 chic 31.5 31.500 1987-01-01
    ## 2 chic 33.0 29.875 1987-01-02
    ## 3 chic 33.0 27.375 1987-01-03
    ## 4 chic 29.0 28.625 1987-01-04
    ## 5 chic 32.0 28.875 1987-01-05
    ## 6 chic 40.0 35.125 1987-01-06

Apply select function to select the dataframe corresponding to the all
columns except columns between *varn* and *varn* using

<center>
`select(df, -(varn:varm))`
</center>

    head(select(df, -(city:date)))

    ##   pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1         NA   34.00000 4.250000  19.98810
    ## 2         NA         NA 3.304348  23.19099
    ## 3         NA   34.16667 3.333333  23.81548
    ## 4         NA   47.00000 4.375000  30.43452
    ## 5         NA         NA 4.750000  30.33333
    ## 6         NA   48.00000 5.833333  25.77233

The equivalent code in regular `R` implies finding the correspnding
indices:

    i <- match("city", names(df))
    j <- match("date", names(df))
    head(df[,-(i:j)])

    ##   pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1         NA   34.00000 4.250000  19.98810
    ## 2         NA         NA 3.304348  23.19099
    ## 3         NA   34.16667 3.333333  23.81548
    ## 4         NA   47.00000 4.375000  30.43452
    ## 5         NA         NA 4.750000  30.33333
    ## 6         NA   48.00000 5.833333  25.77233

### The `filter()` function

The `filter()` function is used to filter rows based on conditions:

<center>
`filter(df, condition)`
</center>

    df.f <- filter(df, pm25tmean2 > 30)
    head(df.f)

    ##   city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 1 chic   23 21.9 1998-01-17      38.10   32.46154  3.180556  25.30000
    ## 2 chic   28 25.8 1998-01-23      33.95   38.69231  1.750000  29.37630
    ## 3 chic   55 51.3 1998-04-30      39.40   34.00000 10.786232  25.31310
    ## 4 chic   59 53.7 1998-05-01      35.40   28.50000 14.295125  31.42905
    ## 5 chic   57 52.0 1998-05-02      33.30   35.00000 20.662879  26.79861
    ## 6 chic   57 56.0 1998-05-07      32.10   34.50000 24.270422  33.99167

The equivalent code in regular `R` implies the use of the `which()`
function (applying directly the logical condition does not work when
missing values appears):

    df.f2 <- df[which(df$pm25tmean2 > 30), ]
    head(df.f2)

    ##      city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 4035 chic   23 21.9 1998-01-17      38.10   32.46154  3.180556  25.30000
    ## 4041 chic   28 25.8 1998-01-23      33.95   38.69231  1.750000  29.37630
    ## 4138 chic   55 51.3 1998-04-30      39.40   34.00000 10.786232  25.31310
    ## 4139 chic   59 53.7 1998-05-01      35.40   28.50000 14.295125  31.42905
    ## 4140 chic   57 52.0 1998-05-02      33.30   35.00000 20.662879  26.79861
    ## 4145 chic   57 56.0 1998-05-07      32.10   34.50000 24.270422  33.99167

Subsetting rows based on conditions for multiple columns:

    df.f <- filter(df, pm25tmean2 > 30 & tmpd > 80)
    head(df.f)

    ##   city tmpd dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic   81 71.2 1998-08-23    39.6000       59.0 45.86364  14.32639
    ## 2 chic   81 70.4 1998-09-06    31.5000       50.5 50.66250  20.31250
    ## 3 chic   82 72.2 2001-07-20    32.3000       58.5 33.00380  33.67500
    ## 4 chic   84 72.9 2001-08-01    43.7000       81.5 45.17736  27.44239
    ## 5 chic   85 72.6 2001-08-08    38.8375       70.0 37.98047  27.62743
    ## 6 chic   84 72.6 2001-08-09    38.2000       66.0 36.73245  26.46742

    # The equivalent code in regular `R`:
    df.f2 <- df[which(df$pm25tmean2 > 30 & df$tmpd > 80 ), ]
    head(df.f2)

    ##      city tmpd dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 4253 chic   81 71.2 1998-08-23    39.6000       59.0 45.86364  14.32639
    ## 4267 chic   81 70.4 1998-09-06    31.5000       50.5 50.66250  20.31250
    ## 5315 chic   82 72.2 2001-07-20    32.3000       58.5 33.00380  33.67500
    ## 5327 chic   84 72.9 2001-08-01    43.7000       81.5 45.17736  27.44239
    ## 5334 chic   85 72.6 2001-08-08    38.8375       70.0 37.98047  27.62743
    ## 5335 chic   84 72.6 2001-08-09    38.2000       66.0 36.73245  26.46742

### The `arrange()` function

Used to reorder the rows of a dataframe based on the values of a
variable (column):

    df_a1 <- arrange(df, date)
    head(df_a1)

    ##   city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 3 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 6 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233

    tail(df_a1)

    ##      city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 6935 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944
    ## 6936 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6937 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 6938 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 6939 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 6940 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000

    # The equivalent code in regular `R`:
    df_a2 <- df[order(df$date), ]
    head(df_a2)

    ##   city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 3 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 6 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233

    tail(df_a2)

    ##      city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 6935 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944
    ## 6936 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6937 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 6938 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 6939 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 6940 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000

Arranging the rows in descending order

    df_a1 <- arrange(df, desc(date))
    head(df_a1)

    ##   city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 1 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000
    ## 2 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 3 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 4 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 5 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944

    tail(df_a1)

    ##      city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 6935 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233
    ## 6936 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 6937 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 6938 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 6939 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 6940 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810

    # The equivalent code in regular `R`:
    df_a2 <- df[order(df$date, decreasing = TRUE), ]
    head(df_a2)

    ##      city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 6940 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000
    ## 6939 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 6938 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 6937 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 6936 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6935 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944

    tail(df_a2)

    ##   city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 6 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233
    ## 5 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 4 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 3 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 2 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 1 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810

### The `rename()` function

It is used to rename a variable in a dataframe.

    df_r1 <- rename(df, pm25 = pm25tmean2, dewpoint = dptp)
    head(df_r1)

    ##   city tmpd dewpoint       date pm25 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5   31.500 1987-01-01   NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0   29.875 1987-01-02   NA         NA 3.304348  23.19099
    ## 3 chic 33.0   27.375 1987-01-03   NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0   28.625 1987-01-04   NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0   28.875 1987-01-05   NA         NA 4.750000  30.33333
    ## 6 chic 40.0   35.125 1987-01-06   NA   48.00000 5.833333  25.77233

    # The equivalent code in regular `R`:
    df_r2 <- df
    names(df_r2)[match(c("dptp", "pm25tmean2"), names(df_r2))] <- c("dewpoint", "pm25")
    head(df_r2)

    ##   city tmpd dewpoint       date pm25 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5   31.500 1987-01-01   NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0   29.875 1987-01-02   NA         NA 3.304348  23.19099
    ## 3 chic 33.0   27.375 1987-01-03   NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0   28.625 1987-01-04   NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0   28.875 1987-01-05   NA         NA 4.750000  30.33333
    ## 6 chic 40.0   35.125 1987-01-06   NA   48.00000 5.833333  25.77233

    head(df)

    ##   city tmpd   dptp       date pm25tmean2 pm10tmean2 o3tmean2 no2tmean2
    ## 1 chic 31.5 31.500 1987-01-01         NA   34.00000 4.250000  19.98810
    ## 2 chic 33.0 29.875 1987-01-02         NA         NA 3.304348  23.19099
    ## 3 chic 33.0 27.375 1987-01-03         NA   34.16667 3.333333  23.81548
    ## 4 chic 29.0 28.625 1987-01-04         NA   47.00000 4.375000  30.43452
    ## 5 chic 32.0 28.875 1987-01-05         NA         NA 4.750000  30.33333
    ## 6 chic 40.0 35.125 1987-01-06         NA   48.00000 5.833333  25.77233

### The `mutate()` function

The `mutate()` function is used to transform existing variables or
create new variables

    df <- arrange(df, desc(date))
    df_m1 <- mutate(df, pm25centered = pm25tmean2 - mean(pm25tmean2, na.rm = TRUE))
    head(df_m1)

    ##   city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 1 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000
    ## 2 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 3 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 4 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 5 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944
    ##   pm25centered
    ## 1    -1.230958
    ## 2    -1.173815
    ## 3    -8.780958
    ## 4     1.519042
    ## 5     7.329042
    ## 6    -7.830958

    # The equivalent code in regular `R`:
    df_m2 <- df
    df_m2$pm25centered <- df_m2$pm25tmean2 - mean(df_m2$pm25tmean2, na.rm = TRUE)
    head(df_m2)

    ##   city tmpd dptp       date pm25tmean2 pm10tmean2  o3tmean2 no2tmean2
    ## 1 chic   35 30.1 2005-12-31   15.00000       23.5  2.531250  13.25000
    ## 2 chic   36 31.0 2005-12-30   15.05714       19.2  3.034420  22.80556
    ## 3 chic   35 29.4 2005-12-29    7.45000       23.5  6.794837  19.97222
    ## 4 chic   37 34.5 2005-12-28   17.75000       27.5  3.260417  19.28563
    ## 5 chic   40 33.6 2005-12-27   23.56000       27.0  4.468750  23.50000
    ## 6 chic   35 29.6 2005-12-26    8.40000        8.5 14.041667  16.81944
    ##   pm25centered
    ## 1    -1.230958
    ## 2    -1.173815
    ## 3    -8.780958
    ## 4     1.519042
    ## 5     7.329042
    ## 6    -7.830958

### The `groupby()` function

    df1 <- mutate(df, 
                  tempcat = factor(tmpd > 80, 
                                   labels = c("cold","hot")))
    hotcold <- group_by(df1, tempcat)
    head(hotcold)

    ## # A tibble: 6 × 9
    ## # Groups:   tempcat [1]
    ##   city   tmpd  dptp date       pm25tmean2 pm10tmean2 o3tmean2 no2tmean2 tempcat
    ##   <chr> <dbl> <dbl> <date>          <dbl>      <dbl>    <dbl>     <dbl> <fct>  
    ## 1 chic     35  30.1 2005-12-31      15          23.5     2.53      13.2 cold   
    ## 2 chic     36  31   2005-12-30      15.1        19.2     3.03      22.8 cold   
    ## 3 chic     35  29.4 2005-12-29       7.45       23.5     6.79      20.0 cold   
    ## 4 chic     37  34.5 2005-12-28      17.8        27.5     3.26      19.3 cold   
    ## 5 chic     40  33.6 2005-12-27      23.6        27       4.47      23.5 cold   
    ## 6 chic     35  29.6 2005-12-26       8.4         8.5    14.0       16.8 cold

    summarise(hotcold, 
              pm25 = mean(pm25tmean2, na.rm = TRUE), 
              o3 = max(o3tmean2), 
              no2 = median(no2tmean2))

    ## # A tibble: 3 × 4
    ##   tempcat  pm25    o3   no2
    ##   <fct>   <dbl> <dbl> <dbl>
    ## 1 cold     16.0 66.6   24.5
    ## 2 hot      26.5 63.0   24.9
    ## 3 <NA>     47.7  9.42  37.4

<!--```{r dplyr13b, echo = TRUE}
# The equivalent code in regular `R`:
df2 <- df
df2$tempcat <- factor(df2$tmpd > 80, 
                      labels = c("cold","hot"))
pm25 <- c()
o3 <- c()
no2 <- c()

unique_factors <- as.character(unique(df2$tempcat))
if('<NA>' %in% unique_factors){
  unique_factors[match('<NA>',unique_factors)] <- NA
}
for (i in seq_along(unique(df2$tempcat))){
  pm25 <- c(pm25, mean(df$pm25tmean2[which(df2$tempcat == unique(df2$tempcat)[i])], na.rm = TRUE))
  o3 <- c(o3, max(df$o3tmean2[which(df2$tempcat == unique(df2$tempcat)[i])]))
  no2 <- c(no2, median(df$no2tmean2[which(df2$tempcat == unique(df2$tempcat)[i])]))
}
df2_s <- data.frame(tempcat <- unique(df2$tempcat),
                    pm25 <- pm25,
                    o3 <- o3,
                    no2 <- no2)
df2_s
```-->

    df1 <- mutate(df, 
                  year = as.POSIXlt(date)$year + 1900)
    years <- group_by(df1, year)
    head(hotcold)

    ## # A tibble: 6 × 9
    ## # Groups:   tempcat [1]
    ##   city   tmpd  dptp date       pm25tmean2 pm10tmean2 o3tmean2 no2tmean2 tempcat
    ##   <chr> <dbl> <dbl> <date>          <dbl>      <dbl>    <dbl>     <dbl> <fct>  
    ## 1 chic     35  30.1 2005-12-31      15          23.5     2.53      13.2 cold   
    ## 2 chic     36  31   2005-12-30      15.1        19.2     3.03      22.8 cold   
    ## 3 chic     35  29.4 2005-12-29       7.45       23.5     6.79      20.0 cold   
    ## 4 chic     37  34.5 2005-12-28      17.8        27.5     3.26      19.3 cold   
    ## 5 chic     40  33.6 2005-12-27      23.6        27       4.47      23.5 cold   
    ## 6 chic     35  29.6 2005-12-26       8.4         8.5    14.0       16.8 cold

    summarise(years, 
              pm25 = mean(pm25tmean2, na.rm = TRUE), 
              o3 = max(o3tmean2), 
              no2 = median(no2tmean2))

    ## # A tibble: 19 × 4
    ##     year  pm25    o3   no2
    ##    <dbl> <dbl> <dbl> <dbl>
    ##  1  1987 NaN    63.0  23.5
    ##  2  1988 NaN    61.7  24.5
    ##  3  1989 NaN    59.7  26.1
    ##  4  1990 NaN    52.2  22.6
    ##  5  1991 NaN    63.1  21.4
    ##  6  1992 NaN    50.8  24.8
    ##  7  1993 NaN    44.3  25.8
    ##  8  1994 NaN    52.2  28.5
    ##  9  1995 NaN    66.6  27.3
    ## 10  1996 NaN    58.4  26.4
    ## 11  1997 NaN    56.5  25.5
    ## 12  1998  18.3  50.7  24.6
    ## 13  1999  18.5  57.5  24.7
    ## 14  2000  16.9  55.8  23.5
    ## 15  2001  16.9  51.8  25.1
    ## 16  2002  15.3  54.9  22.7
    ## 17  2003  15.2  56.2  24.6
    ## 18  2004  14.6  44.5  23.4
    ## 19  2005  16.2  58.8  22.6

### The %&gt;% operator (pipeline operator)

    df %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarise(pm25 = mean(pm25tmean2, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

    ## # A tibble: 12 × 4
    ##    month  pm25    o3   no2
    ##    <dbl> <dbl> <dbl> <dbl>
    ##  1     1  17.8  28.2  25.4
    ##  2     2  20.4  37.4  26.8
    ##  3     3  17.4  39.0  26.8
    ##  4     4  13.9  47.9  25.0
    ##  5     5  14.1  52.8  24.2
    ##  6     6  15.9  66.6  25.0
    ##  7     7  16.6  59.5  22.4
    ##  8     8  16.9  54.0  23.0
    ##  9     9  15.9  57.5  24.5
    ## 10    10  14.2  47.1  24.2
    ## 11    11  15.2  29.5  23.6
    ## 12    12  17.5  27.7  24.5

Once you get familiar with the `dplyr` grammar there are few additional
benefits: \* `dplyr` can work with other data frame *backends* \*
`data.table` for large fast tables \* SQL interface for relational
databases via the DBI package

## 6. Merging Data

### Peer review data

    if(!file.exists('./data')){
      dir.create("./data")
    }
    fileUrl1 <- 'https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/04_01_editingTextVariables/data/reviews.csv'
    fileUrl2 <- 'https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/04_01_editingTextVariables/data/solutions.csv'
    download.file(fileUrl1, destfile = './data/reviews.csv', method = 'curl')
    download.file(fileUrl2, destfile = './data/solutions.csv', method = 'curl')
    reviews <- read.csv('./data/reviews.csv')
    solutions <- read.csv('./data/solutions.csv')
    head(reviews, 3)

    ##   id solution_id reviewer_id      start       stop time_left accept
    ## 1  1           3          27 1304095698 1304095758      1754      1
    ## 2  2           4          22 1304095188 1304095206      2306      1
    ## 3  3           5          28 1304095276 1304095320      2192      1

    head(solutions, 3)

    ##   id problem_id subject_id      start       stop time_left answer
    ## 1  1        156         29 1304095119 1304095169      2343      B
    ## 2  2        269         25 1304095119 1304095183      2329      C
    ## 3  3         34         22 1304095127 1304095146      2366      C

### Merging data - merge()

-   Merges data frames
-   Important parameters:
    -   x, y, by, by.x, by.y, all
-   By default, it’s merging based on the common columns (for this
    example it would merge based on the *id*, *start* *stop*
    *time\_left*)

<!-- -->

    names(reviews)

    ## [1] "id"          "solution_id" "reviewer_id" "start"       "stop"       
    ## [6] "time_left"   "accept"

    names(solutions)

    ## [1] "id"         "problem_id" "subject_id" "start"      "stop"      
    ## [6] "time_left"  "answer"

    mergedData <- merge(reviews, solutions, 
                        by.x = 'solution_id', 
                        by.y = 'id', 
                        all = TRUE)
    head(mergedData)

    ##   solution_id id reviewer_id    start.x     stop.x time_left.x accept
    ## 1           1  4          26 1304095267 1304095423        2089      1
    ## 2           2  6          29 1304095471 1304095513        1999      1
    ## 3           3  1          27 1304095698 1304095758        1754      1
    ## 4           4  2          22 1304095188 1304095206        2306      1
    ## 5           5  3          28 1304095276 1304095320        2192      1
    ## 6           6 16          22 1304095303 1304095471        2041      1
    ##   problem_id subject_id    start.y     stop.y time_left.y answer
    ## 1        156         29 1304095119 1304095169        2343      B
    ## 2        269         25 1304095119 1304095183        2329      C
    ## 3         34         22 1304095127 1304095146        2366      C
    ## 4         19         23 1304095127 1304095150        2362      D
    ## 5        605         26 1304095127 1304095167        2345      A
    ## 6        384         27 1304095131 1304095270        2242      C

### Default - merge all common columns names

    intersect(names(solutions), names(reviews))

    ## [1] "id"        "start"     "stop"      "time_left"

    mergedData2 <- merge(reviews, solutions, all = TRUE)
    head(mergedData2)

    ##   id      start       stop time_left solution_id reviewer_id accept problem_id
    ## 1  1 1304095119 1304095169      2343          NA          NA     NA        156
    ## 2  1 1304095698 1304095758      1754           3          27      1         NA
    ## 3  2 1304095119 1304095183      2329          NA          NA     NA        269
    ## 4  2 1304095188 1304095206      2306           4          22      1         NA
    ## 5  3 1304095127 1304095146      2366          NA          NA     NA         34
    ## 6  3 1304095276 1304095320      2192           5          28      1         NA
    ##   subject_id answer
    ## 1         29      B
    ## 2         NA   <NA>
    ## 3         25      C
    ## 4         NA   <NA>
    ## 5         22      C
    ## 6         NA   <NA>

### Using join in the plyr package

Faster but less full features - defaults to left join

    df1 <- data.frame(id = sample(1:10), x = rnorm(10))
    df2 <- data.frame(id = sample(1:10), y = rnorm(10))
    join(df1, df2)

    ##    id           x            y
    ## 1   1 -0.35886059  0.008787944
    ## 2   8 -0.12548752  1.009306693
    ## 3   6 -1.52703991 -1.031755121
    ## 4   5 -1.33022863 -2.009475185
    ## 5   2 -0.20355123 -0.911516098
    ## 6   7  0.06934219  0.734062946
    ## 7  10  0.18428799  0.013869073
    ## 8   3  0.09984099  0.076250620
    ## 9   4  1.98652615 -1.342678054
    ## 10  9  0.18278767  1.040067042

    arrange(join(df1, df2), id)

    ##    id           x            y
    ## 1   1 -0.35886059  0.008787944
    ## 2   2 -0.20355123 -0.911516098
    ## 3   3  0.09984099  0.076250620
    ## 4   4  1.98652615 -1.342678054
    ## 5   5 -1.33022863 -2.009475185
    ## 6   6 -1.52703991 -1.031755121
    ## 7   7  0.06934219  0.734062946
    ## 8   8 -0.12548752  1.009306693
    ## 9   9  0.18278767  1.040067042
    ## 10 10  0.18428799  0.013869073

### Multiple data frames

    df1 <- data.frame(id = sample(1:10), x = rnorm(10))
    df2 <- data.frame(id = sample(1:10), y = rnorm(10))
    df3 <- data.frame(id = sample(1:10), z = rnorm(10))
    dfList <- list(df1, df2, df3)
    join_all(dfList)

    ##    id          x          y          z
    ## 1  10 -0.9235948  1.8432618 -0.1286380
    ## 2   5 -1.1535500 -0.2008327 -1.0020081
    ## 3   7  1.2545821  0.1627588 -0.5252270
    ## 4   8 -0.4614443 -2.2000898  0.8279377
    ## 5   3 -1.2459543 -0.8562394 -0.4523467
    ## 6   4 -1.9075333 -1.1044349  0.3847079
    ## 7   6  0.7615748  0.4553345 -0.7777880
    ## 8   1  0.3125853 -1.0178494  0.4006214
    ## 9   2 -0.3016994 -1.1062620  0.1656575
    ## 10  9 -1.9757024  0.4083666  0.3850492
