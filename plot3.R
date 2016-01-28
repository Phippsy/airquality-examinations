library(ggplot2)
library(dplyr)
library(scales)
source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

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

