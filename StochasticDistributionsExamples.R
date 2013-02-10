library(ggplot2)

nstudents <- 14 * 2 # 14 students, each doing things twice.

# Coin flip example 1: Number of success (=heads) out of 10 coin flips, for each person (=sample)
successes <- c(4, 4, 3, 8, 5, 6, 6, 7, 6, 5, 5, 4, 8, 4, 5, 4, 4, 5, 8, 6, 5, 5, 5, 7, 7, 4, 5, 4)  

# plot the results
c1 <- qplot(successes, xlim = c(0,10), binwidth = 1, color = I("white"))
c1

# what is the probability of getting a head?
(prob.successes <- sum(successes)/(10 * length(successes))  )

# what are the chances of getting 0, 1, 2, ... 10 successes given this probability?
pred.successes <- nstudents * dbinom(0:10, size = 10, prob = prob.successes)

c1 + geom_point(aes(x = 0:10 + 0.5, y = pred.successes), col = "red")




# Coin flip example 2: Number of successes (=heads) in 1 minute, for each person (=sample)
heads <- c(5, 14, 13, 9, 14, 6, 8, 12, 7, 13, 4, 10, 7, 12, 8, 16, 13, 11, 18, 12, 16, 11, 18, 12, 13, 11, 9, 10)

#plot the results
c2 <- qplot(heads, binwidth = 1, color = I("white")) 
c2

# rate will be the rate of flipping times the probability of getting a heads
rate.heads <- sum(heads)/28

# What are the chances of getting 0, 1, 2, ... 20 heads given this rate?
pred.heads <- nstudents * dpois(0:20, lambda = rate.heads)

c2 + geom_point(aes(x = 0:20 + 0.5, y = pred.heads), col = "red")



# Back to the original coin-flipping example. What if we want to be sure that our coin is fair (i.e., p = 0.5)? What is the probability that p = 0.5 (or any other value) if we see a heads and b tails?

# In the first trial we had
successes[1]
# heads and 
10 - successes[1]
# tails

qplot(c(0,1), stat = "function", fun = dbeta, geom = "line", args = list(shape1 = (successes[1]-1), shape2 = (10 - successes[1] -1) ))

# if we add more data (e.g., the first twenty coin flipes in "successes" ) we should get close to the truth, and more confidence, and so on

a <- cumsum(successes)
b <- cumsum( 10 - successes)

for(i in 1:nstudents) {
	p <- qplot(c(0,1), stat = "function", fun = dbeta, geom = "line", 
				args = list(shape1 = a[i]-1, shape2 = b[i]-1 ))
	print(p)
}
# Hit the back button to see each graph in order


# rice on the ground example as measured in quadrats
rice <- c(0, 0, 1, 0, 0, 0, 7, 1, 1, 0, 4, 3, 5, 2, 1, 2, 3, 0, 1, 0, 1, 1, 3, 0)

r1 <- qplot(rice, binwidth = 1, color = I("white"))
r1
# what is the rate of rice per quadrat?
rate.rice <- mean(rice)
rate.rice # = lambda
var(rice)

var(rice)/mean(rice) # should be close to 1, but with small data set, maybe not

# What are the chances of getting 0, 1, 2, ... rice grains in a plot?
# That is, what is the expected distribution of rice per quadrat?
pred.rice <- nstudents * dpois(0:10, lambda = rate.rice)

r1 + geom_point(aes(x = 0:10 + 0.5, y = pred.rice), col = "red")


# What if we were to go back and count the number of rice stems after a while? 
# We wouldn't expect them all to have the same number of stems, right? Some would have many, some few...
# like this
qplot(c(0,10), stat = "function", fun = dgamma, args = list(shape = 1, scale = 2), n = 11)

# create a vector for the number of stems
stems <- numeric()

# cycle through each plot or quadrat
for(i in 1:length(rice)){
	# each rice grain in the quadrat has a number of stems coming from a gamma
	# sum them up to get the number of stems in the plot
	stems <- c(stems, sum(round( rgamma(rice[i], shape = 1, scale = 2) ))  )
}

r2 <- qplot(stems, binwidth = 1, color = I("white"))
r2

# what is the mean of stems? Should be approx: shape*scale
mu.stems <- mean(stems)
mu.stems

# What is the predicted distribution of the number of stems per quadrant?
pred.stems <- nstudents * dnbinom(0:max(stems), mu = mu.stems, size = 1)

r2 + geom_point(aes(x = 0:max(stems) + 0.5, y = pred.stems), col = "red")




