
train_raw = read.csv(file="train.csv", header=TRUE,sep=",")
# Make some columns to be factors, instead of numeric
train_raw$Survived <- as.factor(train_raw$Survived)
train_raw$Pclass <- as.factor(train_raw$Pclass)

# Remove rows that contain NA (an inspection of data shows that 170 rows have NA in Age)
train_clean <- train_raw[rowSums(is.na(train_raw)) == 0,]

# we could remove the 1st 4th and 9th columns, as non important (id,  name, ticket no)
# but no need to, just don't include them in the formula. I just show how I could do it here.
# train_clean <- train_clean[, c(-1,-4,-9)]


# get the test data
test_raw = read.csv(file="test.csv", header=TRUE,sep=",")
# There are 86 rows with no Age data (NA), but do not remove them
# Make Pclass a factor
test_raw$Pclass <- as.factor(test_raw$Pclass)


# The is NO file with the ground truth! (initially I thought it was gender_submission.csv)


fol <- formula(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare)

# Let's start with a simple decision tree
library(rpart)
decision_tree <- rpart(fol, method="class", data=train_clean)
summary(decision_tree)

# graphical representation (needs both commands)
plot(decision_tree)
text(decision_tree)


# Make your predictions on the testing data
predictions <- predict(decision_tree, test_raw, type="class")
# Our accuracy
# We do not konw the ground truth. If we did:          mean(predictions == truth$Survived) 
# Confusion matrix
# We do ont konw the ground truth. If we did:          table(predictions, truth$Survived)


# write the redictions to a csv file to be passed to Kaggle
# it should contain 418 rows (for all the test rows) and a header with the fields. 
# I also converted the predictions from factors to numberic (and I had to subtract 1, otherwise I was getting 1 and 2)
# If I do not convert to numeric the predictions appear as "0" and "1", and I was not sure if this was allowed.
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predictions)-1), file="decision_tree.csv", row.names=FALSE)
# I also had to
# First decision tree, trained with clean data. Using R, library rpart
# Accuracy 0.78469

# Let's see the accuracy if we take all data into account, even NA age. (it's actually better!)
dtree_all <- rpart(fol, method="class", data=train_raw)
predict_all <- predict(dtree_all, test_raw, type="class")
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predictions)-1), file="dtree_all.csv", row.names=FALSE)
# Accuracy 0.79426

# Inspect the data with some scatterplots
plot(train_clean$Age, train_clean$Sex, col= train_clean$Survived)
plot(train_clean$Age, train_clean$Fare, col= train_clean$Survived)
plot(train_clean$Age, train_clean$Pclass, col= train_clean$Survived)


# SVMs 
library(e1071)

# Tune an svm with cross-validation. Start with some coarse tuned, and based on results do fine tuning
tuned <- tune(svm, fol, data = train_raw, ranges = list(cost=c(0.001, 0.01, 0.1, 1, 10, 100)))
# best cost ~10
tuned <- tune(svm, fol, data = train_raw, ranges = list(cost=seq(1,10, by=0.5))) # fine tune
# best cost ~ 4   (expected error: ~0.175)

modelsvm <- svm(fol, data=train_raw, cost=4)
predictions_svm <- predict(modelsvm, test_raw, type="class")

# predictions_svm return a short vector than 418, because they do not predict elements that have 

write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predictions_svm)-1), file="svm_clean_tuned.csv", row.names=FALSE)
# not the right length of data 

#try with Clean data
tuned <- tune(svm, fol, data = train_clean, ranges = list(cost=c(0.001, 0.01, 0.1, 1, 10, 100)))
tuned <- tune(svm, fol, data = train_clean, ranges = list(cost=seq(1,10, by=0.5)))
# best cost 3.5
svm <- svm(fol, data=train_clean, cost=3.5)
predictions_svm <- predict(modelsvm, test_raw, type="class")


fol_sansAge <- formula(Survived ~ Pclass + Sex + SibSp + Parch + Fare)
modelsvm <- svm(fol_sansAge, data=train_raw, cost=4)
# for testing if a row has a NA element then the prediction in not generated EVEN IF that parameter is not included in formula.
# It's better to delete the columns that you don't want in the test data.
test_clean <- test_raw[c(-3,-5,-8,-10,-11)]
# but there was one NA remaining. Find out where
test_clean[rowSums(is.na(test_clean)) > 0,]
#    PassengerId Pclass  Sex SibSp Parch Fare
#153        1044      3 male     0     0   NA

# "fix" it by filling in some data
test_clean[153,"Fare"] <- 0
predictions_svm <- predict(modelsvm, test_raw, type="class")
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predictions_svm)-1), file="svm_clean_sansAge.csv", row.names=FALSE)
# Accuracy 0.77512


pred_combine <- predict_all
pred_combine[names(predictions_svm)] = predictions_svm

write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(pred_combine)-1), file="svm_tree_combo.csv", row.names=FALSE)
# 0.77512



library(randomForest)

# Impute the train data
train_impute <- rfImpute(fol, train_raw)

# but how do we impute the test data?? We are missing the response 
# the test data are the important one to Impute



model_rf <- randomForest(fol, data= train_impute)
importance(model_rf)
predi_rf <- predict(model_rf, test_raw, type="class"))
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predi_rf)-1), file="rf_imputed.csv", row.names=FALSE)
# There are NAs written !

# get rif of NA
predi_rf_replNA <- predi_rf 
predi_rf_replNA[is.na(predi_rf_replNA)] <- 0
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(predi_rf_replNA)-1), file="rf_imputed.csv", row.names=FALSE)
# 0.76077 




tuned <- tune(svm, fol, data = train_impute, ranges = list(cost=c(0.001, 0.01, 0.1, 1, 10, 100)))
tuned <- tune(svm, fol, data = train_impute, ranges = list(cost=c(seq(0.1,0.9,0.1), seq(1,10,1))))
# variation of best result between 0.8 and 5


svm_impute <- svm(fol, data=train_impute, cost=3)
# 387 SVs
predict_impute <- predict(svm_impute, test_raw, type="class")
# the test data are not Imputed!


pred_comb2 <- predi_rf_replNA
pred_comb2[names(predict_impute)] = predict_impute
write.csv(data.frame(PassengerID = test_raw$PassengerId, Survived=as.numeric(pred_comb2)-1), file="svm_imputed.csv", row.names=FALSE)
# 0.79904. best yet, but still not that great.

