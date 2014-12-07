#-------------------------------------------------------------------------------
#                    EXPLORATORY DATA ANALYSIS - ASSIGNMENT 1
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                         PLOT 3: Energy sub metering
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#                       Download and extract datafile
#-------------------------------------------------------------------------------

## set directory where to download "zipped" datafile and unzip it
## (will also be the working directory for the assignment)
setwd("C:/RWork/DataScience/04-ExploratoryDataAnalysis/Assignment1")


## save current system's "locale" settings
myLocaleSettings <- Sys.getlocale(category = "LC_TIME")

## set "locale" settings to English to have labels printed in English
Sys.setlocale("LC_TIME", "English")


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


## CREATE A DATETIME VARIABLE USEFUL FOR TIME-SERIES
DF$DateTime <- strptime(paste(DF$Date, DF$Time), "%d/%m/%Y %H:%M:%S")


#-------------------------------------------------------------------------------
#  Plot the requested graph on the screen device
#-------------------------------------------------------------------------------
 plot(DF$DateTime, DF$Sub_metering_1, type = "l", col = "black", 
      xlab="", ylab="Energy sub metering")                                    ## 1st variable + adequate label
lines(DF$DateTime, DF$Sub_metering_2, type = "l", col = "red")                ## add 2nd variable
lines(DF$DateTime, DF$Sub_metering_3, type = "l", col = "blue")               ## add 3rd variable
legend("topright", lty=1, col=c("black","red","blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))        ## add legend

#-------------------------------------------------------------------------------
#  Plot the requested graph in a PNG file   
#-------------------------------------------------------------------------------
png("plot3.png")
plot(DF$DateTime, DF$Sub_metering_1, type = "l", col = "black", 
     xlab="", ylab="Energy sub metering")                                     ## 1st variable + adequate label
lines(DF$DateTime, DF$Sub_metering_2, type = "l", col = "red")                ## add 2nd variable
lines(DF$DateTime, DF$Sub_metering_3, type = "l", col = "blue")               ## add 3rd variable
legend("topright", lty=1, col=c("black","red","blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))        ## add legend
dev.off()


#-------------------------------------------------------------------------------
#  Reset back to original what needs to be resetted
#-------------------------------------------------------------------------------

## restore system to its original "locale" settings
Sys.setlocale("LC_TIME", myLocaleSettings)