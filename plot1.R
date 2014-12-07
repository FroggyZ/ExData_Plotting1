#-------------------------------------------------------------------------------
#                    EXPLORATORY DATA ANALYSIS - ASSIGNMENT 1
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                 PLOT 1: Histogram on Global Active Power variable
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#                       Download and extract datafile
#-------------------------------------------------------------------------------

## set directory where to download "zipped" datafile and unzip it
## (will also be the working directory for the assignment)
setwd("C:/RWork/DataScience/04-ExploratoryDataAnalysis/Assignment1")


## download and open zipped file for assignment
url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(url, 'household_power_consumption.zip')
unzip('household_power_consumption.zip')


## READ ONLY DATA FOR 01/02/2007 and 02/02/2007
## to do that, use package "sqldf" to select rows with conditions expressed in SQL
library(sqldf)

## Connect to "household_power_consumption.txt" file
myFile <- file("./household_power_consumption.txt")

## select only observations needed  
DF     <- sqldf('select * from myFile where Date = "1/2/2007" OR Date = "2/2/2007"',
                dbname = tempfile(),
                file.format = list(header = TRUE, 
                                   sep = ";", 
                                   eol = '\r\n'))
## write some information on that DF  
str(DF)
summary(DF)

## close connection  
sqldf()

## Note that in doing so, it seems that there is no NAs for the subset Feb. 1-2, 2007 !!
## However, "na.strings" is set to "?" as it was specified in assignment #1


## CREATE A DATETIME VARIABLE USEFUL FOR TIME-SERIES
DF$DateTime <- strptime(paste(DF$Date, DF$Time), "%d/%m/%Y %H:%M:%S")


#-------------------------------------------------------------------------------
#  Plot the requested graph on the screen device
#-------------------------------------------------------------------------------
hist(DF$Global_active_power, col="red", 
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")

#-------------------------------------------------------------------------------
#  Plot the requested graph in a PNG file   
#-------------------------------------------------------------------------------
png("plot1.png")
hist(DF$Global_active_power, col="red", 
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")
dev.off()