library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "dataset.zip",method = "curl")
unzip("dataset.zip")

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
masterdata <- cbind(subject, y, x)

td <- masterdata
select(td,subject, code, contains("mean"), contains("std"))
td$code <- activities[td$code, 2]
names(td)[2] = "activity"
names(td)<-gsub("Acc", "Accelerometer", names(td))
names(td)<-gsub("Gyro", "Gyroscope", names(td))
names(td)<-gsub("BodyBody", "Body", names(td))
names(td)<-gsub("Mag", "Magnitude", names(td))
names(td)<-gsub("^t", "Time", names(td))
names(td)<-gsub("^f", "Frequency", names(td))
names(td)<-gsub("tBody", "TimeBody", names(td))
names(td)<-gsub("-mean()", "Mean", names(td), ignore.case = TRUE)
names(td)<-gsub("-std()", "STD", names(td), ignore.case = TRUE)
names(td)<-gsub("-freq()", "Frequency", names(td), ignore.case = TRUE)
names(td)<-gsub("angle", "Angle", names(td))
names(td)<-gsub("gravity", "Gravity", names(td))

ind_data <- td %>%
group_by(subject, activity) %>%
summarise_all(funs(mean))

write.table(ind_data, "independent_tidy_data.txt", row.name=FALSE)



