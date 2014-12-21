## defines the function readDataSet(directoryName) used to read "train" and
## "test" dataset from the relavant directories passed as argument 
readDataSet <- function (directory_name){
	## this function reads the 3 files contained in the input argument <directory_name>
	## and containing the observations
	 
	## gets the list of files in the "directory"
	fileVect<-dir(directory_name)
	
	## identifies the files containing the set of subjects, the set of activities and
	## the set of values that have to be merged into the dataframe 
	subjFileIndx<-grep("subject", fileVect)
	actFileIndx<-grep("y_", fileVect)
	valFileIndx<-grep("X_", fileVect)
	
	## reads from fileVect[subjFileIndx] into subjVect the list of subjects to which the values refer
	subjVect<-readLines(paste(directory_name, "/", fileVect[subjFileIndx], sep=""))
	## reads from fileVect[actFileIndx] into actVect the list of activites to which the values refer
	actVect<-readLines(paste(directory_name, "/", fileVect[actFileIndx], sep=""))
	
	## reads from fileVect[valFileIndx] into dFrame the values each made of 561 variables
	dFrame<-read.table(paste(directory_name, "/", fileVect[valFileIndx], sep=""))
	
	## adds to dFrame as temporary first column the vector with the activities' IDs
	dFrame<-cbind(as.numeric(actVect), dFrame)
	## adds to dFrame as first column the vector with the subjects
	dFrame<-cbind(as.numeric(subjVect), dFrame)
	## adds to dFrame as last column a column with all <directory_name> to identify the origin of the data
	dFrame<-cbind(dFrame, sourceFile=rep(directory_name, nrow(dFrame)))
	
	## returns the dataframe with 1+1+561+1 variables
	dFrame
}


## HERE THE INSTRUCTIONS FOR IMPLEMENTING PART1 TO PART5 START

## if not already there, set the working directory to subdirectory "UCI HAR Dataset"
## where there are common files and the subdirectories "train" and "test" with the actual datasets
if(!grepl("UCI HAR Dataset", getwd())) {setwd("UCI HAR Dataset")}


## PART1 - to merge training and test datasets into one dataset
## calls readDataSet() with "train" as parameter to build "train" dataframe
train.df<-readDataSet("train")
## call readDataSet() with "test" as parameter to build "test" dataframe
test.df<-readDataSet("test")
## merges train.df and test.df data sets into dataset
dataset<-rbind(train.df, test.df)
rm(train.df,test.df) ## to free memory resources

## PART2 - to extract only the measurements on "MEAN" and "STANDARD DEVIATION" for each measurement
## gets from the "features.txt" file the names of the measurements
varsNames.df<-read.table("features.txt", sep=" ", stringsAsFactors=FALSE)
##  add in reverse order on top of varsNames.df "ID" and "name" for variable <subjects> and
## for variable <activities> to prepare for PART 4
varsNames.df<-rbind(c(0,"activity"), varsNames.df)
varsNames.df<-rbind(c(-1,"subjID"), varsNames.df)
##  add as last row the ID and value for the source_file to prepare for PART 4
varsNames.df<-rbind(varsNames.df, c(nrow(varsNames.df)+1,"sourceFile"))

## cleans varsNames for assignment to variable names,
## removes from varsNames.df[,2] all punctuation characters
varsNames.df[,2]<-gsub("[[:punct:]]","",varsNames.df[,2])
## makes variable names more significant
## changes leading "t" with "Time"
varsNames.df[,2]<-sub("^t", "Time", varsNames.df[,2])
## changes leading "f" with "Frequency" 
varsNames.df[,2]<-sub("^f", "Frequency", varsNames.df[,2])
## reduces "BodyBody" to "Body"
varsNames.df[,2]<-sub("BodyBody", "Body", varsNames.df[,2])
## changes "mean" to "Mean" in order to highlight the term
varsNames.df[,2]<-sub("mean", "Mean", varsNames.df[,2])
## changes "std" to "StandDev" in order to highlight the term
varsNames.df[,2]<-sub("std", "StandDev", varsNames.df[,2])



## identifies from varsNames.df[,2] the measurements on "MEAN" and "STD DEVIATION"
## and builds a vector "selectCol" to select the columns of interest
## N.B. measurements with "mean"|"Mean"|"std" in the middle
## (except when followed by X or Y or Z) are not considered,
## those containing "anglet...gravityMean" are not extracted

## vector <selectCol> with numbers of columns to extract is built and used  
## the columns #1 and #2 have to be included to extract "subjects" and "activities"
selectCol<-c(1, 2)
## add those columns that contain "mean | Mean | std" in the form stated above
selectCol<-c(selectCol, grep("Mean[XYZ]?$|StandDev[XYZ]?$", varsNames.df[-grep("gravityMean", varsNames.df[,2]),2]))

## extracts from dataset only the columns identified by the vector selectCol and
## copy them into a new dataframe called datasetMeanSTD
datasetMeanSTD<- dataset[, selectCol]
## rm(dataset) ## to free memory resources


## PART 3 - to use descriptive activity names to name the activities
##reads from file "activity_labels.txt" the IDs and the names of the activities
actNames<-read.table("activity_labels.txt",sep=" ", stringsAsFactors=FALSE)

## changes the numeric ID of activities with the relevant name associated in actNames dataframe
## sets the class of datasetMeanSTD[,2] as "factor" and then uses actNames to change the levels
datasetMeanSTD[,2]<-as.factor(datasetMeanSTD[,2])
levels(datasetMeanSTD[,2])<-actNames[,2]

## PART 4 - to appropriately label the dataset with descriptive variable names
## assigns the variables of datasetMeanSTD the names contained in varsNames
names(datasetMeanSTD)<-varsNames.df[selectCol,2]


## PART5 - creates a second, independent tidy dataset from <4> with the average of
## each var for each activity and each subject
library(dplyr)
library(tidyr)

## create a copy of datasetMeanSTD grouped by "subjID" and "activity" variables
groupSubjAct<-group_by(datasetMeanSTD, subjID, activity)
## builds a vector containing the names of the variables on which the mean has to be calculated  
colVars<-names(groupSubjAct)[-c(1,2)]
## creates a list made of elements of class "call", named as <namevars> and 
## with values equal to "mean(<namevarx)"
dots <- sapply(colVars, function(x) substitute(mean(x), list(x=as.name(x))))
## creates the dataset with the means of the variabile for each couple "subject-activity"
## summarize is invoked using as arguments: groupSubjAct and every element of dots
targetdataset<-do.call(summarise, c(list(.data=groupSubjAct), dots))
## using tidyr function gather() transpose into the new variable "measures" the "features"
## corresponding to columns 3:68, and into the new variabile "mean" the relevant values
tidydataset<-gather(targetdataset, measurement, mean, -c(subjID, activity))
tidydataset<-arrange(tidydataset, subjID, activity)

