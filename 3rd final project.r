# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set

## start

x.data <- read.table("test/X_test.txt")
x.label <- read.table("test/y_test.txt", col.names="label")
x.subject <- read.table("test/subject_test.txt", col.names="subject")
y.data <- read.table("train/X_train.txt")
y.label <- read.table("train/y_train.txt", col.names="label")
y.subject <- read.table("train/subject_train.txt", col.names="subject")
data <- rbind(cbind(x.subjects, x.labels, x.data),
              cbind(y.subjects, y.labels, y.data))

## get features and the mean/std
z.data <- read.table("features.txt", strip.white=TRUE)
z.data.mean.std <- z.data[grep("mean\\(\\)|std\\(\\)", z.data$V2), ]
data.mean.std <- data[, c(1, 2, z.data.mean.std$V1+2)]

## continue
activity_labels <- read.table("activity_labels.txt")
data.mean.std$label <- activity_labels[data.mean.std$label, 2]
good.colnames <- c("subject", "label", z.data.mean.std$V2)
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
colnames(data.mean.std) <- good.colnames

## get the mean
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

## put out
write.table(format(aggr.data, scientific=T), "tidy_data.txt", row.name=F, col.names=F, quote=2)