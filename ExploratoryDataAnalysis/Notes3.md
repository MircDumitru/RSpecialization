## 1. Hierarchical clustering

Simple to use and very useful for visualizing high dimensional data. The
ideas are fairly intuitive and it is a quick way to get a sense what is
happening in a high dimensional set.

### Clustering

Clustering organizes data points that are **close** into groups

-   How do we define close?
-   How do we group data points?
-   How do we visualize the grouping?
-   How do we interpret the grouping?

### Hierarchical clustering

-   An agglomerative approach
    -   find closest two things
    -   put them together
    -   find the closest
-   Requires
    -   a defined distance
    -   a merging approach
-   Produces
    -   a tree showing how close things are to each other (dendogram)

#### How do we define close?

-   Most important step
    -   Garbage in -&gt; garbage out
-   Distance or similarity
    -   Continuous - euclidean distance, correlation similarity
    -   Binary - Manhattan distance
-   Pic a distance/similiarty that makes sense for yur problem.

<!-- -->

    set.seed(1234)
    par(mar = c(0,0,0,0))
    x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
    y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
    plot(x, y, col = "blue", pch = 19, cex = 2)
    text(x + 0.05, y + 0.05, labels = as.character(1:12))

![](Notes3_files/figure-markdown_strict/unnamed-chunk-1-1.png)

    df <- data.frame(x = x, y = y)
    distxy <- dist(df)
    hClustering <- hclust(distxy)
    plot(hClustering)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-2-1.png)

### Merging points

How do you merge points together? What is the new location of the
“merged” point? \* Average linkage - center of gravity of the points
group. \* Complete linkage - the distance between two clusters is the
distance between the furtherest from each other two points in the
clusters.

### heatmap() function

    df <- data.frame(x = x, y = y)
    set.seed(143)
    dataMatrix <- as.matrix(df)[sample(1:12),]
    heatmap(dataMatrix)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-3-1.png)

## 2. K-means clustering & dimension reduction

K-Means is an old technique, but remains very useful for summarizing
high dimensional data and seeing what patterns the data show and what
observations are very similar to each other and what observations are
different form each other.

### K-means clustering

-   A partioning approach
    -   fix a number of clusters
    -   get “centroids” of each cluster
    -   assign things to closest centroid
    -   recalculate centroids
-   Requires
    -   a defined distance metric
    -   a number of clusters
    -   an inital guess as to cluster centroids
-   Produces
    -   final estmate of cluster centroids
    -   an assignment of each point to clusters

<!-- -->

    set.seed(1234)
    par(mar = c(0,0,0,0))
    x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
    y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
    plot(x,y,col = 'cyan', pch = 19, cex = 2)
    text(x + 0.05, y + 0.05, labels = as.character(1:12))

![](Notes3_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    dataFrame <- data.frame(x,y)
    kMeansObj <- kmeans(dataFrame, centers = 3)
    kMeansObj <- kmeans(dataFrame, centers = 3)
    plot(x,y, col = kMeansObj$cluster, pch = 19, cex = 2)
    points(kMeansObj$centers, col = 1:3, pch = 3, cex = 3)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-4-2.png)

    names(kMeansObj)

    ## [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
    ## [6] "betweenss"    "size"         "iter"         "ifault"

    kMeansObj$cluster

    ##  [1] 3 3 3 3 1 1 1 1 2 2 2 2

    kMeansObj$iter

    ## [1] 1

    kMeansObj$centers

    ##           x         y
    ## 1 1.9906904 2.0078229
    ## 2 2.8534966 0.9831222
    ## 3 0.8904553 1.0068707

#### Heatmaps

    set.seed(1234)
    dataMatrix <-as.matrix(dataFrame)[sample(1:12), ]
    kMeansObj2 <- kmeans(dataMatrix, centers = 3)
    par(mfrow = c(1, 2), mar = c(2, 4, 0.1, 0.1))
    image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt = 'n')
    image(t(dataMatrix)[, order(kMeansObj2$cluster)], yaxt = 'n')

![](Notes3_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### Dimension Reduction

Principal Components Analysis (PCA) and Singlur Value Decomposition
(SVD) are important techniques both in the exploratory data analysis
phase and in the more formal modeling phase. The technique can be easily
used in both stages. Here it is covered how it is used in the
exploratory phase, going through what goes underneath and what the
underlying basis is.

    set.seed(12345)
    par(mar = rep(0.2, 4))
    dataMatrix <- matrix(rnorm(400), nrow = 40)
    image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])

![](Notes3_files/figure-markdown_strict/unnamed-chunk-10-1.png)

    par(mar = rep(.2, 4))
    heatmap(dataMatrix)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-11-1.png)

#### Adding a pattern to the data set

    set.seed(678910)
    for(i in 1:40){
        # flip a coin
        coinFlip <- rbinom(1, size = 1, prob = 0.5)
        # if coin is head add a common patter to that row
       if(coinFlip){
           dataMatrix[i,] <- dataMatrix[i, ] + rep(c(0,3), each = 5)
       } 
    }
    par(mar = rep(0.2, 4))
    image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])

![](Notes3_files/figure-markdown_strict/unnamed-chunk-12-1.png)

    par(mar = rep(.2, 4))
    heatmap(dataMatrix)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-13-1.png)

#### Patterns in rows and columns

    hh <- hclust(dist(dataMatrix))
    dataMatrixOrdered <- dataMatrix[hh$order, ]
    par(mfrow = c(1, 3))
    image(t(dataMatrixOrdered)[ , nrow(dataMatrixOrdered):1])
    plot(rowMeans(dataMatrixOrdered), 40:1, 
        xlab = 'Row Mean', ylab = 'Row', pch = 19)
    plot(colMeans(dataMatrixOrdered), 
        xlab = 'Column', ylab = 'Column Mean', pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-14-1.png)

#### Related problems

You have multivarate variables
**X**<sub>1</sub>, …, **X**<sub>*n*</sub>, so
**X**<sub>*i*</sub> = (*X*<sub>*i*1</sub>,…,*X*<sub>*i**m*</sub>). \*
Find a new set of multivariate variables that are uncorrelated and
explain as much variance as possible. \* If you put all variables
together in one matrix, find the best matrix xreated with fewer
variables (lower rank) that explains the original data.

The first goal is *statistical* and the second one is *data
compression*.

#### SVD - Singular value decomposition

If **X** is a matrix wwith each variable in a column and each
observation in a row then the SVD is a *matrix decomposition*

where \* the columns of **U** are orthogonal (left singular vectors), \*
the columns of **V** are orthogonal (right singular vectors) \* the
matrix **D** is a diagonal matrix (singular values)

#### PCA - Principal components analysis

The principal components are equal to the right singular values if you
first scale (substract the mean & divide by the standard deviation) the
variables.

#### Components of the SVD - **u** and **v**

    svd1 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(1,3))
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    plot(svd1$u[, 1], 40:1, 
         xlab = 'Row', 
         ylab = 'First left singular vector',
         pch = 19)
    plot(svd1$v[, 1], 
         xlab = 'Column', 
         ylab = 'First right singular vector',
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-15-1.png)

    svd1$u[,1]

    ##  [1] -0.14105455 -0.13890797 -0.15326905 -0.12875622 -0.08905957 -0.09789417
    ##  [7] -0.01126703 -0.04883403 -0.07287826 -0.02907261 -0.16970155 -0.12607341
    ## [13] -0.20210126 -0.19378533 -0.11823805 -0.12021471 -0.11304998 -0.12292726
    ## [19] -0.12408459 -0.16862945 -0.12165026 -0.17502622 -0.16546733 -0.13656414
    ## [25]  0.21500524  0.26902554  0.18307788  0.23164192  0.17210362  0.17174938
    ## [31]  0.22996415  0.15284317  0.12981249  0.11361322  0.18650320  0.14881901
    ## [37]  0.16285835  0.23376268  0.14362847  0.22409869

    svd1$v[,1]

    ##  [1] -0.01269600  0.11959541  0.03336723  0.09405542 -0.12201820 -0.43175437
    ##  [7] -0.44120227 -0.43732624 -0.44207248 -0.43924243

#### Components of the SVD - variance explained

    par(mfrow = c(1,2))
    plot(svd1$d, 
         xlab = 'Column', 
         ylab = 'Singlar value', 
         pch = 19)
    plot(svd1$d^2/sum(svd1$d^2), 
         xlab = 'Column', 
         ylab = 'Prop. of variane explained', 
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-18-1.png)

#### Relationship to principal compoents

    svd1 <- svd(scale(dataMatrixOrdered))
    pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
    plot(pca1$rotation[,1], svd1$v[,1], 
         xlab = 'Principal Component 1',
         ylab = 'Right Singular Vector 1',
         pch = 19)  
    abline(c(0,1))

![](Notes3_files/figure-markdown_strict/unnamed-chunk-19-1.png)

#### Components of SVD - variance explained

    constantMatrix <- dataMatrixOrdered * 0
    for(i in 1:dim(dataMatrixOrdered)[1]){
        constantMatrix[i,] <- rep(c(0,1), each = 5)
    }
    svd1 <- svd(constantMatrix)
    par(mfrow = c(1,3))
    image(t(constantMatrix)[,nrow(constantMatrix):1])
    plot(svd1$d, 
         xlab = 'Column', ylab = 'Singular Value',
         pch = 19)
    plot(svd1$d^2/sum(svd1$d^2), 
         xlab = 'Column', ylab = 'Prop of Variance Explained', 
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-20-1.png)

#### Adding a second pattern

    set.seed(678910)
    for(i in 1:40){
        # flip twp coins
        coinFlip1 <- rbinom(1, size = 1, prob = 0.5)
        coinFlip2 <- rbinom(1, size = 1, prob = 0.5)
        # if coin is head add a common patter to that row
       if(coinFlip1){
           dataMatrix[i,] <- dataMatrix[i, ] + rep(c(0,5), each = 5)
       }
       if(coinFlip2){
           dataMatrix[i,] <- dataMatrix[i, ] + rep(c(0,5), 5)
       }    
    }
    hh <- hclust(dist(dataMatrix))
    dataMatrixOrdered <- dataMatrix[hh$order, ]

    par(mfrow = c(1,2))
    image(t(dataMatrix)[,nrow(dataMatrix):1])
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])

![](Notes3_files/figure-markdown_strict/unnamed-chunk-21-1.png)

#### **v** and patterns of variance in rows

    svd2 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(2,3))
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    plot(rep(c(0,1),each = 5), 
         xlab = 'Column', ylab = 'Pattern 1',
         pch = 19)
    plot(rep(c(0,1), 5), 
         xlab = 'Column', ylab = 'Pattern 2', 
         pch = 19)
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    plot(svd2$v[,1], 
         xlab = 'Column', ylab = 'First right singular vector',
         pch = 19)
    plot(svd2$v[,2], 
         xlab = 'Column', ylab = 'Second right singular vector', 
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-22-1.png)

#### **d** and variance explained

    par(mfrow = c(1,3))
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    plot(svd2$d, 
         xlab = 'Column', ylab = 'Singular Value',
         pch = 19)
    plot(svd2$d^2/sum(svd2$d^2), 
         xlab = 'Column', ylab = 'Percent of Variance Explained', 
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-23-1.png)

#### Missing values

    dataMatrix3 <- dataMatrixOrdered
    ## Randomly insert some missing data
    dataMatrix3[sample(1:100, size = 40, replace = FALSE)] <- NA
    par(mfrow = c(1,2))
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    image(t(dataMatrix3)[,nrow(dataMatrix3):1])

![](Notes3_files/figure-markdown_strict/unnamed-chunk-24-1.png)

    ## svd3 <- svd(scale(dataMatrix3)) ## Doesn't work

#### Imputing {`impute`}

    library(impute)
    # dataMatrix3 <- dataMatrixOrdered
    # dataMatrix3[sample(1:100, size = 40, replace = FALSE)] <- NA
    # The approach for imputing is the missing values is based on the knn, i.e. a missing value is imputed by the k nearest neighbours to that row
    dataMatrix3 <- impute.knn(dataMatrix3)$data
    svd <-svd(scale(dataMatrixOrdered))
    svd3 <-svd(scale(dataMatrix3))
    par(mfrow = c(2,2), mar = c(2,2,1,1))
    image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
    plot(svd$v[, 1], 
         xlab = 'Column', ylab = 'First right singular vector',
         pch = 19)
    image(t(dataMatrix3)[,nrow(dataMatrix3):1])
    plot(svd3$v[, 1], 
         xlab = 'Column', ylab = 'First right singular vector',
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-26-1.png)

#### Face example

    load("data/face.rda")
    image(t(faceData)[, nrow(faceData):1])

![](Notes3_files/figure-markdown_strict/unnamed-chunk-27-1.png)

    svdFace <- svd(scale(faceData))
    plot(svdFace$d^2/sum(svdFace$d^2),
         xlab = 'Singular Vector',
         ylab = 'Variance Explained',
         pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-28-1.png)

    svdFace <- svd(scale(faceData))

    approx1 <- svdFace$u[,1] %*% t(svdFace$v[,1]) * svdFace$d[1]

    approx5 <- svdFace$u[, 1:5] %*% diag(svdFace$d[1:5])  %*% t(svdFace$v[, 1:5])

    approx10 <- svdFace$u[,1:10] %*% diag(svdFace$d[1:10])  %*% t(svdFace$v[, 1:10])

    par(mfrow = c(1, 4),  mar = c(24,2,1,1))
    image(t(approx1)[, nrow(approx1):1], main = '(a)')
    image(t(approx5)[, nrow(approx5):1], main = '(b)')
    image(t(approx10)[, nrow(approx10):1], main = '(c)')
    image(t(faceData)[, nrow(faceData):1], main = '(d)')

![](Notes3_files/figure-markdown_strict/unnamed-chunk-30-1.png)

## 3. Working with color

### Plotting and Color in R

-   The default color schemes for most plots in `R` are horrendous.
-   Recenty, there have been developments to improve the
    handling/specification of colors in plots/graphs/etc.
-   There are functions in R and in external packages that are very
    handy.

### Color Utilites in R

-   The `grDevices` package has two functions
    -   `colorRamp`
    -   `colorRampPalette`
-   These functions take palettes of colors and help to interpolate
    between the colors.
-   The function `colors()` lists the name of colors you can use in any
    plotting function.
-   `colorRamp`: takes a palette of colors and return a function that
    takes values between 0 and 1, indicating the extremes of the color
    palette (e.g. see the ‘gray’ function)
-   `colorRampPalette`: takes a palette of colors and return a function
    that takes integer arguments and returns a vector of colors
    interpolating the palette (like `heat.colors` or `topo.colors`)

<!-- -->

    pal <- colorRamp(c('red', 'blue'))
    pal(0)

    ##      [,1] [,2] [,3]
    ## [1,]  255    0    0

    pal(1)

    ##      [,1] [,2] [,3]
    ## [1,]    0    0  255

    pal(0.5)

    ##       [,1] [,2]  [,3]
    ## [1,] 127.5    0 127.5

    pal(seq(0, 1, len=10))

    ##            [,1] [,2]      [,3]
    ##  [1,] 255.00000    0   0.00000
    ##  [2,] 226.66667    0  28.33333
    ##  [3,] 198.33333    0  56.66667
    ##  [4,] 170.00000    0  85.00000
    ##  [5,] 141.66667    0 113.33333
    ##  [6,] 113.33333    0 141.66667
    ##  [7,]  85.00000    0 170.00000
    ##  [8,]  56.66667    0 198.33333
    ##  [9,]  28.33333    0 226.66667
    ## [10,]   0.00000    0 255.00000

    pal <- colorRampPalette(c('red', 'yellow'))
    pal(2)

    ## [1] "#FF0000" "#FFFF00"

    pal(10)

    ##  [1] "#FF0000" "#FF1C00" "#FF3800" "#FF5500" "#FF7100" "#FF8D00" "#FFAA00"
    ##  [8] "#FFC600" "#FFE200" "#FFFF00"

### RColorBrewer Package

-   One package on CRAN that contains interesting/useful color palettes
-   There are three types of palettes
    -   sequential
    -   diverging
    -   qualitative
-   Palette information can be used in conjunction with the
    `colorRamp()` and `colorRampPalette()`

<!-- -->

    library(RColorBrewer)
    cols <- brewer.pal(3,"BuGn")
    cols

    ## [1] "#E5F5F9" "#99D8C9" "#2CA25F"

    pal <- colorRampPalette(cols)
    image(volcano, col = pal(20))

![](Notes3_files/figure-markdown_strict/unnamed-chunk-33-1.png)

### The `smoothScatter()` function

    x <- rnorm(1e5)
    y <- rnorm(1e5)
    smoothScatter(x,y)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-34-1.png)

### Some other plotting notes

-   The `rgb` function can be used to produce any color via red, green
    blue proportions.
-   Color transparancy can be added via the `alpha` pramenter to `rgb`.
-   The **colorspace** package can be used for different control over
    colors.

<!-- -->

    x <- rnorm(1e3)
    y <- rnorm(1e3)
    par(mfrow = c(1,2))
    plot(x,y, pch = 19)
    plot(x,y, col = rgb(0, 0, 0, 0.2), pch = 19)

![](Notes3_files/figure-markdown_strict/unnamed-chunk-35-1.png)
