## Introduction

This codebook describes how the tidy dataset was created from the
original data collected from the accelerometers from the Samsung Galaxy
S smartphone, described at

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

and available at

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

Here the variables, the data and the transformations are described.

## The original data & the variables

The original data consists in the training and test datasets, with the
corresponding features and lables data.

-   The number of measurements (available records) is:
    -   7352 for the training set
    -   2947 for the testing set  
-   The number of labels is 6. The labels are coded numerically (*i.e.*
    1,2,..6) in both the training and testing sets.
-   The labels activity is the following:

<table>
<thead>
<tr class="header">
<th>Numerical Label</th>
<th>Descriptive Label</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>WALKING</td>
</tr>
<tr class="even">
<td>2</td>
<td>WALKING_UPSTAIRS</td>
</tr>
<tr class="odd">
<td>3</td>
<td>WALKING_DOWNSTAIRS</td>
</tr>
<tr class="even">
<td>4</td>
<td>SITTING</td>
</tr>
<tr class="odd">
<td>5</td>
<td>STANDING</td>
</tr>
<tr class="even">
<td>6</td>
<td>LAYING</td>
</tr>
</tbody>
</table>

-   The number of features is 561 and their names are available in the
    *features.txt* file. 79 out of the 561 features are obtained from
    activities by averaging (mean) or dispertion computation (std).

The goal of the tidy data set is to be build from the original data
accounting only for these 79 mean/std related features.

## Transformations

The tidy data set is obtained via the following procedure:

-   Reading the training data, adding the names, bindining it:

    1.  The training features dataframe `Xtr` is read and the feature
        names are added.
    2.  The training labels dataframe `ytr` is read and the “label” name
        is added.
    3.  The `train` data frame is obtained from two dataframes by
        binding them, with the labels column being the last.
        (`dim(train) = (7352, 562)`)

-   Reading the testing data, adding the names, bindining it:

    1.  The testing features dataset `Xte` is read and the feature names
        are added.
    2.  The testing labels dataset `yte` is read and the “label” name is
        added.
    3.  The `test` data frame is obtained from two dataframes by binding
        them, with the labels column being the last.
        (`dim(test) = (2947, 562)`)

-   Data merging: The `training` and `testing` dataframes are merged
    into the `DF` dataframe. (`dim(DF) = (10299, 562)`)

-   Descriptive activity names are used instead of the numerical values
    for the activity lables, using the values from the Table.

-   The dataframe `df` is extracted from `DF`, by considering only the
    79 columns that are mean or std activity related.
    (`dim(df) = (10299, 80)`)

-   The independent tidy data frame `df_means` obtained by considering
    the average of each variable for each activity in `df` is created.
    (`dim(df_means) = (6, 80)`)

-   The independent tidy data frame `df_means` is saved as a *.csv* file
    dataset: *tidydata.csv*.
