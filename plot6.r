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
# Question 6 : plot6.R -> plot6png
#
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
# -----------------------------------------------------------------------------

# Setup the working environment...
library(plyr)
library(ggplot2)
library(reshape2)

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

# Make Plot6 on screen...
# Use the subset function to restrict data to Baltimore City and Los Angeles
# County, then use grep to find the Vehicle SCC codes and subset a second time
# to restrict the data to these codes. A combination of melt and ddply was used
# to summarise total emissions by both year and location. The gsub function was
# used to add an additonal column with the name of the location, to allow simple
# plot labels. The plot was generated using the ggplot package.

sub.NEI <- subset(NEI, fips == "24510" | fips == "06037")
sub.SCC <- SCC[grep("[Vv]ehicle",SCC$EI.Sector),]
data.NEI <- subset(sub.NEI, SCC %in% sub.SCC$SCC)

melt.data.NEI <- melt(data.NEI, id.vars=c("fips", "year"), measure.vars="Emissions")
sum.data.NEI <- ddply(melt.data.NEI, .(fips, year), summarise, sum=sum(value))
sum.data.NEI$area <- sum.data.NEI$fips
sum.data.NEI$area <- gsub("24510", "Baltimore City", sum.data.NEI$area)
sum.data.NEI$area <- gsub("06037", "Los Angeles County", sum.data.NEI$area)

g <- ggplot(sum.data.NEI, aes(x=factor(year), y=sum))
g   + geom_bar(stat="identity") +
      facet_wrap(~area) +
      xlab("Year") + ylab("Vehicle PM25 Emissions (tons)")
      
# Copy Plot6 to PNG file...
dev.copy(png, file="plot6.png")
dev.off()