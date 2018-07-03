# Getting-and-Cleaning-Data-Project

The run_analysis.R program will do the following:

* Check if the UCI HAR dataset is present.  If it isn't it will be downloaded and unzipped to the working directory.
* It will find all the training data and test data for data columns containing mean or std variables
* It will column bind the subjects and activities on to the two data sets
* It will merge the train and test sets into one file
* It will change the names of the variables to be more readable and change the activities to their factor names
* Finally, it will melt the table by the two key factors, Subject and Activity and cast that to arrive at the means of the factors
* The final table will be stored to teh working directory as "tidy.txt"
