library(ggplot2)
library(dplyr)
library(scales)

  setwd("/Users/donalp/Dropbox/3-Work/Training/Software stuff/Coding/R/DataScience/Coursera/Exploratory data analysis/airquality-examinations")

  if (!file.exists("./data")) {
    dir.create("./data")
  }
  
  if (!file.exists("./data/exdata-data-NEI_data.zip")) {
    download.file(
      url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
      method="curl",
      destfile="./data/exdata-data-NEI_data.zip")
    unzip("./data/exdata-data-NEI_data.zip", exdir="./data")
  }

# Reading in data
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

# plot1.R: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total 
# PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
plot1data<-NEI %>% group_by(year) %>% summarise ( year_total = sum(Emissions))
png(filename = "plot1.png",
    width = 480, height = 480)
print(
  with( plot1data, barplot(year_total, year,
                       pch=19, 
                       main="Annual US PM2.5 Emissions: 1999-2008", 
                       ylab="Total emissions (tonnes)", 
                       xlab="Year",
                       names.arg=c(plot1data$year)
                       ) )
)
dev.off()

# plot2.R
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 
# to 2008? Use the base plotting system to make a plot answering this question.
plot2data<-NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarise(year_total = sum(Emissions))

png(filename = "plot2.png",
    width = 480, height = 480)
print(
with( plot2data, barplot(year_total, year,
                      pch=19, 
                      main="Annual US PM2.5 Emissions in Baltimore: 1999-2008", 
                      ylab="Total emissions (tonnes)", 
                      xlab="Year",
                      names.arg=c(plot2data$year)) )
)
dev.off()

# plot3.R
# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
plot3data<-NEI %>% filter(fips == "24510") %>% group_by(year, type) %>% summarise(year_total = sum(Emissions))
plot3data$year<-as.factor(plot3data$year)

png(filename = "plot3.png", width = 480, height = 480)
print(
  ggplot(plot3data, aes(x=year, y=year_total, fill=type)) + 
    geom_bar(stat="identity") + ggtitle("Annual US PM2.5 Emissions in Baltimore, by type: 1999-2008") +
    ylab("Total emissions (tonnes)") + xlab("Year") + facet_grid( . ~ type ) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    scale_y_continuous(labels = comma) 
  )
dev.off()


# plot4.R
combustionCodes<- ( SCC %>% filter(grepl("Coal", Short.Name, ignore.case = TRUE))
                  %>% filter(grepl("comb", Short.Name, ignore.case=TRUE)))$SCC

plot4data<-NEI %>% filter(SCC %in% combustionCodes) %>% 
  group_by(year) %>% summarise (year_total = sum(Emissions) )
plot4data$year<-as.factor(plot4data$year)

png(filename = "plot4.png", width = 480, height = 480)
print(
  ggplot(plot4data, aes(x=year, y=year_total) ) + geom_bar(stat="identity") +
    xlab("Year") + ylab("Total emissions (tonnes)") + 
    ggtitle("U.S. PM2.5 emissions from coal combustion-related sources, 1999-2008") +
    scale_y_continuous(labels = comma) 
)
dev.off()

# plot5.R
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City ?
carCodes<- unique(( SCC %>% filter( grepl("Vehicle", EI.Sector, ignore.case = TRUE) ) )$SCC)

plot5data<-NEI %>% filter(SCC %in% carCodes) %>% filter(fips == "24510") %>%
  group_by(year) %>% summarise( year_total = sum(Emissions) )
plot5data$year<-as.factor(plot5data$year)

png(filename = "plot5.png", width = 480, height = 480)
print(
  ggplot( plot5data, aes(x=year, y=year_total) ) + geom_bar(stat="identity") +
    xlab("Year") + ylab("Total emissions (tonnes)") + 
    ggtitle("PM2.5 emissions from motor vehicle sources in Baltimore City, 1999-2008") +
    scale_y_continuous(labels = comma) 
)
dev.off()

# plot6.R
  # Compare emissions from motor vehicle sources in Baltimore City with emissions 
  # from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which 
  # city has seen greater changes over time in motor vehicle emissions?
# --> consider tracking the percentage change over time by city

plot6data<-NEI %>% filter(SCC %in% carCodes) %>% filter(fips == "24510" | fips == "06037")
plot6data$city<-ifelse(plot6data$fips == "24510", "Baltimore City", "L.A. County")
plot6data<- plot6data %>%
  group_by(city, year) %>% summarise (year_total = sum(Emissions) )
plot6data$year<-as.factor(plot6data$year)

png(filename = "plot6.png", width = 480, height = 480)
  print(
  ggplot(plot6data, aes(x=year, y=year_total, fill=city) ) + geom_bar(stat="identity", position="dodge") + 
    xlab("Year") + ylab("Total emissions (tonnes)") + 
    ggtitle("PM2.5 emissions from motor vehicle sources: \nBaltimore City vs L.A. County, 1999-2008") +
    scale_y_continuous(labels = comma) 
)
dev.off()

