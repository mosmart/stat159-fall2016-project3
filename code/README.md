# Code
---
### Scripts

`data-processing-script.R` loads the raw data from 2014 and 2012, cleans the data, takes a subset of the regressors, computes some new linear combinations of predictors, and saves a copy of the subsetted data as well as a scaled version of the same data.

`eda-script.R` computes and saves summary statistics from the un-scaled data, a histogram of each regressors distribution, a scatterplot matrix, and a correlation matrix.

`regression.R` preforms a linear regression using the scaled data, saving the outputed model.

`session-info-script.R` creates `session-info.txt`, a .txt file with all current program versions.

`simulation.R` runs a simulation to predict the top schools to recruit from, saving the outputted list.

`train-test-data-script.R` splits the scaled data into test and training sets for cross validation.