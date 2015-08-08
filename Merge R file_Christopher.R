# R File for Cleaning the PSLE Data for 2013 and 2014
# Written by Christopher
# Last change: 2015-08-08

#########################################################
# Seeting up R and loading file
#########################################################

library(stringr) # Needed for splitting
library(plyr) # Needed for renaming
library(zoo) #Needed for the schools

# Working directory
setwd("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/")

# Import csv
PSLE2012_RANKING <- read.csv("PSLE2012_RANKING.csv", stringsAsFactors = FALSE, header = FALSE, sep = ";") # Import with no header
PSLE2013_IMPROVEMENT <- read.csv("PSLE2013_IMPROVEMENT.csv", stringsAsFactors = FALSE, header = FALSE) # Import with no header
PSLE2013_RANKING <- read.csv("PSLE2013_RANKING.csv", stringsAsFactors = FALSE, header = FALSE) # Import with no header
PSLE2014_IMPROVEMENT <- read.csv("PSLE2014_IMPROVEMENT.csv", stringsAsFactors = FALSE, header = FALSE) # Import with no header
PSLE2014_RANKING <- read.csv("PSLE2014_RANKING.csv", stringsAsFactors = FALSE, header = FALSE) # Import with no header
MASTER <- read.csv("MASTER.csv", stringsAsFactors = FALSE, header = FALSE) # Import with no header

summary(PSLE2012_RANKING$V4)
x <- summary(PSLE2012_RANKING$V4)
