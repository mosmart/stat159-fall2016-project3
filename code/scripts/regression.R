# Regression
library(DAAG)

# import data
scaled_schools <- read.csv("../../data/scaled-schools.csv", header=TRUE)

# get just types of majors and stem major
features <- c("MN_EARN_WNE_MALE0_P6", "ADM_RATE",
              "SATMTMID", "STEM_DEG_WOMEN", "COUNT_WNE_MALE0_P6",
              "WOMENONLY", "HIGHDEG4")
regression_data <- scaled_schools[, features]

# OLS with 10-fold cross validation
regression <- lm(MN_EARN_WNE_MALE0_P6 ~., data = regression_data)
cv <- CVlm(regression_data, regression, m=10, seed=29)
cv_ms <- attr(cv, "ms")

# save results
save(regression,cv,cv_ms, file = "../../data/regression-results.RData")