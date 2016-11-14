# load regression: regression,cv,cv_ms
load("../../data/regression-results.RData") 

# load scaled-schools
load("../../data/train-test.RData")

# load unscaled dataset
school_data <- read.csv('../../data/female-data-2014-15.csv', header=TRUE)
schools_2014 <- read.csv('../../data/MERGED2014_15_PP.csv', header=TRUE)

# view regression results
summary(regression) # see that all features are significant

# make coefficient from regression the weight of the feature
all_weights <- regression$coefficients
weights <- data.frame(all_weights[-1])
names(weights) <- "weight"

# create score for every school
school_data$SCORE <- scaled_schools$ADM_RATE*weights["ADM_RATE",] +
  scaled_schools$SATMTMID*weights["SATMTMID",] + scaled_schools$STEM_DEG_WOMEN*weights["STEM_DEG_WOMEN",] +
  scaled_schools$COUNT_WNE_MALE0_P6*weights["COUNT_WNE_MALE0_P6",] + scaled_schools$WOMENONLY*weights["WOMENONLY",] +
  scaled_schools$HIGHDEG4*weights["HIGHDEG4",]

# Number of female recruits is STEM_DEG_WOMEN

# get institution name and location
school_info <- c("UNITID", "INSTNM", "CITY")
info <- schools_2014[,school_info]
schools_with_info <- merge(school_data, info, by =  "UNITID")

# get top institutions by score
ordered_schools <- schools_with_info[order(-schools_with_info$SCORE),] 

# save ordered data
save(ordered_schools, file = "../../data/ordered-schools.RData")

  
