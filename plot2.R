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
## file is the name of teh file in the zip
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

## Construct second plot
## Add new columnn of date & time so we can plot a timeseries on the x axis
data$DateTime <- strptime(paste(data[["Date"]], data[["Time"]]), format='%d/%m/%Y %H:%M:%S')

plot(data[["DateTime"]], data[["Global_active_power"]], type="l", xlab="", ylab="Global Active Power (kilowatts)")

##Save plot as plot.png
dev.copy(png, file = "plot2.png", width = 480, height = 480);
dev.off();
