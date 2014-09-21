# Codebook

Author: [Chia Hock Lai](https://github.com/hlchia)

## Introduction
This file describes the data, variables and approach that has been taken to clean up the data.

## Dataset Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

Each record includes:

    1. Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    2. Triaxial Angular velocity from the gyroscope.
    3. A 561-feature vector with time and frequency domain variables.
    4. Its activity label.
    5. An identifier of the subject who carried out the experiment.


Descriptions of files included in the dataset:


    1. 'features_info.txt': Shows information about the variables used on the feature vector.
    2. 'features.txt': List of all features.
    3. 'activity_labels.txt': Links the activity ids with their activity name.
    4. 'train/X_train.txt': Training set.
    5. 'train/y_train.txt': Training labels.
    6. 'test/X_test.txt': Test set.
    7. 'test/y_test.txt': Test labels.
    8. 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
    9. 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
    10. 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.
    11. 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.


## Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

## Transformations

### Load the datasets of training, test, activty labels and features

Download and unzip the data based on the url provided by the instructor.

Use `read.table` to load the data.
```
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt") 
x_test <- read.table("test/x_test.txt") 
```


### Extracts only the measurements on the mean and standard deviation for each measurement. 

As we are only interested in the variables on mean and standard deviation, we will setup a logical vector
using the regular expression function `grepl` for columns containing words "-std" OR "-mean"

`target_cols <- grepl("-std()|-mean()", features[,2]) `

### Uses descriptive activity names to name the activities in the data set

The descriptive activity names are loaded into `activity_labels` dataset, we add a new column the test data and update it with the corresponding descriptive name in `activity_labels`.
```
y_test$V2 <- activity_labels[y_test$V1, 2] 
```

### Appropriately labels the data set with descriptive variable names. 

Next we tidy up the test data with descriptive variable names
```
names(subject_test) = "Subject"
names(y_test) = c("Activity_Id", "Activity")
names(x_test) = features[,2]
```

### Extracts only the measurements on the mean and standard deviation for each measurement. 

We include only the variables we want using the logical vector `target_cols` we setup earlier
```
x_test <- x_test[,target_cols]
```

Finally we merge the test datasets using `cbind' function
```
merged_x_test <- cbind(subject_test, y_test, x_test)
```

### Repeat the process for the training datasets

We repeat the same process for the training datasets to get a merged training dataset
```
merged_x_train <- cbind(subject_train, y_train, x_train)
```


### Merges the training and the test sets to create one data set.

As now both the training and test datasets have the same columns, we combine them into a single dataset using the `rbind` function.
```
merged_x <- rbind(merged_x_test, merged_x_train)
```


### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

We use the `aggregate` function and apply `mean` function to the all the features columns only (starting from 4th column till the end) and according to each Subject and each Activity. The newly merged tidy data is then stored in `tidy_data`  data table

```
tidy_data <- aggregate(merged_x[,4:ncol(merged_x)], by=list(Subject = merged_x$Subject, Activity = merged_x$Activity), FUN=mean, na.rm = TRUE)
```

Finally we write the `tidy_data`a into a tab delimited text file, excluding the row names column


```
write.table(tidy_data, "tidy_data.txt", sep = "\t", row.names = FALSE)
```




