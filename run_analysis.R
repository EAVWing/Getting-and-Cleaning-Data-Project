library(reshape2)

## Get the data set and unzip it into working directory
filename <- "getdata.zip"
if(!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename)
}
if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
}

## Load the activity lables and features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Make a vector of the feature names we want
featurenamesfull <- as.character(features[,2])
featurenamesmeanstd <- grep(".*mean.*|.*std.*",featurenamesfull)

## Load the dataset for the data we want
trainfull <- read.table("UCI HAR Dataset/train/X_train.txt")
traindata <- trainfull[featurenamesmeanstd]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
traindata <- cbind(trainSubjects, trainActivities, traindata)
rm(trainfull)
testfull <- read.table("UCI HAR Dataset/test/X_test.txt")
testdata <- testfull[featurenamesmeanstd]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testdata <- cbind(testSubjects, testActivities, testdata)
rm(testfull)

## Clean up the feature names
featurenames <- features[featurenamesmeanstd,2]
featurenames = gsub("-mean", "Mean", featurenames)
featurenames = gsub("-std", "Std", featurenames)
featurenames <- gsub("[-()]", "", featurenames)

## Merge train and test
fulldata <- rbind(traindata, testdata)

## Add the column names
colnames(fulldata) <- c("Subject", "Activity", featurenames)

## Make subjects and activities factors and change the activity labels
fulldata$Activity <- factor(fulldata$Activity, levels = activitylabels[,1], labels = activitylabels[,2])
fulldata$Subject <- as.factor(fulldata$Subject)

## Melt the data and find the means
fulldatamelt <- melt(fulldata, id = c("Subject", "Activity"))
fulldatamean <- dcast(fulldatamelt, Subject + Activity ~ variable, mean)

## finally write the table to the working directory
write.table(fulldatamean, "tidy.txt", row.names = FALSE, quote = FALSE)
