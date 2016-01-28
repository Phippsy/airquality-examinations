source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

# plot1.R: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
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