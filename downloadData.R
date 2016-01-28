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
