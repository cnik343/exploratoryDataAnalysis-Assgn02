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
# Question 5 : plot5.R -> plot5.png
#
# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
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

# Make Plot5 on screen...
# Use the subset function to restrict data to Baltimore City, then use grep to
# find the Vehicle SCC codes and subset a second time to restrict the data based
# upon these codes. The tapply function was used to summarise total emissions as
# a function of year. The plot was generated using the barplot function from the
# base plotting system.

sub.NEI <- subset(NEI, fips == "24510")
sub.SCC <- SCC[grep("[Vv]ehicle",SCC$EI.Sector),]
data.NEI <- subset(sub.NEI, SCC %in% sub.SCC$SCC)

sum.data.NEI <- tapply(data.NEI$Emissions, data.NEI$year, sum)
barplot(sum.data.NEI, xlab = "Year", ylab = "Baltimore Vehicle PM25 Emissions (tons)")

# Copy Plot5 to PNG file...

dev.copy(png, file="plot5.png")
dev.off()