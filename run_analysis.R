#Author:Francisco J. Alvarez Montero
#This is the R script for week 4 of the Getting and Cleaning Data course by Johns Hopkins University
#The goal is to prepare tidy data that can be used for later analysis
#The script named run_analysis.R has the following goals:
#1.Merges two datasets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#The script was developed using the R version  '0.99.893' for WINDOWS 7

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#CODE STARTS HERE
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
##Clean the workspace
rm(list=ls())
##Load required packages
library(plyr)

##STEP 1: DOWNLOAD THE FILE AND UNZIP IT 
#Assign the directory or folder path to a variable
filedirectory<-"./Data Science Specialization/Data Cleaning/Week4"
#Create a new directory or folder if it does not exist.The recursive parameter o dir.create is set to TRUE because it needs to create several folders or directories
if(!file.exists(filedirectory)){dir.create(filedirectory,recursive = TRUE)}
#Assign the URL with the zip FILE containing the datasets to a variable
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#Assign the name of the file to be downloaded to a variable
filename<-"Dataset.zip"
#I the ZIP file does not exits, it Downloads into the previously created folder or directory: "./Data Science Specialization/Data Cleaning/Week4"
if(!file.exists(paste(filedirectory,"/",filename,sep=""))){download.file(fileUrl,destfile=paste(filedirectory,filename,sep=""))}
#Unzip the downloaded file
unzip(zipfile=paste(filedirectory,"/",filename,sep=""),exdir=filedirectory)
#The unzipped files are in the folder 'UCI HAR Dataset'. Get the list of files and print it
#Construct the path to a file from components in a platform-independent way. 
path2files<-file.path(filedirectory,"UCI HAR Dataset")
#Get the list of files in the folder and subfolders, recursive must be set to TRUE for this
filesinfolder<-list.files(path2files, recursive=TRUE)
#Print the list of files
#filesinfolder

##STEP 2: READ THE DATA FROM THE FILES
#The files to be read are six:
#1.test/subject_test.txt
#2.test/X_test.txt
#3.test/y_test.txt
#4.train/subject_train.txt
#5.train/X_train.txt
#6. train/y_train.txt
# Read and load the subject files from the 'train' and 'test' folders
activityTestDf  <- read.table(file.path(path2files, "test" , "Y_test.txt" ),header = FALSE)
activityTrainDf <- read.table(file.path(path2files, "train", "Y_train.txt"),header = FALSE)
subjectTestDf  <- read.table(file.path(path2files, "test" , "subject_test.txt"),header = FALSE)
subjectTrainDf <- read.table(file.path(path2files, "train", "subject_train.txt"),header = FALSE)
featuresTestDf  <- read.table(file.path(path2files, "test" , "X_test.txt" ),header = FALSE)
featuresTrainDf <- read.table(file.path(path2files, "train", "X_train.txt"),header = FALSE)

##STEP 3: MERGES THE TRAINING AND THE TEST DATA FRAMES TO CREATE ONE DATA FRAME
#Merge the data frames row by row and create new data frames
subjectsDf <- rbind(subjectTrainDf,subjectTestDf)
activitiesDf<- rbind(activityTrainDf, activityTestDf)
featuresDf<- rbind(featuresTrainDf, featuresTestDf)
#Assign names to the variables/columns o the 3 previous data frames
names(subjectsDf)<-c("Subject")
names(activitiesDf)<- c("Activity")
#Read the 'features.txt' file
featuresNamesDf <- read.table(file.path(path2files, "features.txt"),head=FALSE)
names(featuresDf)<- featuresNamesDf$V2
#Create the final data frame by merging or uniting the activitiesDf and subjectsDf data frames and then, the featuresDf
subjectActivityDf <- cbind(subjectsDf, activitiesDf)
finalDf <- cbind(featuresDf, subjectActivityDf)

##STEP 4: EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT FROM THE FINAL DATA FRAME
# Select only feature name's, from the featuresNamesDf data frame, that have "mean()" or "std()" as part of their names
subFeaturesNamesDf<-featuresNamesDf$V2[grep("mean\\(\\)|std\\(\\)", featuresNamesDf$V2)]
#From the subFeaturesNamesDf data frame, create a vector tha contains the selected feature names + Subject + Activity. They will act as column names
selectedNames<-c(as.character(subFeaturesNamesDf), "Subject", "Activity" )
#Subset the finalDf data frame by tbe selected feature names. 'select=' is an argument that indicates the columns to select from the data frame
finalDf<-subset(finalDf,select=selectedNames)

#STEP 5: ASSIGN DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA FRAME/SET. IT LABELS THE ACTIVITITIES. 
#Read and load descriptive activity names from the 'activity_labels.txt' file
activityLabelsDf <- read.table(file.path(path2files, "activity_labels.txt"),header = FALSE)
#Factorize the variable `activity` in  the data frame 'finalDf' using  descriptive activity names 
finalDf$Activity<-factor(finalDf$Activity);
finalDf$Activity<- factor(finalDf$Activity,labels=as.character(activityLabelsDf$V2))

##STEP 6: APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES. FEATURE NAMES ARE  LABELLED USING DESCRIPTIVE VARIABLE NAMES
#- prefix t  is replaced by  Time
#- Acc is replaced by Accelerometer
#- Gyro is replaced by Gyroscope
#- prefix f is replaced by Frequency
#- Mag is replaced by Magnitude
#- BodyBody is replaced by Body
names(finalDf)<-gsub("^t", "Time", names(finalDf))
names(finalDf)<-gsub("^f", "Frequency", names(finalDf))
names(finalDf)<-gsub("Acc", "Accelerometer", names(finalDf))
names(finalDf)<-gsub("Gyro", "Gyroscope", names(finalDf))
names(finalDf)<-gsub("Mag", "Magnitude", names(finalDf))
names(finalDf)<-gsub("BodyBody", "Body", names(finalDf))

##step 7: CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
#A second independent tidy data frame/set is created with the average of each variable for each activity and each subject 
#based on the data frame/set in step 6. 
finalDf02<-aggregate(. ~Subject + Activity, finalDf, mean)
#Arrange or sort the data frame by Subject and Activity
finalDf02<-arrange(finalDf02, Subject,Activity)
#Write the data frame into a text file
write.table(finalDf02, file = "independenttidydata.txt",row.name=FALSE)
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#CODE ENDS HERE
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''