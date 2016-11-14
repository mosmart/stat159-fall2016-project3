# Data Processing

# import data
schools_all <- read.csv('../../data/MERGED2014_15_PP.csv', header=TRUE)

# Computer and Information Sciences and Support Services (11), 
# Engineering (14)
# Engineering Technologies and Engineering-Related Fields (15)
# Biological and Biomedical Sciences (26)
# Mathematics and Statistics (27)
# Military Technologies and Applied Sciences (29)
# Physical Sciences (40)
# Science Technologies/Technicians (41)
# Social Sciences (45)
# Psychology (42)
columns <- c('ADM_RATE', 'HIGHDEG', 'PREDDEG', 'MENONLY', 'CURROPER', 'WOMENONLY',
             'UGDS','UGDS_WOMEN','SATMT25', 'SATMT75', 'SATMTMID', 'PCIP42', 'PCIP45',
             'PCIP26','PCIP11', 'PCIP29', 'PCIP41', 'PCIP40', 'PCIP27', 'PCIP14', 'PCIP15')


# keep only desired columns
schools <- schools_all[, columns]

# remove schools no longer in operation
schools <- schools[which(schools$CURROPER == 1),]

# remove schools with only male students
schools <- schools[which(schools$MENONLY == 0),]

# remove schools that specialize in a non-stem field (removes associate colleges)
#schools <- schools[which(schools$CCBASIC < 1 | schools$CCBASIC > 9),]

# keep only schools that have a predominant degree type listed
schools <- schools[which(schools$PREDDEG != 0),]

# keep only schools that offer at least bachelors degrees
schools <- schools[which(schools$HIGHDEG > 2),]

# change data type of columns
schools$ADM_RATE <- as.numeric(levels(schools$ADM_RATE))[schools$ADM_RATE]
schools$HIGHDEG <- as.factor(schools$HIGHDEG)
schools$PREDEG <- as.factor(schools$PREDEG)
schools$UGDS <- as.numeric(levels(schools$UGDS))[schools$UGDS]
schools$UGDS_WOMEN <- as.numeric(levels(schools$UGDS_WOMEN))[schools$UGDS_WOMEN]
schools$WOMEN_TOTAL <- round(schools$UGDS_WOMEN*schools$UGDS,0)
schools$WOMENONLY <- as.numeric(levels(schools$WOMENONLY))[schools$WOMENONLY]
schools$SATMT25 <- as.numeric(levels(schools$SATMT75))[schools$SATMT25]
schools$SATMT75 <- as.numeric(levels(schools$SATMT75))[schools$SATMT75]
schools$SATMTMID <- as.numeric(levels(schools$SATMTMID))[schools$SATMTMID]
schools$PCIP26 <- as.numeric(levels(schools$PCIP26))[schools$PCIP26]
schools$PCIP27 <- as.numeric(levels(schools$PCIP27))[schools$PCIP27]
schools$PCIP11 <- as.numeric(levels(schools$PCIP11))[schools$PCIP11]
schools$PCIP29 <- as.numeric(levels(schools$PCIP29))[schools$PCIP29]
schools$PCIP41 <- as.numeric(levels(schools$PCIP41))[schools$PCIP41]
schools$PCIP40 <- as.numeric(levels(schools$PCIP40))[schools$PCIP40]
schools$PCIP45 <- as.numeric(levels(schools$PCIP45))[schools$PCIP45]
schools$PCIP42 <- as.numeric(levels(schools$PCIP42))[schools$PCIP42]
schools$PCIP14 <- as.numeric(levels(schools$PCIP14))[schools$PCIP14]
schools$PCIP15 <- as.numeric(levels(schools$PCIP15))[schools$PCIP15]
schools$ENG_DEG_PCNT <- schools$PCIP15 + schools$PCIP14
schools$MATH_DEG_PCNT <- schools$PCIP27
schools$SCIENCE_DEG_PCNT <- schools$PCIP40 + schools$PCIP26 + schools$PCIP42 + schools$PCIP45
schools$TECH_DEG_PCNT <- schools$PCIP11 + schools$PCIP29 + schools$PCIP41
schools$STEM_DEG_PCNT <- schools$ENG_DEG_PCNT + schools$MATH_DEG_PCNT + schools$SCIENCE_DEG_PCNT + schools$TECH_DEG_PCNT
schools$STEM_DEG_TOTAL <- round(schools$UGDS*schools$STEM_DEG_PCNT,0)
schools$STEM_DEG_WOMEN <- ifelse(schools$WOMENONLY ==1, schools$STEM_DEG_TOTAL,
                                 ifelse(schools$WOMENONLY ==0, round(schools$STEM_DEG_TOTAL*.5,0), NA))

# remove all rows with na
schools <- na.omit(schools)

# remove men only and if currently operating
schools <- schools[,-c(4:5)]

###################

# Create Dummy Variables

# dummy out categorical variables
temp_schools <- model.matrix(ADM_RATE ~ ., data = schools)

# removing column of ones, and appending Balance
new_schools <- cbind(temp_schools[ ,-1], ADM_RATE = schools$ADM_RATE)

###################

# Mean Centering and Standardizing

# scaling and centering
scaled_schools <- scale(new_schools, center = TRUE, scale = TRUE)

# export scaled data
write.table(scaled_schools, file = "../../data/female-data-2014-15.csv", sep = ",", row.names  = FALSE)
