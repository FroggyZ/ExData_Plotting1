#-------------------------------------------------------------------------------
#                    EXPLORATORY DATA ANALYSIS - ASSIGNMENT 1
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                         PLOT 4: Energy sub metering
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

par(mfrow = c(2,2))                                                           ## window for 2 x 2 graphs 
with(DF, {
        # Top-Left graph with no X-axis label
        plot(DF$DateTime, DF$Global_active_power, type="l", xlab="", ylab="Global Active Power")
        
        # Top-Right graph
        plot(DF$DateTime, DF$Voltage, type = "l", col = "black", xlab="datetime", ylab="Voltage") 
        
        # Bottom-Left graph with no border for legend box and no X-axis label
        plot(DF$DateTime, DF$Sub_metering_1, type = "l", col = "black", xlab="", ylab="Energy sub metering")                                     
        lines(DF$DateTime, DF$Sub_metering_2, type = "l", col = "red")                
        lines(DF$DateTime, DF$Sub_metering_3, type = "l", col = "blue")               
        legend("topright", lty=1, bty="n", col=c("black","red","blue"), 
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
        
        # Bottom-Right graph
        plot(DF$DateTime, DF$Global_reactive_power, type = "l", col = "black", xlab="datetime", 
             ylab="Global_reactive_power")  
        
})


#-------------------------------------------------------------------------------
#  Plot the requested graph in a PNG file   
#-------------------------------------------------------------------------------
png("plot4.png")
par(mfrow = c(2,2))                                                           ## window for 2 x 2 graphs 
with(DF, {
        # Top-Left graph with no X-axis label
        plot(DF$DateTime, DF$Global_active_power, type="l", xlab="", ylab="Global Active Power")
        
        # Top-Right graph
        plot(DF$DateTime, DF$Voltage, type = "l", col = "black", xlab="datetime", ylab="Voltage") 
        
        # Bottom-Left graph with no border for legend box and no X-axis label
        plot(DF$DateTime, DF$Sub_metering_1, type = "l", col = "black", xlab="", ylab="Energy sub metering")                                     
        lines(DF$DateTime, DF$Sub_metering_2, type = "l", col = "red")                
        lines(DF$DateTime, DF$Sub_metering_3, type = "l", col = "blue")               
        legend("topright", lty=1, bty="n", col=c("black","red","blue"), 
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
        
        # Bottom-Right graph
        plot(DF$DateTime, DF$Global_reactive_power, type = "l", col = "black", xlab="datetime", 
             ylab="Global_reactive_power")  
        
})
dev.off()


#-------------------------------------------------------------------------------
#  Reset back to original what needs to be resetted
#-------------------------------------------------------------------------------

## restore window splitting to 1x1
par(mfrow = c(1,1)) 

## restore system to its original "locale" settings
Sys.setlocale("LC_TIME", myLocaleSettings)