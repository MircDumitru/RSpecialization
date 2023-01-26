# Organizing, merging and managing the data - Week 4 Notes

## 1. Editing Text Variables

### Fixing character vectors via `toupper()` and `tolower()`

    df <- read.csv('./data/restaurants.csv')
    names(df)

    ## [1] "name"            "zipCode"         "neighborhood"    "councilDistrict"
    ## [5] "policeDistrict"  "Location.1"

    tolower(names(df))

    ## [1] "name"            "zipcode"         "neighborhood"    "councildistrict"
    ## [5] "policedistrict"  "location.1"

    toupper(names(df))

    ## [1] "NAME"            "ZIPCODE"         "NEIGHBORHOOD"    "COUNCILDISTRICT"
    ## [5] "POLICEDISTRICT"  "LOCATION.1"

Separate values that are separated by periods via `strsplit()`

    # Notice the escape character because . is a reserved character.
    splitNames <- strsplit(names(df), '\\.')
    splitNames

    ## [[1]]
    ## [1] "name"
    ## 
    ## [[2]]
    ## [1] "zipCode"
    ## 
    ## [[3]]
    ## [1] "neighborhood"
    ## 
    ## [[4]]
    ## [1] "councilDistrict"
    ## 
    ## [[5]]
    ## [1] "policeDistrict"
    ## 
    ## [[6]]
    ## [1] "Location" "1"

    splitNames[[5]]

    ## [1] "policeDistrict"

    # Here are two components.
    splitNames[[6]]

    ## [1] "Location" "1"

Quick aside on list

    mylist <- list(letters = c('A', 'B', 'C'),
                   numbers = 1:3,
                   matrix(1:25, ncol = 5))
    head(mylist)     

    ## $letters
    ## [1] "A" "B" "C"
    ## 
    ## $numbers
    ## [1] 1 2 3
    ## 
    ## [[3]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    1    6   11   16   21
    ## [2,]    2    7   12   17   22
    ## [3,]    3    8   13   18   23
    ## [4,]    4    9   14   19   24
    ## [5,]    5   10   15   20   25

    mylist[1]

    ## $letters
    ## [1] "A" "B" "C"

    mylist$letters

    ## [1] "A" "B" "C"

    mylist[[1]]

    ## [1] "A" "B" "C"

    splitNames[[6]][1]

    ## [1] "Location"

    # Function that extracts the first element from a list
    firstElement <- function(x){x[1]}
    # apply the function over each list corresponding to each name.
    sapply(splitNames,firstElement)

    ## [1] "name"            "zipCode"         "neighborhood"    "councilDistrict"
    ## [5] "policeDistrict"  "Location"

    #if(!file.exists('./data')){
    #  dir.create("./data")
    #}
    #fileUrl1 <- 'https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/04_01_editingTextVariables/data/reviews.csv'
    #fileUrl2 <- 'https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/04_01_editingTextVariables/data/solutions.csv'
    #download.file(fileUrl1, destfile = './data/reviews.csv', method = 'curl')
    #download.file(fileUrl2, destfile = './data/solutions.csv', method = 'curl')
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

Substituting out characters is done via the `sub()` function. Replacing
multiple instances of a characters via the `gsub()` function

    names(reviews)

    ## [1] "id"          "solution_id" "reviewer_id" "start"       "stop"       
    ## [6] "time_left"   "accept"

    sub('_', '', names(reviews))

    ## [1] "id"         "solutionid" "reviewerid" "start"      "stop"      
    ## [6] "timeleft"   "accept"

    testName <- 'this_is_a_test_string'
    sub('_', '', testName)

    ## [1] "thisis_a_test_string"

    gsub('_', '', testName)

    ## [1] "thisisateststring"

Searching for specific values and variable names is done via `grep()`
and `grepl()`

    grep('DESERT', df$name)

    ## [1] 341 342

    table(grepl('DESERT', df$name))

    ## 
    ## FALSE  TRUE 
    ##  1325     2

Subsetting:

    # The dataframe that is excluding the rows of restaurants containing the DESERT in their name.
    df.f <- df[!grepl('DESERT', df$name),]
    dim(df)

    ## [1] 1327    6

    dim(df.f)

    ## [1] 1325    6

The elements in the list where the searched appear:

    grep('DESERT', df$name, value = TRUE)

    ## [1] "DESERT CAFE'(1605-07)" "DESERT INN"

    length(grep('DESERT', df$name, value = TRUE))

    ## [1] 2

    grep('VEGAN', df$name, value = TRUE)

    ## character(0)

    length(grep('VEGAN', df$name, value = TRUE))

    ## [1] 0

### The `stringr` library

Getting the number of characters in a string - via `nchar()`

    library(stringr)
    nchar('Jeffrey Leek')

    ## [1] 12

Getting a substring from a string - via `substr()`

    substr('Jeffrey Leek', 1,7)

    ## [1] "Jeffrey"

Concatenating strings - via `paste()`

    paste('Jeffrey', 'Leek')

    ## [1] "Jeffrey Leek"

    paste('Jeffrey', 'Leek', sep = ',')

    ## [1] "Jeffrey,Leek"

    paste('Jeffrey', 'Leek', sep = '')

    ## [1] "JeffreyLeek"

    paste0('Jeffrey', 'Leek')

    ## [1] "JeffreyLeek"

Trimming a string from spaces at the end of the string - via
`str_trim()`

    str_trim('Jeffrey   ')

    ## [1] "Jeffrey"

## 2. Regular Expressions I

-   Regular expressions can be thought of as a combination of literals
    and metacharacters

-   An analogy with natural language:

    -   literal text forming the words of this langauges
    -   metacharacters define the gramar

-   Regular expressions have a rich set of metacharacters

-   Simplest pattern consists only of literals: a match occurs if the
    sequance of literals occurs anwyehere in the ext being tested.

-   We need a way to express:

    -   whitespace word boundaries -sets of literals
    -   the beginning and end of a line
    -   alternatives (“war”/“peace”)

### Starting of a line metacharacters

The `^` represent the START of a line:

    ^i think

will match all of these lines

    i think we all rule for participating
    i think i have ben outed
    i think this will be quite fun

but it won’t match if *i think* would be anywhere else except the
begining of the line.

### Ending of a line metacharacters

The `$` represent the END of a line:

    morning$

will match all of these lines

    something in the morning
    catch a tram home in the morning
    good morning

### Character classes with \[\]

We can list a set of characters we will accept at a given point in the
match

    [Bb] [Uu] [Ss] [Hh]

will match the lines

    The democrats are playing "Name the worst think about Bush!"
    I smelled the desert creosot bush, brownies, BBQ chicken
    BBQ and bushwalking at Molonglo George

### Combinations:

The starting ^, ending $ and the \[\] can be combined for more targeted
searches.

The expression

    ^[Ii] am

will search of for the string *i am*, - at the begining of the line
(because of the ^) - with *i* upercase of lowecase (because of \[Ii\])
so will match

    i am so angry
    I am twittering
    I am over this.

Similarly, you can specifiy a *range* of letters \[a-z\] or \[a-za-Z\]
(notice that the order doesn’t matter):

the expression

    ^[0-9][a-zA-Z]

will match

    7th inning stretch
    2nd half
    3am - can't sleep
    1st sign 
    5ft 7 sent from heaven

When used at the begining of a character class, the “^” is also a
metacharacter and indicates matching charcaters NOT in the indicating
class

    [^?.]$

will search of line endings that doesn’t have “?” or “.” so will match

    i like basketball
    6 and 9
    we all die anyway!

because they don’t end up with a “?” or “.”

## 3. Regular Expressions II

### The “.” - any

The “.” is used to refere to *any* character. So,

    9.11

will match

    the post 9-11 rules
    the 9/11 tragedy
    NetBios: scaning ip 203.169.114.66

### The “|” - or

The “|” metacharacter does *not* mean *pipe* in the context of regular
expressions. It translates to *or*: we can is to combine two expression,
the subexpressions being called alternatives:

    flood|fire

will match the lines

    is firewire like usb on none macs?
    the global flood makes sense 
    i've had the fine on tonight

because all lines contain “flood” *or* “fire”

The “|” metacharacter can be used to include up to any number of
alternatives you want.

    flood|earthquake|hurricane

for searching for one of the fourth words.

The alternatives can be regular expressions, not just literals. For
example

    ^[Gg]ood|[Bb]ad

will search for:

    -"good" at the beggining of the lines irrespective if the first letter is uppercase or lowercase 
    - "bad", irrespective of the position in the line (the absence of "^"), and irrespective if the first letter is uppercase or lowercase 

Subexpressions are often contained in parentheses to constrain the
alternatives:

    ^([Gg]ood|[Bb]ad)

will search for both alternatives at the begining at the line.

### The “?” - optional

The “?” indicates the that indicated expression is optional:

    [Gg]eorge( [Ww] \.)? [Bb]ush

In the above expression the goal was to match a “.” as a literal period;
to do that, we had to “escape” the metacharacter preceding it with a
backslash

We have to do this for any metacharcates we want to include in our
match.

### The “\*” and “+” - repetition

-   “\*” means “any number including none, of the item”
-   “+” means “at least one of item”

<!-- -->

    (.*)

will search for a paranthesis with any character(s) inside, no matter
the number. It will match

    (24, m, germany)
    ... (east area )
    ()

For the expression

    [0-9]+ (.*)[0-9]+

looks for:

    * at least one number followed by
    * any number of characters, including zero followed by,
    * at least one number

This search allows to check for any possible combination of numbers that
are separated by any length combination of characters

### The “{” and “}” - interval quantifiers

They allow to specify the minimum and maximum number of matches of an
expression

    [Bb]ush(+[^ ]+ +){1,5} debate

will search for:

    * Bush (capital or lowercase)
    * at least one space followed by at least one something that is not space followed by at least one space (between 1 and 5 times) followed by
    * followed by debate

For the curly brackets syntax:

    * {m,n} - at least m but not more than n
    * {m} - exactly m
    * {m,} - at least m

### The “\1”, “\2” - matched text

In most implementations, of regular expressions the parantheses can be
used to remember text matched by the subexpression enclosed. The matched
text is refered by “\1”, “\2”…

The expressons

     +([a-zA-Z]+) +\1+

looks for \* one or more spaces, followed by \* one or more characters,
followed by \* one or more spaces followed by \* one or more matched
expressions found before

The “\*” is greedy, so it always matches the *longest* possible stirng
that satisfies the regular expression. To make it less greedy, what we
can do is to add “?”

## 4. Working with Dates

        d1 <- date()
        d1

    ## [1] "Thu Jan 26 23:24:19 2023"

        class(d1)

    ## [1] "character"

        d2 <- Sys.Date()
        d2

    ## [1] "2023-01-26"

        class(d2)

    ## [1] "Date"

Formating dates:

-   %d - day as number (0-31)
-   %a - abbreviated weekday
-   %A - unabbreviated weekday
-   %m - month (00 -12)
-   %b - abbreviated month
-   %B - unabbreviated month
-   %y - two digit yaer
-   %Y - four digit yaer

<!-- -->

    format(d2, "%a %b %d")

    ## [1] "Thu Jan 26"

### Creating dates

    x <- c("1jan1960","2jan1960","21mar1960","29jul1960")
    z <- as.Date(x, "%d %b %Y")
    z

    ## [1] "1960-01-01" "1960-01-02" "1960-03-21" "1960-07-29"

    z[1] - z[2]

    ## Time difference of -1 days

    as.numeric(z[1] - z[2])

    ## [1] -1

### Julian conversion

    weekdays(d2)

    ## [1] "Thursday"

    months(d2)

    ## [1] "January"

    julian(d2)

    ## [1] 19383
    ## attr(,"origin")
    ## [1] "1970-01-01"

### Lubridate package

    library(lubridate);
    ymd('20230108')

    ## [1] "2023-01-08"

    mdy('08/04/2023')

    ## [1] "2023-08-04"

    dmy('03-04-2023')

    ## [1] "2023-04-03"

    ymd_hms('2023-08-03 10:15:04')

    ## [1] "2023-08-03 10:15:04 UTC"

    ymd_hms('2023-08-03 10:15:04', tz = "Pacific/Auckland")

    ## [1] "2023-08-03 10:15:04 NZST"

    ?Sys.timezone

    x = dmy(c("1jan1960","2jan1960","21mar1960","29jul1960"))
    wday(x)

    ## [1] 6 7 2 6

    wday(x, label = TRUE)

    ## [1] Fri Sat Mon Fri
    ## Levels: Sun < Mon < Tue < Wed < Thu < Fri < Sat

## 5. Data Resources

Open Government Sites

-   United Nations: <https://data.un.org>
-   United States: <https://data.gov>
-   United Kingdom: <https://data.gov.uk>
-   France: <https://www.data.gouv.fr>
-   Many more: <https://www.data.gov/opendatasites>
-   Gapminder: <https://www.gapminder.org>
-   United States Susveys: <https://www.asdfree.com>
-   Infochimps Marketplace: <https://www.infochimps/com/marketplace>
