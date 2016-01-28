library(ggplot2)
library(dplyr)
library(scales)
source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

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
