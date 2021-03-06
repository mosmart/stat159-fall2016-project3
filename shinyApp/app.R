
library(shiny)
library(corrplot)
library(ggplot2)

options(shiny.reactlog=TRUE)

ui <- fluidPage(
  ## ----------------------- HISTOGRAMS AND SCATTERPLOT MATRIX -----------------------
  headerPanel('Exploring College Data Statistics'),
  sidebarPanel(
    selectInput('xcol', 'Select Graph', c("Admission Rate"="hist-adm-rate","Mean Earnings"="hist-mn-earn","STEM Degree Total"="hist-stem-deg-total",
                                          "STEM Pecentage Women"="hist-stem-pcnt-women","Percentage of Women in Undergrad"="hist-ugds-women",
                                          "Scatterplot Matrix" = "scatterplot-matrix"))
  ),
  mainPanel(
    plotOutput('plot1')
  ),
  
  ## ----------------------- REGRESSION -----------------------
  headerPanel('Regression Exploration'),
  sidebarPanel(
  selectInput("variable", "Variables to Regress against Mean Earnings:",
                 c("Median SAT Math Score" = "SATMTMID",
                   "Admission Rate" = "ADM_RATE",
                   "Approx. Number of Female STEM" = "STEM_DEG_WOMEN",
                   "Schools that offer bachelors" = "HIGHDEG4",
                   "Women Only Schools" = "WOMENONLY",
                   "Female Students working after 6 years of entry" = "COUNT_WNE_MALE0_P6"))
  ),
  mainPanel(
  plotOutput("regplot")
  ),
  
  ## ----------------------- SCATTER PLOT WITH DATA TABLE -----------------------
  headerPanel('Score Representation'),
  mainPanel(
    plotOutput("Scoreplot",
               click = "plot1_click",
               brush = brushOpts(id = "plot1_brush")),
    width = 12
  ),
  verticalLayout(
    column(width = 12,
           h4("Points near click"),
           dataTableOutput("click_info")
    ),
    column(width = 12,
           h4("Brushed points"),
           dataTableOutput("brush_info")
    )
  )
  
)

server <- function(input, output) {
  
  ## ----------------------- HISTOGRAMS AND SCATTERPLOT MATRIX -----------------------
  
  female_full = read.csv("../data/female-data-2014-15.csv")

  output$plot1 = renderPlot({
    if(input$xcol == "hist-adm-rate"){
    plot(hist(female_full$ADM_RATE), xlab='Admission Rate', main='Histogram of Admission Rates')
    }
    if(input$xcol == "hist-mn-earn"){
      plot(hist((female_full$MN_EARN_WNE_MALE0_P6)/1000), xlab='Mean earnings (in thousands)', main='Histogram of Mean Women Earnings after 6 Years')
    }
    if(input$xcol == "hist-stem-deg-total"){
      plot(hist(female_full$STEM_DEG_TOTAL, breaks=20), xlab='Stem degrees', main='Histogram of Total STEM Degrees')
    }
    if(input$xcol == "hist-stem-pcnt-women"){
      female_full$STEM_DEG_PCNT_WOMEN = female_full$STEM_DEG_WOMEN / female_full$STEM_DEG_TOTAL
      newdata <- female_full[which(female_full$STEM_DEG_PCNT_WOMEN != 0 & female_full$WOMENONLY == 0),]
      plot(hist(newdata$STEM_DEG_PCNT_WOMEN, breaks=25), xlab='Percentage of Women', main='Histogram of % of Women in STEM')
    }
    if(input$xcol == "hist-ugds-women"){
      plot(hist(female_full$UGDS_WOMEN), xlab='Percentage of Women', main='Histogram of % of Women in Undergrad')
    }
    if(input$xcol == "scatterplot-matrix"){
      cor_data <- female_full[c('ADM_RATE', 'UGDS_WOMEN', 'MN_EARN_WNE_MALE0_P6', 'WOMEN_TOTAL', 'STEM_DEG_WOMEN')]
      corrplot(cor(cor_data), method = "ellipse", main='Scatterplot Matrix')
    }
  })
  
  ## ----------------------- REGRESSION -----------------------
  
  scaled_schools <- read.csv("../data/scaled-schools.csv", header=TRUE)
  features <- c("MN_EARN_WNE_MALE0_P6", "ADM_RATE",
                "SATMTMID", "STEM_DEG_WOMEN", "COUNT_WNE_MALE0_P6",
                "WOMENONLY", "HIGHDEG4")
  regression_data <- scaled_schools[, features]

  output$regplot = renderPlot({
    text = as.character(input$variable)
    dummy = all.vars(parse(text = text))
    dummy = as.list(dummy)
    dummy = dummy[[1]]
    
    plot(regression_data[[dummy]], regression_data[['MN_EARN_WNE_MALE0_P6']], xlab = dummy, ylab = "Mean Earnings of Women", main = "OLS Regression")
    abline(lm(regression_data[['MN_EARN_WNE_MALE0_P6']] ~ regression_data[[dummy]]), col="red")
  })
  
  ## ----------------------- SCATTER PLOT WITH DATA TABLE -----------------------
  
  load("../data/ordered-schools.RData")
  ordered_schools = ordered_schools[,c("SCORE","INSTNM","CITY","ADM_RATE","SATMTMID","STEM_DEG_PCNT","MN_EARN_WNE_MALE0_P6")]
  output$Scoreplot <- renderPlot({
    
    ggplot(ordered_schools, aes(SCORE, SATMTMID)) + geom_point(aes(color = factor(as.integer(SCORE)))) +
      scale_color_discrete(name="Score") + 
      ggtitle("Scatterplot of University Score vs Median SAT Score") +
      labs(x = "Score", y = "SAT Median Score")
    
  })
  
  output$click_info <- renderDataTable({
    nearPoints(ordered_schools, input$plot1_click, addDist = TRUE)
  })
  
  output$brush_info <- renderDataTable({
    brushedPoints(ordered_schools, input$plot1_brush)
  })
  
}

shinyApp(ui = ui, server = server)

