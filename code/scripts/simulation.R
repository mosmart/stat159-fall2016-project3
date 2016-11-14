# load regression: regression,cv,cv_ms
load("../../data/regression-results.RData") 

# load scaled-schools
load("../../data/test-training.RData")

weights <- regression$coefficients