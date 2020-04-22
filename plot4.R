#Activating packages
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

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

# Making a specific database for a plot of sub metering
plot_base <- database %>% 
  gather(Energy_sub_metering,Watt_hour,contains("Sub_metering"))

#Making all of the sub plots
subplot1 <- ggplot(data=database,aes(y=Global_active_power,x=datetime))+
  geom_path(color="black")+
  scale_y_continuous(name="Global Active Power (kilowatts)")+
  scale_x_datetime(name=NULL,
                   breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                   labels=c("Thu","Fri","Sat"))

subplot2 <- ggplot(data=database,aes(y=Voltage,x=datetime))+
  geom_path(color="black")+
  scale_y_continuous(name="Voltage")+
  scale_x_datetime(name=NULL,
                   breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                   labels=c("Thu","Fri","Sat"))

subplot3 <- ggplot(data=plot_base,aes(y=Watt_hour,x=datetime))+
  geom_path(aes(color=Energy_sub_metering))+
  scale_y_continuous(name="Energy sub metering")+
  scale_x_datetime(name=NULL,
                   breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                   labels=c("Tue","Fri","Sat"))+
  theme(legend.position = c(0.95,0.95),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.title = element_blank())

subplot3

subplot4 <- ggplot(data=database,aes(y=Global_reactive_power,x=datetime))+
  geom_path(color="black")+
  scale_y_continuous(name="Global Reactive Power")+
  scale_x_datetime(name=NULL,
                   breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                   labels=c("Thu","Fri","Sat"))

#Making a complete panle of 4 plots
plot4 <- grid.arrange(subplot1,subplot2,subplot3,subplot4,nrow=2)

# Saving plot 4 through png device
ggsave(paste0(path,"/plot4.png"),plot4,dpi=250)
