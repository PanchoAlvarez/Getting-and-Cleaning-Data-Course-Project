---
title: "Untitled"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
#Getting and Cleaning Data Course Project
Author: **Francisco J. Álvarez Montero**
Date: **May 12th 2016-12/05/2016**

This repository includes all the files for week 4's project of the Getting and Cleaning Data course. In particular, the goal of the project is to create a tidy data set of [wearable computing data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The tidy data set is produced through an R script called **run_analysis.R**. The data used for this project must be downloaded from a [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in the form of a **zip file**.  In order to create the tidy data set the following goals must be acomplished:

- Merge two datasets to create one data set
- Extract only the measurements on the mean and standard deviation for each measurement
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names.
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

##Clean the workspace and load the required libraries
```{r load-packages, echo=FALSE}
rm(list=ls())
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
