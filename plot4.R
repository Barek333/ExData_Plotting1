###Reading only the part of the dataframe I need 
###but assuming that you have a full txt original file in your working directory!!!

library(data.table)
library(sqldf)
Sys.setlocale("LC_TIME", "English")
#DF4 <- read.csv.sql("household_power_consumption.txt", sql = "select * from file where Date = '1/2/2007' OR '2/2/2007'",sep=";" )


#Very elegant way of doing it, also using fread can be good
rawfile <- file("household_power_consumption.txt", "r")
cat(grep("(^Date)|(^[1|2]/2/2007)",readLines(rawfile), value=TRUE), sep="\n", file="filtered.txt")
close(rawfile)

#reading in the filtered dataset, adding a datatime variable to it
data <-read.table("filtered.txt",sep=";",header=TRUE,stringsAsFactors=F)
data$datetime <- as.POSIXct( strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S"))

#creating a picture with four plots going columnwise
png("plot4.png", width=480, height=480)
par(mfcol=c(2,2))
plot(data$datetime,data$Global_active_power,xlab="",ylab="Global Active Power (kilowatts)",type="l")
plot(data$datetime,data$Sub_metering_1,xlab="",ylab="Energy sub metering",type="l")
lines(data$datetime,data$Sub_metering_2,col="red")
lines(data$datetime,data$Sub_metering_3,col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1)
plot(data$datetime,data$Voltage,xlab="datetime",ylab="Voltage",type="l")
plot(data$datetime,data$Global_reactive_power,xlab="datetime",ylab="Voltage",type="l")
dev.off()