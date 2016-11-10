
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)

source("functions.R")
source("datasets.R")

shinyUI(fluidPage(theme = shinytheme("slate"),

  # Application title
  headerPanel("Curvival", windowTitle = "Curvival App"),

  # https://github.com/rstudio/shiny-examples/blob/master/066-upload-file/ui.R
  sidebarLayout(
    
    sidebarPanel(
      fileInput('datafile', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      
      checkboxInput('header', 'Header', TRUE),
      selectInput('sep', 'Separator',
                   c(Tab = '\t',
                     Comma = ',',
                     Semicolon = ';')),
      selectInput('quote', 'Quote',
                   c('No quotes' = '',
                     'Double Quote' = '"',
                     'Single Quote' = "'")),
      
      tags$hr(),
      textInput('plotTitle', 'Plot Title', value = "Survival Curve"),
      
      selectInput('theme','Plot Theme',
                  c('Black and White' = 'bw',
                    'Dark' = 'dark',
                    'Grey' = 'grey',
                    'Void' = 'void',
                    'Light' = 'light',
                    'Classic' = 'classic',
                    'Minimal' = 'minimal',
                    'Line Drawing' = 'linedraw'),
                  'grey', multiple = FALSE),
      
      selectInput('colorscale', 'ColorBrewer Scale', 
                  c(Choose = '', colorOpts), 
                  selectize = TRUE, 
                  multiple = FALSE),
      checkboxInput('transparent', 'Transparency', value = FALSE),
      checkboxInput('labels', 'Labels', value = FALSE),
      
      sliderInput('asprat', 'Aspect Ratio', value = 1, min = 0 , max = 3, step = 0.01)
      ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",
          #h3(textOutput("caption")),
          plotOutput("survPlot")
          )
        )
    )
  )
))
