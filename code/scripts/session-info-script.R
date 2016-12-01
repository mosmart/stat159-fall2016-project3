# Script to record information about the session.

library(shiny)
library(corrplot)
library(ggplot2)
library(DAAG)

sink("session-info.txt", append = TRUE)
cat("Session Information\n\n")
sessionInfo()
devtools::session_info()
sink()
