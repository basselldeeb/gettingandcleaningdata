
##  BLOCK 1 ## PREPARE CODE

##  Check paths for every set 

## dataset must be stored under the file name "UCI HAR Dataset"

## Train Set
pathtrainX <- file.path(getwd(),"UCI HAR Dataset","train","X_train.txt")
pathtrainY <- file.path(getwd(),"UCI HAR Dataset","train","y_train.txt")
pathtrainS <- file.path(getwd(),"UCI HAR Dataset","train","subject_train.txt")

## Test Set
pathtestX <- file.path(getwd(),"UCI HAR Dataset","test","X_test.txt")
pathtestY <- file.path(getwd(),"UCI HAR Dataset","test","y_test.txt")
pathtestS <- file.path(getwd(),"UCI HAR Dataset","test","subject_test.txt")

## Labels
pathActivity <- file.path(getwd(),"UCI HAR Dataset","activity_labels.txt")
pathFeatures <- file.path(getwd(),"UCI HAR Dataset","features.txt")
## /BLOCK 1 ## PREPARE CODE


## BLOCK 2 ## LOAD DATA AND LABEL VARIABLES

## 1.Merges the training and the test sets to create one data set.
## Load Tables and combine train and test
X <- rbind(read.table(pathtrainX), read.table(pathtestX)) 
Y <- rbind(read.table(pathtrainY), read.table(pathtestY)) 
S <- rbind(read.table(pathtrainS), read.table(pathtestS)) 

## Load tables Activities and Features 
Activity <- read.table(pathActivity) 
Features <- read.table(pathFeatures) 


## Label names for Features table 
names(X) <- Features$V2

## /BLOCK 2 ## LOAD DATA AND LABEL VARIABLES


## BLOCK 3 ## MANIPULATE LABELS AND CREATE DATA SET


## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
subsetNames <- names(X)[grep("mean\\(\\)|std\\(\\)", names(X))]

x <- subset(X,select = subsetNames)

## 3.Uses descriptive activity names to label the activities in the data set
Y <- as.data.frame(merge(Y,Activity, by.x = "V1" )[,2])
names(Y)<- "Activity"
names(S)<- "Subject"

## 4.Appropriately labels the data set with descriptive variable names.

names(x)<-gsub("^t", "time", names(x))
names(x)<-gsub("^f", "frequency", names(x))
names(x)<-gsub("Acc", "Accelerometer", names(x))
names(x)<-gsub("Gyro", "Gyroscope", names(x))
names(x)<-gsub("Mag", "Magnitude", names(x))
names(x)<-gsub("BodyBody", "Body", names(x))

## Combine tables 
Data <- cbind(Y,x,S)

## /BLOCK 3 ## MANIPULATE LABELS AND CREATE DATA SET

## BLOCK 4 ## CALCULATIONS AND OUTPUT ON FINAL DATA SET

## 5.From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

Data2 <- aggregate(.~Subject + Activity, Data, mean)
Data2 <- Data2[order(Data2$Subject,Data2$Activity),]


## Write output table 
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

## /BLOCK 4 ## CALCULATIONS AND OUTPUT ON FINAL DATA SET
