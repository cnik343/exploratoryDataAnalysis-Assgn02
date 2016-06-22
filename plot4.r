# Exploratory Data Analysis - Assignment 02
# -----------------------------------------------------------------------------
# Assignment 
# The overall goal of this assignment is to explore the National Emissions
# Inventory database and see what it say about fine particulate matter pollution
# in the United states over the 10-year period 1999–2008. You may use any R
# package you want to support your analysis. You must address a number of
# questions and tasks in your exploratory analysis. For each question/task you
# will need to make a single plot. Unless specified, you can use any plotting
# system in R to make your plot.
#
# Question 4 : plot4.R -> plot4.png
#
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
# -----------------------------------------------------------------------------

# Setup the working environment...
# Remove everything from the workspace and set the working directory...
rm(list = ls())
setwd('W://code//R-Stats//Coursera//04 - ExploratoryDataAnalysis Assgn02')

# Define the data directory and files and download the data if necessary...
dataDir         <- "./data"
dataZip         <- paste(dataDir, "exdata%2Fdata%2FNEI_data.zip", sep="/")
dataNEI         <- paste(dataDir, "summarySCC_PM25.rds", sep="/")
dataSCC         <- paste(dataDir, "Source_Classification_Code.rds", sep="/")

# Download and Unzip the data if necessary...
if(!file.exists(dataNEI) || !file.exists(dataSCC)){
    if(!file.exists(dataZip)){
        url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url,destfile = dataZip)
    }
    unzip(dataZip, exdir=dataDir) 
}

# Load the data - The first line will likely take a few seconds. Be patient!
NEI <- readRDS(dataNEI)
SCC <- readRDS(dataSCC)

# Make Plot4 on screen...
# Use grep to find the Fuel Coal SCC codes and subset to restrict the NEI data
# based upon these codes. The tapply function was used to summarise total
# emissions as a function of year. The plot was generated using the barplot
# function from the # base plotting system.

sub.SCC <- SCC[grep("[Ff]uel(.*)[Cc]oal",SCC$EI.Sector),]
data.NEI <- subset(NEI, SCC %in% sub.SCC$SCC)

sum.data.NEI <- tapply(data.NEI$Emissions, data.NEI$year, sum)
barplot(sum.data.NEI, xlab = "Year", ylab = "Coal Combustion PM25 Emissions (tons)")

# Copy Plot4 to PNG file...

dev.copy(png, file="plot4.png")
dev.off()