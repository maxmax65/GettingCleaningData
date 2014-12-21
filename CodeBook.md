#COURSE PROJECT


##DATA DICTIONARY
The data set contains 11880 observations of 4 variables

 1. subjID
 
              : type = categorical
              : number of categories = 30
              : values = 1, 2, 3, ... ,28, 29, 30
              : meaning = unique identifier of each subject involved in the experiment\n
 
 2. activity
 
              : type = categorical
              : number of categories = 6
              : values = "LAYING", "SITTING","STANDING", "WALKING", "WALKING_DOWNSTAIRS","WALKING_UPSTAIRS"
              : meaning = names of the activities performed by the subjects in the experiment
 3. measurement
 
              : type = categorical
              : number of categories = 66
              : values =
                "FrequencyBodyAccJerkMagMean"      "FrequencyBodyAccJerkMagStandDev"                
                "FrequencyBodyAccJerkMeanX"        "FrequencyBodyAccJerkMeanY"        "FrequencyBodyAccJerkMeanZ"                
                "FrequencyBodyAccJerkStandDevX"    "FrequencyBodyAccJerkStandDevY"    "FrequencyBodyAccJerkStandDevZ"                
                "FrequencyBodyAccMagMean"          "FrequencyBodyAccMagStandDev"
                "FrequencyBodyAccMeanX"            "FrequencyBodyAccMeanY"            "FrequencyBodyAccMeanZ"
                "FrequencyBodyAccStandDevX"        "FrequencyBodyAccStandDevY"        "FrequencyBodyAccStandDevZ"
                "FrequencyBodyGyroJerkMagMean"     "FrequencyBodyGyroJerkMagStandDev"
                "FrequencyBodyGyroMagMean"         "FrequencyBodyGyroMagStandDev"
                "FrequencyBodyGyroMeanX"           "FrequencyBodyGyroMeanY"           "FrequencyBodyGyroMeanZ"
                "FrequencyBodyGyroStandDevX"       "FrequencyBodyGyroStandDevY"       "FrequencyBodyGyroStandDevZ"
                "TimeBodyAccJerkMagMean"          "TimeBodyAccJerkMagStandDev"
                "TimeBodyAccJerkMeanX"             "TimeBodyAccJerkMeanY"             "TimeBodyAccJerkMeanZ"
                "TimeBodyAccJerkStandDevX"         "TimeBodyAccJerkStandDevY"         "TimeBodyAccJerkStandDevZ"
                "TimeBodyAccMagMean"               "TimeBodyAccMagStandDev"
                "TimeBodyAccMeanX"                 "TimeBodyAccMeanY"                 "TimeBodyAccMeanZ"
                "TimeBodyAccStandDevX"             "TimeBodyAccStandDevY"             "TimeBodyAccStandDevZ"
                "TimeBodyGyroJerkMagMean"          "TimeBodyGyroJerkMagStandDev"
                "TimeBodyGyroJerkMeanX"            "TimeBodyGyroJerkMeanY"            "TimeBodyGyroJerkMeanZ"
                "TimeBodyGyroJerkStandDevX"        "TimeBodyGyroJerkStandDevY"        "TimeBodyGyroJerkStandDevZ"
                "TimeBodyGyroMagMean"              "TimeBodyGyroMagStandDev"
                "TimeBodyGyroMeanX"                "TimeBodyGyroMeanY"                "TimeBodyGyroMeanZ"
                "TimeBodyGyroStandDevX"            "TimeBodyGyroStandDevY"            "TimeBodyGyroStandDevZ"
                "TimeGravityAccMagMean"            "TimeGravityAccMagStandDev"
                "TimeGravityAccMeanX"              "TimeGravityAccMeanY"              "TimeGravityAccMeanZ"
                "TimeGravityAccStandDevX"          "TimeGravityAccStandDevY"          "TimeGravityAccStandDevZ"
              : meaning = names of the measurements derived from the original data extracted from the accelerometer and gyroscope
                          3-axial raw signals tAcc-XYZ and tGyro-XYZ. 40 names refers to "time domain" and 26 names to
                          "frequency domain"

4. mean

              : type = quantitative
              : range: [-1, 1] "double"
              : meaning = the mean calculated on all the observations of the cleaned original dataset for each "measurement"
                          related to every possible combination of subject and activity


##DESCRIPTION OF THE PROCESS TO MAKE THE DATASET

The raw date are organized in 2 files, containing the names of the activities and the names of the measurements, and 2 sets of 3 files, each set referring to either "training set" or "test set".

Data from "train" and "test" data sets are read into two dataframes that are merged (by row) into an intermediate complete dataset.

The variable names, read from the relevant file into a dataframe, are extended with 2 new names - "subjID" and "activity" -, are tidied and used to: 1) identify and select the vars of interest ("subjID", "activity" and those referring to "mean" or "standard deviation"); 2) name the variables of the dataset.

A new dataframe with only the variables of interest is created subsetting the complete dataframe.
The selected elements of the dataframe with the variable names are used to name the variables of the new dataframe containing the observations of interest.

The "activity" variable is transformed into a "factor" and its levels are modified using the names of the "activities" read from the relevant file.

The new dataframe is grouped by "subject ID" and "activity" and copied into another dataframe, that is used to calculate the mean for each measurement via a "do.call" function using as argument the function "summarize".

The obtained dataset is then rearranged (using gather() function of "tidyr" package) to transform into values of a new variable, called "measurement", the names of the columns corresponding to the derived quantities, and put in the variable "mean" the calculated value.