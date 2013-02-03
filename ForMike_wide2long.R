base_wide <- read.csv("BaselineIENFD.csv")
str(base_wide)
library(reshape2)

# with melt you provide the ID variables (i.e., those that were not measured) and it assumes everything else was measured.
base_long <- melt(base_wide, id.vars = c("ID", "Control", "Sex"))
str(base_long)

# You'll notice that you have two new columns called "variable" and "value" 
# Take a look and make sure you see where they came from.

# you might want to rename those columns, like this
colnames(base_long)[c(4,5)] <- c("Location", "IENFD")

# Your naming of the "Location" variable is still wonky. 
# You can change the labels on the levels of these as such
levels(base_long$Location)
levels(base_long$Location) <- c("DL", "DT", "PT")

summary(base_long)
str(base_long)