## The dataset has 2,075,259 rows and 9 columns. First calculate a rough 
## estimate of how much memory the dataset will require in memory before reading
## into R. Make sure your computer has enough memory (most modern computers 
## should be fine).

## We will only be using data from the dates 2007-02-01 and 2007-02-02. One
## alternative is to read the data from just those dates rather than reading in
## the entire dataset and subsetting to those dates.

## You may find it useful to convert the Date and Time variables to Date/Time
## classes in R using the strptime() and as.Date() functions. Note that in this
## dataset missing values are coded as ?.

## Gets power data from remote server
## Subsets to 2007-02-01 & 2007-02-02
## Saves data to CSV
## Returns dataframe of data
getPowerData <- function() {
  ##URL of zipped data
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  ## File name of data in zip
  file <- "household_power_consumption.txt"
  ## Download and unzip data
  data <- downloadUnzipData(url,file,header = TRUE,sep = ";")
  ## Subset based on dates
  dates <- c("1/2/2007", "2/2/2007")
  data <- subset(data, Date %in% dates)
  ## Save data locally so we don't have to keep on downloading
  write.csv(data, file = "data//power.csv", row.names = FALSE)
}

## Downloads, unzips data, return data table
## url is URL of zip file
## file is the name of the file in the zip
## ... to pass extra args to read.table
downloadUnzipData <- function(url,file,header = TRUE, sep = ";") {
  temp <- tempfile()
  download.file(url,temp)
  data <- read.table(unz(temp, file),header,sep)
  unlink(temp)
  data
}

## Download Power Data if it's not around
if(!file.exists("data//power.csv")) {
  getPowerData()
}

data <- read.csv("data//power.csv")

## Construct forth plot
## Add new columnn of date & time so we can plot a timeseries on the x axis This
## may already be present if this script in run after plot2.R or plot3.R but no harm done it
## will just overwrite
data$DateTime <- strptime(paste(data[["Date"]], data[["Time"]]), format='%d/%m/%Y %H:%M:%S')

## This time plot straight to PNG rather than copy from screen, because we'll
## cut of the legend if we don't set the width upfront
png("plot4.png", width = 480, height = 480)

## 4 figures arranged in 2 rows and 2 columns
par(mfrow = c(2, 2))
## Top left
plot(data[["DateTime"]], data[["Global_active_power"]], type="l", xlab="", ylab="Global Active Power (kilowatts)")
## Top right
plot(data[["DateTime"]], data[["Voltage"]], type="l", xlab="datetime", ylab="Voltage")

## Bottom left

##Plot Sub metering 1 and add Y axis label
plot(data[["DateTime"]], data[["Sub_metering_1"]], type="l", col="black", xlab="", ylab="")
##Add Sub metering 2
points(data[["DateTime"]], data[["Sub_metering_2"]], type="l", col="red")
##Add Sub metering 3 a
points(data[["DateTime"]], data[["Sub_metering_3"]], type="l", col="blue")
## Add legend
legend("topright", lty = "solid", col = c("black","blue", "red"), bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Bottom right
plot(data[["DateTime"]], data[["Global_reactive_power"]], type="l", xlab="datetime", ylab="Global_reactive_power")

##Save plot
dev.off()
