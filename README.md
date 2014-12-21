## Getting and Cleaninig Data - Course Project
#### by Max Testa

The script "run_analys.R" handles two locally stored sets of 3 files (previously downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" and uncrompressed).
One set, stored in the subdirectory "train", relates to a "training" dataset, and the other, stored in the subdirectory "test", relates to a "testing" dataset.  

The files of each file-set have all the same number of rows, that corresponds to the number of observations done over the activities performed by the selected subjects of that particular group. The list of subjects who perform the activity (represented by numeric IDs), the list of the activity performed (represented by numeric IDs) and the list of 561 derived quantities related to each measurement are contained in the three files of each set.

In the working directory there are also other 2 files: one with the names of the 561 variablesm, the other with the names of the 6 activities performed by the persons partecipating to the experiment


##PART 1
The script reads the contents of the 3 files of each file-set and combines them by columns into a single dataframe, to which also another last column is added to contain either "train" or "test" in order to identify the original file-set.

To read the files of the two file-sets the script calls twice a locally-defined function "readDataSet()", that received as input-parameter the name of the directory containing the files to read and returns a dataframe with the information from those files.

Then the scripts combines by rows the two dataframes to form a unique dataframe called "dataset" (with 10299 observations and 2+561+1 = 564 variables).


##PART 2
The scripts reads into a dataframe - "varsNames.df"" - the file "features.txt" that contains the name of the 561 "derived quantities".
The dataframe is extended adding two new elements that host the IDs and names of "subject" and "activity", and appending another element to host the ID and name for the type of the original "sourcefile".
Then the names contained in this dataframe are manipulated to remove all punctuation characters, to avoid repetions and to make more clear the structure of the name, so that to prepare the execution of Part 3 and 4

The script creates a vector - "selectCol" - that contains the position in "varsNames.df"" of the elements whose V2 variable contains at the end the words "Mean" or "STD", alone or followed by an X or a Y or a Z (for 3-axial quantities), excluding the variable names containing "anglet...gravityMean".

Subsetting the dataframe "dataset" using the vector "selectCol" the script creates another dataframe - "datasetMeanSTD" - containing only the measurements with "mean" and "standard deviation"


## PART 3
The script reads from file "activity_labels.txt" the IDs and the names of the activities and, after forcing the class of variable "activity" of datasetMeanSTD to "factor", uses the command levels() to substitute the numeric levels with the more significant verbal ones  - "WALKING", "WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING","LAYING" - obtained reading the "activity_labels.txt" file 


## PART 4
The script uses the vector "selectCol" to select the elements of "varsNames.df" and to assign them as descriptive names for the variables of the dataframe "datasetMeanSTD".


##PART5
The script loads the packages "dplyr" and "tidyr" to make use of their functions.
The script creates a new dataframe "groupSubjAct" grouping datasetMeanSTD by "subjID" and "activity" variables, in order to calculate the mean of each other variable based on the combinations of "subjID and activity".
To apply the function "summarize()" to more than a variable without typing in all the names, the script creates a vector containing the names of the variables on which the mean has to be calculated and with that it creates a list of elements of class "call", whose values are of the kind "mean(<namevarx>)". Then the script invokes the "do.call()" function passing as parameters the function "summarize" and its arguments - i.e. the "groupSubjAct" dataframe as .data, the list containing the "mean<nomevarx>" as function.
The result is assigned to the final dataframe "tidydataset".

This dataframe is further processed to gather, in a unique variable called "measures", all the names of the different "derived quantities" (considering them as values of this variable) and in the new variable "mean" the values just calculated. In this way a long version of the dataset is obtained, reducing the number of the columns.
Finally the "tidydataset" is sorted in order to have the observations ordered by "subjID" and "activity" (as factor).

The final dataset  meets the basic principles of a tidy dataset: "1. each variable is in one column; 2. each different observation of that variable is in a different row". (for more information and discussion please refer to: https://class.coursera.org/getdata-016/forum/thread?thread_id=50 and to https://class.coursera.org/getdata-016/forum/thread?thread_id=100)