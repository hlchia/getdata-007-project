setwd("/Users/hlchia/documents/data/UCI HAR Dataset")

library(data.table)

# 1. Merges the training and the test sets to create one data set.

# load the global datasets for features and activity to be used for both test and training data
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# setup logical vector for columns we are interested i.e. columns containing -std OR -mean
target_cols <- grepl("-std()|-mean()", features[,2]) 

# load the related test datasets 
subject_test <- read.table("test/subject_test.txt") # contains test observations arranged as a single col of subject
y_test <- read.table("test/y_test.txt") # contains test observations arranged as a single col of activity_ids
x_test <- read.table("test/x_test.txt") # contains test observations arranged as 561 cols of features

# 3. Uses descriptive activity names to name the activities in the data set

# add a new column for descriptive activity names by looking up the activiy_labels vector
y_test$V2 <- activity_labels[y_test$V1, 2] 


# 4. Appropriately labels the data set with descriptive variable names. 
# tidy up the test data with proper col names
names(subject_test) = "Subject"
names(y_test) = c("Activity_Id", "Activity")
names(x_test) = features[,2]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# include only cols we want usinf the logical vector setup earlier
x_test <- x_test[,target_cols]

# merge the test datasets
merged_x_test <- cbind(subject_test, y_test, x_test)

# repeat the same for training data
subject_train <- read.table("train/subject_train.txt") # contains training observations arranged as a single col of subject
y_train <- read.table("train/y_train.txt") # contains training observations arranged as a single col of activity_ids
x_train <- read.table("train/x_train.txt") # contains training observations arranged as 561 cols of features

# 3. Uses descriptive activity names to name the activities in the data set
y_train$V2 <- activity_labels[y_train$V1, 2] 

# 4. Appropriately labels the data set with descriptive variable names. 
names(subject_train) = "Subject"
names(y_train) = c("Activity_Id", "Activity")
names(x_train) = features[,2]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
x_train <- x_train[,target_cols]

# merge the training datasets
merged_x_train <- cbind(subject_train, y_train, x_train)

# 1. Merges the training and the test sets to create one data set.
merged_x <- rbind(merged_x_test, merged_x_train)


# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

# when using aggregate, apply mean function to the features columns only (starting from 4th col till the end) according to Subject and Activity
tidy_data <- aggregate(merged_x[,4:ncol(merged_x)], by=list(Subject = merged_x$Subject, Activity = merged_x$Activity), FUN=mean, na.rm = TRUE)

# write the tidy data into a tab delimited text file, excl the row names column
write.table(tidy_data, "tidy_data.txt", sep = "\t", row.names = FALSE)



