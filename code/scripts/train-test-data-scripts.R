# Training and Testing

# importing the data
scaled_schools <- read.table('../../data/scaled-schools.csv', header=TRUE, sep=',')


set.seed(2)
# create training data
train_ids <- sample(1:nrow(scaled_schools), round(nrow(scaled_schools)*.75,0), replace = FALSE)
train <- scaled_schools[train_ids,]
test <- scaled_schools[-train_ids,]
test_ids <- as.numeric(factor(row.names(test)))

save(train, test, train_ids, test_ids,scaled_schools, file = "../../data/train-test.RData")
