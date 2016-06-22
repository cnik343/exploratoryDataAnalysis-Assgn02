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
# Question 1 : plot1.R -> plot1.png
#
# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.
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

# Make Plot1 on screen...
# Use tapply to summarise total emissions as a function of year and then use the
# barplot function from the base plotting system to generate required output.

sum.data.NEI  <- tapply(NEI$Emissions, NEI$year, sum)
barplot(sum.data.NEI, xlab = "Year", ylab = "Total PM25 Emissions (tons)")

# Copy Plot1 to PNG file...

dev.copy(png, file="plot1.png")
dev.off()
