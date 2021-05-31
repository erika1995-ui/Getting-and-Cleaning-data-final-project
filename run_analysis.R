#1. Merges the training and the test sets to create one data set
# Call the needed libraries
library(dplyr)
library(data.table)

#dowload data throught the web site
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_zip<-"UCI HAR Dataset.zip"
download.file(fileUrl,file_zip)

#check the existing file
if(file.exists(file_zip)) unzip (file_zip)

#the file exist and it's downloaded. Now we'll read the name of the features and of the activities
Name_features<-read.table("UCI HAR Dataset/features.txt")
Name_activities<-read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)

#Now we'll read both training and test dataset and merge them together
Training<-read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
activity_train<-read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
features_train<-read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)

Test<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
activity_test<-read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
features_test<-read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)

#Combine function can be used to merge training and test data sets
subject<-rbind(Training,Test)
activity<-rbind(activity_train,activity_test)
features<-rbind(features_train,features_test)
#Rename the columns with the features name file txt
colnames(features)<-t(Name_features[2])
#Rename also the columns activity and subject with colnames and finally merge all the data
colnames(activity)<-"Activity"
colnames(subject)<-"Subject"

Data<-cbind(features,activity,subject)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
# grep function select each colomn which contains the words "Mean" or "Std", ignoring the letter case
Mean_sd<-grep(".*Mean.*|.*Std.*", names(Data), ignore.case=TRUE)
#columns with mean and std variables + activity and subject
Mean_sd_columns<-c(Mean_sd,562,563)
#subset data with mean and std variables
subset_data<-Data[,Mean_sd_columns]

#3.Uses descriptive activity names to name the activities in the data set
#we have to use activity txt file given to rename the activity numeric column in subset_Data df
subset_data$Activity<- as.character(subset_data$Activity)
for (i in 1:6){
  subset_data$Activity[subset_data$Activity==i]<- as.character(Name_activities[i,2])
}
#and now we creata factor activity variable 
subset_data$Activity<-as.factor(subset_data$Activity)

#4.Appropriately labels the data set with descriptive variable names. 
names(subset_data)
#we can label the columns with other words for example: f can stand for frequency, t for time, Acc for accelerometer, Gyro for Gyroscope
#BodyBody for Body and Mag with magnitude
names(subset_data)<-gsub("Acc", "Accelerometer", names(subset_data))
names(subset_data)<-gsub("Gyro", "Gyroscope", names(subset_data))
names(subset_data)<-gsub("BodyBody", "Body", names(subset_data))
names(subset_data)<-gsub("Mag", "Magnitude", names(subset_data))
names(subset_data)<-gsub("^t", "Time", names(subset_data))
names(subset_data)<-gsub("^f", "Frequency", names(subset_data))
names(subset_data)<-gsub("tBody", "TimeBody", names(subset_data))
names(subset_data)<-gsub("-mean()", "Mean", names(subset_data), ignore.case = TRUE)
names(subset_data)<-gsub("-std()", "STD", names(subset_data), ignore.case = TRUE)
names(subset_data)<-gsub("-freq()", "Frequency", names(subset_data), ignore.case = TRUE)
names(subset_data)<-gsub("angle", "Angle", names(subset_data))
names(subset_data)<-gsub("gravity", "Gravity", names(subset_data))

names(subset_data)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#we can set subject variable as a factor variable 
new_tidy_Data <- subset_data %>%
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))
write.table(new_tidy_Data, "New_Tidy_Data.txt", row.name=FALSE)
