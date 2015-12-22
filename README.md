# Getting and Cleaning Data 

We will explain here how run_analysis.R works. 
The idea is to take Samsung data from zip file getdata-projectfiles-UCI HAR Dataset
and create the file "UCI HAR Dataset" in your working directory. 

From there if you call the function source() or the script run_analysis.R
the script will access the folder "UCI HAR Dataset" and it will run the different steps 
for this assigment.

The output is a txt file with the final table that will be stored on the working directory.

the names of the variables in this output table can be checked in the CodeBook.md


## Assigment

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on 
a series of yes/no questions related to the project. You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



## Script

This code will create tables throughout the process in order to explain the different
activities performed on the data.

The script is structured in 4 BLOCKS
* Prepare data
* Load Data and Label variables
* Manipulate Labels and create dataset
* Calculations and Output on the final dataset

# Prepare data
This creates paths for the different files that are going to be loaded. Based on the premise that
files are stored in the file "UCI HAR Dataset".


pathtrainX <- file.path(getwd(),"UCI HAR Dataset","train","X_train.txt")
pathtrainY <- file.path(getwd(),"UCI HAR Dataset","train","y_train.txt")
pathtrainS <- file.path(getwd(),"UCI HAR Dataset","train","subject_train.txt")


pathtestX <- file.path(getwd(),"UCI HAR Dataset","test","X_test.txt")
pathtestY <- file.path(getwd(),"UCI HAR Dataset","test","y_test.txt")
pathtestS <- file.path(getwd(),"UCI HAR Dataset","test","subject_test.txt")


pathActivity <- file.path(getwd(),"UCI HAR Dataset","activity_labels.txt")
pathFeatures <- file.path(getwd(),"UCI HAR Dataset","features.txt")

File.path() returns the path for each of the files that will be used in the script.


# Load Data and Label variables
 1.Merges the training and the test sets to create one data set.
 Load Tables and combine train and test
X <- rbind(read.table(pathtrainX), read.table(pathtestX)) 
Y <- rbind(read.table(pathtrainY), read.table(pathtestY)) 
S <- rbind(read.table(pathtrainS), read.table(pathtestS)) 

 Load tables Activities and Features 
Activity <- read.table(pathActivity) 
Features <- read.table(pathFeatures) 


## Label names for Features table 
names(X) <- Features$V2


## Manipulate Labels and create dataset 
 This block will filter the variables only to pick those that are mean and standard deviation variables, 
 also it will rename the variables into a more descriptive description.
 Also it will rename the variable for Subject and activity.


 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
 Grab only variables that contain the word mean or std
subsetNames <- names(X)[grep("mean\\(\\)|std\\(\\)", names(X))]

make a subset of the data set taking only those variables in the previous step
x <- subset(X,select = subsetNames)

## 3.Uses descriptive activity names to label the activities in the data set
## label table Y using names from table Activity
Y <- as.data.frame(merge(Y,Activity, by.x = "V1" )[,2])
names(Y)<- "Activity"
names(S)<- "Subject"

## 4.Appropriately labels the data set with descriptive variable names.
## gsub replaces a word with another word
names(x)<-gsub("^t", "time", names(x))
names(x)<-gsub("^f", "frequency", names(x))
names(x)<-gsub("Acc", "Accelerometer", names(x))
names(x)<-gsub("Gyro", "Gyroscope", names(x))
names(x)<-gsub("Mag", "Magnitude", names(x))
names(x)<-gsub("BodyBody", "Body", names(x))

## Combine tables. This will combine the Subject, the filtered measurements and the activities
Data <- cbind(Y,x,S)


## Calculations and Output on the final dataset
 This block calculates the average value based on the Subject and Activity using the aggregate function.
 Finally stores a table with the tidy table. 

## 5.From the data set in step 4, creates a second, independent tidy data set
 with the average of each variable for each activity and each subject.

Data2 <- aggregate(.~Subject + Activity, Data, mean)
Data2 <- Data2[order(Data2$Subject,Data2$Activity),]


## Write output table 
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

