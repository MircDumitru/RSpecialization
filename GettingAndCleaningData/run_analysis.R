# Reading the training sets

# Task 1 - Merges the training and the test sets to create one data set.

# Get the column names from the "features.txt" file
featureNamesDf <- read.table('./UCIHARDataset/features.txt')
featureNames <- featureNamesDf$V2

# Training data
# Get the Xtr dataframe from 'train/X_train.txt' and set the column names
Xtr <- read.table('./UCIHARDataset/train/X_train.txt',
                  col.names = featureNames)
# print(dim(Xtr))
# print(Xtr[1:5,1:5])

# Get the ytr dataframe from 'train/y_train.txt' and set the column name as label
ytr <- read.table('./UCIHARDataset/train/y_train.txt',
                  col.names = c("label"))
# print(dim(ytr))
# print(Xtr[1:5,1])

# Get the train dataframe by column biding the Xtr and ytr (lables are the 
# last column)
train <- cbind(Xtr, ytr)
print(dim(train))
print(train[1:5,1:5])


# Testing data
# Get the Xte dataframe from 'test/X_test.txt' and set the column names
Xte <- read.table('./UCIHARDataset/test/X_test.txt',
                  col.names = featureNames)
# print(dim(Xte))
# print(Xte[1:5,1:5])

# Get the yte dataframe from 'test/y_test.txt' and set the column name as label
yte <- read.table('./UCIHARDataset/test/y_test.txt',
                  col.names = c("label"))
# print(dim(yte))
# print(Xte[1:5,1])

# Get the test dataframe by column biding the Xte and yte (lables are the 
# last column)
test <- cbind(Xte, yte)
print(dim(test))
print(test[1:5,1:5])

# Merging data

DF <- merge(train,test,all = TRUE)
print(dim(DF))
print(DF[1:5,1:5])

# Task 2 - Extracts only the measurements on the mean and standard 
# deviation for each measurement. 

# Get the positions of the mean & std measurements via grep and add the 
# last column (correspondint to the labels)

positions <- c(grep("mean|std", featureNames), ncol(DF))
df <- DF[,positions]
print(names(df))
print(dim(df))
print(df[1:5, 1:5])

# Task 3 - Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table('./UCIHARDataset/activity_labels.txt')
descriptiveActivity <- function(x){activityLabels[x,2]}
df$label <- sapply(df$label, descriptiveActivity)
print(df[1:5, (ncol(df)-5):ncol(df)])

# Task 4 - it is done at the start.

# Task 5 - From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
# The tidy data frame is df_means;
# The tidy data frame is saved in the data file as tidydata.csv
df_groups <- group_by(df, label)
df_means <- as.data.frame(summarise(df_groups, across(everything(), mean, na.rm=TRUE)))
print(df_means[, 1:5])
write.csv(df_means, file = "./data/tidydata.csv",  row.names = TRUE)
