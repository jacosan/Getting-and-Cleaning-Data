# Load features & trasnform to factor
features <- read.table("UCI HAR Dataset/features.txt")
features <- as.factor(features$V2)

###### TEST DATA ######

# Load X_test and name columns as features
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(X_test) = features

# Creates labeled activity table with y_test index
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
act_labels <- as.factor(act_labels$V2)
activity_table = as.data.table(act_labels[y_test$V1])
setnames (activity_table, "V1", "Activity_Label")

# Loads subject_test 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
setnames(subject_test, "V1", "Subject_ID")

# Bind Test Data
test_data <- cbind (subject_test, activity_table, as.data.table(X_test))

######   TRAIN DATA ######

# Load X_train and name columns as features
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(X_train) = features

# Create labeled activity table with y_train index
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activity_table = as.data.table(act_labels[y_train$V1])
setnames (activity_table, "V1", "Activity_Label")

# Loads subject_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
setnames(subject_train, "V1", "Subject_ID")

# Bind Train Data
train_data <- cbind (subject_train, activity_table, as.data.table(X_train))

###### MERGED DATA ######
# Merge Test and Train data
raw_data = rbind(test_data, train_data)

# Extract mean and sd and creates clean_data set
mean_sd_Index <- grep("mean\\(\\)|std\\(\\)", features)
clean_data <- raw_data[, mean_sd_Index]

# Change columns labels 
names(clean_data) <- gsub('-mean', ' Mean ', names(clean_data))
names(clean_data) <- gsub('-std', ' Std ', names(clean_data))
names(clean_data) <- gsub('[()-]','', names(clean_data))

# Create tidy data set
clean_data$Subject_ID <- as.factor(clean_data$Subject_ID)
tidy_ds = aggregate(clean_data, by=list(Subject_ID = clean_data$Subject_ID, Activity_Label = clean_data$Activity_Label), mean)
tidy_ds[,4] = NULL
tidy_ds[,3] = NULL

## Create file with tidy_ds dataset
write.table(tidy_ds, "tidy_ds_v2.txt", row.names = FALSE)
