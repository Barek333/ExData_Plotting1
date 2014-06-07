#Reading only the part of the dataframe I need
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

#creating a plot of energy sub metering over time and saving it as a png
png("plot3.png", width=480, height=480)
plot(data$datetime,data$Sub_metering_1,xlab="",ylab="Energy sub metering",type="l")
lines(data$datetime,data$Sub_metering_2,col="red")
lines(data$datetime,data$Sub_metering_3,col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1)
dev.off()