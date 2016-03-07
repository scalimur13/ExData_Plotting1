#url for download file
fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#route for work
if(!file.exists("./data")){dir.create("./data")}

#check zip file for download if doesn't exists
if(!file.exists("./data/exdata_data_household_power_consumption.zip")){
    download.file(url = fileurl, destfile = "./data/exdata_data_household_power_consumption.zip")
    #unzip file
    unzip("./data/exdata_data_household_power_consumption.zip", exdir = "./data")    
}

#load data from local disk
library(data.table)
data<-fread("./data/household_power_consumption.txt", header=TRUE, sep=";", colClasses = rep("character",9),na="?")

#format date column
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

#filter data by date for work with filter data
data <- data[data$Date >= as.Date("2007-02-01") & data$Date <= as.Date("2007-02-02"),]

#generate date with time in one column
data$DatewithTime <- as.POSIXct(strptime(paste(data$Date, data$Time, sep = " "),
                                         format = "%Y-%m-%d %H:%M:%S"))

#format numeric data 
data$Global_active_power<-as.numeric(data$Global_active_power)
#reset graphs by row
par(mfrow=c(1,1))
#generate graph
with( data,
      plot(DatewithTime,
           Global_active_power,
           type="l",
           xlab = "",
           ylab="Global Active Power (kilowatts)"))

#save plot in png
dev.copy(png, file="./data/plot2.png",width = 480, height = 480, units = "px")
dev.off()