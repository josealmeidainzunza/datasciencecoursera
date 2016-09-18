#Read data from the files
#    Values of Varible Activity consist of data from “Y_train.txt” and “Y_test.txt”
#    values of Varible Subject consist of data from “subject_train.txt” and subject_test.txt"
#    Values of Varibles Features consist of data from “X_train.txt” and “X_test.txt”
#    Names of Varibles Features come from “features.txt”
#    levels of Varible Activity come from “activity_labels.txt”

Activity_Test <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt",header = FALSE)
Activity_Train <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt",header = FALSE)
subj_Train <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Subject_train.txt",header = FALSE)
subj_Test <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Subject_test.txt",header = FALSE)
Features_Test  <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt" ,header = FALSE)
Features_Train <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt" ,header = FALSE)

##Merges the training and the test sets to create one data set
#Concatenate the data tables by rows
Subject <- rbind(subj_Train, subj_Test)
Activity<- rbind(Activity_Train, Activity_Test)
Features<- rbind(Features_Train, Features_Test)

#set names to variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",head=FALSE)
names(Features)<- FeaturesNames$V2

#Merge columns to get the data frame Data for all data
dataCombine <- cbind(Subject, Activity)
Data <- cbind(Features, dataCombine)


##Extracts only the measurements on the mean and standard deviation for each measurement
#taken Names of Features with “mean()” or “std()”
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
#str(Data)


##Uses descriptive activity names to name the activities in the data set
#Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table("C:/Users/jose.almeida.inzunza/Documents/DataClean/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",header = FALSE)


##Appropriately labels the data set with descriptive variable names
#Set descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##Creates a second,independent tidy data set and ouput it
#independent tidy data set will be created with the average of each variable for 
#each activity and each subject based on the data set in step 4.
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)###C:/Users/jose.almeida.inzunza/Documents/