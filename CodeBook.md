This CodeBook contains all the variable names used in the run_analysis.R code. We will see all the five steps that bring us to the final tidy dataset and all the variables inside.

FIRST STEP: Merges the training and the test sets to create one data set
All the text files are downloaded and unzipped from UCI HAR Dataset file. Then also the activities [6 rows and 2 columns] and features [561 rows and 2 columns] text files are loaded
then training ("Training") and test ("Test") datasets were merged together into a unique file called "Data"[10299 rows and 563 columns].
In the test data there is also three text files: subject_test (with the volunteer test subjects observed), X_test (with feature recorded data) and y_test(with data on activities labels).
The same files are also contained in the training file: subject_train (with volunteer subject observed), X_train (with feature recorded data) and y_train (with data on activities labels).

SECOND STEP:Extracts only the measurements on the mean and standard deviation for each measurement
"Mean_sd" variable contains all the columns with the words "Mean" and "std" inside and "subset_data" variable [10299 rows and 88 columns] is the subset of the "Data" dataframe and contains all the rows of the merged dataset
and the only columns with mean and standard deviation variables. 

THIRD STEP:Uses descriptive activity names to name the activities in the data set
Entire numbers in code column of the "subset_data" are replaced with corresponding activity taken from second column of the activities variable, described before.

FOURTH STEP:Appropriately labels the data set with descriptive variable names
i replaced the subset_data names with this words by using the gsub command:
Acc" with "Accelerometer"
"Gyro" with "Gyroscope"
"BodyBody" with "Body"
"Mag" with "Magnitude"
"^t", "Time", 
"^f", "Frequency"
"tBody" with "TimeBody"
"-mean()" with "Mean"
"-std()" with "STD"
"-freq()" with "Frequency"
"angle" with "Angle"
"gravity" with "Gravity"

FIFTH STEP:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
"New_Tidy_Data" [180 rows and 88 columns] is the final dataset obtained by taking the means of each variable for each activity and subject. Then the file is saved in txt file.
