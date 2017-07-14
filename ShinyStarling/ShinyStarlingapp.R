#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Load libraries.  Must include shiny.  These are global (within app).  
#Can also define global parameters here.  Any information that all functions might need.
library(shiny)
library(knitr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(lubridate)
library(scales)
library(readr)
library(ggmap)
library(HLMdiag)
library(RColorBrewer)
library(gridExtra)
library(broom)

#Then there are two main functions:  ui() and server().
#  1. ui() sets up user interface.
#  2. server()

#Then shinyApp function just runs it all.

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Math Test Scores by School"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 100,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         plotOutput('scatterPlot')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   # Read in math test data. Keep first four schools only.
   data<-read.csv("./Data/mathtest.csv")
   data = data[which(data$school %in% 1:4),]


   #----------------------------------
   #Function for histogram by school.
   output$distPlot = renderPlot({
      
      # ggplot Histogram for each school's math test scores.
      ggplot(data, aes(data$mathscore)) + 
         geom_histogram(bins = input$bins, na.rm=T, show.legend = NA) + 
         facet_wrap(~school, ncol=4) +
         labs(x='math test score',y = 'freq')
   })

   #----------------------------------   
   #Function for histogram by school.
   output$scatterPlot = renderPlot({
         
         # ggplot scatter plot, coloured by test score.
         ggplot(data, aes(x=1:nrow(data), y=data$mathscore, colour=as.factor(data$school))) +
            geom_point(show.legend = FALSE) + 
            labs(x='Index', y='math test score')
   })
   
   #Function for scatter plot of math test scores, colored by school.
   #Interactive portion is mouse-over test score.
}

# Run the application 
shinyApp(ui = ui, server = server)

#How do you get your own data set in?  
# If you have your own data, you'd put it in the same directory as the .app file, and
# do read command in global section, by library(shiny).

