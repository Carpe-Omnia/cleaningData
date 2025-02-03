  ##Loading DPLYR for easier manipulation of data
  library(dplyr)
  
  ##checking to see if the file already exists on the system
  ##if not downloads the file and unzips it 
  rawDataFileName <- "getdata_projectfiles_UCI HAR Dataset.zip"
  if (file.exists(rawDataFileName) != TRUE){
    rawDataFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
    download.file(rawDataFileURL, destfile = rawDataFileName)
  }
  
  ##creating text strings for relative directories
  dataDirectory <- "./UCI HAR DATASET"
  trainingDirectory <- paste(dataDirectory, "train/", sep="/")
  testDirectory <- paste(dataDirectory, "test/", sep="/")
  
  ##creating text strings for data directly in the data folder
  featuresPath <- paste(dataDirectory, "/features.txt", sep="")
  activityLabelsPath <- paste(dataDirectory, "/activity_labels.txt", sep="")
  
  ##creating text strings for training data paths
  trainingXPath <- paste(trainingDirectory, "X_train.txt", sep="")
  trainingYPath <- paste(trainingDirectory, "y_train.txt", sep="")
  trainingSubjectPath <- paste(trainingDirectory, "subject_train.txt", sep="")
  
  ##creating text strings for test data paths
  testXPath <- paste(testDirectory, "X_test.txt", sep="")
  testYPath <- paste(testDirectory, "y_test.txt", sep="")
  testSubjectPath <- paste(testDirectory, "subject_test.txt", sep="")
  
  ##Checking to see if one of the files exists already. If not, unzips the downloaded raw data folder
  if(file.exists(trainingXPath) != TRUE){
    unzip(rawDataFileName)
  }
  
  ##loading features and activity labels into memory
  ##put this here because they aren't nested deeper in the file structure
  features <- read.table(featuresPath, col.names=c("code", "feature"))
  activityLabels <- read.table(activityLabelsPath, col.names=c("code", "activity"))
  
  ##loading training Data into memory
  trainingX <- read.table(trainingXPath, col.names = features$feature)
  trainingY <- read.table(trainingYPath, col.names = "activity")
  trainingSubject <- read.table(trainingSubjectPath, col.names = "subjectNumber")
  
  ##loading test Data into memory
  testX <- read.table(testXPath, col.names = features$feature)
  testY <- read.table(testYPath, col.names = "activity")
  testSubject <- read.table(testSubjectPath, col.names = "subjectNumber")
  
  ##combining test and training data into one set
  combinedX <- rbind(trainingX ,testX )
  combinedY <- rbind(trainingY, testY)
  combinedSubject <- rbind(trainingSubject, testSubject)
  
  ##Give descriptive activity names to the activities in the data set
  ##Does this by iterating through each row and replacing the number with it's corresponding 
  ##verbal counterpart from the activity labels dataset
  ##This pre-accomplishes step 3 
  for(i in 1:nrow(combinedY)){
    activityNumber <- combinedY[i, 1]
    combinedY[i, 1] <- activityLabels[activityNumber, 2]
  }
  
  ##combining all data elements into one data frame
  ##This accomplishes step 1 from the assignment
  combinedData <- data.frame(subject = combinedSubject, activity = combinedY)
  combinedData <- cbind(combinedData, combinedX)
  View(combinedData)
  
  ##Refining the data to only include averages and standard deviation columns
  ##This accomplishes step 2 from the assignment
  refinedData <- select(combinedData, subjectNumber, activity, contains("mean"), contains("std"))
  
  ##Clarifying a few of the names I thought were hard to read
  ##This accomplishes step 4
  names(refinedData)<-sub("^f", "frequency", names(refinedData))
  names(refinedData)<-sub("^t", "time", names(refinedData))
  View(refinedData)
  
  if(file.exists("tidyData.txt") != TRUE){
    write.table(refinedData, file="myTidyData.txt", row.names = FALSE )
  }
  
  ##Creating summary data for each test subject and activity
  ##This accomplishes step 5
  summaryData <- group_by(refinedData, subjectNumber, activity)
  summaryData <- summarize_all(summaryData, mean)
  View(summaryData)
  if(file.exists("summaryData.txt") != TRUE){
    write.table(summaryData, file="mySummaryData.txt", row.names = FALSE )
  }
