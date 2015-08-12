library(stringr)
library(plyr)
library(dplyr)
library(zoo)

###############################
# Merge School data to Master
###############################

# Open both
MASTER <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/MASTER.csv", stringsAsFactors = FALSE, header = TRUE, sep=";") # Import with no header
School <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/pesptz.org (books delivered)/Schooldata_final.csv", stringsAsFactors = FALSE, header = TRUE, sep=";") # Import with no header


########## Prepare school file
# Write class 7 into Schoolsubset
Schoolsubset <- subset(School, class=="VII")

# Remove duplicates, this is of course not optimal
duplicates <- duplicated(Schoolsubset$schoolname)
Schoolsubset = data.frame(Schoolsubset, duplicates)
Schoolsubset <- subset(Schoolsubset , duplicates==FALSE)

# Get rid of symbols in schoolname
schoolname2 <- Schoolsubset$schoolname
Schoolsubset = data.frame(Schoolsubset, schoolname2)
Schoolsubset$schoolname2 <- Schoolsubset$schoolname
Schoolsubset$schoolname2 <- str_replace_all(Schoolsubset$schoolname2, '-', '')
Schoolsubset$schoolname2 <- str_replace_all(Schoolsubset$schoolname2, " ", "")

# Make a letters capital
Schoolsubset <- mutate_each(Schoolsubset, funs(toupper))

######### Prepare MASTER file
# Take of symbols in schoolname of MASTER File
MASTER$schoolname2 <- str_replace_all(MASTER$schoolname, "[']", "")
MASTER$schoolname2 <- str_replace_all(MASTER$schoolname2, "PRIMARY", "")
MASTER$schoolname2 <- str_replace_all(MASTER$schoolname2, "SCHOOL", "")
MASTER$schoolname2 <- str_replace_all(MASTER$schoolname2, " ", "")
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Achtung, dadurch, dass hier keine Duplikate entfernt werden, ist noch ein Fehler drin. 
# Dadurch werden Schuldaten zu Schülern gemerged, die dort nicht hingehören.


####################### Merge school to master
MASTER <- join(MASTER, Schoolsubset, by = "schoolname2") 


###################### 
# MERGE Aggregated Data to MASTER

# Import csv
PSLE2012_RANKING <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/PSLE2012_RANKING.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";") # Import with no header
PSLE2013_IMPROVEMENT <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/PSLE2013_IMPROVEMENT.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";") # Import with no header
PSLE2013_RANKING <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/PSLE2013_RANKING.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";") # Import with no header
PSLE2014_IMPROVEMENT <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/PSLE2014_IMPROVEMENT.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";") # Import with no header
PSLE2014_RANKING <- read.csv("C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/necta.org (aggregated)/PSLE2014_RANKING.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";") # Import with no header

########## Clean data
PSLE2012_RANKING$CENTRE.CODE <- str_replace_all(PSLE2012_RANKING$CENTRE.CODE, "-", "")
PSLE2012_RANKING$CENTRE.CODE <- str_replace_all(PSLE2012_RANKING$CENTRE.CODE, "S", "")
PSLE2013_RANKING$CENTRE.CODE <- str_replace_all(PSLE2013_RANKING$CENTRE.CODE, "-", "")
PSLE2013_RANKING$CENTRE.CODE <- str_replace_all(PSLE2013_RANKING$CENTRE.CODE, "S", "")
PSLE2014_RANKING$CENTRE.CODE <- str_replace_all(PSLE2014_RANKING$CENTRE.CODE, "-", "")
PSLE2014_RANKING$CENTRE.CODE <- str_replace_all(PSLE2014_RANKING$CENTRE.CODE, "S", "")
PSLE2013_IMPROVEMENT$CENTRE.CODE <- str_replace_all(PSLE2013_IMPROVEMENT$CENTRE.CODE, "-", "")
PSLE2013_IMPROVEMENT$CENTRE.CODE <- str_replace_all(PSLE2013_IMPROVEMENT$CENTRE.CODE, "S", "")
PSLE2014_IMPROVEMENT$PS1201.046 <- str_replace_all(PSLE2014_IMPROVEMENT$PS1201.046, "-", "")
PSLE2014_IMPROVEMENT$PS1201.046 <- str_replace_all(PSLE2014_IMPROVEMENT$PS1201.046, "S", "")

# Add years
PSLE2012_RANKING$year <- 2012
PSLE2013_RANKING$year <- 2013  
PSLE2014_RANKING$year <- 2014  
PSLE2013_IMPROVEMENT$year <- 2013  
PSLE2014_IMPROVEMENT$year <- 2014  

PSLE2012_RANKING <- rename(PSLE2012_RANKING, schoolcode = CENTRE.CODE)
PSLE2013_RANKING <- rename(PSLE2013_RANKING, schoolcode = CENTRE.CODE)
PSLE2014_RANKING <- rename(PSLE2014_RANKING, schoolcode = CENTRE.CODE)
PSLE2013_IMPROVEMENT <- rename(PSLE2013_IMPROVEMENT, schoolcode = CENTRE.CODE)
PSLE2014_IMPROVEMENT <- rename(PSLE2014_IMPROVEMENT, schoolcode = PS1201.046)

###### Merging

MERGED <- join(MASTER, PSLE2013_RANKING, by= c("year", "schoolcode"))
MERGED <- join(MERGED, PSLE2014_RANKING, by= c("year", "schoolcode"))
MERGED <- join(MERGED, PSLE2013_IMPROVEMENT, by= c("year", "schoolcode"))
MERGED <- join(MERGED, PSLE2014_IMPROVEMENT, by= c("year", "schoolcode"))
MERGED <- full_join(MERGED, PSLE2012_RANKING, by= c("year", "schoolcode"), match = "all")

write.table(MERGED, file = "C:/Users/Christopher/Google Drive/Data Animals/Jambo Bukoba/Data/Merge/allmerged.csv", sep=";", row.names=FALSE)

