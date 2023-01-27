==================================================================
Peer-graded Assignment: Getting and Cleaning Data Course Project
==================================================================
Mircea Dumitru
==================================================================

The assigment is based on the data collected from the accelerometers from the Samsung Galaxy S smartphone. The goal of the assignment is to build a tidy dataset, accounting for some requirements.

The data 
======================================

The original data consists in the training and test datasets, with thecorresponding features and lables data.-   The number of measurements (available records) is:    -   7352 for the training set    -   2947 for the testing set  -   The number of labels is 6. The labels are coded numerically (*i.e.*    1,2,..6) in both the training and testing sets.-   The labels activity is the following: (1-WALKING, 2-WALKING_UPSTAIRS,3-WALKING_DOWNSTAIRS,4-SITTING,5-STANDING,6-LAYING)
-   The number of features is 561 and their names are available in the *features.txt* file. 
-   79 out of the 561 features are obtained from activities by averaging (mean) or dispertion computation (std).The goal of the tidy data set is to be build from the original dataaccounting only for these 79 mean/std related features.

The script & the CookBook.md file
======================================

- the script creating the tidy data is "run_analysis.R" which uses the "dplyr" library
- the details of how the transformation are detailed in CookBook.md file.