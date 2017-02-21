# Here is some made up data
x <- rnorm(n=505, mean=10, sd=4)

### What does ecdf do? It is a cummulative distribution plot.
plot(ecdf(x)) # you will see that this looks like a CDF plot of the normal
curve(pnorm(x, mean = 10, sd=4), add=TRUE, col = "red")

# Now if we want the Q-Q plot, this might be easier
library(tidyverse)
df <- data.frame(x=sort(x))
df <- df %>% 
	mutate(quant = percent_rank(lag(x)), #We lag one b/c we want percent _less_ than the observation
				 normal = qnorm(p=quant, 
				 							 mean=mean(x),
				 							 sd=sd(x)),
				 lognormal = qlnorm(p=quant,
				 									 meanlog=log(mean(x)),
				 									 sdlog=log(sd(x))),
				 gamma = qgamma(p=quant, 
				 							 scale=var(x)/mean(x),
				 							 shape=mean(x)^2/var(x))
				 )

ggplot(df, aes(x=normal, y=x)) + geom_point() + geom_abline(color="red")
ggplot(df, aes(x=lognormal, y=x)) + geom_point() + geom_abline(color="red")
ggplot(df, aes(x=gamma, y=x)) + geom_point() + geom_abline(color="red")
