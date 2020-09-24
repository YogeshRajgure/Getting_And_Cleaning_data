library(dplyr)

features <- read.table("./UCI_HAR_Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI_HAR_Dataset/activity_labels.txt", col.names = c("output", "activity"))
# contains labels of output

subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt", col.names = "output")

subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt", col.names = "output")


# Merging all the data into one
X_all <- rbind(x_train, x_test)
Y_all <- rbind(y_train, y_test)
Subject_all <- rbind(subject_train, subject_test)
#here all three tables are merged for their rows, subject=subject_of_data, x=data, y=result_of_data 
merged <- cbind(Subject_all,  Y_all, X_all)


# Only extract the mean and std. deviation measurents
tidy_data_for_x <- merged %>% select(contains("mean") | contains("std"))
tidy_data <- cbind(Subject_all, Y_all, tidy_data_for_x)   #merged %>% select(c(Subject_all, Y_all))


# provide actual names to the output column using activities table
tidy_data[2] <- activities[tidy_data$output, 2]
names(tidy_data)[2] <- paste("activity")

# describe all the short forms of variables in table

names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))


# store tidydata in independent data set

Final_tidy_data <- tidy_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

#make a new file to store this data

write.table(Final_tidy_data, "Final_Tidy_Data.txt", row.name = FALSE)


head(Final_tidy_data)