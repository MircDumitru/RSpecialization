# Organizing, merging and managing the data - Week 1 Notes

## What’s covered in those notes

-   The basic ideas behind getting data ready for analysis.
    -   Finding and extracting raw data.
    -   Tidy data principles and how to make data tiny.
    -   Practical implementation through a range of `R` packages.

The pipeline between the available *raw data* and the *data
comunication*, the data you want to communicate:

> ***$\color{red}{\text{raw data -&gt; processing script -&gt; tidy data}}$
> -&gt; data analysis -&gt; data communication:***

so this course will cover the first (red) part of the pipeline.

## 1. The raw data:

-   The original source of the data
-   Often hard to use for data analysis
-   Data analysis *includes* preprocessing
-   Raw data may only need to be processed once
-   <http://en.wikipedia.org/wiki/Raw_data>

## 2. Processed data:

-   Data is ready for analysis
-   Processing can include merging, subsetting, transforming, etc
-   There may be standards for processing
-   All steps should be recorded (this is critically important.)
-   <http://en.wikipedia.org/wiki/Computer_data_processing>

### The composits of tidy data

The tidy data is the target, i.e. the clean data that can be used for
data analysis.

The four things you should have when you go from *raw data* to the *tidy
data* are:

-   The raw data
-   A tidy data set
-   A code book describing each variable and its values in the tidy data
    set.
-   An explicit and exact recipe reporting the steps that took from 1 to
    2 to 3.

You know the raw data is in the right form if you

-   Ran no software on the data
-   Did not manipulate any of the numbers in the data
-   Did not remove any data from the data set
-   Did not summarize the data in any way

### The tidy data

-   Each variable you measure should be in one column
-   Each different observation of that variable should be in a different
    row
-   There should be one table for each “kind” of variable
-   If you have multiple tables, they should include a column in the
    table that allows them to be linked

*Some important tips*

-   Include a row at the top of each file with variable names
-   Make variable names human readable (e.g. *AgeAtDiagnosis* instead of
    “AgeDx”)
-   In general data should be saves in one file per table

### The code book

-   Information about the variables (including units!) in the data set
    not contained in the tidy data
-   Information about the summary choices you made
-   Information about the experimental stydy design you used

*Some important tips*

-   A common format for the document is a Word/text/Markdown file
-   There should be a section called *Study Design* that has a thorough
    description of how you collected the data.
-   There be a section called “Code book” data describes each variable
    and its units

## 3. The instruction list

-   Ideally a computer script
-   The input for the script is the raw data
-   The output is the processed, tidy data
-   There are no parameters to the script

In some cases it will not be possible to script every step. In that
cases, you should provide instructions like:

-   Step 1 - take the raw file, run version 2.1.3 of summarize software
    with paramters a = 1, b = 2.
-   Step 2 - run the software separately for each sample.
-   Step 3 - take column three of outputile.out for each sample and that
    is the corresponing row in the output adta set.

## 4. Downloading files

### Get/Set your working directory

-   A basic compotent of working with data is knowing your working
    directory.
-   The two main commands are `getwd()` and `setwd()`.
-   Be aware of relative vs. absolute paths.
    -   Relative - `setwd('./data')`, `setwd('../')`.
    -   Absolute - `setwd('/Users/John/Data/')`.

### Checking for and creating directories

-   `file.exists('directoryName')` - checks to see if the directory
    exits.
-   `dir.create('directoryName')` - creates a directory if it doesn’t
    exit.

<!-- -->

    if(!file.exists('data')){
      dir.create('data')
    }

### Getting data from the internet

The function that can download files from internet is:
`download.file()`.

-   Even if you could this by hand, helps with reproducibility.
-   Important paramters are *url*, *destfile*, *method*.
-   Useful for downloading tab-delimited, csv and other files.

### Example: Baltimore Camera Data

    fileUrl <- "https://opendata.arcgis.com/api/v3/datasets/37599bb547784bdd9a359ccaff32eb76_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1"
    download.file(fileUrl, 
                  destfile = "./data/health.csv",
                  method = 'curl')
    list.files('./data')

    ## [1] "health.csv"

    dateDownloaded <- date()
    dateDownloaded

    ## [1] "Wed Jan 25 22:10:29 2023"

### Some notes about download.file()

-   If the *url* starts with *http* you can use `download.file()`
-   If the *url* starts with *https* you may need to set
    `method = 'culr'`
-   If the file is big, it might take a while
-   Be sure to record when you download.

## 5. Reading local flat files

Loading flat files is done via `read.table()`

-   This is the main function for reading data into `R`
-   Flexible and roboust but requires more paramters
-   Reads the data into RAM - big that can cause problems
-   Important parameters: *file*, *header*, *sep*, *row.names*, *nrows*
-   Related: `read.csv()`, `read.csv2()`

### Example: Baltimore Camera Data

    healthData <- read.table("./data/health.csv", sep = ',', header = TRUE)
    head(healthData[1:6])

    ##             callDateTime        responseType attemptedDiversion
    ## 1 2021/06/16 04:00:00+00          no attempt                 no
    ## 2 2021/06/16 21:53:00+00     co-notification                yes
    ## 3 2021/06/17 01:06:00+00           diversion                yes
    ## 4 2021/06/17 03:53:00+00          no attempt                 no
    ## 5 2021/06/17 04:07:00+00          no attempt                 no
    ## 6 2021/06/17 06:02:00+00 escalated diversion                 no
    ##   eligibleByCallType eligibleBy911Narrative involvedAgencies
    ## 1                yes                    yes             BCFD
    ## 2                yes                    yes        BCRI BCFD
    ## 3                 no                     no             BCRI
    ## 4                yes                    yes        BCFD BPD 
    ## 5                yes                    yes             BCFD
    ## 6                yes                    yes

### Some more important parameters

-   *quote* - you can tell `R` whether there are any quoted values.
-   *na.strings* - set the character that represents a missing value.
-   *nrows* - how many rows to read of the file (e.g. nrows = 10 reads
    10 lines).
-   *skip* - number of lines to skip before starting reading.

## 6. Reading Excel files

Still probably the most widely used format for sharing data.

    if(!file.exists('data')) dir.create('data')
      
    fileUrl <- "https://opendata.arcgis.com/api/v3/datasets/37599bb547784bdd9a359ccaff32eb76_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1"
    download.file(fileUrl, 
                  destfile = "./data/health.xlsx",
                  method = 'curl')
    dateDownloaded <- date()

<!--```{r excel1, echo = TRUE}
#library(xlsx)
#healthData <- read.xlsx('./data/health.xlsx', sheetIndex = 1, header = TRUE)
#head(healthData)
```-->

### Further notes

-   the `write.xlsx()` function will write out an Excel file with
    similar arguments
-   the `read.xlsx2()` is much faster that `write.xlsx()` but for
    reading subsets of rows may be slightly unstable
-   the ‘XLConnect’ package has more options for writing and
    manipulating Excel files
-   The XLConnect vignette is a good place to start for that package.
-   In general it is advised to store the data in .csv or .tab/txt
    files, as they are easier to distribute.

## 7. Reading XML files

The `R` function to do this is `xmlTreeParse()`

-   Extensible markup language
-   Frequently used to store structured data
-   Particularly widely used in intenet applications
-   Extracting XML is the basis for most web scaping
-   Components
    -   Markup - labels that give the text structure
    -   Content - the actual text of the document
-   <http://en.wikipedia.org/wiki/XML>

### Tags, elements & attributes

-   Tags corresopnd to general labels
    -   Start tags `<section>`
    -   End tags `</section>`
    -   Empty tags <line-break />
-   Elements are specific examples of tags
    -   `<Greeting> Hello world <Greeting>`
-   Attributes are components of the label
    -   `<img src = "jeff.jpg" alt = instructor />`

<!-- -->

    library(XML)
    fileUrl <- "http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/simple.xml"
    doc <- xmlTreeParse(fileUrl, useInternal = TRUE)
    rootNode <- xmlRoot(doc)
    xmlName(rootNode)

    ## [1] "breakfast_menu"

    names(rootNode)

    ##   food   food   food   food   food 
    ## "food" "food" "food" "food" "food"

### Directly access parts of the XML document

    rootNode[[1]]

    ## <food>
    ##   <name>Belgian Waffles</name>
    ##   <price>$5.95</price>
    ##   <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
    ##   <calories>650</calories>
    ## </food>

    rootNode[[1]][[1]]

    ## <name>Belgian Waffles</name>

    rootNode[[1]][[2]]

    ## <price>$5.95</price>

### Extracting parts of a XML document

Uses the function `xmlSApply()`

    xmlSApply(rootNode, xmlValue)

    ##                                                                                                                     food 
    ##                               "Belgian Waffles$5.95Two of our famous Belgian Waffles with plenty of real maple syrup650" 
    ##                                                                                                                     food 
    ##                    "Strawberry Belgian Waffles$7.95Light Belgian waffles covered with strawberries and whipped cream900" 
    ##                                                                                                                     food 
    ## "Berry-Berry Belgian Waffles$8.95Light Belgian waffles covered with an assortment of fresh berries and whipped cream900" 
    ##                                                                                                                     food 
    ##                                                "French Toast$4.50Thick slices made from our homemade sourdough bread600" 
    ##                                                                                                                     food 
    ##                         "Homestyle Breakfast$6.95Two eggs, bacon or sausage, toast, and our ever-popular hash browns950"

### XPath

-   */node* - top level node
-   *//node* - node at any level
-   *node\[@attr-name\]* - node with an attribute name
-   *node\[@attr-name = 'bob'\]* - node with attribute name
-   <http://www.stat.berkely.edu/~statcur/Workshop2/Presentations/XML.pdf>

<!-- -->

    xpathSApply(rootNode, '//name', xmlValue)

    ## [1] "Belgian Waffles"             "Strawberry Belgian Waffles" 
    ## [3] "Berry-Berry Belgian Waffles" "French Toast"               
    ## [5] "Homestyle Breakfast"

    xpathSApply(rootNode, '//price', xmlValue)

    ## [1] "$5.95" "$7.95" "$8.95" "$4.50" "$6.95"

<!--```{r xml7, echo = TRUE}
fileUrl <- "https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl, useInternal = TRUE)
scores <- xpathSApply(doc, "//li[@class = 'score']", xmlValue)
teams <- xpathSApply(doc, "//li[@class = 'team-name']", xmlValue)
teams
```-->

## 8. Reading JSON files

-   JSON stands for Javascript Object Notation
-   Lightweight data storage
-   Common format for data from application programming interfaces
    (APIs)
-   Similar structure to XML but different syntax/format
-   Data stored as:
    -   Numbers (doubles)
    -   Strings (double quoted)
    -   Boolean (logical, true/false)
    -   Array (ordered, comma separated enclosed in square brackets
        \[\])
    -   Object (unordered, comma separated collection of key:value pairs
        in curly brackets)

<!-- -->

    library(jsonlite)
    jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
    names(jsonData[1:6])

    ## [1] "id"        "node_id"   "name"      "full_name" "private"   "owner"

    names(jsonData$owner)

    ##  [1] "login"               "id"                  "node_id"            
    ##  [4] "avatar_url"          "gravatar_id"         "url"                
    ##  [7] "html_url"            "followers_url"       "following_url"      
    ## [10] "gists_url"           "starred_url"         "subscriptions_url"  
    ## [13] "organizations_url"   "repos_url"           "events_url"         
    ## [16] "received_events_url" "type"                "site_admin"

    names(jsonData$owner$login)

    ## NULL

    jsonData2 <- toJSON(iris, prety = TRUE)
    cat(jsonData2[1:5])

    ## [{"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.7,"Sepal.Width":3.2,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.6,"Sepal.Width":3.1,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.6,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.4,"Sepal.Width":3.9,"Petal.Length":1.7,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":4.6,"Sepal.Width":3.4,"Petal.Length":1.4,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.4,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.4,"Sepal.Width":2.9,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.9,"Sepal.Width":3.1,"Petal.Length":1.5,"Petal.Width":0.1,"Species":"setosa"},{"Sepal.Length":5.4,"Sepal.Width":3.7,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.8,"Sepal.Width":3.4,"Petal.Length":1.6,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.8,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.1,"Species":"setosa"},{"Sepal.Length":4.3,"Sepal.Width":3,"Petal.Length":1.1,"Petal.Width":0.1,"Species":"setosa"},{"Sepal.Length":5.8,"Sepal.Width":4,"Petal.Length":1.2,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.7,"Sepal.Width":4.4,"Petal.Length":1.5,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":5.4,"Sepal.Width":3.9,"Petal.Length":1.3,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Length":1.4,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":5.7,"Sepal.Width":3.8,"Petal.Length":1.7,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.8,"Petal.Length":1.5,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":5.4,"Sepal.Width":3.4,"Petal.Length":1.7,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.7,"Petal.Length":1.5,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":4.6,"Sepal.Width":3.6,"Petal.Length":1,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.3,"Petal.Length":1.7,"Petal.Width":0.5,"Species":"setosa"},{"Sepal.Length":4.8,"Sepal.Width":3.4,"Petal.Length":1.9,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3,"Petal.Length":1.6,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.4,"Petal.Length":1.6,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":5.2,"Sepal.Width":3.5,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.2,"Sepal.Width":3.4,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.7,"Sepal.Width":3.2,"Petal.Length":1.6,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.8,"Sepal.Width":3.1,"Petal.Length":1.6,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.4,"Sepal.Width":3.4,"Petal.Length":1.5,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":5.2,"Sepal.Width":4.1,"Petal.Length":1.5,"Petal.Width":0.1,"Species":"setosa"},{"Sepal.Length":5.5,"Sepal.Width":4.2,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.9,"Sepal.Width":3.1,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.2,"Petal.Length":1.2,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.5,"Sepal.Width":3.5,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.9,"Sepal.Width":3.6,"Petal.Length":1.4,"Petal.Width":0.1,"Species":"setosa"},{"Sepal.Length":4.4,"Sepal.Width":3,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.4,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.5,"Petal.Length":1.3,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":4.5,"Sepal.Width":2.3,"Petal.Length":1.3,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":4.4,"Sepal.Width":3.2,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.5,"Petal.Length":1.6,"Petal.Width":0.6,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.8,"Petal.Length":1.9,"Petal.Width":0.4,"Species":"setosa"},{"Sepal.Length":4.8,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.3,"Species":"setosa"},{"Sepal.Length":5.1,"Sepal.Width":3.8,"Petal.Length":1.6,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":4.6,"Sepal.Width":3.2,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5.3,"Sepal.Width":3.7,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":5,"Sepal.Width":3.3,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},{"Sepal.Length":7,"Sepal.Width":3.2,"Petal.Length":4.7,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":6.4,"Sepal.Width":3.2,"Petal.Length":4.5,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":6.9,"Sepal.Width":3.1,"Petal.Length":4.9,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":5.5,"Sepal.Width":2.3,"Petal.Length":4,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.5,"Sepal.Width":2.8,"Petal.Length":4.6,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":5.7,"Sepal.Width":2.8,"Petal.Length":4.5,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.3,"Sepal.Width":3.3,"Petal.Length":4.7,"Petal.Width":1.6,"Species":"versicolor"},{"Sepal.Length":4.9,"Sepal.Width":2.4,"Petal.Length":3.3,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":6.6,"Sepal.Width":2.9,"Petal.Length":4.6,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.2,"Sepal.Width":2.7,"Petal.Length":3.9,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":5,"Sepal.Width":2,"Petal.Length":3.5,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":5.9,"Sepal.Width":3,"Petal.Length":4.2,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":6,"Sepal.Width":2.2,"Petal.Length":4,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":6.1,"Sepal.Width":2.9,"Petal.Length":4.7,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":5.6,"Sepal.Width":2.9,"Petal.Length":3.6,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.7,"Sepal.Width":3.1,"Petal.Length":4.4,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":5.6,"Sepal.Width":3,"Petal.Length":4.5,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":5.8,"Sepal.Width":2.7,"Petal.Length":4.1,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":6.2,"Sepal.Width":2.2,"Petal.Length":4.5,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":5.6,"Sepal.Width":2.5,"Petal.Length":3.9,"Petal.Width":1.1,"Species":"versicolor"},{"Sepal.Length":5.9,"Sepal.Width":3.2,"Petal.Length":4.8,"Petal.Width":1.8,"Species":"versicolor"},{"Sepal.Length":6.1,"Sepal.Width":2.8,"Petal.Length":4,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.3,"Sepal.Width":2.5,"Petal.Length":4.9,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":6.1,"Sepal.Width":2.8,"Petal.Length":4.7,"Petal.Width":1.2,"Species":"versicolor"},{"Sepal.Length":6.4,"Sepal.Width":2.9,"Petal.Length":4.3,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.6,"Sepal.Width":3,"Petal.Length":4.4,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":6.8,"Sepal.Width":2.8,"Petal.Length":4.8,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":6.7,"Sepal.Width":3,"Petal.Length":5,"Petal.Width":1.7,"Species":"versicolor"},{"Sepal.Length":6,"Sepal.Width":2.9,"Petal.Length":4.5,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":5.7,"Sepal.Width":2.6,"Petal.Length":3.5,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":5.5,"Sepal.Width":2.4,"Petal.Length":3.8,"Petal.Width":1.1,"Species":"versicolor"},{"Sepal.Length":5.5,"Sepal.Width":2.4,"Petal.Length":3.7,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":5.8,"Sepal.Width":2.7,"Petal.Length":3.9,"Petal.Width":1.2,"Species":"versicolor"},{"Sepal.Length":6,"Sepal.Width":2.7,"Petal.Length":5.1,"Petal.Width":1.6,"Species":"versicolor"},{"Sepal.Length":5.4,"Sepal.Width":3,"Petal.Length":4.5,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":6,"Sepal.Width":3.4,"Petal.Length":4.5,"Petal.Width":1.6,"Species":"versicolor"},{"Sepal.Length":6.7,"Sepal.Width":3.1,"Petal.Length":4.7,"Petal.Width":1.5,"Species":"versicolor"},{"Sepal.Length":6.3,"Sepal.Width":2.3,"Petal.Length":4.4,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.6,"Sepal.Width":3,"Petal.Length":4.1,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.5,"Sepal.Width":2.5,"Petal.Length":4,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.5,"Sepal.Width":2.6,"Petal.Length":4.4,"Petal.Width":1.2,"Species":"versicolor"},{"Sepal.Length":6.1,"Sepal.Width":3,"Petal.Length":4.6,"Petal.Width":1.4,"Species":"versicolor"},{"Sepal.Length":5.8,"Sepal.Width":2.6,"Petal.Length":4,"Petal.Width":1.2,"Species":"versicolor"},{"Sepal.Length":5,"Sepal.Width":2.3,"Petal.Length":3.3,"Petal.Width":1,"Species":"versicolor"},{"Sepal.Length":5.6,"Sepal.Width":2.7,"Petal.Length":4.2,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.7,"Sepal.Width":3,"Petal.Length":4.2,"Petal.Width":1.2,"Species":"versicolor"},{"Sepal.Length":5.7,"Sepal.Width":2.9,"Petal.Length":4.2,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.2,"Sepal.Width":2.9,"Petal.Length":4.3,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":5.1,"Sepal.Width":2.5,"Petal.Length":3,"Petal.Width":1.1,"Species":"versicolor"},{"Sepal.Length":5.7,"Sepal.Width":2.8,"Petal.Length":4.1,"Petal.Width":1.3,"Species":"versicolor"},{"Sepal.Length":6.3,"Sepal.Width":3.3,"Petal.Length":6,"Petal.Width":2.5,"Species":"virginica"},{"Sepal.Length":5.8,"Sepal.Width":2.7,"Petal.Length":5.1,"Petal.Width":1.9,"Species":"virginica"},{"Sepal.Length":7.1,"Sepal.Width":3,"Petal.Length":5.9,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":6.3,"Sepal.Width":2.9,"Petal.Length":5.6,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.5,"Sepal.Width":3,"Petal.Length":5.8,"Petal.Width":2.2,"Species":"virginica"},{"Sepal.Length":7.6,"Sepal.Width":3,"Petal.Length":6.6,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":4.9,"Sepal.Width":2.5,"Petal.Length":4.5,"Petal.Width":1.7,"Species":"virginica"},{"Sepal.Length":7.3,"Sepal.Width":2.9,"Petal.Length":6.3,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.7,"Sepal.Width":2.5,"Petal.Length":5.8,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":7.2,"Sepal.Width":3.6,"Petal.Length":6.1,"Petal.Width":2.5,"Species":"virginica"},{"Sepal.Length":6.5,"Sepal.Width":3.2,"Petal.Length":5.1,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":6.4,"Sepal.Width":2.7,"Petal.Length":5.3,"Petal.Width":1.9,"Species":"virginica"},{"Sepal.Length":6.8,"Sepal.Width":3,"Petal.Length":5.5,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":5.7,"Sepal.Width":2.5,"Petal.Length":5,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":5.8,"Sepal.Width":2.8,"Petal.Length":5.1,"Petal.Width":2.4,"Species":"virginica"},{"Sepal.Length":6.4,"Sepal.Width":3.2,"Petal.Length":5.3,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":6.5,"Sepal.Width":3,"Petal.Length":5.5,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":7.7,"Sepal.Width":3.8,"Petal.Length":6.7,"Petal.Width":2.2,"Species":"virginica"},{"Sepal.Length":7.7,"Sepal.Width":2.6,"Petal.Length":6.9,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":6,"Sepal.Width":2.2,"Petal.Length":5,"Petal.Width":1.5,"Species":"virginica"},{"Sepal.Length":6.9,"Sepal.Width":3.2,"Petal.Length":5.7,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":5.6,"Sepal.Width":2.8,"Petal.Length":4.9,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":7.7,"Sepal.Width":2.8,"Petal.Length":6.7,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":6.3,"Sepal.Width":2.7,"Petal.Length":4.9,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.7,"Sepal.Width":3.3,"Petal.Length":5.7,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":7.2,"Sepal.Width":3.2,"Petal.Length":6,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.2,"Sepal.Width":2.8,"Petal.Length":4.8,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.1,"Sepal.Width":3,"Petal.Length":4.9,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.4,"Sepal.Width":2.8,"Petal.Length":5.6,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":7.2,"Sepal.Width":3,"Petal.Length":5.8,"Petal.Width":1.6,"Species":"virginica"},{"Sepal.Length":7.4,"Sepal.Width":2.8,"Petal.Length":6.1,"Petal.Width":1.9,"Species":"virginica"},{"Sepal.Length":7.9,"Sepal.Width":3.8,"Petal.Length":6.4,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":6.4,"Sepal.Width":2.8,"Petal.Length":5.6,"Petal.Width":2.2,"Species":"virginica"},{"Sepal.Length":6.3,"Sepal.Width":2.8,"Petal.Length":5.1,"Petal.Width":1.5,"Species":"virginica"},{"Sepal.Length":6.1,"Sepal.Width":2.6,"Petal.Length":5.6,"Petal.Width":1.4,"Species":"virginica"},{"Sepal.Length":7.7,"Sepal.Width":3,"Petal.Length":6.1,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":6.3,"Sepal.Width":3.4,"Petal.Length":5.6,"Petal.Width":2.4,"Species":"virginica"},{"Sepal.Length":6.4,"Sepal.Width":3.1,"Petal.Length":5.5,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6,"Sepal.Width":3,"Petal.Length":4.8,"Petal.Width":1.8,"Species":"virginica"},{"Sepal.Length":6.9,"Sepal.Width":3.1,"Petal.Length":5.4,"Petal.Width":2.1,"Species":"virginica"},{"Sepal.Length":6.7,"Sepal.Width":3.1,"Petal.Length":5.6,"Petal.Width":2.4,"Species":"virginica"},{"Sepal.Length":6.9,"Sepal.Width":3.1,"Petal.Length":5.1,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":5.8,"Sepal.Width":2.7,"Petal.Length":5.1,"Petal.Width":1.9,"Species":"virginica"},{"Sepal.Length":6.8,"Sepal.Width":3.2,"Petal.Length":5.9,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":6.7,"Sepal.Width":3.3,"Petal.Length":5.7,"Petal.Width":2.5,"Species":"virginica"},{"Sepal.Length":6.7,"Sepal.Width":3,"Petal.Length":5.2,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":6.3,"Sepal.Width":2.5,"Petal.Length":5,"Petal.Width":1.9,"Species":"virginica"},{"Sepal.Length":6.5,"Sepal.Width":3,"Petal.Length":5.2,"Petal.Width":2,"Species":"virginica"},{"Sepal.Length":6.2,"Sepal.Width":3.4,"Petal.Length":5.4,"Petal.Width":2.3,"Species":"virginica"},{"Sepal.Length":5.9,"Sepal.Width":3,"Petal.Length":5.1,"Petal.Width":1.8,"Species":"virginica"}] NA NA NA NA

    iris2 <- fromJSON(jsonData2)
    head(iris2)

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

## 9. The `data.table` package

-   Inherets from `data.frame`
    -   all functions that accept `data.frame` work on `data.table`
-   Written in C, so it is much faster
-   Much faster at subsetting, grouping and updating

<!-- -->

    DF = data.frame(x = rnorm(9), 
                    y = rep(c('a','b','c'), each = 3),
                    z = rnorm(9))
    head(DF,3)

    ##           x y          z
    ## 1 -1.652462 a -0.2955728
    ## 2  0.231394 a  0.2434540
    ## 3 -1.211792 a  0.6560301

    library(data.table)
    DT = data.table(x = rnorm(9), 
                    y = rep(c('a','b','c'), each = 3),
                    z = rnorm(9))
    head(DT,3)

    ##             x y          z
    ## 1:  0.7570613 a -0.1419903
    ## 2: -0.1640536 a  1.4872820
    ## 3: -0.9179018 a -0.3312729

### See all the data tables in memory

    tables()

    ##    NAME NROW NCOL MB  COLS KEY
    ## 1:   DT    9    3  0 x,y,z    
    ## Total: 0MB

### Subsetting rows

    DT[2,]

    ##             x y        z
    ## 1: -0.1640536 a 1.487282

    DT[DT$y=='a',]

    ##             x y          z
    ## 1:  0.7570613 a -0.1419903
    ## 2: -0.1640536 a  1.4872820
    ## 3: -0.9179018 a -0.3312729

    DT[c(2,3)] # the second and third rows

    ##             x y          z
    ## 1: -0.1640536 a  1.4872820
    ## 2: -0.9179018 a -0.3312729

### Subsetting columns

-   The subsetting function is modifed for data.table
-   The argument you pass after the comma is called an ‘expression’
-   In `R` an expression is a collection of statements enclosed in
    curley brackets

<!-- -->

    DT[,list(mean(x),sum(z))]

    ##            V1         V2
    ## 1: -0.2600574 -0.1724806

    head(DT)

    ##              x y          z
    ## 1:  0.75706126 a -0.1419903
    ## 2: -0.16405356 a  1.4872820
    ## 3: -0.91790178 a -0.3312729
    ## 4:  0.09523797 b -0.7968534
    ## 5:  0.37901897 b  1.0849623
    ## 6: -0.44052856 b -0.4305321

    DT[,table(y)]

    ## y
    ## a b c 
    ## 3 3 3

    head(DT)

    ##              x y          z
    ## 1:  0.75706126 a -0.1419903
    ## 2: -0.16405356 a  1.4872820
    ## 3: -0.91790178 a -0.3312729
    ## 4:  0.09523797 b -0.7968534
    ## 5:  0.37901897 b  1.0849623
    ## 6: -0.44052856 b -0.4305321

### Adding new columns

    DT[,w:=z^2]
    head(DT)

    ##              x y          z          w
    ## 1:  0.75706126 a -0.1419903 0.02016125
    ## 2: -0.16405356 a  1.4872820 2.21200776
    ## 3: -0.91790178 a -0.3312729 0.10974173
    ## 4:  0.09523797 b -0.7968534 0.63497529
    ## 5:  0.37901897 b  1.0849623 1.17714310
    ## 6: -0.44052856 b -0.4305321 0.18535790

    DT2 <- DT
    DT[,y:=2]
    head(DT,n=3)

    ##             x y          z          w
    ## 1:  0.7570613 2 -0.1419903 0.02016125
    ## 2: -0.1640536 2  1.4872820 2.21200776
    ## 3: -0.9179018 2 -0.3312729 0.10974173

    head(DT2,n=3)

    ##             x y          z          w
    ## 1:  0.7570613 2 -0.1419903 0.02016125
    ## 2: -0.1640536 2  1.4872820 2.21200776
    ## 3: -0.9179018 2 -0.3312729 0.10974173

### Multiple operations

    DT[, m:= {tmp <- (x+2); log2(tmp+5)}]
    head(DT)

    ##              x y          z          w        m
    ## 1:  0.75706126 2 -0.1419903 0.02016125 2.955510
    ## 2: -0.16405356 2  1.4872820 2.21200776 2.773141
    ## 3: -0.91790178 2 -0.3312729 0.10974173 2.604569
    ## 4:  0.09523797 2 -0.7968534 0.63497529 2.826851
    ## 5:  0.37901897 2  1.0849623 1.17714310 2.883429
    ## 6: -0.44052856 2 -0.4305321 0.18535790 2.713580

### `plyr`-like options

    DT[, a:=x>0]
    head(DT)

    ##              x y          z          w        m     a
    ## 1:  0.75706126 2 -0.1419903 0.02016125 2.955510  TRUE
    ## 2: -0.16405356 2  1.4872820 2.21200776 2.773141 FALSE
    ## 3: -0.91790178 2 -0.3312729 0.10974173 2.604569 FALSE
    ## 4:  0.09523797 2 -0.7968534 0.63497529 2.826851  TRUE
    ## 5:  0.37901897 2  1.0849623 1.17714310 2.883429  TRUE
    ## 6: -0.44052856 2 -0.4305321 0.18535790 2.713580 FALSE

### Special variables

`.N` An integer, length 1, containing the number r

    set.seed(123)
    DT <- data.table(x = sample(letters[1:3], 1E5, TRUE))
    DT[, .N, by = x]

    ##    x     N
    ## 1: c 33294
    ## 2: b 33305
    ## 3: a 33401

### Keys

    DT <- data.table(x = rep(c('a','b','c'), each = 1000),
                     y = rnorm(300))
    setkey(DT,x)
    DT['a']

    ##       x           y
    ##    1: a  0.88631257
    ##    2: a  2.82858132
    ##    3: a  2.03145429
    ##    4: a  1.90675413
    ##    5: a  0.21490826
    ##   ---              
    ##  996: a -0.02793948
    ##  997: a -1.74492339
    ##  998: a  0.65284209
    ##  999: a -0.93830821
    ## 1000: a  0.62753159

    DT1 <- data.table(x = c('a','a','b','dt1'),
                     y = 1:4)
    DT2 <- data.table(x = c('a','b','dt2'),
                     z = 5:7)
    setkey(DT1, x)
    setkey(DT2, x)
    merge(DT1, DT2)

    ##    x y z
    ## 1: a 1 5
    ## 2: a 2 5
    ## 3: b 3 6

### Fast reading

    big_df <- data.frame(x = rnorm(1E6),
                         y = rnorm(1E6))
    file <- tempfile()
    write.table(big_df, file = file,
                row.names = FALSE, col.names = TRUE,
                sep = '\t', quote = FALSE)
    system.time(fread(file))

    ##    user  system elapsed 
    ##   0.042   0.004   0.047

    system.time(read.table(file, header = TRUE, sep ='\t'))

    ##    user  system elapsed 
    ##   2.541   0.049   2.591
