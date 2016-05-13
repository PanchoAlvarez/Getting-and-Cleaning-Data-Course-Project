#Getting and Cleaning Data Course Project
Author: **Francisco J. Álvarez Montero**

Date: **May 12th 2016-12/05/2016**

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

#Introduction
This repository includes all the files for week 4's project of the Getting and Cleaning Data course. In particular, the goal of the project is to create a tidy data set of [wearable computing data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The tidy data set is produced through an R script called **run_analysis.R**. The data used for this project must be downloaded from a [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in the form of a **zip file**.  In order to create the tidy data set the following goals must be acomplished:

- Merge two datasets to create one data set
- Extract only the measurements on the mean and standard deviation for each measurement
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names.
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

#Information about the data 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#Information contained in the data
For each record in the dataset it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- Its activity label.

#Citation 
Anguita, D., Ghio, A., Oneto, L., Parra, X., & Reyes-Ortiz, J. L. (2012). Human activity recognition on smartphones using a multiclass hardware-friendly support vector machine. In Ambient assisted living and home care (pp. 216-223). Springer Berlin Heidelberg.


#R code to produce the tidy data set
## Clean the workspace and load the required libraries
```{r cleanload}
##Clean the workspace
rm(list=ls())
##Load required packages
library(plyr)
library(knitr)
```

##Donwload the file containing the data and unzip it
```{r download results:hide}
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
filesinfolder
```

##Read the data from the files
###The files to be read are six:
- test/subject_test.txt
- test/X_test.txt
- test/y_test.txt
- train/subject_train.txt
- train/X_train.txt
- train/y_train.txt

The files to be used in this analysis are shown graphically in the figure below. Files in the Inertial Signals folders are not being used here. From the figure, we see that we will use Activity, Subject and Features as part of descriptive variable names for the final data frame we will create.

<div id="bg">
  <img src="re_tidy.png" alt="">
</div> 

```{r readfiles results:hide}
# Read and load the subject files from the 'train' and 'test' folders
activityTestDf  <- read.table(file.path(path2files, "test" , "Y_test.txt" ),header = FALSE)
activityTrainDf <- read.table(file.path(path2files, "train", "Y_train.txt"),header = FALSE)
subjectTestDf  <- read.table(file.path(path2files, "test" , "subject_test.txt"),header = FALSE)
subjectTrainDf <- read.table(file.path(path2files, "train", "subject_train.txt"),header = FALSE)
featuresTestDf  <- read.table(file.path(path2files, "test" , "X_test.txt" ),header = FALSE)
featuresTrainDf <- read.table(file.path(path2files, "train", "X_train.txt"),header = FALSE)
```

###The structure of the data frames is the following:
```{r readfiles}
str(activityTestDf)
str(activityTrainDf)
str(subjectTestDf)
str(subjectTrainDf)
str(featuresTestDf)
str(featuresTrainDf)
```

##Merge the data frames row by row and create 3 new data frames
```{r mergedataframes}
subjectsDf <- rbind(subjectTrainDf,subjectTestDf)
activitiesDf<- rbind(activityTrainDf, activityTestDf)
featuresDf<- rbind(featuresTrainDf, featuresTestDf)
#Assign names to the variables/columns o the 3 previous data frames
names(subjectsDf)<-c("Subject")
names(activitiesDf)<- c("Activity")
#Read the 'features.txt' file
featuresNamesDf <- read.table(file.path(path2files, "features.txt"),head=FALSE)
names(featuresDf)<- featuresNamesDf$V2
```

##Merge or unite the merged data frames (**3**) into a **single big** one
```{r createonebigdf }
#Create the final data frame by merging or uniting the activitiesDf and subjectsDf data frames and then, the featuresDf
subjectActivityDf <- cbind(subjectsDf, activitiesDf)
finalDf <- cbind(featuresDf, subjectActivityDf)
#Show the structure of the data frame
str(finalDf) 
```

##Select only feature name's, from the featuresNamesDf data frame, that have “mean()” or “std()” as part of their names
```{r readfeatures}
subFeaturesNamesDf<-featuresNamesDf$V2[grep("mean\\(\\)|std\\(\\)", featuresNamesDf$V2)]
#From the subFeaturesNamesDf data frame, create a vector tha contains the selected feature names + Subject + Activity. They will act as column names
selectedNames<-c(as.character(subFeaturesNamesDf), "Subject", "Activity" )
#Subset the finalDf data frame by tbe selected feature names. 'select=' is an argument that indicates the columns to select from the data frame
finalDf<-subset(finalDf,select=selectedNames)
#Shwo structure of the data frame
str(finalDf)
```

##Read and load descriptive activity names from the 'activity_labels' file
```{r readactivitynames}
activityLabelsDf <- read.table(file.path(path2files, "activity_labels.txt"),header = FALSE)
#Factorize the variable `activity` in  the data frame 'finalDf' using  descriptive activity names 
finalDf$Activity<-factor(finalDf$Activity);
finalDf$Activity<- factor(finalDf$Activity,labels=as.character(activityLabelsDf$V2))
```

##Expand the colum names of the **final big** data frame in order to improve their readability
- prefix t  is replaced by  Time
- Acc is replaced by Accelerometer
- Gyro is replaced by Gyroscope
- prefix f is replaced by Frequency
- Mag is replaced by Magnitude
- BodyBody is replaced by Body

```{r expandcolumnnames}
names(finalDf)<-gsub("^t", "Time", names(finalDf))
names(finalDf)<-gsub("^f", "Frequency", names(finalDf))
names(finalDf)<-gsub("Acc", "Accelerometer", names(finalDf))
names(finalDf)<-gsub("Gyro", "Gyroscope", names(finalDf))
names(finalDf)<-gsub("Mag", "Magnitude", names(finalDf))
names(finalDf)<-gsub("BodyBody", "Body", names(finalDf))
str(finalDf)
```

##From the **final big** data frame, create a second, tidy data frame with the average of each variable for each activity and each subject
```{r createsecondbigdf}
finalDf02<-aggregate(. ~Subject + Activity, finalDf, mean)
#Arrange or sort the data frame by Subject and Activity
finalDf02<-arrange(finalDf02, Subject,Activity)
str(finalDf02)
```

##Create a **text file**, representing the final tidy data set, from the previously created data frame
```{r createtextfile}
write.table(finalDf02, file = "independenttidydata.txt",row.name=FALSE)
```
