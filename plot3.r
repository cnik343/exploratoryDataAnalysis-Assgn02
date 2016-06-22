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
# Question 3 : plot3.R -> plot3.png
#
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in emissions
# from 1999–2008 for Baltimore City? Which have seen increases in emissions from
# 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
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

# Make Plot3 on screen...
# Use the subset function to restrict data to Baltimore City, then use a
# combination of melt and ddply from the reshape2 and plyr packages to summarise
# total emissions as a function of both year and type. The plot was generated
# using the ggplot package.

sub.NEI <- subset(NEI, fips == "24510")
melt.sub.NEI <- melt(sub.NEI, id.vars=c("type", "year"), measure.vars="Emissions")
sum.data.NEI <- ddply(melt.sub.NEI, .(type, year), summarise, sum=sum(value))
g <- ggplot(sum.data.NEI, aes(x=factor(year), y=sum))
g   + geom_bar(stat="identity") +
      facet_wrap(~type) +
      xlab("Year") +
      ylab("Baltimore PM25 Emissions (tons)")

# Copy Plots3 to PNG file...

dev.copy(png, file="plot3.png")
dev.off()