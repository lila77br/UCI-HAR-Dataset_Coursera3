#Getting data
unzip(zipfile="C:/Users/Sara/Documents/R/getdata_projectfiles_UCI HAR Dataset.zip",exdir="./R")
pathdata = file.path("./R", "UCI HAR Dataset")
files = list.files(pathdata, recursive=TRUE)
#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)
##3 Uses descriptive activity names to name the activities in the data set
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#the activity labels value
colnames(activityLabels) <- c('activityId','activityType')
##1 Merges the training and the test sets to create one data set
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)
##2 Extracts only the measurements on the mean and standard deviation for each measurement:
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
## 4 Tagging Names
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)
## 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
