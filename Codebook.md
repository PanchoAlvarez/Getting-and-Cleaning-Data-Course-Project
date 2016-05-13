#Getting and Cleaning Data Course Project
Author: **Francisco J. Álvarez Montero**

Date: **May 12th 2016-12/05/2016**

#Introduction
-----------------------
This repository includes all the files for week 4's project of the Getting and Cleaning Data course. In particular, the goal of the project is to create a tidy data set of [wearable computing data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The tidy data set is produced through an R script called **run_analysis.R**. The data used for this project must be downloaded from a [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in the form of a **zip file**.  In order to create the tidy data set the following goals must be acomplished:

- Merge two datasets to create one data set
- Extract only the measurements on the mean and standard deviation for each measurement
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names.
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

#Information about the data 
----------------------
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#Information contained in the data
------------------------
For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- Its activity label.

#Citation 
-----------------------
Anguita, D., Ghio, A., Oneto, L., Parra, X., & Reyes-Ortiz, J. L. (2012). Human activity recognition on smartphones using a multiclass hardware-friendly support vector machine. In Ambient assisted living and home care (pp. 216-223). Springer Berlin Heidelberg.


#R code to produce the tidy data set
-----------------------------------------
##Clean the workspace and load the required libraries
```{r load-packages, echo=FALSE}
##Clean the workspace
rm(list=ls())
##Load required packages
library(plyr)
```
##Donwload the file containing the data and unzip it
```{r downloadandunzip, echo=FALSE}
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
