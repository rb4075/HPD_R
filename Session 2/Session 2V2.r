
### Welcome to HPD's R Sessions. 
### Created by: Ricardo Martínez Campos, Mayor's Office to Protect Tenants
### December 2019


### Before starting the session, make sure that you:
  ### 1. Configured the Global Options
  ### 2. Created your R Project
  ### 3. Created your R File

###############################################
############### Topic 1: R Projects vs. R Files
##############################################

###########################################
############### Topic 2: Where to learn R?
###########################################

##################################
############### Topic 3: Libraries
##################################

install.packages("dplyr")
install.packages("reshape")
install.packages("tidyverse")

library(tidyverse)
library(dplyr)
library(reshape) ### Usually used for pivot tables

###################################################################
############### Topic 4: Exploring the data -- Initial manipulation
###################################################################

### 4.1 Loading Data from a .csv file
########
evictions <- read.csv(file="Data/Evictions OpenData.csv")

### 4.2 Extracting columns (fields) and values in columns of your data and storing them in a new variable
########
boroughs <-  evictions$BOROUGH
### When extracting a column from a data frame, R stores it in a new type of value called VECTOR
### We can print the values of a vector (or any object, actually) using "print"
print(boroughs)
### Note: Integers and Strings can be stored in R as factors. Factors are useful when conducting statistical
### analysis and you need to asign a variable to each of your categories (for example, binary)
### If we don't need factors the best thing to do is to turn Factors into the correct category. 
### Facotrs use levels to organize the data
levels(boroughs)

### 4.3 Understanding Indeces (brackets)
### Seomthing that you might notices are the brackets at the beginning of the command line when calling a command
### They are there to show the position of each element in the vector/dataframe/list 
### We can use these positions to extract values as well
boro.values  <- levels(boroughs) 
### Look at how storing the levels in a new vector automatically changes the data type
### Let's say that we want to extract the Manhattan value, which is in the third position
manhattan  <-  boro.values[3]


### 4.4 Extracting values from a dataframe
#######
### We can also extract data directly from the dataframe, giving R a couple of instructions
### Let's suppose we want to extract the first column of the evictions dataset
first.column <- evictions[1]
### This is similar to what we have learned before.
### However, using a similar nomenclature for the code, we can extract specific rows, series of rows, series of
### columns or specific values in a dataframe
### First row:
first.row <- evictions[1,]
### First five rows:
five.rows <- evictions[1:5,]
### First and fifth row only:
first.and.fifth <- evictions[c(1,5),]
### Value from second row and third column
int.second.third <- evictions[2,3]
print(int.second.third)

### 4.5 Changing data types
#######
### Turning Factors into characters
### Previously we identified that the "Borough" field is not a character. We need to turn it from factor to
### character since that's the way we want it for our purposes.
evictions$BOROUGH  <- as.character(evictions$BOROUGH)
### Which reads: set the BOROUGH field on the Evictions dataset "as character" *IN* the BOROUGH field 
### within the Evictions dataframe
### Now if you call the line to extract the column you will see that the data type changed
borougs.character  <- evictions$BOROUGH
### You can use "as.numeric", "as.character" and "as.factor" to change to some of the most common
### data types in R

### 4.6 Changing names of fields
#######
### Getting the list of field names from a dataframe
colnames(evictions)
colnames(evictions)[1] <- "Index" 
### And we can also look for the column using its name
colnames(evictions)[colnames(evictions) == "Index"] <- "INDX"
### Remmber, colnames(evictions) == "INDX" is a placeholder for the index number of Index (which is the number 1)
### If we were to run "colnames(evictions) == "Index" alone, it would show the position in which Index is TRUE


#################################################################
############### Topic 5: Subsetting data using specific variables
#################################################################

### 5.1 Subsetting rows that meet one specific criteria
#######
### Let's suppose that we want to subset all eviction cases that took place in Queens.
### We can do that using simple base R functions
queens.cases <- subset(evictions, BOROUGH == "QUEENS")

### 5.2 Subsetting rows that meet more than one criteria
#######
### Now let's subset cases that both took place in Queens and that were Residential cases
queens.cases.residential <- subset(evictions, BOROUGH == "QUEENS" & RESIDENTIAL_COMMERCIAL_IND == "Residential") 

### 5.3 Subsetting strings
#######
### We sometimes need to subset values using strings or portions of a string. We can do that using grep, which
### is a base R function that looks for values that match the criteria given.
### grep gives you the index of all rows that meet the criteria
grep("AVE", evictions$EVICTION_ADDRESS)
### If we have the location/index of all rows, then we can use that vector and pair it with a locator
### function to identify the dataframe that we are looking for
avenue.cases <- evictions[grep("AVE", evictions$EVICTION_ADDRESS), ]
### Which read as: From the evictions dataset, give me all the columns that match the list of rows (indeces)
### identified by grep using "AVE" as criteria in the EVICTION_ADDDRESS column, and store it in a new
### dataframe called "avenue.cases"

### 5.4 Subsetting Dates
### Dates are actually a data type in R, and they are one of the trickiest to manipulate, because
### you need to make sure they are in the correct R Format
### First lets extract the date column from our dataframe so that we can inspect it individually
dates <- evictions$EXECUTED_DATE
### The first thing that we notice is that the dates are in the Factor data type. They need to be a character
### (We can also notice there is 717 different dates)
dates <- as.character(dates) 
print(dates)
### Now we can change the format to DATE
dates <- as.Date(dates, "%m/%d/%Y")
### Here the function requires tu inputs: one is the date vector (or column, in case you are calling this
### function directly on a dataframe) and the other one is the format in which the date is currently written on
### %m means "month", "/" serves as the original separator, "%d" means day and "%Y" means Year. We use 
### "%y" when the year is only two digits, and when we have the day or month as a string, we use "a/A" instead
### of "d" and "b/B" instead of "m" (a/A and b/B means abbreviated and unabbreviated respectively)
### We can also notice how the date changed in format. Look at the values section in the Environment. 
### Let's run this in the dataframe
evictions$EXECUTED_DATE <- as.Date(evictions$EXECUTED_DATE, "%m/%d/%Y")
### Now we can go on and subset the dates. Let's subset all cases since January 1st, 2019
since.2019 <- subset(evictions, EXECUTED_DATE >= "2019-01-01")

#################################################################
############### Topic 6: Removing rows by criteria in a dataframe
#################################################################

### 6.1 We can remove rows by stating a specific criteria using the selection process with brackets
#######
since.2019.clean <- since.2019[!(since.2019$INDX =="28748/16"),]
### Here, the key is the "!" operator, which means inverse in the R world. 

### 6.2 Dropping all NA
#######
evictions.nona  <-  na.omit(evictions)

### 6.3 Dropping NAs but only for certain columns
#######
evictions.nona.boro  <-  evictions[!is.na(evictions$BOROUGH),]

############################################################
############### Topic 7: Condcuting Basic Summary Statistics
############################################################

### 7.1 Get a quick summary of your dataframe
#######
summary(evictions)
### This function will give you very basic, straightforward statistics of your data. It will identify
### what is numeric and what is categorical and will give you counts or statistics based on that.
### However this is not useful if our data is formatted incorrectly or requires deeper analysis.
### We can use another version of this function to visualize statistics for a specific category in a field
### For instance, how are evictions distributed based on the type of use
by(evictions, evictions$RESIDENTIAL_COMMERCIAL_IND, summary)
### This will give you to braks of summaries, one for Residential and one for Commercial. There
### is definitely some interesting information that you can get very quickly but it is still very limited. 

### 7.2 Get a quick summary of a column in your dataframe
#######
### Similar to what we have done so far, you can get the summary statistics for a given column
### in your dataframe as if you were subsetting the column
s.statistics.docket <-  summary(evictions$DOCKET_NUMBER)
print(s.statistics.docket)

### 7.3 Getting values directly from columns
#######
### R can also use basic functions to obtain statistics directly from colunmns, like this one:
median(evictions$DOCKET_NUMBER)

#####################################
############### Topic 8: Pivot Tables
#####################################

### 8.1 Creating a simple two-entry table
#######
### In R we can create two-entry tables using the cast function from the reshape package.
### These tables need you to input which variables you want to use as the frames of the table, and then define 
### the data frame that you would be using.
### For example, if we want to know the counts of eviction cases in each Borough based on the type of eviction 
### (Residential vs. Commercial), we could do the following:
pivot.table.evictions <- cast(evictions, BOROUGH ~ RESIDENTIAL_COMMERCIAL_IND)
### FYI, counts is the default operation conducted by these two entrey tables.

### 8.2 Creating a two entry table with other operations
### Let's assume that we want the same layout than previously, but now instead of counts we can the median 
### of the Docket Number per Borough and by type of eviction (!!!!! this is just for the purposes of exemplifying)
### how the median value of a thrid field would look like--getting the median of the Docket Number makes no sense.
pivot.table.evictions.median <- cast(evictions, BOROUGH ~ RESIDENTIAL_COMMERCIAL_IND, median, value = "DOCKET_NUMBER")







