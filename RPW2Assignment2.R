#Assignment 2 - Specdata

#Write a code to get a bunch of files, combine them into one table (probably wrong term) and then take the mean of two of the columns

#GET A BUNCH OF FILES
#Move to assignments working directory
    getwd()
    setwd("C:/Users/JKK/Assignments/")

#Download specdata zipfile, borrowed url from 'aurquhart' from Github
    dataset_url <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip"
    download.file(dataset_url, "specdata.zip")
    
#Unzip file
    unzip("specdata.zip", exdir = "specdata")

#Confirm file unzipped
    list.files("specdata")

#Set working directory to new area
    setwed("C:/Users/JKK/Assignments/specdata")
        
##COMBINE FILES INTO ONE TABLE
#Define terms
    directory <- "specdata" #names the files in specdata "directory"   
    fileslist <- list.files(directory, full.names=TRUE) #takes the list of files in the direcory applying the filepath (full.name func)
    
#Create a blank table (aka empty data frame)
    datatable <-data.frame() 
    Countfiles <- length(files)
    
 #Fill in the table (aka loop through files and rbind)
    for (i in Countfiles) {
        datatable <- rbind(datatable, read.csv(fileslist[i])) #we're goint to call the new talbe we're going to fill the same thing as the empty table.  Then fill empty table "datatable" with the csv files in fileslist    
    }
 #Confirm it worked by showing header
    head(fileslist)
    
 #Label the Columns
   colnames(datatable) = datatable [1, ] #row 1 = headers
   datatable = datatable [-1, ] #remove row 1
    
##TAKE MEAN OF SPECIFIC COLUMNS
    mean(datatable[,"sulfate"], na.rm = TRUE) #mean of column in table called sulfate excluding null rows or rows w/NA in that column
    mean(datatable[,"nitrate"], na.rm = TRUE)
    
##CODE THAT ACTUALLY WORKS 
    pollutantmean <- function(directory, pollutant, id = 1:332) {
        files <- list.files(directory, full.names=TRUE)
        dat <- data.frame()
        
        for(i in id)
        {
            dat <- rbind(dat, read.csv(files[i]))
        }
        
        mean_data <- mean(dat[,pollutant], na.rm = TRUE)
        round(mean_data, digits=3)
