# Alzheimers-Prediction
This research project involved using ICD-9 diagnosis codes from Medicare Insurance claims data to predict whether an individual would later develop Alzheimer's. The project involved converting the data from a wide form to long-form within SAS and then exporting the file into R. There, I trained a number of supervised machine learning methods on the data to create my predictions.

My involvement with the project began back in early June when Danny Hughes, the head of the Georgia Institute of Technology's Health Economics and Analytics Labratory emailed me a PowerPoint containing the results of his collaboration with colleagues in Louisville. He initially tasked me with replicating the three models in the PowerPoint and running a logistic regression on them. 

The base data is provided in a SAS file named “export_matched_patients”. I made an exact copy to use for my project. Before making the three models, Danny asked that I make some minor edits to the data. He asked that I cut the nine-digit ZIP codes down to their five-digit base, and he asked that I ensure all Line Diagnosis Codes were length five by appending zeros to any shorter than that length. 
 
After these edits, I created the three models by cutting the data down to the necessary information and transposing that information into the final required form. As part of the transposing process, null values were introduced into cells not containing any information. To avoid errors in the coming data analysis, I replaced all null values with zeros. In addition, I created a program to verify that no data had been lost in the previous processes. This program checked all three models to ensure that they contained the same number of line diagnosis codes, Alzheimer’s patients, Non-Alzheimer’s patients, and total observations as the base data. Finally, I ordered the line diagnosis codes by alphabetical order, so any relationships between related codes could be quickly identified in the data analysis.        

Model 1 displays the number of times a patient had a particular line diagnosis code. Model 2 displays a binary value describing whether a patient had a particular line diagnosis code. A value of 1 indicates that the patient had a particular code, and a value of 0 indicates that the patient did not have a particular code. Model 3 displays the number of years prior to January 1st 2012 that a patient had a particular line diagnosis code. So, if a patient 1 had code E81 in 2007, the value in that cell would be 5.
After creating the three models in SAS, I converted them into CSV files, so I could do my data analysis in R. After downloading the models into R and doing some minor manipulations, I attempted to run a logistic regression on all three models using the glm function. The function returned a warning saying that the model had achieved complete separation. After consulting with Danny, we determined that our line diagnosis codes were too granular and thus introducing false relationships into the models. To solve this problem, Danny suggested truncating the line diagnosis codes to three values instead of five. As the ICD 9 codes are hierarchical, removing the last two digits made each code more general and thus eliminated the relationships between codes that share the same nested groupings. After adopting his suggestion, the three models no longer suffered from complete separation.

However, another issue quickly arose. When running the glm function on the three models, it could not converge on coefficient values. After consulting with Danny on some ideas, I attempted to implement most of his suggestions. First, I increased the Fisher Scoring Iterations to 100 and then 1,000 for the glm function. This of course increased the computing time and ultimately did not resolve my issue. I next attempted to run a forward and backward stepwise logistic regression on the models. Both of these took more than nine hours to compute, so I moved on. Finally, I ran a Lasso logistic regression on the three models, and they finally converged on coefficient values. 
After finding a suitable way to train a logistic regression on the three models, I could now test them to understand their predictive power. I divided the models into training data containing 80% of the observations and testing data containing the remaining 20%. After this division, I trained the model using with the training data and then tested it with the testing data. Below is the percentage of observations the models predicted correctly. Note that I also ran a Ridge regression on the models using the same process.

	Model 1	Model 2 	Model 3
Lasso Regression	66.1%	68.9%	67.1%
Ridge Regression	59.9%	69.4%	62.8%
 
After talking to Danny about the results above, he asked that I implement two suggestions. First, he asked that I calculate the Mean Square Error (MSE) for future models, and he asked me to remove any line diagnosis codes linked to dementia. He believed that the second suggestion could lead to an improvement in our models’ performance. After talking to Danny, I implemented his suggestions and decided to also use ten-fold cross validation when calculating my models. Using this process would provide a more representative idea of the predictive power of our models. In addition, I removed code XX0 from the models as it is a place holder that does not indicate any specific condition.
As part of ten-fold cross validation, I created an R program to divided my models into ten different groups of 80% training data and 20% testing data. I then used the training data in each group to calculate the model and then tested this model using the testing data. From these predictions, I calculated the MSE and percentage of observations predicted correctly. I then repeated this process for every group and took the average of the respective values. Those values are shown below.

MSE:
	Model 1	Model 2 	Model 3
Lasso Regression	0.22	0.21	0.22
Ridge Regression	0.23	Not Calculated	Not Calculated

Percentage of Correct Predictions:
	Model 1	Model 2 	Model 3
Lasso Regression	65.0%	66.5%	63.7%
Ridge Regression	63.4%	Not Calculated	Not Calculated

In addition, I took the time to run a Linear Probability Model on the three models using ten-fold cross validation. Below are the Percentage of Correct Predictions. Note that I did not provide MSE because Linear Probability Models can provide predictions outside of [0,1], making this measure useless.

	Model 1	Model 2 	Model 3
Percentage Correct	62.9%	65.2%	61.9%
