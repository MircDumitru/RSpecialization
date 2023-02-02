## 1. The Lattice Plotting System in R

Implemented using the following packages:

-   `latice` conatins code for producing Trellis graphics, which are
    independent of the “base” graphics system, includes functions like
    `xyplot`, `bwplot`, `levelplot`.

-   `grid` implements a different graphing system independent of the the
    “base” system; the `latice` package builds on top of `grid`.

-   We seldom call functions from the grid package directly

-   The lattice plotting system does not have a “two-phase” aspect with
    separate plotting and annotation like in the base ploting

-   All plotting/annotation is done at once with a single function call

### Latice functions

-   `xyplot` this is the main function for creating scatterplots
-   `bwplot` box-and-whiskers plots
-   `histogram` histograms
-   `striplot` like a boxplot but with actual points
-   `dotplot` plot dots on “violin strings”
-   `splom` scaterplot matrix like `pairs` in base ploting system
-   `levelplot`, `contourplot` for plotting “image” data

Lattice functions generally take a formul for their frist argument,
usually of the form

    xyplot(x~y | f*g, data)

-   We use the formula notation here, hence the ~
-   On the left of the ~ is the y-axis variable, on the right is the
    x-axis variable
-   f and g are conditioning variables - they are optional
    -   The \* indicates an interaction between variables
-   The second argument is the data frame or list from which the
    variables in the formula should be look up
    -   If no data frame or list is passed, the parent frmae is used.
-   If no other arguments are passed, there are defaults that be used.

<!-- -->

    library(lattice)
    library(datasets)
    ## Simple scatterplot
    xyplot(Ozone ~ Wind, data = airquality)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-1-1.png)

    library(lattice)
    library(datasets)
    ## 
    xyplot(Ozone ~ Wind | Month, 
           data = airquality, layout = c(5,1))

![](Notes2_files/figure-markdown_strict/unnamed-chunk-2-1.png)

### Lattice behaviour

Lattice functions behave differently from base graphics functions in one
critical way.

-   Base graphics functions plot data directly to the graphics device
    (scree, PDF file, …).

-   Lattice graphics functions return an object of class **trellis**.

-   The print methods for lattice functions actually do the work of
    ploting the data on the graphics device.

-   Latice functions return “plot objects” that can, in principle, be
    stored (but it’s usually better to just save the code + data).

-   On the command line, trellis objects are *auto-printed* so that it
    appears the function is plotting the data.

<!-- -->

    p <- xyplot(Ozone ~ Wind, data = airquality) ## Nothing happens
    print(p)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    xyplot(Ozone ~ Wind, data = airquality) ## Auto-printing

![](Notes2_files/figure-markdown_strict/unnamed-chunk-3-2.png)

### Lattice panel functions

-   Lattice functions have a **panel function** which controls what
    happens inside each panel of the plot

-   Each panel receives the *x* and *y* coordinates of data points in
    their panel, each panel representing a subset of the data defined by
    the condition specified.

<!-- -->

    set.seed(10)
    x <- rnorm(100)
    f <- rep(0:1, each = 50)
    y <- x + f - x * f + rnorm(100, sd = 0.5)
    f <- factor(f, labels = c("Group 1", "Group 2"))
    xyplot(y ~ x | f, layout = (c(2,1))) # Plot with two panels

![](Notes2_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    ## Custom panel function
    xyplot(y ~ x | f, panel = function(x, y, ...){
        panel.xyplot(x, y, ...) ## First call the defaul panel function xyplot
        panel.abline(h = median(y), lty = 2) # Add a horizontal line at the median
    })

![](Notes2_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    ## Custom panel function
    xyplot(y ~ x | f, panel = function(x, y, ...){
        panel.xyplot(x, y, ...) ## First call the defaul panel function xyplot
        panel.lmline(x, y, col = 2) # Add the regression line
    })

![](Notes2_files/figure-markdown_strict/unnamed-chunk-6-1.png)

You *can not* use any annotation function from the base system in the
lattice.

## 2.2 ggplot2 plotting system

What is ggplot2?

-   An implementation of the *Gramar of Graphics* by Leland Wilkinson.
-   Written by Hadley Wickham.
-   A “third” graphics system for R (along with **base** and
    **lattice**).
-   Available from CRAN via `install.packages()`.
-   Website: <https://ggplot2.tidyverse.org>.

### Grammar of graphics

“In brief, the grammar tells us that a stastistical graphic is a
**mapping** from data to **aesthetic** attributes (colour, shape, size)
of **geometric** objects (points, lines, bars). The plot may also
contain statistical transformations of the data and is drawn on a
speficif coodrinate system”.

### The `qplot()` function

-   Works much like the plot function in base graphics system.
-   Looks for data in a data frame, similar to lattice, or in the parent
    environment.
-   Plots are made up of *aesthetics* (size, shape, color) and geoms(
    points, lines).
-   Factors are important for indicating subsets of the data (if they
    are to have different properties); they should be *labeled*.
-   The `qplot()` hides what goes on underneath, which is ok for most
    operations.
-   `ggplot()` is the core function and very flexible for doing things
    `qplot` cannot do.

### Example dataset

The dataset used for this example is *mpg*:

    library(ggplot2)
    str(mpg)

    ## tibble [234 × 11] (S3: tbl_df/tbl/data.frame)
    ##  $ manufacturer: chr [1:234] "audi" "audi" "audi" "audi" ...
    ##  $ model       : chr [1:234] "a4" "a4" "a4" "a4" ...
    ##  $ displ       : num [1:234] 1.8 1.8 2 2 2.8 2.8 3.1 1.8 1.8 2 ...
    ##  $ year        : int [1:234] 1999 1999 2008 2008 1999 1999 2008 1999 1999 2008 ...
    ##  $ cyl         : int [1:234] 4 4 4 4 6 6 6 4 4 4 ...
    ##  $ trans       : chr [1:234] "auto(l5)" "manual(m5)" "manual(m6)" "auto(av)" ...
    ##  $ drv         : chr [1:234] "f" "f" "f" "f" ...
    ##  $ cty         : int [1:234] 18 21 20 21 16 18 18 18 16 20 ...
    ##  $ hwy         : int [1:234] 29 29 31 30 26 26 27 26 25 28 ...
    ##  $ fl          : chr [1:234] "p" "p" "p" "p" ...
    ##  $ class       : chr [1:234] "compact" "compact" "compact" "compact" ...

The factor variables (`mpg$manufacturer` and `mpg$drv`) are labeled
appropriately.

    qplot(displ, hwy, data = mpg)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-8-1.png)

### Modifying some of the aesthetics

    qplot(displ, hwy, data = mpg, color = drv)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-9-1.png)

    qplot(displ, hwy, data = mpg, shape = drv)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-10-1.png)

### Adding some statistics (a smoother)

    qplot(displ, hwy, data = mpg, geom = c('point', 'smooth'))

![](Notes2_files/figure-markdown_strict/unnamed-chunk-11-1.png)

    qplot(displ, hwy, data = mpg) + geom_smooth(method = 'lm')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-12-1.png)

    qplot(displ, hwy, data = mpg) + geom_smooth()

![](Notes2_files/figure-markdown_strict/unnamed-chunk-13-1.png)

### Histograms & Densities

    qplot(hwy, data = mpg, fill = drv)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-14-1.png)

    qplot(hwy, data = mpg, col = drv, geom = "density")

![](Notes2_files/figure-markdown_strict/unnamed-chunk-15-1.png)

### Facests

    qplot(displ, hwy, data = mpg, facets = .~drv)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-16-1.png)

    qplot(displ, hwy, data = mpg, facets = .~drv) + geom_smooth()

![](Notes2_files/figure-markdown_strict/unnamed-chunk-17-1.png)

    qplot(hwy, data = mpg, facets = drv~., binwidth = 2)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-18-1.png)

### Basic components of a ggplot2 plot

-   **a data frame**
-   **aesthetic mapping**: how data are mapped to color, size
-   **geoms**: geometric objects (e.g. points, lines, shapes)
-   **facets**: for conditional plots
-   **stats**: statistical transformations (e.g. binning, quantiles,
    smoothing)
-   **scales**: what scale an aestetic map uses (e.g. male = red, female
    = blue)
-   **coordinate system**

### Building plots with ggplot2

-   When building plots in ggplot2 (rather than using qplot) the
    *artist’s palette* model may be the closest analogy
-   Plots are built up in layers
    -   plot the data
    -   overlay a summary
    -   metadata & annotation

<!-- -->

    qplot(displ, hwy, data = mpg, 
          facets = . ~ drv,
          geom = c("point", 'smooth'), method = 'loess')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-19-1.png)

    qplot(displ, hwy, data = mpg, 
          facets = . ~ drv,
          geom = c("point", 'smooth'), method = 'lm')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-20-1.png)

Recreating the plot using the lower level ggplot2 framework

    g <- ggplot(mpg, aes(displ, hwy))
    summary(g)

    ## data: manufacturer, model, displ, year, cyl, trans, drv, cty, hwy, fl,
    ##   class [234x11]
    ## mapping:  x = ~displ, y = ~hwy
    ## faceting: <ggproto object: Class FacetNull, Facet, gg>
    ##     compute_layout: function
    ##     draw_back: function
    ##     draw_front: function
    ##     draw_labels: function
    ##     draw_panels: function
    ##     finish_data: function
    ##     init_scales: function
    ##     map_data: function
    ##     params: list
    ##     setup_data: function
    ##     setup_params: function
    ##     shrink: TRUE
    ##     train_scales: function
    ##     vars: function
    ##     super:  <ggproto object: Class FacetNull, Facet, gg>

    print(g) # No layers in this plot

![](Notes2_files/figure-markdown_strict/unnamed-chunk-22-1.png)

    p <- g + geom_point()
    print(p)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-23-1.png)

    g + geom_point() + geom_smooth() ## corresponds to the loess smoother, i.e. corresponds to calling geom_smooth(method = 'loess')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-24-1.png)

    g + geom_point() + geom_smooth(method = 'lm')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-25-1.png)

Another layer is the facets

    g + geom_point() + facet_grid(. ~ drv) + geom_smooth(method = 'lm')

![](Notes2_files/figure-markdown_strict/unnamed-chunk-26-1.png)

### Annotation

-   Labels `xlab()`, `ylab()`, `labs()`, `ggtitle()`
-   Each of the *geom* functions has options to modify
-   For things that only make sense globally, use `theme()`
    -   Example: `theme(legend.position = 'none')`
-   Two standard appearance themes are included:
    -   `theme_gray()`: the default theme (gray background)
    -   `theme_bw()`: more stark/plain

### Modifying Aesthetics

    g + geom_point(color = "steelblue", 
                   size = 4,
                   alpha = 1/2)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-27-1.png)

    g + geom_point(aes(color = drv), 
                   size = 4,
                   alpha = 1/2)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-28-1.png)

### Modifying Labels

    g + geom_point(aes(color = drv)) + labs(title = "hwy vs. displ") + theme(plot.title = element_text(hjust = 0.5)) + labs( x = expression("value of displ"), y = expression("value of hwy"))

![](Notes2_files/figure-markdown_strict/unnamed-chunk-29-1.png)

### Customizing the Smooth

    g + geom_point(aes(color = drv), size = 2, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = 'lm', se = FALSE)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-30-1.png)

### Changing the theme

    g + geom_point(aes(color = drv)) + theme_bw(base_family = "Times")

![](Notes2_files/figure-markdown_strict/unnamed-chunk-31-1.png)

### A Note about axis limits

    testdat <- data.frame(x = 1:100, y = rnorm(100))
    testdat[50,2] <- 100 ## Outlier
    plot(testdat$x, testdat$y, type = 'l', ylim = c(-3,3))

![](Notes2_files/figure-markdown_strict/unnamed-chunk-32-1.png)

    g <- ggplot(testdat, aes(x, y))
    g + geom_line()

![](Notes2_files/figure-markdown_strict/unnamed-chunk-33-1.png)

    # This subsets the data to include values that are in the specified interval
    g <- ggplot(testdat, aes(x, y))
    g + geom_line() + ylim(-3,3)

![](Notes2_files/figure-markdown_strict/unnamed-chunk-34-1.png)

    # This uses coord_cartesian to recreate the phenomena encounterd in base plot
    g <- ggplot(testdat, aes(x, y))
    g + geom_line() + coord_cartesian(ylim = c(-3,3))

![](Notes2_files/figure-markdown_strict/unnamed-chunk-35-1.png)
