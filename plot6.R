library(ggplot2)
library(dplyr)
library(scales)
source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

# plot6.R
  # Compare emissions from motor vehicle sources in Baltimore City with emissions 
  # from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which 
  # city has seen greater changes over time in motor vehicle emissions?

# Filter by fips codes and vehicle categories
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

