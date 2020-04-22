#Activating packages
library(dplyr)
library(ggplot2)
library(tidyr)

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

# Making a specific database for a plot
plot_base <- database %>% 
  gather(Energy_sub_metering,Watt_hour,contains("Sub_metering"))


# Making plot 3 - a path plot of energey sub metering by time
plot3 <- ggplot(data=plot_base,aes(y=Watt_hour,x=datetime))+
  geom_path(aes(color=Energy_sub_metering))+
  scale_y_continuous(name="Energy sub metering")+
  scale_x_datetime(name=NULL,
                   breaks=as.POSIXct(c("2007-02-01 00:01:00 MSK","2007-02-02 00:01:00 MSK","2007-02-03 00:03:00 MSK")),
                   labels=c("Tue","Fri","Sat"))+
  theme(legend.position = c(0.95,0.95),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.title = element_blank())

# Saving plot 3 through png device
ggsave(paste0(path,"/plot3.png"),plot3,dpi=250)
