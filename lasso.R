#Importing Packages ####
library(tidyverse)
library(caret)
library(glmnet)
# Setting Working Directory ####
path = "C:\\Users\\sgyorfi3\\Documents\\My SAS Files\\Model1"

setwd(path)

#Importing Data ####

data = read.csv("Model1.csv", header = TRUE)


#Data Manipulating ####
data = data[,-1]

#Creating Testing and Training Sets####
set.seed(123)
splits = createFolds(data$Alz, k= 10, list = FALSE, returnTrain = FALSE)
data = cbind(data,splits)

set1train = model.matrix(Alz~.,data[splits != 1,])[,c(-1,-4269)] 
set1test = model.matrix(Alz~.,data[splits == 1,])[,c(-1,-4269)]

set2train = model.matrix(Alz~.,data[splits != 2,])[,c(-1,-4269)]
set2test = model.matrix(Alz~.,data[splits == 2,])[,c(-1,-4269)]

set3train = model.matrix(Alz~.,data[splits != 3,])[,c(-1,-4269)]
set3test = model.matrix(Alz~.,data[splits == 3,])[,c(-1,-4269)]

set4train = model.matrix(Alz~.,data[splits != 4,])[,c(-1,-4269)]
set4test = model.matrix(Alz~.,data[splits == 4,])[,c(-1,-4269)]

set5train = model.matrix(Alz~.,data[splits != 5,])[,c(-1,-4269)]
set5test = model.matrix(Alz~.,data[splits == 5,])[,c(-1,-4269)]

set6train = model.matrix(Alz~.,data[splits != 6,])[,c(-1,-4269)]
set6test = model.matrix(Alz~.,data[splits == 6,])[,c(-1,-4269)]

set7train = model.matrix(Alz~.,data[splits != 7,])[,c(-1,-4269)]
set7test = model.matrix(Alz~.,data[splits == 7,])[,c(-1,-4269)]

set8train = model.matrix(Alz~.,data[splits != 8,])[,c(-1,-4269)]
set8test = model.matrix(Alz~.,data[splits == 8,])[,c(-1,-4269)]

set9train = model.matrix(Alz~.,data[splits != 9,])[,c(-1,-4269)]
set9test = model.matrix(Alz~.,data[splits == 9,])[,c(-1,-4269)]

set10train = model.matrix(Alz~.,data[splits != 10,])[,c(-1,-4269)]
set10test = model.matrix(Alz~.,data[splits == 10,])[,c(-1,-4269)]

#Running Lasso/Ridge Regressions####

val1 = list(set1train,data[splits != 1, 1],set1test,data[splits == 1,1])
val2 = list(set2train,data[splits  != 2,1], set2test, data[splits == 2,1])
val3 = list(set3train,data[splits  != 3,1], set3test, data[splits == 3,1])
val4 = list(set4train,data[splits  != 4,1], set4test, data[splits == 4,1])
val5 = list(set5train,data[splits  != 5,1], set5test, data[splits == 5,1])
val6 = list(set6train,data[splits  != 6,1], set6test, data[splits == 6,1])
val7 = list(set7train,data[splits  != 7,1], set7test, data[splits == 7,1])
val8 = list(set8train,data[splits  != 8,1], set8test, data[splits == 8,1])
val9 = list(set9train,data[splits  != 9,1], set9test, data[splits == 9,1])
val10 = list(set10train,data[splits  != 10,1], set10test, data[splits == 10,1])

in_list = list(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10)

Lasso_Calculator <- function(inp) {
  avg_MSE = 0
  avg_correct = 0 
  
  for (val in inp) {
    cv.lasso <- cv.glmnet(val[[1]],val[[2]], alpha = 0, family = "binomial")
    lasso.model <- glmnet(val[[1]], val[[2]], alpha = 0, family = "binomial", lambda = cv.lasso$lambda.min)
    probabilities <- lasso.model %>% predict(newx = val[[3]], type = "response")
    predicted.classes <- ifelse(probabilities > 0.5, 1, 0)
    observed.classes <- val[[4]]
    correct = mean(predicted.classes == observed.classes)
    MSE = Reduce( '+',(observed.classes - probabilities)^2)/length(probabilities)
    avg_MSE = avg_MSE + MSE
    avg_correct = avg_correct +correct
    
  }
  avg_MSE = avg_MSE/length(inp)
  avg_correct = avg_correct/length(inp)
  out = list(avg_MSE,avg_correct)
  return(out)
}
#Creating Testing and Training Sets ####
set1train = (data[splits != 1,])[,c(-4269)]
set1test = (data[splits == 1,])[,c(-4269)]

set2train = (data[splits != 2,])[,c(-4269)]
set2test = (data[splits == 2,])[,c(-4269)]

set3train = (data[splits != 3,])[,c(-4269)]
set3test = (data[splits == 3,])[,c(-4269)]

set4train = (data[splits != 4,])[,c(-4269)]
set4test = (data[splits == 4,])[,c(-4269)]

set5train = (data[splits != 5,])[,c(-4269)]
set5test = (data[splits == 5,])[,c(-4269)]

set6train = (data[splits != 6,])[,c(-4269)]
set6test = (data[splits == 6,])[,c(-4269)]

set7train = (data[splits != 7,])[,c(-4269)]
set7test = (data[splits == 7,])[,c(-4269)]

set8train = (data[splits != 8,])[,c(-4269)]
set8test = (data[splits == 8,])[,c(-4269)]

set9train = (data[splits != 9,])[,c(-4269)]
set9test = (data[splits == 9,])[,c(-4269)]

set10train = (data[splits != 10,])[,c(-4269)]
set10test = (data[splits == 10,])[,c(-4269)]

#Running Linear Probability Model####

val1 = list(set1train,set1test)
val2 = list(set2train,set2test)
val3 = list(set3train,set3test)
val4 = list(set4train,set4test)
val5 = list(set5train,set5test)
val6 = list(set6train,set6test)
val7 = list(set7train,set7test)
val8 = list(set8train,set8test)
val9 = list(set9train,set9test)
val10 = list(set10train,set10test)

in_list = list(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10)

# Function below calculates Mean Square Error for Lasso and Ridge Regressions

LPM_Calculator <- function(inp) {
  avg_MSE = 0
  avg_correct = 0 
  for (val in inp) {
  
    model = lm(Alz~., data = val[[1]])
    predictions = predict.lm(model, val[[2]][,2:4268])
    rounded_predictions = ifelse(predictions > 0.5, 1, 0)
    observed_results = val[[2]][[1]]
    correct = mean(rounded_predictions == observed_results)
    MSE = Reduce( '+',(observed_results - predictions)^2)/length(predictions)
    print(MSE)
    print(correct)
    avg_MSE = avg_MSE + MSE
    avg_correct = avg_correct +correct
  }
  
  avg_MSE = avg_MSE/length(inp)
  avg_correct = avg_correct/length(inp)
  out = list(avg_MSE,avg_correct)
  return(out)
}

