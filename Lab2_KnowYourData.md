Know your data: EMD chapter 2
========================================================

Our goals in this lab are to: 

1. learn to import and work with data
2. learn to inspect and summarize data
3. learn to explore data with plots

We will use the several datasets used in Ben Bolker's book, Ecological Models and Data in R (aka, EMD) and create, more or less, the same figures he presents, _with one important exeption_: We will be using the functions in the ggplot2 package. (You can, if you want, see how Ben makes these figures in base R and in ggplot2 here: http://www.math.mcmaster.ca/~bolker/classes/s756/labs/vislab.html)

There are many good functions for plotting data in R. Unfortunately, they all end up being a bit limited under many circumstances, they often require different syntax or formulations, and often they make what should be very simple, rather difficult. I think the [ggplot2](http://ggplot2.org/) does away with many of these issues, most of the time. (Although to be honest, sometimes it makes fairly simple things incredibly frustrating to accomplish with its cryptic arguements... but we'll cross that bridge as we go.) The primary advantages of using it in this class are 1) that it is really nice for exploratory plotting and 2) that the figures are pretty much publication ready with little added work. Also, it seems to have a growing following, which means better and better documentation (e.g., http://wiki.stdout.org/rcookbook/Graphs/). But I digress. On with the show!

Importing data
-----------------------------
Let’s start with the Reed frog data from Vonesh and Bolker. You can find the comma- delimited files online at:

Download these files to a location you can find them, idealy the same folder as your project. Reading them in is easy if you know the location and format of the file:

```r
ReedfrogFuncresp <- read.csv("ReedfrogFuncresp.csv", header = T)
ReedfrogPred <- read.csv("ReedfrogPred.csv", header = T)
ReedfrogSizepred <- read.csv("ReedfrogSizepred.csv", header = T)
```

The `header = T` just tells R that the first line is the header row, where you keep all of the names of the variables. This is important because if there are _any_ characters in a column such as a the name of the variable or even a space after a number (a space is a character), then R treats the whole column as if it were characters and converts it into a factor.  
Note, too, that if you have your data stored somewhere else, you'll need to specify the full path of the file. Alternatively in RStudio you can use the "Import Dataset" button in the workspace tab, but that's cheating!  
If you get an error, you probably mis‐specified the location or the file was not in the right format.

Inspecting the data
--------------------------
Of course, getting the file into R does not mean that everything is OK with it. We should start by making sure it fits our expectations in terms of its structure (using `str()`), the types of variables, and the range of data:


```r
str(ReedfrogPred)
```

```
## 'data.frame':	48 obs. of  6 variables:
##  $ X       : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ density : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ pred    : Factor w/ 2 levels "no","pred": 1 1 1 1 1 1 1 1 2 2 ...
##  $ size    : Factor w/ 2 levels "big","small": 1 1 1 1 2 2 2 2 1 1 ...
##  $ surv    : int  9 10 7 10 9 9 10 9 4 9 ...
##  $ propsurv: num  0.9 1 0.7 1 0.9 0.9 1 0.9 0.4 0.9 ...
```

Notice the first variable, X, which seems to increase from 1 to 2 to 3... This was an index left over from when I saved the file. It did not have a name, so R called it “X”. We don’t need it, so let’s get rid of it:

```r
ReedfrogPred <- ReedfrogPred[, 2:6]
str(ReedfrogPred)
```

```
## 'data.frame':	48 obs. of  5 variables:
##  $ density : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ pred    : Factor w/ 2 levels "no","pred": 1 1 1 1 1 1 1 1 2 2 ...
##  $ size    : Factor w/ 2 levels "big","small": 1 1 1 1 2 2 2 2 1 1 ...
##  $ surv    : int  9 10 7 10 9 9 10 9 4 9 ...
##  $ propsurv: num  0.9 1 0.7 1 0.9 0.9 1 0.9 0.4 0.9 ...
```

Again, remember how we index matrices and data frames. Within the square brackets the first entry is for rows, the second for columns. We are simply saying that we want all of the rows and just columns 2 through 6.

OK. That looks better. The factors (predator vs. no predator; big vs. small) seem OK. The rest are either integer or numeric. This all seems to be as expected. Now let's look at the ranges of values, their means, etc.

```r
summary(ReedfrogPred)
```

```
##     density       pred       size         surv         propsurv    
##  Min.   :10.0   no  :24   big  :24   Min.   : 4.0   Min.   :0.114  
##  1st Qu.:10.0   pred:24   small:24   1st Qu.: 9.0   1st Qu.:0.496  
##  Median :25.0                        Median :12.5   Median :0.886  
##  Mean   :23.3                        Mean   :16.3   Mean   :0.722  
##  3rd Qu.:35.0                        3rd Qu.:23.0   3rd Qu.:0.920  
##  Max.   :35.0                        Max.   :35.0   Max.   :1.000
```

This seems to be OK, too. The maximum number surviving (`surv`) is not greater than the maximum density (`density`) and the `propsurv` is between 0 and 1. If you knew more about the data and experiment, you might have other expectations about the ranges of data.  

Lastly, take a look at the first and last few rows of data. The last ones can often get messed up in Excel, so pay attention:

```r
head(ReedfrogPred)
```

```
##   density pred  size surv propsurv
## 1      10   no   big    9      0.9
## 2      10   no   big   10      1.0
## 3      10   no   big    7      0.7
## 4      10   no   big   10      1.0
## 5      10   no small    9      0.9
## 6      10   no small    9      0.9
```

```r
tail(ReedfrogPred)
```

```
##    density pred  size surv propsurv
## 43      35 pred   big   13   0.3714
## 44      35 pred   big   14   0.4000
## 45      35 pred small   22   0.6286
## 46      35 pred small   12   0.3429
## 47      35 pred small   31   0.8857
## 48      35 pred small   17   0.4857
```

In this case, everything seems to be OK. Make sure you check the other data files.





Now it would be useful to know how many observations we have at each level of size and density. The `table()` command is very useful here. It counts the number of rows (=observations) at each combination of variables you feed it:

```r
table(ReedfrogPred$density, ReedfrogPred$size)
```

```
##     
##      big small
##   10   8     8
##   25   8     8
##   35   8     8
```


One other aspect of this data that would be useful to know is how the average mortality rate (or proportion that survived) varies with density and/or size? We can use the `tapply()` function to apply a function, such as `mean()`, to the observations that fall into the different groups we specify. (Just as `table()` counts the observations in groups we specify, `tapply()` applies a function to those observations.)

```r
tapply(ReedfrogPred$propsurv, INDEX = ReedfrogPred$size, FUN = mean)
```

```
##    big  small 
## 0.6755 0.7677
```

```r
tapply(ReedfrogPred$propsurv, INDEX = ReedfrogPred$density, FUN = mean)
```

```
##     10     25     35 
## 0.8063 0.6675 0.6911
```

```r
tapply(ReedfrogPred$propsurv, INDEX = list(ReedfrogPred$size, ReedfrogPred$density), 
    FUN = mean)
```

```
##           10    25     35
## big   0.7750 0.630 0.6214
## small 0.8375 0.705 0.7607
```

So it appears that the mean proportion surviving in these experiments varies both with density and with size. Mortality is greatest in the “big” size class at the highest density. As useful as this summary may be, I still prefer graphical arguments. Let’s try some.

**Bonus**: _Did you see how I had to keep referring to the dataframe name, as in ReedfrogPred$size, over and over again? That can get old, lead to carpal tunnel, or worse, to mistakes. So here's a simpler way. Use the_ `with()` _function_.  

```r
with(ReedfrogPred, tapply(propsurv, INDEX = list(size, density), FUN = mean))
```

_This way R knows to look in the ReedfrogPred dataframe for the various names (e.g., propsurv, size, density) that you use in your statement._


Plotting the data: scatter plots and smoothing functions
-----------------
Let us start with the Reed frog functional response data (Figure XXX in EMD) as it is relatively straightforward. We just want to plot the number killed against the number of initial frogs.   
Again, we are going to use the ggplot2 package (rather than the `boxplot()` function in base R). Make sure it's attached.


```r
library(ggplot2)
qplot(x = Initial, y = Killed, data = ReedfrogFuncresp)
```

![plot of chunk functionalresponse](figure/functionalresponse.png) 

Nice enough, but how do we add lines, particularly, say, a smoothed line? Well, one of the unique features of the ggplot2 way of doing things is that everything we add to a panel is a geometry of some sort or another. We can add smoother geometry as such:


```r
library(ggplot2)
qplot(x = Initial, y = Killed, data = ReedfrogFuncresp) + geom_smooth()
```

```
## geom_smooth: method="auto" and size of largest group is <1000, so using
## loess. Use 'method = x' to change the smoothing method.
```

![plot of chunk functionalresponse_smooth](figure/functionalresponse_smooth.png) 

As you see, we have a sort of curvy blue line added, along with a grey envelope, which is the 95% CI. You can turn off the envelope by writing, " `... + geom_smooth(se = FALSE)`".  
The line is by default a loess (locally [weighted] scatterplot smoothing, a form of local regression). You can change the method that the smoother uses, as in, " `... + geom_smooth(method = "lm")`".  
The range of options include `lm`, `glm`, `gam` (general additive models; must load the `mgcv` package), `loess`, `rlm` (robust fitting of linear models; must supply function from `MASS` package), or your own functions. 
Note that this figure doesn't look quite like what EMD shows because of slightly different functions that are used (`lowess()` vs. `loess()`, for instance).

We can also add more than one line, strung together by "`+`" signs. So for instance:

```r
qplot(x = Initial, y = Killed, data = ReedfrogFuncresp) + geom_smooth(method = "loess", 
    span = 0.9, se = F, color = "red") + geom_smooth(method = "lm", se = F)
```

![plot of chunk functionalresponse_smoothlm](figure/functionalresponse_smoothlm.png) 


And we can pretty up the figure with nicer axis labels:

```r
qplot(x = Initial, y = Killed, data = ReedfrogFuncresp, xlab = "Initial number of Reed frog tadpoles", 
    ylab = "Number killed") + geom_smooth(method = "loess", span = 0.9, se = F, 
    color = "red") + geom_smooth(method = "lm", se = F)
```

![plot of chunk functionalresponse_smoothlm2](figure/functionalresponse_smoothlm2.png) 



Plotting the data: mapping sample size onto symbol area
-----------------
Let us switch datasets, to the experiment where predation rates were measured as a function of the tadpole's body length (TBL). Again, this is simple:

```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred)
```

![plot of chunk sizepred](figure/sizepred.png) 


No problem, except that if you look carefully at the data, you'll see that there are three tadpoles that were 21 mm TBL, all of which survived. They are overplotted on our figure. How do we solve this? There are at least three ways.  

*1) Jitter things a bit (add random noise).*  

```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred, position = "jitter")
```

![plot of chunk sizepred.jitter](figure/sizepred.jitter.png) 

OK. There is too much noise... we can control this if need be, but let's move on.

*2) Make the points semi-transparent.*  

```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred, alpha = I(1/3), size = I(2))
```

![plot of chunk sizepred.alpha](figure/sizepred.alpha.png) 

Well, this works better for some things than others. _Why the_ `I()`_? This tells ggplot2 that are not adding a new "scale" and so not to include a legend. Try it without this wrapper function and see what happens!_

*3) Make the size (=area) of the points proportional to the number of observations.*  
We can, in fact, do this multiple ways. While we can use some built in summary statistic functions in the ggplot2 package (see below for a partial solution), it is hard to get the geom right (i.e., I cannot make the mean values connected by lines... no idea why). This is often the case, and so while there is the fancy way, I would recommend just keeping it simple and creating a new data set.. could summarize our data by common values of "TBL"" and "Kill"" using the `table()` or `tapply()` functions, essentially creating a new dataframe to plot. 

First let's use `table()` to count how many observations we have at each combination of `TBL` and `Kill`. Note that we turn this into a dataframe. `ggplot2` doesn't work well with matrices, which are the default output of `table()`.

```r
rfsp <- with(ReedfrogSizepred, as.data.frame(table(TBL, Kill)))
str(rfsp)
```

```
## 'data.frame':	30 obs. of  3 variables:
##  $ TBL : Factor w/ 5 levels "9","12","21",..: 1 2 3 4 5 1 2 3 4 5 ...
##  $ Kill: Factor w/ 6 levels "0","1","2","3",..: 1 1 1 1 1 2 2 2 2 2 ...
##  $ Freq: int  1 0 3 2 3 1 0 0 1 0 ...
```

```r
rfsp$Kill <- as.numeric(as.character(rfsp$Kill))
rfsp$TBL <- as.numeric(as.character(rfsp$TBL))
str(rfsp)
```

```
## 'data.frame':	30 obs. of  3 variables:
##  $ TBL : num  9 12 21 25 37 9 12 21 25 37 ...
##  $ Kill: num  0 0 0 0 0 1 1 1 1 1 ...
##  $ Freq: int  1 0 3 2 3 1 0 0 1 0 ...
```

You will see that the `as.data.frame()` function has used row names to create the TBL and Kill columns, but because they were text, they are automagically converted into factors. This is the way to turn them back into numbers. (This is common; remember this)  
Also notice that there are a whole bunch of TBL by Kill combinations with a frequency of zero We don't want to plot those, so let's subset our dataframe to exclude those. We can then plot these 10 observations using `Freq` to determine the size or area of the points.

```r
rfsp <- subset(rfsp, Freq != 0)
qplot(x = TBL, y = Kill, size = Freq, data = rfsp) + scale_size_area()
```

![plot of chunk sizepred.subset](figure/sizepred.subset.png) 

The `... + scale_size_area()` tells the function to make the _area_, not the diameter, proportional to the number of observations.

Now, we also wanted to plot the mean values at each level of TBL. Note that we need to add a column for the `TBL` values. Luckily, the row names from our call to `tapply()` are just those values! Also, the function is going to look for a column called "Freq", so let's make sure it finds what it's looking for. 

```r
rfsp.ave <- with(ReedfrogSizepred, data.frame(Kill = tapply(Kill, TBL, mean)))
rfsp.ave$TBL <- as.numeric(row.names(rfsp.ave))
```


Since this is a separate dataframe, we'll need to tell `ggplot2` to use the `rfsp.ave` dataframe in the `geom_line()` function. We also need to specify what the size is because size also affects line widths.

```r
qplot(x = TBL, y = Kill, size = Freq, data = rfsp) + scale_size_area() + geom_line(data = rfsp.ave, 
    size = I(1/2))
```

![plot of chunk sizepred.line](figure/sizepred.line.png) 

And there you go. Can you add nicer x and y axis labels? What about changing the title of the legend? (See `?guide_legend` for help.)


### Here's how to use the inbuilt `stat_sum()` function ###


```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred) + stat_sum(aes(size = ..n..)) + 
    scale_size_area()
```

There are a few new things going on here. We are using `stat_sum()` to simply sum up the number of observations in each group (x-y combination). The stuff inside the brackets forces the function to return actual numbers instead of proportions (try it without this!). And because we want the _area_ of each point to be proportional to the sample size (rather than the diameter, which would be misleading!), we need to tell R to use the the area scale. 

To add in the mean values at each level of TBL, we can use this:

```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred) + stat_sum(aes(size = ..n..)) + 
    scale_size_area() + stat_summary(fun.y = "mean", geom = "point", color = "blue", 
    pch = 1, size = 5)
```

but unfortunately if we use `geom = "line"` it all falls apart. (Also, the function I'm using to generate these web pages chokes on this, telling me there are missing values and not plotting the smallest dots. That's why there's no graphs to see.)

We can always use other smoothing functions to get the gist of the pattern:

```r
qplot(x = TBL, y = Kill, data = ReedfrogSizepred) + stat_sum(aes(size = ..n..)) + 
    scale_size_area() + geom_smooth(method = "loess", se = F)
```



Plotting the data: other geometries and multiple facets
-----------------
Since the ReedfrogPred data involve responses in distinct treatments (rather than along continuous predictor variables), we probably want to use bar plots or box plots. I think box plots show a lot more information (means as well as the range of data) and are generally preferable to bar plots. They are very flexible, too.

Here ggplot2 comes into it's own. It is easy to make different variables a function of some variable or another. We can also make different facets for different treatments or groups. 


```r
qplot(factor(density), propsurv, color = size, facets = . ~ pred, data = ReedfrogPred, 
    geom = "boxplot")
```

![plot of chunk ReedfrogPredplot](figure/ReedfrogPredplot1.png) 

```r

qplot(factor(density), propsurv, facets = size ~ pred, data = ReedfrogPred, 
    geom = "boxplot")
```

![plot of chunk ReedfrogPredplot](figure/ReedfrogPredplot2.png) 

Try switching which factors you map to color, linetype, facets, etc. Try different geometries as well (e.g., point) with and without smoothing. 


Plotting the data: more on ggplot2
-----------------

One of the nice things about the ggplot2 package is that everything is an object, including the basic "theme" of the plot. Try using different themes:
`... + theme_bw() # black and white  
... + theme_minimal()  
... + theme_classic()'  
You can modify these or make your own once you get the hang of things.

Similarly, each graph is actually an object, so you can assign them to variables and reference them later. In fact the `qplot()` function is really a short-hand. The normal way of plotting something is like this:


```r
p <- ggplot(data = ReedfrogPred, aes(x = density, y = propsurv, color = size))
p + geom_point()
```

![plot of chunk ggplot](figure/ggplot1.png) 

```r
q <- p + geom_point() + facet_grid(. ~ pred)
q
```

![plot of chunk ggplot](figure/ggplot2.png) 

```r
q + geom_smooth(method = "lm")
```

![plot of chunk ggplot](figure/ggplot3.png) 

```r
p + geom_smooth(method = "lm")
```

![plot of chunk ggplot](figure/ggplot4.png) 

So once you get the basics of your plot down (the aesthetics like the x and y positions), you can simply add geometries or what not to them.


All of basic documentation of the ggplot2 package can be found here http://docs.ggplot2.org/current/, but as an introduction, http://wiki.stdout.org/rcookbook/Graphs/ is much easier to follow. There is a good deal of useful help on http://stackoverflow.com/questions/tagged/ggplot2


Homework
-----------------
With the data in the file at
http://www.esf.edu/efb/brunner/Rworkshop/RsylvaticaData.xls
create one (1) publication-
