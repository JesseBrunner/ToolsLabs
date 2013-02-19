# Script to pick the winners of the fitting challenge in Lab 3


# load in everyone's parameter estimates
pars <- read.csv("Lab3_Parameters_CurveMatching.csv")

# set the x-values over which to compare
x <- seq(0,10, length = 100)


#-------------------------------------------------------------------------------
# The first challenge was to match a Negative Exponential and a Hyperbolic curve
NegExp <- function(x, a = 1, b = 1) {
	y <- a * exp(-b * x)
	return(y)
}

Hyperbolic <- function(x, a = 2, b = 3) {
	y <- a/(b + x)
	return(y)
}

compare.NE.Hyp <- function(x, a.NE, b.NE, a.Hyp, b.Hyp){
	# calculate the sum of the squared differences between the models
	sum( ( NegExp(x, a.NE, b.NE) - Hyperbolic(x, a.Hyp, b.Hyp) )^2 )
}

dev.NE.Hyp <- numeric()

for(i in 1:dim(pars)[1]){
	dev.NE.Hyp[i] <- with(pars, compare.NE.Hyp(x, a.NE[i], b.NE[i], a.Hyp[i], b.Hyp[i]) )
}

# and the winner of the first challenge is...
pars[which.min(dev.NE.Hyp), ]

#--------------------------------------------------------------------
# The second challenge was to match a logistic and a Holling type III
Logistic <- function(x, a, b) {
	exp( a + b*x) / (1 + exp(a + b * x))
}

Holling3 <- function(x, a, b) {
	(a * x^2)/(b^2 + x^2)
}

compare.Log.Hol <- function(x, a.log, b.log, a.hol, b.hol){
	# calculate the sum of the squared differences between the models
	sum( ( Logistic(x, a.log, b.log) - Holling3(x, a.hol, b.hol) )^2 )
}

dev.Log.Hol <- numeric()

for(i in 1:dim(pars)[1]){
	dev.Log.Hol[i] <- with(pars, compare.Log.Hol(x, a.log[i], b.log[i], a.hol[i], b.hol[i]) )
}

# and the winner of the second challenge is...
pars[which.min(dev.Log.Hol), ]