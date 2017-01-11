# Load packages
library(tidyverse)

# Load in the data
Predation <- read_csv("ReedfrogPred.csv")

# Get summaries
summary(Predation)

# Plot propsurve against density
p <- ggplot(data=Predation, aes(x=density, y=propsurv)) + 
	geom_point() + facet_grid(size ~ pred)
p

# Test whether propsurv declines with density
lm1 <- lm(propsurv ~ density, data=Predation)
summary(lm1)

# Oh! need to account for predators and size
lm2 <- lm(propsurv ~ density + pred + size, data=Predation)
summary(lm2)

# What are the effect sizes?
coef(lm2)

# Hmmm am I fitting the right model? Maybe this should be a logistic?