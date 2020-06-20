library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt", 
                      col.names = c("features","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", 
                      col.names = c("id", "activity"))
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", 
                      col.names = features$functions)
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", 
                      col.names = "id")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                      col.names = "subject")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                      col.names = "subject")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$functions)
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", 
                      col.names = "id")

#Merging the train and test into one data set
xdata <- rbind(xTrain, xTest)
ydata <- rbind(yTrain, yTest)
Subjectdata <- rbind(subjectTrain, subjectTest)
Merged <- cbind(xdata, ydata, Subjectdata)


#Extracting the mean and std for each meassurment
Merged <- select(Merged, id, subject, contains("mean"), contains("std"))


#Descriptive activity names for each activity
Merged$id <- activities[Merged$id, "activity"]

Merged <- rename(Merged, Activity = id, Subject = subject)

#Renaming each variable name in the data set
names(Merged)<-gsub("Acc", "Accelerometer", names(Merged))
names(Merged)<-gsub("Gyro", "Gyroscope", names(Merged))
names(Merged)<-gsub("BodyBody", "Body", names(Merged))
names(Merged)<-gsub("Mag", "Magnitude", names(Merged))
names(Merged)<-gsub("^t", "Time", names(Merged))
names(Merged)<-gsub("^f", "Frequency", names(Merged))
names(Merged)<-gsub("tBody", "TimeBody", names(Merged))
names(Merged)<-gsub("-mean()", "Mean", names(Merged), ignore.case = TRUE)
names(Merged)<-gsub("-std()", "STD", names(Merged), ignore.case = TRUE)
names(Merged)<-gsub("-freq()", "Frequency", names(Merged), 
                      ignore.case = TRUE)
names(Merged)<-gsub("angle", "Angle", names(Merged))
names(Merged)<-gsub("gravity", "Gravity", names(Merged))



#Grouping
Tidy <- group_by(Merged, Subject, Activity)

#Grouping by the mean
Exitdata <- summarise_all(Tidy, funs(mean))

#Exiting the data
write.table(Exitdata, "Finaldata.txt", row.names = FALSE)
