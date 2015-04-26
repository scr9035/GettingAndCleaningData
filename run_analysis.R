library(dplyr)

#open the files, make sure your wd is correct
features <- read.table("features.txt", header=FALSE)
activity_labels <- read.table("activity_labels.txt", header=FALSE)

x_test <- read.table("x_test.txt", header = FALSE)
y_test <- read.table("y_test.txt", header = FALSE)
subject_test <- read.table("subject_test.txt", header = FALSE)

x_train <- read.table("x_train.txt", header = FALSE)
y_train <- read.table("y_train.txt", header = FALSE)
subject_train <- read.table("subject_train.txt", header = FALSE)



#filter features for std and mean. This is the tough part. At least for me
#break the string into more managable sections
features$V2 = gsub('-mean','Mean',features$V2)
features$V2 = gsub('-std','Std',features$V2)
features$V2 = gsub('[-()]','',features$V2)



#add column names to make it easier for me to understand a data set when I View(df)
colnames(x_test) <- features$V2
colnames(subject_test) <- c("participant")
colnames(y_test) <- c("activity")

colnames(x_train) <- features$V2
colnames(subject_train) <- c("participant")
colnames(y_train) <- c("activity")


#make one data set
testing <- rbind(y_test, y_train)
training <- rbind(subject_test, subject_train)
test_train <- rbind(x_test,x_train)



colsMeanStd <- grep(".*Mean.*|.*Std.*", features$V2)    #make an array with the column numbers we want to subset for Mean and Std
mean_std <- test_train[,colsMeanStd]                    #make a data set with just columns that have Mean and Std in them
allData <- cbind(mean_std,testing,training)             #make a single data set

#compute the mean allData according to participant and activity
tidy <- aggregate(allData, list(participant=allData$participant, activity=allData$activity), mean)
tidy <- tidy[,1:88]

write.table(tidy,"tidy.txt", row.names=FALSE)