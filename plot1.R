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

# Making plot 1 - a histogram of Global active power
plot1 <- ggplot(data=database,aes(x=Global_active_power))+
  geom_histogram(fill="red",color="black")+
  scale_x_continuous(name="Global Active Power (kilowatts)")+
  scale_y_continuous(name="Frequency",limits=c(0,1200))

# Saving plot 1 through png device
ggsave(paste0(path,"/plot1.png"),plot1,dpi=250)
