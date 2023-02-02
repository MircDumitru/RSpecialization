### Question 1

Under the lattice graphics system, what do the primary plotting
functions like xyplot() and bwplot() return?

-   an object of class “plot”
-   nothing; only a plot is made
-   an object of class “lattice”
-   an object of class “trellis”

### Answer 1

-   an object of class “trellis”

### Question 2

What is produced by the following code?

    library(nlme)
    library(lattice)
    xyplot(weight ~ Time | Diet, BodyWeight)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-1-1.png)

-   A set of 11 panels showing the relationship between weight and diet
    for each time.
-   A set of 3 panels showing the relationship between weight and time
    for each diet.
-   A set of 3 panels showing the relationship between weight and time
    for each rat.
-   A set of 16 panels showing the relationship between weight and time
    for each rat.

### Answer 2

-   A set of 3 panels showing the relationship between weight and time
    for each diet.

### Question 3

Annotation of plots in any plotting system involves adding points,
lines, or text to the plot, in addition to customizing axis labels or
adding titles. Different plotting systems have different sets of
functions for annotating plots in this way.

Which of the following functions can be used to annotate the panels in a
multi-panel lattice plot?

-   text()
-   llines()
-   lines()
-   axis()
-   points()

### Answer 3

-   lines()

### Question 4

The following code does NOT result in a plot appearing on the screen
device.

    library(lattice)
    library(datasets)
    data(airquality)
    p <- xyplot(Ozone ~ Wind | factor(Month), data = airquality)

Which of the following is an explanation for why no plot appears?

-   The xyplot() function, by default, sends plots to the PDF device.
-   The variables being plotted are not found in that dataset.
-   There is a syntax error in the call to xyplot().
-   The object ‘p’ has not yet been printed with the appropriate print
    method.

### Answer 4

-   The object ‘p’ has not yet been printed with the appropriate print
    method.

### Question 5

In the lattice system, which of the following functions can be used to
finely control the appearance of all lattice plots?

-   splom()
-   par()
-   trellis.par.set()
-   print.trellis()

### Answer 5

-   trellis.par.set()

### Question 6

What is ggplot2 an implementation of?

-   a 3D visualization system
-   the Grammar of Graphics developed by Leland Wilkinson
-   the S language originally developed by Bell Labs
-   the base plotting system in R

### Answer 6

-   the Grammar of Graphics developed by Leland Wilkinson

### Question 7

Load the \`airquality’ dataset form the datasets package in R

    library(datasets)
    data(airquality)

I am interested in examining how the relationship between ozone and wind
speed varies across each month. What would be the appropriate code to
visualize that using ggplot2?

    library(ggplot2)
    airquality = transform(airquality, Month = factor(Month))
    qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    qplot(Wind, Ozone, data = airquality, geom = "smooth")

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-6-1.png)

    qplot(Wind, Ozone, data = airquality)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-7-1.png)

### Answer 7

    library(ggplot2)
    airquality = transform(airquality, Month = factor(Month))
    qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-8-1.png)

### Question 8

What is a geom in the ggplot2 system?

-   a plotting object like point, line, or other shape
-   a method for making conditioning plots
-   a method for mapping data to attributes like color and size
-   a statistical transformation

### Answer 8

-   a plotting object like point, line, or other shape

### Question 9

When I run the following code I get an error:

    library(ggplot2)
    library(ggplot2movies)
    g <- ggplot(movies, aes(votes, rating))
    print(g)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-9-1.png)

I was expecting a scatterplot of ‘votes’ and ‘rating’ to appear. What’s
the problem?

-   ggplot does not yet know what type of layer to add to the plot.
-   The object ‘g’ does not have a print method.
-   The dataset is too large and hence cannot be plotted to the screen.
-   There is a syntax error in the call to ggplot.

### Answer 9

-   ggplot does not yet know what type of layer to add to the plot.

### Question 10

The following code creates a scatterplot of ‘votes’ and ‘rating’ from
the movies dataset in the ggplot2 package. After loading the ggplot2
package with the library() function, I can run

    qplot(votes, rating, data = movies)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-10-1.png)

How can I modify the the code above to add a smoother to the
scatterplot?

    qplot(votes, rating, data = movies, panel = panel.loess)

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-11-1.png)

    qplot(votes, rating, data = movies) + geom_smooth()

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-12-1.png)

    qplot(votes, rating, data = movies, smooth = "loess")

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-13-1.png)

    ## qplot(votes, rating, data = movies) + stats_smooth("loess")

### Answer 10

    qplot(votes, rating, data = movies) + geom_smooth()

![](Quiz2_files/figure-markdown_strict/unnamed-chunk-15-1.png)
