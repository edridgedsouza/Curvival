# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
library(dplyr)
library(magrittr)
library(ggplot2)
library(reshape2)

source("functions.R")
source("datasets.R")

shinyServer(function(input, output) {
  #output$caption <- renderText(input$plotTitle)
  
  
  output$survPlot <- renderPlot({
    survdata <- input$datafile
    
    if (is.null(survdata)) {
      return(NULL)
    }
    else {
      data <- read.csv(
        survdata$datapath,
        header = TRUE,
        sep = input$sep,
        quote = input$quote,
        check.names = FALSE
      )
      colnames(data)[1] <- "Time"
      longdata <- data %>% melt(id = "Time",
                                variable.name = "Setting",
                                value.name = "Survival")
      
      
      ggplot(longdata, aes(x = Time, y = Survival, color = Setting)) +
        geom_step(direction = "vh") +
        returnTheme(input$theme) +
        returnColorScale(input$colorscale) +
        coord_fixed(ratio = as.numeric(input$asprat)) +
        returnTransparent(input$transparent) +
        ggtitle(input$plotTitle) +
        hasLabels(input$labels, longdata)
      
    }
  }, bg = "transparent")
  
  # Focus on the dose-response curve tab now
  
  output$doseResponse <- renderPlot({
    
    # Still have to re-load this all bc dynamic loading or something
    survdata <- input$datafile
    if (is.null(survdata)) {
      return(NULL)
    }
    else{
      data <- read.csv(
        survdata$datapath,
        header = TRUE,
        sep = input$sep,
        quote = input$quote,
        check.names = FALSE
      )
      colnames(data)[1] <- "Time"
      longdata <- data %>% melt(id = "Time",
                                variable.name = "Setting",
                                value.name = "Survival")
      
      
      pure_longdata <-
        longdata %>%  # Extract only the numbers from the concentration settings
        mutate(Setting = as.character(lapply(Setting,
                                             function(x) {
                                               gsub("(\\d*)\\D*", "\\1", x)
                                             }))) %>%
        mutate(Setting = -1*log10(as.numeric(Setting)) %>% round(3)) %>%
        mutate(Setting = as.factor(Setting)) %>%
        as.data.frame()
      
      # Will change this later, only temporary
      ggplot(pure_longdata, aes(x = Time,
                                y = Survival,
                                color = Setting)) +
        geom_step(direction = "vh") +
        returnTheme(input$dr.theme) +
        returnColorScale(input$dr.colorscale) +
        coord_fixed(ratio = as.numeric(input$dr.asprat)) +
        returnTransparent(input$dr.transparent) +
        ggtitle(input$dr.plotTitle) +
        hasLabels(input$dr.labels, pure_longdata)
      
    }
  }, bg = "transparent")
})
