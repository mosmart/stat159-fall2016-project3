
library(shiny)
options(shiny.reactlog=TRUE)

ui <- fluidPage(
  headerPanel('Exploring College Data Statistics'),
  sidebarPanel(
    selectInput('xcol', 'Select Graph', c("Admission Rate"="hist-adm-rate","Mean Earnings"="hist-mn-earn","STEM Degree Total"="hist-stem-deg-total",
                                          "STEM Pecentage Women"="hist-stem-pcnt-women","Percentage of Women in Undergrad"="hist-ugds-women",
                                          "Scatterplot Matrix" = "scatterplot-matrix"))
  ),
  mainPanel(
    plotOutput('plot1')
  ),
  
  headerPanel('Regression Exploration'),
  sidebarPanel(
  checkboxGroupInput("variable", "Variables to Regress against Mean Earnings:",
                     c("Median SAT Math Score" = "SATMTMID",
                       "Admission Rate" = "ADM_RATE",
                       "Approx. Number of Female STEM" = "STEM_DEG_WOMEN",
                       "Schools that offer bachelors" = "HIGHDEG4",
                       "Women Only Schools" = "WOMENONLY",
                       "Female Students working after 6 years of entry" = "COUNT_WNE_MALE0_P6"))
  ),
  mainPanel(
  plotOutput("regplot")
  )
)

server <- function(input, output) {
  female_full = read.csv("../data/female-data-2014-15.csv")
  
  output$plot1 = renderPlot({
    if(input$xcol == "hist-adm-rate"){
    plot(hist(female_full$ADM_RATE, xlab='Admission Rate', main='Histogram of Admission Rates'))
    }
    if(input$xcol == "hist-mn-earn"){
      plot(hist((female_full$MN_EARN_WNE_MALE0_P6)/1000, xlab='Mean earnings (in thousands)', main='Histogram of Mean Women Earnings after 6 Years'))
    }
    if(input$xcol == "hist-stem-deg-total"){
      plot(hist(female_full$STEM_DEG_TOTAL, breaks=20, xlab='Stem degrees', main='Histogram of Total STEM Degrees'))
    }
    if(input$xcol == "hist-stem-pcnt-women"){
      newdata <- female_full[which(female_full$STEM_DEG_PCNT_WOMEN != 0
                                   & female_full$WOMENONLY == 0), ]
      plot(hist(newdata$STEM_DEG_PCNT_WOMEN, breaks=25, xlab='Percentage of Women', main='Histogram of % of Women in STEM'))
    }
    if(input$xcol == "hist-ugds-women"){
      plot(hist(female_full$UGDS_WOMEN, xlab='Percentage of Women', main='Histogram of % of Women in Undergrad'))
    }
    if(input$xcol == "scatterplot-matrix"){
      cor_data <- female_full[c('ADM_RATE', 'UGDS_WOMEN', 'MN_EARN_WNE_MALE0_P6', 'WOMEN_TOTAL', 'STEM_DEG_WOMEN')]
      cor_matrix <- cor(cor_data)
      scatterplot_matrix <- pairs(cor_data, gap=0, main='Scatterplot Matrix')
      plot(scatterplot_matrix)
      #This part does not work. 
    }
  })
  
  scaled_schools <- read.csv("../data/scaled-schools.csv", header=TRUE)
  features <- c("MN_EARN_WNE_MALE0_P6", "ADM_RATE",
                "SATMTMID", "STEM_DEG_WOMEN", "COUNT_WNE_MALE0_P6",
                "WOMENONLY", "HIGHDEG4")
  regression_data <- scaled_schools[, features]

  error = reactive({
    cat(file  = stderr(), typeof(input$variable))
  })
  
  output$regplot = renderPlot({
    plot(regression_data[,input$variable],regression_data$MN_EARN_WNE_MALE06_P6)
    abline(lm(MN_EARN_WNE_MALE0_P6 ~ input$variable, data = regression_data))
    error()
  })
  
  
    
}

shinyApp(ui = ui, server = server)

