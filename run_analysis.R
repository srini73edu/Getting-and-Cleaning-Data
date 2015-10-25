setwd("C:/Srini/R/downloads/ProgramAssignment")
# Read Training Data
training <- read.table("UCI HAR Dataset/train/X_train.txt")
training[,562] <- read.table("UCI HAR Dataset/train/Y_train.txt")
training[,563] <- read.table("UCI HAR Dataset/train/subject_train.txt")
# Read Testing Data
testing <- read.table("UCI HAR Dataset/test/X_test.txt")
testing[,562] <- read.table("UCI HAR Dataset/test/Y_test.txt")
testing[,563] <- read.table("UCI HAR Dataset/test/subject_test.txt")
#Read Activity Labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
#Read Features
features <- read.table("UCI HAR Dataset/features.txt")

# Merge training and test sets together
allData = rbind(training, testing)

# Read features and make the feature names better suited for R with some substitutions
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Get only the data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
# First reduce the features table to what we want
features <- features[colsWeWant,]
# Now add the last two columns (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)
# And remove the unwanted columns from allData
allData <- allData[,colsWeWant]
# Add the column names (features) to allData
colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))

#Replace activity code with the corresponding activity value
allData$activity <- activityLabels$V2[allData$activity]

id_labels <- c("activity","subject")
data_labels <- setdiff(colnames(allData), id_labels)
melt_data <- melt(allData, id = id_labels, measure.vars = data_labels)
# Apply mean function to dataset using dcast function
tidy_data <- dcast(melt_data, subject + activity ~ variable, mean)

#Writing to tidy.txt file
write.table(tidy_data, "tidy.txt", sep="\t", row.name=FALSE)
