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


#prepare png for save
png(file="./data/plot4.png",width = 480, height = 480, units = "px")

#put two graphs by row
par(mfrow = c(2, 2))

## put graph in plot
with(data,
     plot(DatewithTime,
          Global_active_power,
          type = "l",
          xlab = "",
          ylab = "Global Active Power"))

## put graph two in plot
with(data,
     plot(DatewithTime,
          Voltage,
          type = "l",
          xlab = "datetime",
          ylab = "Voltage"))

## put graph three in plot
with(data,
     plot(DatewithTime,
          Sub_metering_1,
          type = "l",
          xlab = "",
          ylab = "Energy sub metering"))
with(data,
     points(DatewithTime,
            type = "l",
            Sub_metering_2,
            col = "red")
)
with(data,
     points(DatewithTime,
            type = "l",
            Sub_metering_3,
            col = "blue")
)
#legends for graph three
legend("topright", col = c("black", "blue", "red"),
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty = 1)

## add last graph 
with(data,
     plot(DatewithTime,
          Global_reactive_power,
          type = "l",
          xlab = "datetime",
          ylab = "Global_reactive_power"))

dev.off()