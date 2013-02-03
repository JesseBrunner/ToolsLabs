# Illustrating the importance of exploring funcitons, particularly integrating and differentiating

logistic <- function(x, r = 2, K = 100){
	
	N <- x
	
	# The logistic growth equation
	r*N*(K-N)/K
	
}

logistic.sol <- function(x, r = 2, K = 100, N0 = 1){
	
	t <- x
	# The solution to the logistic growth equation
	K/( 1 + (K/N0 - 1) * exp(-r*t) )
	
}


D(expression(r*N*(K-N)/K), "N")

logistic.deriv <- function(x, r = 2, K = 100){
	
	N <- x
	# the first derivative of the logistic growth equation
	(r * (K - N) - r * N)/K
}


library(ggplot2)


# Plot of dN/dt against N for the logistic equation
qplot(x=c(0,110), stat="function", fun=logistic, geom="line", ylab = expression(frac(dN,dt)), xlab = "N", main = expression( frac(dN,dt) == frac(rN(K-N), K) ) ) + geom_hline(yintercept = 0)

qplot(x=c(0,110), stat="function", fun=logistic.deriv, geom="line", ylab = expression(frac(d(dN/dt),dt)), xlab = "N", main = expression( frac(d(dN/dt),dt) == r - frac(2*r*N,K) ) ) + geom_hline(yintercept = 0)

			 

# Plot of N againt time for the solution to the logistic equation
qplot(x= c(0,10), stat = "function", fun = logistic.sol, geom="line", ylab = "N", xlab = "t", main = expression( N(t) == frac(K, 1+(frac(K,N[0])-1)*e^-rt ) ) )


qplot(x=c(0,110), stat="function", fun=eval(D(expression(r*x*(k-x)/k)), "x"), geom="line", args =list(r = 2, k = 100))

