Codebook
========

Variable list and descriptions
------------------------------

Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
featCount        | Feature: Count of data points used to compute average
featAverage      | Feature: Average of each variable for each activity and each subject
activity         | Activity name
featDomain       | Feature: Time domain signal or frequency domain signal (Time or Freq)
featInstrument   | Feature: Measuring instrument (Accelerometer or Gyroscope)
featAcceleration | Feature: Acceleration signal (Body or Gravity)
featVariable 	 | Feature: Variable (Mean or SD)
featJerk 	 | Feature: Jerk signal
featMagnitude 	 | Feature: Magnitude of the signals calculated using the Euclidean norm
featAxis         | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)



Structure
---------
str(dt)

Classes ‘data.table’ and 'data.frame':	679734 obs. of  16 variables:
 $ featureCode     : chr  "V121" "V121" "V121" "V121" ...
 $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activityNum     : int  6 6 6 6 6 6 6 6 6 6 ...
 $ activityName    : chr  "LAYING" "LAYING" "LAYING" "LAYING" ...
 $ value           : num  0.03155 0.00926 -0.01342 -0.02496 -0.02955 ...
 $ featureNum      : int  121 121 121 121 121 121 121 121 121 121 ...
 $ featureName     : chr  "tBodyGyro-mean()-X" "tBodyGyro-mean()-X" "tBodyGyro-mean()-X" "tBodyGyro-mean()-X" ...
 $ activity        : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ feature         : Factor w/ 66 levels "fBodyAcc-mean()-X",..: 43 43 43 43 43 43 43 43 43 43 ...
 $ featDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
 $ featInstrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
 $ featAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
 $ featVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 1 1 1 1 1 1 1 ...
 $ featJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 1 1 ...
 $ featMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 1 1 1 1 ...
 $ featAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 2 2 2 2 2 2 2 2 2 ...
 - attr(*, ".internal.selfref")=<externalptr> 
 - attr(*, "sorted")= chr  "subject" "activity" "featDomain" "featAcceleration" ...


List the key variables in the data table
----------------------------------------
key(dt)
[1] "subject"          "activity"         "featDomain"       "featAcceleration" "featInstrument"   "featJerk"        
[7] "featMagnitude"    "featVariable"     "featAxis"        



Show a few rows of dataset
--------------------------

dt
        featureCode subject activityNum     activityName       value featureNum               featureName
     1:        V121       1           6           LAYING  0.03155195        121        tBodyGyro-mean()-X
     2:        V121       1           6           LAYING  0.00925711        121        tBodyGyro-mean()-X
     3:        V121       1           6           LAYING -0.01342439        121        tBodyGyro-mean()-X
     4:        V121       1           6           LAYING -0.02495981        121        tBodyGyro-mean()-X
     5:        V121       1           6           LAYING -0.02955039        121        tBodyGyro-mean()-X
    ---                                                                                                  
679730:        V517      30           2 WALKING_UPSTAIRS -0.28755322        517 fBodyBodyAccJerkMag-std()
679731:        V517      30           2 WALKING_UPSTAIRS -0.32337205        517 fBodyBodyAccJerkMag-std()
679732:        V517      30           2 WALKING_UPSTAIRS -0.32630192        517 fBodyBodyAccJerkMag-std()
679733:        V517      30           2 WALKING_UPSTAIRS -0.37807723        517 fBodyBodyAccJerkMag-std()
679734:        V517      30           2 WALKING_UPSTAIRS -0.28722743        517 fBodyBodyAccJerkMag-std()
                activity                   feature featDomain featInstrument featAcceleration featVariable featJerk
     1:           LAYING        tBodyGyro-mean()-X       Time      Gyroscope               NA         Mean       NA
     2:           LAYING        tBodyGyro-mean()-X       Time      Gyroscope               NA         Mean       NA
     3:           LAYING        tBodyGyro-mean()-X       Time      Gyroscope               NA         Mean       NA
     4:           LAYING        tBodyGyro-mean()-X       Time      Gyroscope               NA         Mean       NA
     5:           LAYING        tBodyGyro-mean()-X       Time      Gyroscope               NA         Mean       NA
    ---                                                                                                            
679730: WALKING_UPSTAIRS fBodyBodyAccJerkMag-std()       Freq  Accelerometer             Body           SD     Jerk
679731: WALKING_UPSTAIRS fBodyBodyAccJerkMag-std()       Freq  Accelerometer             Body           SD     Jerk
679732: WALKING_UPSTAIRS fBodyBodyAccJerkMag-std()       Freq  Accelerometer             Body           SD     Jerk
679733: WALKING_UPSTAIRS fBodyBodyAccJerkMag-std()       Freq  Accelerometer             Body           SD     Jerk
679734: WALKING_UPSTAIRS fBodyBodyAccJerkMag-std()       Freq  Accelerometer             Body           SD     Jerk
        featMagnitude featAxis
     1:            NA        X
     2:            NA        X
     3:            NA        X
     4:            NA        X
     5:            NA        X
    ---                       
679730:     Magnitude       NA
679731:     Magnitude       NA
679732:     Magnitude       NA
679733:     Magnitude       NA
679734:     Magnitude       NA