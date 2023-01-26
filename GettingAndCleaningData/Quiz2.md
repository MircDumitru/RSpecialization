# Organizing, merging and managing the data - Week 1 Quiz

## Question 1

Register an application with the Github API here
<https://github.com/settings/applications>. Access the API to get
information on your instructors repositories (hint: this is the url you
want <https://api.github.com/users/jtleek/repos>). Use this data to find
the time that the datasharing repo was created. What time was it
created?

This tutorial may be useful
(<https://github.com/hadley/httr/blob/master/demo/oauth2-github.r>). You
may also need to run the code in the base R package and not R studio.

        library(jsonlite)
        library(httr)

        oauth_endpoints("github")

    ## <oauth_endpoint>
    ##  authorize: https://github.com/login/oauth/authorize
    ##  access:    https://github.com/login/oauth/access_token

        gitapp <- oauth_app(appname = "CourseraQuiz",
                            key = "41ea1a57f120665ae076",
                            secret = "40f3391f0692d698a744fd2a1f5d7d65ef0e0bb1")
        gitapp

    ## <oauth_app> CourseraQuiz
    ##   key:    41ea1a57f120665ae076
    ##   secret: <hidden>

        load("./data/github_token.Rdata")
        
        #github_token <- oauth2.0_token(oauth_endpoints("github"), gitapp)
        #github_token

        gtoken <- config(token = github_token)
        gtoken

    ## <request>
    ## Auth token: Token2.0

        req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
        stop_for_status(req)
        json = content(req)
        df = jsonlite::fromJSON(jsonlite::toJSON(json))
        names(df)

    ##  [1] "id"                          "node_id"                    
    ##  [3] "name"                        "full_name"                  
    ##  [5] "private"                     "owner"                      
    ##  [7] "html_url"                    "description"                
    ##  [9] "fork"                        "url"                        
    ## [11] "forks_url"                   "keys_url"                   
    ## [13] "collaborators_url"           "teams_url"                  
    ## [15] "hooks_url"                   "issue_events_url"           
    ## [17] "events_url"                  "assignees_url"              
    ## [19] "branches_url"                "tags_url"                   
    ## [21] "blobs_url"                   "git_tags_url"               
    ## [23] "git_refs_url"                "trees_url"                  
    ## [25] "statuses_url"                "languages_url"              
    ## [27] "stargazers_url"              "contributors_url"           
    ## [29] "subscribers_url"             "subscription_url"           
    ## [31] "commits_url"                 "git_commits_url"            
    ## [33] "comments_url"                "issue_comment_url"          
    ## [35] "contents_url"                "compare_url"                
    ## [37] "merges_url"                  "archive_url"                
    ## [39] "downloads_url"               "issues_url"                 
    ## [41] "pulls_url"                   "milestones_url"             
    ## [43] "notifications_url"           "labels_url"                 
    ## [45] "releases_url"                "deployments_url"            
    ## [47] "created_at"                  "updated_at"                 
    ## [49] "pushed_at"                   "git_url"                    
    ## [51] "ssh_url"                     "clone_url"                  
    ## [53] "svn_url"                     "homepage"                   
    ## [55] "size"                        "stargazers_count"           
    ## [57] "watchers_count"              "language"                   
    ## [59] "has_issues"                  "has_projects"               
    ## [61] "has_downloads"               "has_wiki"                   
    ## [63] "has_pages"                   "has_discussions"            
    ## [65] "forks_count"                 "mirror_url"                 
    ## [67] "archived"                    "disabled"                   
    ## [69] "open_issues_count"           "license"                    
    ## [71] "allow_forking"               "is_template"                
    ## [73] "web_commit_signoff_required" "topics"                     
    ## [75] "visibility"                  "forks"                      
    ## [77] "open_issues"                 "watchers"                   
    ## [79] "default_branch"              "permissions"

        df[df$full_name == "jtleek/datasharing", "created_at"] 

    ## [[1]]
    ## [1] "2013-11-07T13:25:07Z"

## Question 2

The `sqldf` package allows for execution of `SQL` commands on `R` data
frames. We will use the `sqldf` package to practice the queries we might
send with the `dbSendQuery` command in `RMySQL`.

Download the American Community Survey data
<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv> and
load it into an `R` object called `acs`.

Which of the following commands will select only the data for the
probability weights pwgtp1 with ages less than 50?

        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
        download.file(fileUrl, './data/quiz22.csv', method = 'curl')
        acs <- read.csv('./data/quiz22.csv')
        head(acs)[, 1:6]

    ##   RT SERIALNO SPORDER PUMA ST  ADJUST
    ## 1  P      186       1  700 16 1015675
    ## 2  P      186       2  700 16 1015675
    ## 3  P      186       3  700 16 1015675
    ## 4  P      186       4  700 16 1015675
    ## 5  P      306       1  700 16 1015675
    ## 6  P      395       1  100 16 1015675

        dim(acs)

    ## [1] 14931   239

        library(sqldf)
        # This selects only the column corresponding to the the pwgtp1, with no filter for the second condition (age less than 50)
        acs1 <- sqldf("select pwgtp1 from acs")
        head(acs1)

    ##   pwgtp1
    ## 1     87
    ## 2     88
    ## 3     94
    ## 4     91
    ## 5    539
    ## 6    192

        # This selects the dataframe with rows corresponding to age less than 50.
        acs2 <- sqldf("select * from acs where AGEP < 50")
        head(acs2)[, 1:6]

    ##   RT SERIALNO SPORDER PUMA ST  ADJUST
    ## 1  P      186       1  700 16 1015675
    ## 2  P      186       2  700 16 1015675
    ## 3  P      186       3  700 16 1015675
    ## 4  P      186       4  700 16 1015675
    ## 5  P      306       1  700 16 1015675
    ## 6  P      395       1  100 16 1015675

        dim(acs2)

    ## [1] 10093   239

        #But it can be used the extract the desired result by selecting the column corresponding to the probability weights
        acs2$pwgtp1[1:6]

    ## [1]  87  88  94  91 539 192

        # This selects the desired output: selects the probabilty column from the data based, filtered based on the aga conditiion.
        acs3 <- sqldf("select pwgtp1 from acs where AGEP < 50")
        head(acs3)

    ##   pwgtp1
    ## 1     87
    ## 2     88
    ## 3     94
    ## 4     91
    ## 5    539
    ## 6    192

        # This doesn't change the (original) dataframe, no condition is applied for the selection hence it selects the whole dataframe
        acs4 <- sqldf("select * from acs")
        head(acs4)[, 1:6]

    ##   RT SERIALNO SPORDER PUMA ST  ADJUST
    ## 1  P      186       1  700 16 1015675
    ## 2  P      186       2  700 16 1015675
    ## 3  P      186       3  700 16 1015675
    ## 4  P      186       4  700 16 1015675
    ## 5  P      306       1  700 16 1015675
    ## 6  P      395       1  100 16 1015675

        dim(acs4)

    ## [1] 14931   239

## Question 3

Using the same data frame you created in the previous problem, what is
the equivalent function to `unique(acs$AGEP)`

       # acs$AGEP
       # library(DBI)
       # library(RMySQL)
       # This returns the unique values in the the AGEP column of the acs dataframe
       unique(acs$AGEP)[1:6]

    ## [1] 43 42 16 14 29 40

       # This returns the unique values in the the AGEP column of the acs dataframe as a dataframe.
       # CORRECT.
       acs.f1 <- sqldf("select distinct AGEP from acs")
       acs.f1$AGEP[1:6]

    ## [1] 43 42 16 14 29 40

       # This leads to an error. The sqldf grammar uses "distinct", not "unique".
       # Wrong.
       # df.f2 <- sqldf("select unique AGEP from acs")
       
       # This returns the unique values in the the pwgtp1 column of the acs dataframe
       # Wrong.
       acs.f3 <- sqldf("select distinct pwgtp1 from acs")
       head(acs.f3)

    ##   pwgtp1
    ## 1     87
    ## 2     88
    ## 3     94
    ## 4     91
    ## 5    539
    ## 6    192

       # This leads to an error. The sqldf grammar uses "distinct", not "unique".
       # Wrong.
       # sqldf("select AGEP where unique from acs")

## Question 4

How many characters are in the 10th, 20th, 30th and 100th lines of HTML
from this page:

<http://biostat.jhsph.edu/~jleek/contact.html>

(Hint: the `nchar()` function in `R` may be helpful)

        con = url("http://biostat.jhsph.edu/~jleek/contact.html")
        htmlCode = readLines(con)
        close(con)
        htmlCode[c(10, 20, 30, 100)]

    ## [1] "<meta name=\"Distribution\" content=\"Global\" />"
    ## [2] "<script type=\"text/javascript\">"                
    ## [3] "  })();"                                          
    ## [4] "\t\t\t\t<ul class=\"sidemenu\">"

        nchar(htmlCode[c(10, 20, 30, 100)])

    ## [1] 45 31  7 25

## Question 5

Read this data set into R and report the sum of the numbers in the
fourth of the nine columns.

<https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for>

Original source of the data:
<http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for>

(Hint this is a fixed width file format)

        fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
        fwfdata <- read.fwf(fileUrl, 
                            widths = c(1, 9, rep(c(5, 4, 1, 3), 4)),
                            col.names = c('filler','week', 
                                          'filler', 'SST12', 'filler' ,'SSTA12',
                                          'filler', 'SST3', 'filler' ,'SSTA3',
                                          'filler', 'SST34', 'filler' ,'SSTA34',
                                          'filler', 'SST4', 'filler', 'SSTA4'),
                            header = FALSE, skip = 4)
        head(fwfdata,4)

    ##   filler      week filler.1 SST12 filler.2 SSTA12 filler.3 SST3 filler.4 SSTA3
    ## 1     NA 03JAN1990       NA  23.4        -    0.4       NA 25.1        -   0.3
    ## 2     NA 10JAN1990       NA  23.4        -    0.8       NA 25.2        -   0.3
    ## 3     NA 17JAN1990       NA  24.2        -    0.3       NA 25.3        -   0.3
    ## 4     NA 24JAN1990       NA  24.4        -    0.5       NA 25.5        -   0.4
    ##   filler.5 SST34 filler.6 SSTA34 filler.7 SST4 filler.8 SSTA4
    ## 1       NA  26.6             0.0       NA 28.6            0.3
    ## 2       NA  26.6             0.1       NA 28.6            0.3
    ## 3       NA  26.5        -    0.1       NA 28.6            0.3
    ## 4       NA  26.5        -    0.1       NA 28.4            0.2

        fwfdata <- fwfdata[,!grepl('filler',names(fwfdata))]
        head(fwfdata,4)

    ##        week SST12 SSTA12 SST3 SSTA3 SST34 SSTA34 SST4 SSTA4
    ## 1 03JAN1990  23.4    0.4 25.1   0.3  26.6    0.0 28.6   0.3
    ## 2 10JAN1990  23.4    0.8 25.2   0.3  26.6    0.1 28.6   0.3
    ## 3 17JAN1990  24.2    0.3 25.3   0.3  26.5    0.1 28.6   0.3
    ## 4 24JAN1990  24.4    0.5 25.5   0.4  26.5    0.1 28.4   0.2

        sum(fwfdata[,4])

    ## [1] 32426.7
