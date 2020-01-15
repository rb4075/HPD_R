
### Welcome to HPD's R Sessions. 

### Before starting the session, make sure that you:
  ### 1. Configured the Global Options
  ### 2. Created your R Project
  ### 3. Created your R File

### Topic 1: R Projects vs. R Files

### Topic 2: Where to learn R?

### Topic 3: Libraries

install.packages("dplyr")
library(dplyr)
install.packages("reshape")
library(reshape) ### Usually used for pivot tables
x <- 54


### Topic 4: EXxploring the data -- Initial manipulation
### 4.1 Loading Data from a .csv file
evictions <- read.csv(file="Data/Evictions OpenData.csv")

### 4.2 Substracting columns (fields) of your data and storing them in a new variable
boroughs <-  evictions$BOROUGH
### When extracting a column from a data frame, R creates a new type of data called "LIST"


### Topic 5: Basic Summaries of your data using base R (native R functions)

summary(evictions)
#### This function will give you very basic, straightforward statistics of your data. It will identify
### what is numeric and what is categorical and will give you counts or statistics based on that.
### However this is not useful if our data is formatted incorrectly or requires deeper analysis.

### We can use another version of this function to visualize statistics for a specific category in a field
### For instance, how are evictions distributed based on the type of use

by(evictions, evictions$RESIDENTIAL_COMMERCIAL_IND, summary)
### This will give you to braks of summaries, one for Residential and one for Commercial. There
### is definitely some interesting information that you can get very quickly but it is still very limited. 






pivot.table.evictions <- cast(evictions, gene ~ condition)








