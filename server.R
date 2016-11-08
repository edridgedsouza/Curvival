
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(magrittr)
library(ggplot2)
library(reshape2)

source("functions.R")
source("datasets.R")

shinyServer(function(input, output) {

  output$caption <- renderText(input$plotTitle)
  output$survPlot <- renderPlot({
    survdata <- input$datafile

    if (is.null(survdata)){
      return(NULL)
    }
    else {
      data <- read.csv(survdata$datapath, header = input$header,
                       sep = input$sep, quote = input$quote)
      colnames(data)[1] <- "Time"
      longdata <- data %>% melt(id = "Time", 
                                variable.name = "Setting", 
                                value.name = "Survival")
      
      
      
      ggplot(longdata, aes(x = Time, y = Survival, color=Setting)) + 
        geom_step() +
        returnTheme(input$theme) + returnColorScale(input$colorscale) +
        coord_fixed(ratio=as.numeric(input$asprat))
      
    }
  })

})
