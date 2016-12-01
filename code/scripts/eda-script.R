# Exploratory Data Analysis (EDA)

# importing the data
female_full <- read.table('data/female-data-2014-15.csv', header=TRUE, sep=',')

# adding in an extra column for EDA: percentage of women getting stem degrees
female_full$STEM_DEG_PCNT_WOMEN = female_full$STEM_DEG_WOMEN / female_full$STEM_DEG_TOTAL

###################

# Quantitative Analysis
# Segmenting out some of the interesting quantitative attributes of our data

general <- female_full[c('ADM_RATE', 'SATMTMID', 'UGDS_WOMEN', 'MN_EARN_WNE_MALE0_P6', 'COUNT_WNE_MALE0_P6')]

deg_types <- female_full[c('PCIP26', 'PCIP29', 'PCIP41', 'PCIP27', 'PCIP14', 'PCIP15')]

deg_pcnts <- female_full[c('ENG_DEG_PCNT', 'MATH_DEG_PCNT', 'SCIENCE_DEG_PCNT', 'TECH_DEG_PCNT', 'STEM_DEG_PCNT', 'STEM_DEG_PCNT_WOMEN')]


# Min, Q1, Median, Mean, Q3, Max
summary_stats_general <- summary(general)
summary_stats_deg_types <- summary(deg_types)
summary_stats_deg_pcnts <- summary(deg_pcnts)

# Standard Deviations
standard_deviation_general <- data.frame(sapply(general, function(x) sd(x)))
standard_deviation_deg_types <- data.frame(sapply(deg_types, function(x) sd(x)))
standard_deviation_deg_pcnts <- data.frame(sapply(deg_pcnts, function(x) sd(x)))

# Range
range_general <- data.frame(t(data.frame(sapply(general, function(x) range(x)))))
range_deg_types <- data.frame(t(data.frame(sapply(deg_types, function(x) range(x)))))
range_deg_pcnts <- data.frame(t(data.frame(sapply(deg_pcnts, function(x) range(x)))))

names(range_general) = c("min","max")
range_general$range = range_general$max - range_general$min
names(range_deg_types) = c("min","max")
range_deg_types$range = range_deg_types$max - range_deg_types$min
names(range_deg_pcnts) = c("min","max")
range_deg_pcnts$range = range_deg_pcnts$max - range_deg_pcnts$min

sd_range_general <- cbind(standard_deviation_general, range_general$range)
names(sd_range_general) = c('SD', 'Range')
sd_range_deg_types <- cbind(standard_deviation_deg_types, range_deg_types$range)
names(sd_range_deg_types) = c('SD', 'Range')
sd_range_deg_pcnts <- cbind(standard_deviation_deg_pcnts, range_deg_pcnts$range)
names(sd_range_deg_pcnts) = c('SD', 'Range')

# Visualizations

## Admission rate
png('images/hist-adm-rate.png')
hist(female_full$ADM_RATE, xlab='Admission Rate', main='Histogram of Admission Rates')
dev.off()

## Percentage of female undergrads
png('images/hist-ugds-women.png')
hist(female_full$UGDS_WOMEN, xlab='Percentage of Women', main='Histogram of % of Women in Undergrad')
dev.off()

## Mean earnings of women after 6 years
png('images/hist-mn-earn.png')
hist((female_full$MN_EARN_WNE_MALE0_P6)/1000, xlab='Mean earnings (in thousands)', main='Histogram of Mean Women Earnings after 6 Years')
dev.off()

## Stem degree total
png('images/hist-stem-deg-total.png')
hist(female_full$STEM_DEG_TOTAL, breaks=20, xlab='Stem degrees', main='Histogram of Total STEM Degrees')
dev.off()

## Stem degree percent women
newdata <- female_full[which(female_full$STEM_DEG_PCNT_WOMEN != 0
                             & female_full$WOMENONLY == 0), ]
png('images/hist-stem-pcnt-women.png')
hist(newdata$STEM_DEG_PCNT_WOMEN, breaks=25, xlab='Percentage of Women', main='Histogram of % of Women in STEM')
dev.off()

# Correlation Matrix
# For our correlation matrix, we chose a few variables which we think will have interesting correlations to study
cor_data <- female_full[c('ADM_RATE', 'UGDS_WOMEN', 'MN_EARN_WNE_MALE0_P6', 'STEM_DEG_PCNT', 'STEM_DEG_WOMEN')]
cor_matrix <- cor(cor_data)

#Scatterplot Matrix
png('images/scatterplot-matrix.png')
scatterplot_matrix <- pairs(cor_data, gap=0, main='Scatterplot Matrix')
dev.off()

#Save Data
sink('data/summary-stats.txt')
summary_stats_general
summary_stats_deg_types
summary_stats_deg_pcnts
sd_range_general
sd_range_deg_types
sd_range_deg_pcnts
sink()

sink('data/correlation-matrix.txt')
cor_matrix
sink()

save(summary_stats_general, summary_stats_deg_types, summary_stats_deg_pcnts, sd_range_general,
     sd_range_deg_types, sd_range_deg_pcnts, cor_matrix, file='data/eda-output.RData')

