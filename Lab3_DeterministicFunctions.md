Deterministic functions: EMD chapter 3
========================================================

Our goals in this lab are to: 

1. get a feel for a suite of important deterministic functions, seeing how their parameters changer their shapes and behavior
2. create reference figures that you can refer to when using these functions
3. learn to create your own function

Creating functions: the negative exponential
--------------------------------------------

There are a number of "built in" deterministic functions in R, but it will be very useful if we can create our own. It turns out that they are very easy to make. To illustrate how we do this, let’s make a function that computes values of negative exponential:
$$
  \begin{aligned}
  y & = a \times \exp(-bx)
  \end{aligned}
$$

The basic syntax of any function is:

```r
FunctionName <- function() {
}
```


The stuff inside the parentheses is list of "arguments" that the function takes (or requires). The negative exponential function requires one or more $x$-values, as well as two parameters, $a$ and $b$. 

```r
NegExp <- function(x, a, b) {
}
```


The stuff inside the curly brackets is the heart of the function, the part that does something. In our case, it does the math:

```r
NegExp <- function(x, a, b) {
    a * exp(-b * x)
}
```

It is worth noting that by default the last value that is calculated in a function is "returned". In this case, it means that the value of `a*exp(-b*x` is returned. In more complex functions, it is worth being explicit about what it returned. You can do this with the `return()` function, as so:

Let's try this function and see how it works. First, let's create a sequence of $x$-values, then we will plug them into our `NegExp()` function. 

```r
x <- seq(from = 0, to = 10, length = 50)
y <- NegExp(x, a = 1, b = 1)
y
```

```
##  [1] 1.000e+00 8.154e-01 6.649e-01 5.421e-01 4.421e-01 3.604e-01 2.939e-01
##  [8] 2.397e-01 1.954e-01 1.593e-01 1.299e-01 1.059e-01 8.638e-02 7.044e-02
## [15] 5.743e-02 4.683e-02 3.819e-02 3.114e-02 2.539e-02 2.070e-02 1.688e-02
## [22] 1.376e-02 1.122e-02 9.151e-03 7.462e-03 6.084e-03 4.961e-03 4.045e-03
## [29] 3.299e-03 2.690e-03 2.193e-03 1.788e-03 1.458e-03 1.189e-03 9.695e-04
## [36] 7.905e-04 6.446e-04 5.256e-04 4.286e-04 3.494e-04 2.849e-04 2.323e-04
## [43] 1.894e-04 1.545e-04 1.260e-04 1.027e-04 8.374e-05 6.828e-05 5.568e-05
## [50] 4.540e-05
```


Right. So we feed our function a vector of x-values and it spits out a vector of y-values, which, at first glance, seem to be about right. Let’s plot it and see.


```r
library(ggplot2)  #don't forget to load the package
qplot(x, y, geom = "line")
```

![plot of chunk NegExp.plot](figure/NegExp.plot.png) 


It works! Whoo hoo! Your first function! 

Now, we can make two important changes. First, we can provide default, but overrideable values to the arguments of a function. This is good practice because a) it lets you specify _just_ the thing(s) you want to change and b) there are built in "reasonable" values. It’s good to get in the habit.


```r
NegExp <- function(x, a = 1, b = 1) {
    a * exp(-b * x)
}
y.1 <- NegExp(x)  # using default values
qplot(x, y.1, geom = "line")
```

![plot of chunk NegExp.4](figure/NegExp.41.png) 

```r
y.2 <- NegExp(x, b = 1/3)  # using default value of a, but changing b
qplot(x, y.2, geom = "line")
```

![plot of chunk NegExp.4](figure/NegExp.42.png) 


The other thing to note, as I mentioned before, is that our function is returning a vector of values. We'll see later that a function can do a whole bunch of things, but it can only return one object (a vector, a matrix, a list...).  
By default a function returns the result of the last calculation, but with more complicated functions it is good practice to specify the thing you want returned by using `return(ThingToReturn)`. So in our case we would write:

```r
NegExp <- function(x, a = 1, b = 1) {
    y <- a * exp(-b * x)
    return(y)
}
```

And there you go; you're first fully developed function in R!

Plotting curves with `stat_function()`
--------------------------------------
Instead of generating a vector of x-values, calculating y-values, and then plotting them against each other, we can use the built‐in `stat_function()` of the ggplot2 package. It is designed for just this purpose.

We can plot any function we like, such as this one:

```r
qplot(x = c(0, 5), stat = "function", fun = function(x) 10 * (1 - exp(-2 * x) - 
    1/30 * x^2), geom = "line")
```

![plot of chunk madeup.stat_fun](figure/madeup.stat_fun.png) 


Or use named functions, like our `NegExp()` function (or anything else built into R).

```r
qplot(x = c(0, 10), stat = "function", fun = NegExp, geom = "line")
```

![plot of chunk NegExp.stat_fun](figure/NegExp.stat_fun.png) 


If we want to plot more than one curve on the same axes, we need to use the `ggplot()` version of things, rather than `qplot()`. We are assigning color to different character strings in the `aes()` part, so that the function knows to create entries in a legend for each with the appropriate colors. We then have to specifiy values of the colors and the breaks within the `scale_colour_manual()` function. Note that the names are assigned alphabeticaly, so even though "`a=0.5, b=1`" is the last entry, it gets the first color listed (here, darkgreen).


```r
NE <- ggplot(data.frame(x = c(0, 10)), aes(x)) + stat_function(fun = NegExp, 
    geom = "line", args = list(a = 1, b = 0.5), aes(colour = "a=1, b=0.5")) + 
    stat_function(fun = NegExp, geom = "line", args = list(a = 1, b = 1), aes(colour = "a=1, b=1")) + 
    stat_function(fun = NegExp, geom = "line", args = list(a = 1, b = 2), aes(colour = "a=1, b=2")) + 
    stat_function(fun = NegExp, geom = "line", args = list(a = 1/2, b = 1), 
        aes(colour = "a=0.5, b=1")) + scale_colour_manual("Parameters", values = c("darkgreen", 
    "lightblue", "blue", "darkblue"), breaks = c("a=1, b=0.5", "a=1, b=1", "a=1, b=2", 
    "a=0.5, b=1")) + labs(title = "Negative Exponential") + theme_bw()

NE
```

![plot of chunk guide.NegExp](figure/guide.NegExp.png) 


I think that this sort of figure is a handy reference. You may want to turn this into a pdf and keep it handy or print it out. It's relatively easy to do:

```r
ggsave(NE, file = "NegativeExponential.pdf", width = 8, height = 6)  # width in inches, by default
```


Homework 1: More functions to explore
-------------------------

You should try to at least understand the behavior of, if not create a similar reference pdf of the following deterministic functions. The approach is the same. Try to code them yourself. If you have trouble with the math, see below.

**Hyperbolic**  
$$
  \begin{aligned}
  y & = \frac{a}{b+x} 
  \end{aligned}
$$

**Michaelis-Menton**
$$
  \begin{aligned}
  y & = \frac{ax}{b+x} 
  \end{aligned}
$$

**Holling Type III**
$$
  \begin{aligned}
  y & = \frac{ax^2}{b^2+x^2} 
  \end{aligned}
$$

**Holling Type IV**
$$
  \begin{aligned}
  y & = \frac{ax^2}{b+cx+x^2} 
  \end{aligned}
$$

**Monomolecular**
$$
  \begin{aligned}
  y & = a(1-exp(-bx)) 
  \end{aligned}
$$

**Ricker**
$$
  \begin{aligned}
  y & = ax \times exp(-bx)
  \end{aligned}
$$

**Logistic**
$$
  \begin{aligned}
  y & = \frac{exp(a+bx)}{1+exp(a+bx)}
  \end{aligned}
$$
   
   
   
Homework 2: Which curve?
-------------------------

1. On page 96 in EMD, Bolker states that the logistic is popular because it is a simple sigmoid function, but then indicates that its "rational analogue," the Holling Type III functional response is also a simple sigmoid function. So can you get a Holling type III curve to look like a logistic or vice versa? (Say, from 0 to 10.) If so, under what parameters?

2. What about the hyperbolic and the negative exponential?

Send me one figure for each pair showing me how close you were able to get. Make sure you label your axes, etc., and indicate the parameter combinations you used. Closest fit in the class gets a beer.


---------------
---------------


```r
Hyperbolic <- function(x, a = 2, b = 3) {
    a/(b + x)
}
MichMent <- function(x, a = 2, b = 1) {
    a * x/(b + x)
}
Holling3 <- function(x, a = 2, b = 1) {
    (a * x^2)/(b^2 + x^2)
}
Holling4 <- function(x, a = 2, b = 3, c = -1) {
    (a * x^2)/(b + c * x + x^2)
}
Monomolecular <- function(x, a = 2, b = 3) {
    a * (1 - exp(-b * x))
}
Ricker <- function(x, a = 2, b = 3) {
    a * x * exp(-b * x)
}
Logistic <- function(x, a = 0, b = 1) {
    exp(a + b * x)/(1 + exp(a + b * x))
}
```
























