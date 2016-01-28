library(ggplot2)
library(dplyr)
library(scales)
source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

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