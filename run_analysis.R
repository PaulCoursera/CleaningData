#setwd("/tmp/Tidy-005")

## check required packages. install when not found.
if (!require("data.table")) 
{
  install.packages("data.table")
  require("data.table")
}

if (!require("reshape2")) 
{
  install.packages("reshape2")
  require("reshape2")
}

library(data.table)
library(reshape2)


## declarations
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafile <- "getdata-projectfiles-UCI.zip"
datadir  <- "./UCI HAR Dataset"
testdir  <- paste(datadir, "test", sep = "/")
traindir <- paste(datadir, "train", sep = "/")

###
# download and unzip the data in the dir called UCI_HAR_Dataset
###

## download file if not found
if (!file.exists(datafile))
{
  message("Downloading data...")
  download.file(fileUrl, datafile)
  message("Finished downloading data...")
}

if (!file.exists(datadir))
{
  message("Unzipping data...")
  unzip(datafile)
  message("Finhed unzipping data...")
}

# read train files
dtSubjectTrain <- fread('./UCI HAR Dataset/train/subject_train.txt')
dtSubjectTest <- fread('./UCI HAR Dataset/test/subject_test.txt')

# read activity files
dtActivityTrain <- fread('./UCI HAR Dataset/train/y_train.txt')
dtActivityTest <- fread('./UCI HAR Dataset/test/y_test.txt')

# read data files
dtTrain <- data.table(read.table('./UCI HAR Dataset/train/X_train.txt'))
dtTest <- data.table(read.table('./UCI HAR Dataset/test/X_test.txt'))

###
# 1. merge data tables
###
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activityNum")
dt <- rbind(dtTrain, dtTest)

# merge columns
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

# create key on the datatable
setkey(dt, subject, activityNum)

###
# 2. Extract only the mean and standard deviation
###
dtFeatures <- fread('./UCI HAR Dataset/features.txt')
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]

select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[, select, with = FALSE]

###
# 3. Use descriptive activity names
###
dtActivityNames <- fread('./UCI HAR Dataset/activity_labels.txt')
setnames(dtActivityNames, 
         names(dtActivityNames), 
         c("activityNum", "activityName"))

###
# 4. Label with descriptive activity names
###
dt <- merge(dt, 
            dtActivityNames, 
            by = "activityNum", 
            all.x = TRUE)
setkey(dt, subject, activityNum, activityName)
dt <- data.table(melt(dt, 
                      key(dt), 
                      variable.name = "featureCode"))
dt <- merge(dt, 
            dtFeatures[, list(featureNum, featureCode, featureName)], 
            by = "featureCode", 
            all.x = TRUE)

dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)

#helper for regular expression
grepthis <- function(regex) {grepl(regex, dt$feature)}

n <- 2
y <- matrix(seq(1, n), 
            nrow = n)
x <- matrix(c(grepthis("^t"), 
              grepthis("^f")), 
            ncol = nrow(y))
dt$featDomain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
dt$featInstrument <- factor(x %*% y, 
                            labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), 
              grepthis("GravityAcc")), 
            ncol = nrow(y))
dt$featAcceleration <- factor(x %*% y, 
                              labels = c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), 
              grepthis("std()")), 
            ncol = nrow(y))
dt$featVariable <- factor(x %*% y, 
                          labels = c("Mean", "SD"))

dt$featJerk <- factor(grepthis("Jerk"), 
                      labels = c(NA, "Jerk"))
dt$featMagnitude <- factor(grepthis("Mag"), 
                           labels = c(NA, "Magnitude"))

n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("-X"), 
              grepthis("-Y"), 
              grepthis("-Z")), 
            ncol = nrow(y))
dt$featAxis <- factor(x %*% y, 
                      labels = c(NA, "X", "Y", "Z"))

r1 <- nrow(dt[, .N, by = c("feature")])
r2 <- nrow(dt[, .N, by = c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2

###
# 5. Create a tidy data set
###
message("Create a tidy data set...")
setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

file <- 'tidy_data.txt'
write.table(dtTidy, file, quote = F, sep= "\t", row.names = F)

message("ready...")

