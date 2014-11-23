# Step0. Prepare + download files and libraries

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafile <- "getdata-projectfiles-UCI.zip"
datadir  <- "./UCI HAR Dataset"

##
# check required library-packages. install when not found.
##
if (!require("data.table")) 
{
  install.packages("data.table")
  require("data.table")
}

library(data.table)

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


##
# Step1. Merges the training and the test sets to create one data set.
##
setwd("C:/tmp/Week3")

tmp1 <- read.table("./UCI HAR Dataset/train/X_train.txt")
tmp2 <- read.table("./UCI HAR Dataset/test/X_test.txt")
X <- rbind(tmp1, tmp2)

tmp1 <- read.table("./UCI HAR Dataset/train/y_train.txt")
tmp2 <- read.table("./UCI HAR Dataset/test/y_test.txt") 
Y <- rbind(tmp1, tmp2)

tmp1 <- read.table("./UCI HAR Dataset/train/subject_train.txt")
tmp2 <- read.table("./UCI HAR Dataset/test/subject_test.txt")
S <- rbind(tmp1, tmp2)

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

##
# Step2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##
columns_to_keep <- grep("mean\\(\\)|std\\(\\)", features[, 2])
X <- X[, columns_to_keep]

names(X) <- gsub("\\(\\)", "", features[columns_to_keep, 2]) # remove "()"
names(X) <- gsub("mean", "Mean", names(X)) 
names(X) <- gsub("std", "Std", names(X)) 
names(X) <- gsub("-", "", names(X)) # remove "-"   

##
# Step3. Uses descriptive activity names to name the activities in the data set
##
activities[, 2] <- tolower(gsub("_", "", activities[, 2]))
substr(activities[2, 2], 8, 8) <- toupper(substr(activities[2, 2], 8, 8))
substr(activities[3, 2], 8, 8) <- toupper(substr(activities[3, 2], 8, 8))
activityLabel <- activities[Y[, 1], 2]
Y[, 1] <- activityLabel
names(Y) <- "activity"

##
# Step4. Appropriately labels the data set with descriptive activity  names. 
##
names(S) <- "subject"
cleaned <- cbind(S, Y, X)

# write out the dataset1
write.table(cleaned, "merged_data.txt") 

##
# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
##

uniqueSubjects <- unique(S)[, 1]
subjectCount <- length(unique(S)[, 1])
activityCount <- length(activities[, 1])
columnCount <- dim(cleaned)[2]

result <- matrix(NA, nrow = subjectCount * activityCount, ncol = columnCount) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleaned)

#copy the values into the new array
row <- 1
for (subject in 1:subjectCount) 
{
  for (activity in 1:activityCount) 
  {
    result[row, 1] <- uniqueSubjects[subject]
    result[row, 2] <- activities[activity, 2]
    tmp <- cleaned[cleaned$subject == subject & cleaned$activity == activities[activity, 2], ]
    result[row, 3:columnCount] <- colMeans(tmp[, 3:columnCount])
    row <- row + 1
  }
}

# write dataset2
write.table(result, "tidyset.txt")

message("Done writing output...")
