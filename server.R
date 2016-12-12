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
        hasLabels(input$labels, longdata) +
        returnPercentageLine(bool = input$bool.percentage,
                             yint = input$percentage)
    }
  }, bg = "transparent")
  
  # Focus on the longevity curve tab now
  
  output$longevity <- renderPlot({
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
                                value.name = "Survival") %>%  # Extract only the numbers from the concentration settings
        mutate(Setting = as.character(lapply(Setting,
                                             function(x) {
                                               gsub("(\\d*)\\D*", "\\1", x)
                                             })))
      
      # Manipulation to add a setting for "zero drug" if not already present
      # Just assumes no death at all.
      
      
      pure_longdata <- # Needs more intelligent unit parser
        longdata  %>%
        mutate(Setting = -1 * log10(as.numeric(Setting)) %>% round(3)) %>%
        mutate(Setting = as.factor(Setting)) %>%
        as.data.frame()
      
      longevity <-
        summarizeLongevity(pure_longdata, input$l.percentage)
      
      ggplot(longevity,
             aes(x = Setting, y = Time)) +
        geom_point() +
        returnTheme(input$l.theme) +
        returnColorScale(input$l.colorscale) +
        # coord_fixed(ratio = as.numeric(input$dr.asprat)) +
        returnTransparent(input$l.transparent) +
        ggtitle(input$l.plotTitle) +
        drawLongevityLine(TRUE, longevity)
      
    }
  }, bg = "transparent")
  
  
  
  output$doseResponse <- renderPlot({
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
                                value.name = "Survival") %>%  # Extract only the numbers from the concentration settings
        mutate(Setting = as.character(lapply(Setting,
                                             function(x) {
                                               gsub("(\\d*)\\D*", "\\1", x)
                                             })
                                      )
               )
      
      finalTime <- longdata %>% group_by(Setting) %>% 
        summarize(Survival = min(Survival)) %>%# Find the survival at the bottom
        mutate(Setting = -1 * log10(as.numeric(Setting)) %>% round(3)) %>%
        mutate(Setting = as.factor(Setting))
      
      ggplot(finalTime, aes(Setting, Survival)) + 
        geom_point() + 
        drawDRLine(TRUE, finalTime)
      
    }
    
    
    
  })
  
})



