#Activating packages
library(dplyr)
library(ggplot2)

#Downloading data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
path <- getwd()
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

#Reading data into R, only for the two dates we need, and converting date and Time
database <- read.table(paste0(path,"/household_power_consumption.txt"),
                       header=F,sep=";",stringsAsFactors=F,
                       skip=(grep("1/2/2007|2/2/2007",readLines(paste0(path,"/household_power_consumption.txt")))),nrows=2880,
                       col.names=strsplit(readLines(paste0(path,"/household_power_consumption.txt"),n=1),";")[[1]]) %>% 
  mutate(datetime=as.POSIXct(paste(Date,Time,sep=" "),format="%d/%m/%Y %H:%M:%S"))

# Making plot 2 - a path of global active power by time
plot2 <- ggplot(data=database,aes(y=Global_active_power,x=datetime))+
  geom_path(color="black")+
  scale_y_continuous(name="Global Active Power (kilowatts)")+
  scale_x_datetime(name=NULL,
                     breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                     labels=c("Thu","Fri","Sat"))

# Saving plot 2 through png device
ggsave(paste0(path,"/plot2.png"),plot2,dpi=250)
