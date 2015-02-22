Readme explaining the analysis done with the script "run_analysis.R"

The script uses the data files
X_train.txt, Y_train.txt, X_test.txt, Y_test.txt, features.txt, subject_train.txt, subject_test.txt
as downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

These are saved in the same directory for simplicity.

Looking at the training set, to get the complete set of information we have to combine information from the files subject_train.txt (subject number for each measurement), Y_train.txt (activity category for each measurement), X_train.txt (values for each measurement) and features.txt (the names of each feature that is measured).
The same process is followed for the test set.

Firstly each file is read into a separate dataframe in R. The next step is to rename the columns of the data sets (x_train and x_test) with the feature names which are found in the second column of the data from features.txt. (I chose to use the same names as in the original data rather than renaming)

the cbind function is then used to combine the information in the 3 set-specific files to create a dataframe each for the training data and the test data, with a column for subject number, column for activity category, followed by columns for all the measured features.

The test and training dataframes are then combined into one dataframe ("merged") using the rbind function. (I used rbind as it is not clear to me how the merge function would work differnently in this case; each set has the same columns in the same order)

The next step is to take only the features columns that contain the string "mean" or "std". To do this I create a variable
M_SDcols, a numerical vector, using the grep function on the data from features.txt: M_SDcols <- grep("mean|std", features[,2]) 

This result is used to select just the corresponding columns from the "merged" dataset, with an adjustment to M_SDcols (add 2 to all column numbers and add 2 initial columns) first to allow for the extra first two columns in the "merged" dataset.

I changed the activity codes in the second column of the dataset using the information in activity_labels.txt and renamed the first and second columns "subject" and "activity" respectively.

Then using the reshape2 library, the data was melted down combining the features variables in one column. After that the data was cast, to give the wide-tidy form with a column for each feature variable containing the mean of that variable for each activity for each subject. 
