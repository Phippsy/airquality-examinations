source('downloadData.R')

# Reading in data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
options(scipen=5) # bias against scientific notation

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