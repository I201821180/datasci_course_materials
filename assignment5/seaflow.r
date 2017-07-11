
seaflow = read.csv(file="seaflow_21min.csv", header=TRUE,sep=",");

summary(seaflow)

# buildin plot
plot(seaflow$chl_small, seaflow$pe, col=seaflow$pop)
legend('topleft', legend = levels(seaflow$pop), col=1:length(seaflow$pop),pch=1)

# ggplot was recommended. Legend is automatically created
# load a library
library("ggplot2")
qplot(seaflow$chl_small, seaflow$pe, colour = seaflow$pop)


# this is how you sample 0.9 of the dataframe rows
training <- seaflow[sample(nrow(seaflow), 0.9*nrow(seaflow)), ]

# to separate the data in training and test data. Here they are equal sets.
randomindexes <- sample(nrow(seaflow), 0.5*nrow(seaflow))
training <- seaflow[randomindexes,]
testing <- seaflow[-randomindexes,]  # this takes the complementary 


library(rpart)

fol <- formula(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small)
model <- rpart(fol, method="class", data=training)

# predict on testing data, using the decision tree model.
# if the type is undefined, the defauls is prob, which for each row in the data returns probabilities of matching the labels
# using the type "class" though returns a class/label for each of the rows.
predictions <- predict(model, testing, type="class")

# compare the predicitons with the ground truth
matches <- predictions == testing$pop
successrate <- sum(matches)/nrow(testing)
successrate

# RANDOM FOREST
library(randomForest)
modelforest <- randomForest(fol, data=training)
#see how the model looks like
modelforest

predictions_forest <- predict(modelforest, testing, type="class")
matchesf <- predictions_forest == testing$pop
sum(matchesf)/nrow(testing)

importance(modelforest)

# SVM
library(e1071)
modelsvm <- svm(fol, data=training)
predictions_svm <- predict(modelsvm, testing, type="class")
matchessvm <- predictions_svm== testing$pop
sum(matchessvm)/nrow(testing)

# confusion matrices
table(pred = predictions, true = testing$pop)
table(pred = predictions_forest, true = testing$pop)
table(pred = predictions_svm, true = testing$pop)


# finding problems with the data by inspection. Problem: one variable takes few discrete values
plot(seaflow$pe)
plot(seaflow$fsc_big)
plot(seaflow$fsc_small)
plot(seaflow$fsc_perp)
plot(seaflow$chl_small)
plot(seaflow$chl_big)

# clean the data (remove rows with file_id == 208) and train a svm model again
seaflow_clean <- seaflow[seaflow$file_id != 208,]
ri <- sample(nrow(seaflow_clean), 0.5*nrow(seaflow_clean))
training_cl <- seaflow_clean[ri,]
testing_cl <- seaflow_clean[-ri,]

modelclean<- svm(fol, data=training_cl)
predictions_clean <- predict(modelclean, testing_cl, type="class")
matches_clean <- predictions_clean== testing_cl$pop
sum(matches_clean)/nrow(testing_cl)



