## download and unzip the data
filename <- "Course projects data.zip"
if (!file.exists(filename)){
  file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(file_url, filename)
}
unzip(filename)

## read the data
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## merge the training and the test sets to create one data set
test <- cbind(y_test, subject_test, x_test)
train <- cbind(y_train, subject_train, x_train)
mergedData <- rbind(test, train)

## extract only the measurements on the mean and standard deviation for each measurement
colNames <- colnames(mergedData)
mean_std <- (grepl("code" , colNames) | grepl("subject" , colNames) |
               grepl("mean.." , colNames) | grepl("std.." , colNames))
subsetData <- mergedData[, mean_std == TRUE]

## use descriptive activity names to name the activities in the data set
subsetData$code <- activities[subsetData$code, 2]

## appropriately label the data set with descriptive variable names
names(subsetData)[1] = "activity"
names(subsetData)<-gsub("Acc", "Accelerometer", names(subsetData))
names(subsetData)<-gsub("Gyro", "Gyroscope", names(subsetData))
names(subsetData)<-gsub("BodyBody", "Body", names(subsetData))
names(subsetData)<-gsub("Mag", "Magnitude", names(subsetData))
names(subsetData)<-gsub("^t", "Time", names(subsetData))
names(subsetData)<-gsub("^f", "Frequency", names(subsetData))
names(subsetData)<-gsub("tBody", "TimeBody", names(subsetData))
names(subsetData)<-gsub("-mean()", "Mean", names(subsetData), ignore.case = TRUE)
names(subsetData)<-gsub("-std()", "STD", names(subsetData), ignore.case = TRUE)
names(subsetData)<-gsub("-freq()", "Frequency", names(subsetData), ignore.case = TRUE)
names(subsetData)<-gsub("angle", "Angle", names(subsetData))
names(subsetData)<-gsub("gravity", "Gravity", names(subsetData))

## create a second,independent tidy data set and output it
tidyData <- aggregate(.~subject + activity, subsetData, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]
write.table(tidyData, file = "tidydata.txt", row.name = FALSE)