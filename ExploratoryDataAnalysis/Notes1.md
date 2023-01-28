# Basics of analytic graphics & the base plotting system in R - Week 1

## 1. Graphs

### Principles of Analytics Graphics

-   Principle 1: **Show comparisons**
    -   Evidence for a hypothesis is always *relative* to another
        competing hypothesis.
    -   Alwyas ask :“Compared to WHAT”? (have a basis to what you
        compare with, the *control*).
-   Princple 2: **Show causality, mechanism, explanation, systematic
    structure**
    -   What is your causal framweork for thinking about a question?
-   Princple 3: **Show multivariate data**
    -   Multivariate - more than two variables.
    -   The real world *is* multivariate.
    -   Need to “escape flatland”.
-   Princple 4: **Integration of evidence**
    -   Completely integrate words, numbers, images, diagrams.
    -   Data graphics should make use of many modes of data
        presentation.
    -   Don’t let the tool drive the analysis.
-   Princple 5: **Describe & document the evidence with appropriate
    labels, scales, sources**
    -   A data graphic should tell a complete story that is credible.
-   Princple 6: **Content is king**
    -   Analytical presentations ultimately stand or fall depending on
        the quality, relevance and integrity of their content.

Reference: Edward Tufte (2006) - Beautiful Evidence
<https://www.edwardtufte.com>

### Eploratory graphs

Why do we use graphs in data analysis?

-   To understand data properties.
-   To find patterns in data.
-   To suggest modelling strategies.
-   To debug analysis.
-   To communicate results.

Characteristics of exploratory graphs

-   They are made quickly.
-   A large number are made.
-   The goal is for presonal understanding.
-   Axes/legends are generallly cleand up (later).
-   Color/size are primarly used for information.

Air pollution in the United States

-   The U.S. Environmental Protection Agency (EPA) sets national ambient
    air quality standards for outdoor air pollution
-   For fine particle pollution (*pm2.5*), the “annual mean, averaged
    over 3 years” cannot exceed *12*μ*g/m<sup>3</sup>*
-   Data on daily *pm2.5* are available from the U.S. EPA website
-   **Question:** Are there any counties in the U.S. that exceed that
    national standard for fine particle pollution?

Annual average *pm2.5* averaged over the period 2008 through 2010

    if(!file.exists('./data')){dir.create('./data')}

    fileUrl <- 'https://raw.githubusercontent.com/jtleek/modules/master/04_ExploratoryAnalysis/exploratoryGraphs/data/avgpm25.csv'

    download.file(fileUrl, 
                  destfile = './data/avgpm25.csv', 
                  method = 'curl')

    pollution <- read.csv('data/avgpm25.csv',
                          colClasses = c('numeric', 'character',  'factor', 'numeric', 'numeric'))

    head(pollution)

    ##        pm25  fips region longitude latitude
    ## 1  9.771185 01003   east -87.74826 30.59278
    ## 2  9.993817 01027   east -85.84286 33.26581
    ## 3 10.688618 01033   east -87.72596 34.73148
    ## 4 11.337424 01049   east -85.79892 34.45913
    ## 5 12.119764 01055   east -86.03212 34.01860
    ## 6 10.827805 01069   east -85.35039 31.18973

The features:

-   `pm25` - the level of *pm2.5*, the anual mean averaged over the past
    3 years (2008-2010).
-   `fips` - identifier of the county
-   `region` - EAST or WEST region of the county
-   `longitude` - the longitude of the monitor in that county
-   `latitude` - the latitude of the monitor in that county

The underlying question: Do any counties exceed the standard of
*12*μ*g/m<sup>3</sup>*?

### One dimensional simple summaries of data

#### Six number summary

    - the _min_, _1st quantile_, _median_, _mean_, _3rd quantile_, _max_ of any of the dataframe variables
    - `summary(df$var)`
    - for the air pollution example:

    ```r
        summary(pollution$pm25)
    ```

    ```
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   3.383   8.549  10.047   9.836  11.356  18.441
    ```

    ```r
        summary(pollution$longitude)
    ```

    ```
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -158.04  -97.38  -87.37  -91.65  -80.72  -68.26
    ```

    ```r
        summary(pollution$latitude)
    ```

    ```
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   19.68   35.30   39.09   38.56   41.75   64.82
    ```

#### Boxplots

    - Graphical representation of the six number summary (actually five number summary)
    - `boxplot(df$var)`
    - for the air pollution example:

            boxplot(pollution$pm25, col = "wheat")

![](Notes1_files/figure-markdown_strict/unnamed-chunk-3-1.png)

#### Histograms

-   Graphical representation of the frequencies of the data, gives an
    idea about the distribution of the data - `hist(df$var)` and
    `rug(df$var)` - for the air pollution example:

<!-- -->

            hist(pollution$pm25, col = "wheat")
            rug(pollution$pm25)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-4-1.png) -
changing the histogram breaks

            hist(pollution$pm25, col = "wheat", breaks = 100)
            rug(pollution$pm25)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-5-1.png)

#### Overlaying Features

            boxplot(pollution$pm25, col = "wheat")
            abline(h = 12) # overlying the horizontal line at the level of the national air quality standard. 

![](Notes1_files/figure-markdown_strict/unnamed-chunk-6-1.png)

            hist(pollution$pm25, 
                 col = "wheat")
            abline(v = 12, lwd = 2) # overlying the horizontal line at the level of the national air quality standard. 
            abline(v = median(pollution$pm25), 
                   col = "magenta", 
                   lwd = 2)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-7-1.png)

#### Barplot

    - graphical summary for categorical data
    - `barplot(df$var)`
    - for the air pollution example:

        barplot(table(pollution$region), 
                col = "wheat",
                main = 'Number of counties in each region')

![](Notes1_files/figure-markdown_strict/unnamed-chunk-8-1.png)

### Two dimensional simple summaries of data

For two dimensions:

-   Multiple/overlayed 1-D plots (lattice/ggplot2)
-   Scatterplots
-   Smooth scatterplots

For more than two dimensions:

-   Multiple/overlayed 2-D plots, coplots
-   Use color, size, shape to add dimensions
-   Spinning plots
-   Actual 3-D plots (not that useful)

#### Multiple boxplots

        boxplot(pm25 ~ region, 
                data = pollution, 
                col = "wheat")

![](Notes1_files/figure-markdown_strict/unnamed-chunk-9-1.png)

#### Multiple histograms

        par(mfrow = c(2,1), 
            mar = c(4,4,2,1))
        hist(subset(pollution, region == "east")$pm25, 
             col = 'wheat')
        hist(subset(pollution, region == "west")$pm25, 
             col = 'wheat')

![](Notes1_files/figure-markdown_strict/unnamed-chunk-10-1.png)

#### Scatterplot

        with(pollution, plot(latitude, pm25))
        abline(h = 12, lwd = 2, lty = 2)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-11-1.png)

        with(pollution, plot(latitude, pm25, col = region))
        abline(h = 12, lwd = 2, lty = 2)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-12-1.png)

#### Multiple scatterplots

        par(mfrow = c(1,2), 
            mar = c(5,4,2,1))
        with(subset(pollution, region == 'west'), 
             plot(latitude, pm25, main = "West"))
        abline(h = 12, lwd = 2, lty = 2)
        with(subset(pollution, region == 'east'), 
             plot(latitude, pm25, main = "East"))
        abline(h = 12, lwd = 2, lty = 2)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-13-1.png)

### Resources

-   [R Graph Gallery](https://r-graph-gallery.com)

-   [R Bloggers](https://www.r-bloggers.com)

## 2. Plotting

Three core plotting systems:

#### The base plotting system

-   The “original” model
-   Uses the “artist’s palette” model
-   Starts with a blank canvas and build up from there
-   Start with plot function (or similar)
-   Use annotation functions to add/modify (`text`, `lines`, `points`,
    `axis`)
-   Convenient & intuitive
-   Can’t go back once plot has started (i.e. to adjust margins); needs
    to plan in advance
-   Difficult to “translate” to others once a new plot has been created
-   Plot is just a series of `R` commands

<!-- -->

    library(datasets)
    data("cars")
    with(cars, plot(speed, dist))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-14-1.png)

-   The core plotting and graphics engine in `R` is encapsulated in the
    following packages:
    -   `graphics` - contains plotting functions for the “base” graphing
        systems, including: `plot`, `hist`, `boxplot` and many others

    -   `grDevices` - contains all the code implementing the various
        graphics devices, including X11, PDF, PostScript, PNG, etc

#### The lattice system

-   Implemented in `lattice`package
-   Plots are created with a single function call (`xyplot`, `bwplot`,
    etc).
-   Most uself for conditioning types of plots: looking at how y changes
    x across levels of z.
-   Things like margins/spacing set automatically because entirre plot
    is specified at once.
-   Good for putting many many plots on a screen.
-   Sometimes awkward to specify an entire plot in a single function
    call.
-   Annotation in plot is not especialy intuitive.
-   Use of panel functions and subscripts difficult to wield and
    requires intense preparation.
-   Cannot “add” to the plot once it is created.

<!-- -->

    library(lattice)
    state <- data.frame(state.x77, region = state.region)
    xyplot(Life.Exp ~ Income | region, 
           data = state,
           layout = c(4, 1))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-15-1.png)

-   The lattice plotting system is implemented using the following
    packages:
    -   `lattice` - contains cod for producing Trellis graphcis, which
        are independent of the “base” graphics system; include functions
        like `xyplot`, `bwplot`, `levelplot`

    -   `grid` - implements a different graphing system independent of
        the “base”; the `lattice` package builds on top of `grid`

#### The ggplot2 system

-   Splits the difference between base and latice in a number of ways.
-   Automatically deals with spacings, text, titles but allows to
    annotate by adding to a plot.
-   Superficial similarity to lattice but generally easier/more
    intuitive.
-   Default mode makes many choices for you.

<!-- -->

    library(ggplot2)
    data(mpg)
    qplot(displ, hwy, data = mpg)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-16-1.png)

#### The process of making a plot

-   Where will the plot be made? Screen? File?
-   How it will be used?
    -   for viewing temporarily on the screen?
    -   presented in a web browser?
    -   paper for printing?
    -   presentation?
-   Is there a large amount of data going into the plot? Or just a few
    points?
-   Do you need to be able to dynamically resize the graphic?
-   What graphics system will you use? Base, lattice, ggplot2?
    (generally cannot be mixed)

### The base plotting system

-   There are two phases to creating a base plot:
    -   Initializing a new plot
    -   Annotation (adding to) an exist plot
-   Calling `plot(x,y)` or `hist(x)` will launch a graphics device and
    draw a new plot on the device
-   If the arguments to plot are not of some special class, then the
    *default* method for `plot` is called; this function has *many*
    arguments, letting you set the title, x axis label, …
-   The base graphics system has *many* parameters that can be tweaked;
    they are documented in `?par`.

<!-- -->

    library(datasets)
    hist(airquality$Ozone) ## Draw a new plot

![](Notes1_files/figure-markdown_strict/unnamed-chunk-17-1.png)

    library(datasets)
    with(airquality, plot(Wind, Ozone))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-18-1.png)

    library(datasets)
    airquality <- transform(airquality, Month = factor(Month))
    boxplot(Ozone ~ Month, 
            airquality, 
            xlab = "Month",
            ylab = "Ozone (ppb)")

![](Notes1_files/figure-markdown_strict/unnamed-chunk-19-1.png)

Default values for the global graphics parameters:

    par('lty')

    ## [1] "solid"

    par('col')

    ## [1] "black"

    par('pch')

    ## [1] 1

    par('bg')

    ## [1] "white"

    par('mar')

    ## [1] 5.1 4.1 4.1 2.1

    par('mfrow')

    ## [1] 1 1

-   `plot` - makes a scatterplot or other type of plot depending on the
    class of the object being plotted.
-   `lines` - add lines to a plot given a vector x values and a
    correspodning vectory of y values (or a 2 column matrix); this
    function just connects the dots.
-   `points` - add points to a plot
-   `text` - add text lables to a plot using specified x,y coordinates
-   `title` - add annotations to x, y axis labels, title, subtitle,
    outer margin
-   `mtext` - add arbitrary text to the margins (inner or outer) of a
    plot
-   `axis` - adding axis ticks/labels

Adding title

    library(datasets)
    with(airquality, plot(Wind, Ozone))
    title(main = 'Ozone and Wind in NY city') ## Add a title

![](Notes1_files/figure-markdown_strict/unnamed-chunk-26-1.png)

Adding title directly in the `plot()` function

    with(airquality, plot(Wind, Ozone, 
                          main = 'Ozone and Wind in NY City'))
    with(subset(airquality, Month == 5), points(Wind, Ozone, col = 'blue'))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-27-1.png)

Adding legend to the plot

    with(airquality, plot(Wind, Ozone, 
                          main = 'Ozone and Wind in NY City'))

    with(subset(airquality, Month == 5), points(Wind, Ozone, col = 'blue'))

    with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))

    legend("topright", pch = 1, 
           col = c('blue', "red"), 
           legend = c("May", "Other Months"))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-28-1.png)

Adding a regression line to the plot

    with(airquality, plot(Wind, Ozone, 
                          main = 'Ozone and Wind in NY City'), pch = 20)
    model <- lm(Ozone ~ Wind, airquality)
    abline(model, lwd = 2)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-29-1.png)

Multiple base plots

        par(mfrow = c(1,2))
        with(airquality,{
            plot(Wind, Ozone, main = 'Ozone and Wind')
            plot(Solar.R, Ozone, maine = 'Ozone and Solar Radiation')        
        })

![](Notes1_files/figure-markdown_strict/unnamed-chunk-30-1.png)

        par(mfrow = c(1,3), mar = c(4,4,2,1), oma = c(0,0,2,0))
        with(airquality,{
            plot(Wind, Ozone, main = 'Ozone and Wind')
            plot(Solar.R, Ozone, maine = 'Ozone and Solar Radiation') 
            plot(Temp, Ozone, maine = 'Ozone and Temperature') 
            mtext("Ozone and Weather in NY", outer = TRUE)
        })

![](Notes1_files/figure-markdown_strict/unnamed-chunk-31-1.png)

### Base plotting demonstration

    x <- rnorm(100)
    hist(x)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-32-1.png)

Even no parameters were specified: \* the title appears (histogram of x)
\* the x-axis label (the variable x) \* the y-axis label (Frequency)

    x <- rnorm(100)
    y <- rnorm(100)
    plot(x ,y)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-33-1.png)

Even no parameters were specified: \* the x-axis label (the variable x)
\* the y-axis label (the variable y)

The regions of the plot: \* The regions : - side 1 (bottom) - side 2
(left) - side 3 (up) - side 4 (right)  
\* Can be adjusested via `plot(mar = c(m1, m2, m3, m4))`

### The point shapes - pch

    par(mfrow = c(1, 3))
    plot(x, y, pch = 2)
    plot(x, y, pch = 3)
    plot(x, y, pch = 4)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-34-1.png)

### Title, text, legend

    plot(x, y, pch = 20)
    title("Scatterplot")
    text(-2.5, 2, "Added text")
    legend("topright", legend = 'Data', pch = 20)

    fit <- lm(x~y)
    abline(fit, lwd = 2, col = 'blue')

![](Notes1_files/figure-markdown_strict/unnamed-chunk-35-1.png)

    plot(x, y, xlab = "weight", ylab = "height", pch = 20)
    title("Scatterplot")
    text(-2.5, 2, "Added text")
    legend("topright", legend = 'Data', pch = 20)

    fit <- lm(x~y)
    abline(fit, lwd = 2, col = 'blue')

![](Notes1_files/figure-markdown_strict/unnamed-chunk-36-1.png)

### Multiple plots

    x <- rnorm(100)
    y <- rnorm(100)
    z <- rpois(100, 2)
    par(mfrow = c(2,1), mar = c(2,2,1,1))
    plot(x, y, pch = 20)
    plot(x, z, pch = 20)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-37-1.png)

    x <- rnorm(100)
    y <- rnorm(100)
    z <- rpois(100, 2)
    par(mfrow = c(2,2), mar = c(2,2,1,1))
    plot(x, y, pch = 20)
    plot(z, x, pch = 20)
    plot(x, z, pch = 20)
    plot(y, z, pch = 20)

![](Notes1_files/figure-markdown_strict/unnamed-chunk-38-1.png)

    x <- rnorm(100,5,2)
    noise <- rnorm(100)
    y <- x + noise
    ## Generate factor levels 
    g <- gl(2,50, labels = c("Male", "Female"))
    plot(x, y, type = 'n')
    points(x[g == 'Male'], y[g == 'Male'], 
           pch = 19, col = 'darkmagenta')
    points(x[g == 'Female'], y[g == 'Female'], 
           pch = 19, col = 'darkorange')
    legend("topright", pch = 19, 
           legend = c("Male", 'Female'), 
           col = c('darkmagenta', 'darkorange'))

![](Notes1_files/figure-markdown_strict/unnamed-chunk-39-1.png)

## 3. Graphics Devices

-   A graphic device is something where you can make a plot appear:
    -   A window on the computer (screen device).
    -   A *pdf* file (file device).
    -   A *png* or *jpeg* file (file device).
    -   A scalable vector graphics (*svg*) file (file device)
-   When you make a plot in R, it has to be sent to a specific graphics
    device.
-   The most common place for a plot to be sent is the *screen device*:
    -   On a Mac, the screen device is launched with `quartz()`.
    -   On a Windows, the screen device is launched with `windows()`.
    -   On a Unix/Linux, the screen device is launched with `x11()`.
-   When you make a plot you need to consider how the plot will be used
    to determine what device the plot should be sent to:
    -   The list of devices is found in `?Devices`.
-   For quick visualizations and exploratory analysis, usually you want
    to use the screen device:
    -   Functions like `plot` in base, `xyplot` in latice or `qplot` in
        ggplot2 will default to sending a plot to the screen device.
    -   On a given platform, there is only one screen device.
-   Fol plots that may be printed out or be incorporated into a document
    (papers, presentations) a *file* device is more appropriate:
    -   There are many different file devices to choose from.

### How does a plot get created?

There are two basic approaches to plotting.

-   The first one is the most common:
    -   Call a plotting function (like `plot` or `qplot` ).
    -   The plot appears on the screen device.
    -   Annotate if necessary.

<!-- -->

    library(datasets)
    with(faithful, plot(eruptions, waiting, 
                        col = 'darkorange')) ## Make plot appear on the screen device
    title(main = 'Old Faithful Geyser data')

![](Notes1_files/figure-markdown_strict/unnamed-chunk-40-1.png)

-   The second one is the mostly used for file devices:
    -   *Explicitly* laungh a graphics device.
    -   Call a plotting function to make a plot.
    -   Annotate if necessary.
    -   *Explicitly* close graphics device with `dev.off()` ( *this is
        very important* ).

<!-- -->

    pdf(file = 'myplot.pdf') ## Open PDF device, create "myplot.pdf" in my working directory 
    with(faithful, plot(eruptions, waiting, 
                        col = 'darkorange')) # Create plot and send to a file (no plot appears on screen)
    title(main = 'Old Faithful Geyser data') # Annotate
    dev.off() #Close the PDF file device

    ## quartz_off_screen 
    ##                 2

    ## Now you can view the file 'myplot.pdf' on your computer

### Graphics file devices

Two basic types of file devices: *vector* and *bitmap* devices

-   Vector formats:
    -   **pdf** - useful for line-type graphics, resizes well, portable,
        not efficient if the plot has many points/objects  
    -   **svg** - XML-based scalable vector graphics; supports animation
        and interactivity, potentually useful for web-based plots
    -   **win.metafile** - available only on Windows  
    -   **postscript** - older format
-   Bitmap formats - represent images as series of pixels
    -   **png** - bitmapped format, good for line drawings or images
        with solid colors, uses lossless compression, most web browswers
        can read this format nativaley, good for plotting many many
        points, does not resize well
    -   **jpeg** - good for photgraphs or natural scenes, uses lossy
        compression, good for plotting many many points, does not resize
        well, can be read by almost any computer & any web browswer, not
        great for line drawings
    -   **tiff** - create bitmap files in the TIFF formatl supports
        lossless compression
    -   **bmp** - native Windows bitmapped format

### Multiple open graphics devices

-   Possible to open multipe graphics devices (screen, file or both) for
    example when viewing multiple plots at once.
-   Plotting can only occur on one graphics device at a time.
-   The **curently active** graphics device can be found by calling
    `dev.cur()`.
-   Every open graphics devices is assigned an integer  ≥ 2.
-   You can change the active graphics device with `dev.set(<integer>)`
    where `<integer>` is the number associated with the grpahics device
    you want to switch to.

### Copying Plots

-   Copying a plot to another device is possible
    -   `dev.copy` - copy a plot from one device to another
    -   `dev.copy2pdf` - specifcially copy a plot to a PDF file

Copying a plot is not an exact opeation, the result may not be
identical.

    library(dataset)
    with(faithful, plot(eruptions, waiting, col = 'brown4')) ## Creating the plot
    title(main = 'Old Faithful Geyser data') ## Annotating the plot

![](Notes1_files/figure-markdown_strict/unnamed-chunk-42-1.png)

    dev.copy(png, file = "geyser.png") ## Copying the plot to a PNG file

    ## quartz_off_screen 
    ##                 3

    dev.off() ## Clossing the PNG device

    ## quartz_off_screen 
    ##                 2
