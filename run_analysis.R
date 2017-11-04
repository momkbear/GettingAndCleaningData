##Week 4 Assignment, 
##Review Criteria
#       The submitted data set is tidy.
#       The Github repo contains the required scripts.
#       GitHub contains a code book that modifies and updates the available 
#       codebooks with the data to indicate all the variables and summaries calculated, 
#       along with units, and any other relevant information.
#       The README that explains the analysis files is clear and understandable.
#       The work submitted for this project is the work of the student who submitted it.

#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
##Extract
library(RCurl)
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, "Dataset.zip")
unzip("Dataset.zip")
setwd("C:/Users/JKK/Assignments/gacd/UCIDT") ##In explorer renamed folder UCIDT

##Get and organize tables
library(dplyr)
setwd("C:/Users/JKK/Assignments/gacd/UCIDT")
activitylables <- read.table("activity_labels.txt") 
features <- read.table("features.txt") 

setwd("C:/Users/JKK/Assignments/gacd/UCIDT/train")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

setwd("C:/Users/JKK/Assignments/gacd/UCIDT/Test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

## create a train and a test dataset
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)  

## merge the training and the test sets to create one data set.
dataset <- rbind(train, test)

## adding features names
feature_names <- as.vector(features[, 2]) 
colnames(dataset) <- c("id", "activity_labels", feature_names)

##replace activity codes with activity lables
activity_names <- as.vector(activitylables[, 2])
dataset$activity_labels <- factor(dataset$activity_labels, 
                                  levels = c(1:6),
                                  labels = activity_names)

# Extracts only the measurements on the mean and standard deviation for each measurement.
col_index <- grep("id|activity|mean|std", names(dataset))
newdt <- dataset[, col_index]
newdt <- select(newdt, -contains("Freq"))
head(newdt)

#   Appropriately labels the data set with descriptive variable names.
tolower(names(newdt))
names(newdt) <- gsub(pattern = "\\(\\)", replacement = "", x = names(newdt))
names(newdt) <- gsub(pattern = "-", replacement = "", x = names(newdt))
names(newdt) <- gsub(pattern = "BodyBody", replacement = "Body", x = names(newdt))
names(newdt) <- sub(pattern = "t", replacement = "time", x = names(newdt))
names(newdt) <- sub(pattern = "f", replacement = "freq", x = names(newdt))
head(newdt)

#   From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.
newdt2 <- melt(newdt, id.vars = c("id","activity_labels"))
meandt <- dcast(newdt2, formula = id + activity_labels ~ variable, fun.aggregate = mean)
head(newdt2)
head(meandt)

## save the dataset
write.table(meandt, file = "tidydataset.txt")

##Helpful example https://github.com/paderifabio/run_analysis/blob/master/run_analysis.R

