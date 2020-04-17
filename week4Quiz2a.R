# Download data collected from the accelerometers from the Samsung Galaxy S smartphone using course link.
if(!file.exists("./data")){dir.create("./data")}
quiz4url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(quiz4url, destfile = "./data/activityData.zip", method = "curl")
unzip("activityData.zip")
        # make sure data is in the working directory.

#1.  Merges the training and the test sets to create one data set.
featureList <- read.table(file = "./UCI HAR Dataset/features.txt")
activityList <- read.table(file = "./UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))
x_test <- read.table(file = "./UCI HAR Dataset/test/x_test.txt", col.names = featureList$V2)
y_test <- read.table(file = "./UCI HAR Dataset/test/y_test.txt", col.names = "activityID")
subject_test <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
testData <- cbind(subject_test, y_test, x_test)
        
x_train <- read.table(file = "./UCI HAR Dataset/train/x_train.txt", col.names = featureList$V2)
y_train <- read.table(file = "./UCI HAR Dataset/train/y_train.txt", col.names = "activityID")
subject_train <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
trainData <- cbind(subject_train, y_train, x_train)

TestTrainData <- rbind(testData, trainData)
TestTrainData <- merge(TestTrainData, activityList, by = "activityID")

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
MeanSTDlogic <- grepl("activityID|subject|mean|std", names(TestTrainData))
MeanSTD <- TestTrainData[, MeanSTDlogic]

#3. Uses descriptive activity names to name the activities in the data set.
MeanSTD$activityID <- factor(MeanSTD$activityID, labels = activityList$activity) 

#4. Appropriately labels the data set with descriptive variable names.
        # Done in #1 and #3

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyLogic <- grepl("mean|std", names(MeanSTD))
tidyData <- aggregate.data.frame(MeanSTD[, tidyLogic], by = list(activity = MeanSTD$activityID, subject = MeanSTD$subject), FUN = mean)


