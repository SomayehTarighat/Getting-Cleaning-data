      if(!file.exists("./data")){dir.create("./data")}
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl,destfile="C:/Users/somay/Documents/Coursera/Dataset.zip")

# Unzip dataSet to /data directory
# I did it directly in my working directory under folder Dataset

# get the files (checking):
      getfiles <- file.path("C:/Users/somay/Documents/Coursera/Dataset" , "UCI HAR Dataset")
      files<-list.files(getfiles, recursive=TRUE)
      files
# to read the data from the files into variables:
      # 1:activity files
      activitytest  <- read.table(file.path(getfiles, "test" , "Y_test.txt" ),header = FALSE)
      activitytrain <- read.table(file.path(getfiles, "train", "Y_train.txt"),header = FALSE)
      # 2:subject files
      subjecttest  <- read.table(file.path(getfiles, "test" , "subject_test.txt"),header = FALSE)
      subjecttrain <- read.table(file.path(getfiles, "train", "subject_train.txt"),header = FALSE)
      # 3:feature files
      featurestest  <- read.table(file.path(getfiles, "test" , "X_test.txt" ),header = FALSE)
      featurestrain <- read.table(file.path(getfiles, "train", "X_train.txt"),header = FALSE)
# try str(subjecttest), etc.

# NEXT:
# Merge the training and the test sets to create one data set by:
# a) link data tables by rows, b) name the variables, c) merge columns into data frame of all data
      concatactivity <- rbind(activitytrain, activitytest)
      concatsubject <- rbind(subjecttrain, subjecttest)
      concatfeatures <- rbind(featurestrain, featurestest)
      names(concatsubject)<-c("subject")
      names(concatactivity)<- c("activity")
      featuresnames <- read.table(file.path(getfiles, "features.txt"),head=FALSE)
      names(concatfeatures)<- featuresnames$V2
      #combine:
      combined <- cbind(concatsubject, concatactivity)
      Data <- cbind(concatfeatures, combined)

# extract only the measurements on the mean and standard deviation for each measurement
      subfeaturesnames <- featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]]
      # subset:
      subsetnames<-c(as.character(subfeaturesnames), "subject", "activity" )
      Data<-subset(Data,select=subsetnames)
# try str(Data)

# NEXT:
# use descriptive activity names to name the activities in the data set
      activitylabels <- read.table(file.path(getfiles, "activity_labels.txt"),header = FALSE)
      Data$activity <- factor(Data$activity, labels = as.character(activitylabels$V2))

# NEXT:
# Appropriately label the data set with descriptive variable names
# replace t by time, Acc by accelerometer, Gyro by gyroscope, f by frequency, Mag by magnitude, BodyBody by body
      names(Data)<-gsub("^t", "time", names(Data))
      names(Data)<-gsub("^f", "frequency", names(Data))
      names(Data)<-gsub("Acc", "accelerometer", names(Data))
      names(Data)<-gsub("Gyro", "gyroscope", names(Data))
      names(Data)<-gsub("Mag", "magnitude", names(Data))
      names(Data)<-gsub("BodyBody", "body", names(Data))

# NEXT:
# From the data set in step 4, create a second, independent tidy data set with the 
# average of each variable for each activity and each subject
      library(plyr);
      Data2<-aggregate(. ~subject + activity, Data, mean)
      Data2<-Data2[order(Data2$subject,Data2$activity),]
      write.table(Data2, file = "tidydata.txt",row.name=FALSE)

