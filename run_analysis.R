# define data sets going to be merged
setwd("C:\\courses etc\\Data Science\\Getting data\\project\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
x_test <-  read.table("X_test.txt")
y_test <-  read.table("Y_test.txt")
features <- read.table("features.txt")
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")

names(x_train) <- features[,2]
names(x_test) <- features[,2]

# combine column of labels (y axis) into data sets
training <- cbind(subject_train,y_train,x_train)
test <- cbind(subject_test,y_test,x_test)

# merge training and test (rbind, not merge?)
merged <- rbind(training,test)

# find which columns have mean or SD
M_SD <- features[grep("mean|std", features[,2]),] 
M_SDcols <- grep("mean|std", features[,2]) 

#plus 2 then insert columns 1 and 2 to keep the subject and activity cols
M_SDcols <- M_SDcols + 2
M_SDcols <- c(1,2,M_SDcols)

#select just those columns from dataframe
merged_mean_sd <- merged[,M_SDcols]
# Replace activity codes with description, from activity_labels file  
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="1", "WALKING")
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="2", "WALKING_UPSTAIRS")
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="3", "WALKING_DOWNSTAIRS")
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="4", "SITTING")
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="5", "STANDING")
merged_mean_sd$V1.1 <- replace(merged_mean_sd$V1.1, merged_mean_sd$V1.1=="6", "LAYING")

colnames(merged_mean_sd)[1] <- "subject"
colnames(merged_mean_sd)[2] <- "activity"
library(reshape2)
melted <- melt(merged_mean_sd, id.vars = c("subject", "activity"))
casted <- dcast(melted, subject + activity ~ variable,fun.aggregate =mean)
write.table(casted,file="output.txt",row.name=FALSE)