#Getting and Cleaning Data Course Project
Author: **Francisco J. Álvarez Montero**

Date: **May 12th 2016-12/05/2016**

This repository includes all the files for week 4's project of the Getting and Cleaning Data course. In particular, the goal of the project is to create a tidy data set of [wearable computing data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The tidy data set is produced through an R script called **run_analysis.R**. The algorithm or steps are presented next.

##Steps needed to produce the tidy data set
The steps presented here are just informative. For a precise description, including code, see the **Cookbook.Md** file. The algorithm assumes that the data must be downloaded from a [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in the form of a **zip file**. 

- Clean R's workspace
- Load the **Plyr** package
- Check if the download directory or folder exists. If it does not exist create the folder
- Check if the zip file already exists in the directory. If it does not exist download the zip file into the directory
- Unzip the file
- Read and load the **activity**, **features** and **subject** files creating **6** data frames
- Merge the **activitity** data frames (**2**)
- Merge the **features** data frames (**2**)
- Merge the **subject** data frames (**2**)
- Assign names to the variables/columns to the merged data frames (**3**). Since the **activity** and **subject** data frames have only one column, assign the names **'Activity'** and **'Subject'** to their only column respectively. The column names for the **features** data frame need to be taken from the **'features.txt'** file.
- Merge or unite the merged data frames (**3**) into a **single big** one
- From the available feature names, contained in a previously created data frame, select only  those that have **“mean()”** or **“std()”** as part of their names
- Uset the selected names to subset the **single big** data frame previously created
- Read and load the activity labels from the **activity_labels.txt** file creating a data frame
- Assign this labels to the  **Activity** column of the **single big** data frame
- Expand the colum names of the **final big** data frame in order to improve their readability
- From the **final big** data frame, create a second, tidy data frame with the average of each variable for each activity and each subject
- Create a **text file**, representing the final tidy data set, from the previously created data frame

## Output produced
The output of the steps or algorithm is a text filed named  **'independenttidydata.txt'** which is saved in the working directory of the R Console or RStudio.
