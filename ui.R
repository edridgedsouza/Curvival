
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source("functions.R")
source("datasets.R")

shinyUI(fluidPage(

  # Application title
  titlePanel("Curvival"),

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
      
      tags$hr(),
      
      checkboxInput('header', 'Header', TRUE),
      selectInput('sep', 'Separator',
                   c(Tab='\t',
                     Comma=',',
                     Semicolon=';')),
      selectInput('quote', 'Quote',
                   c('No quotes'='',
                     'Double Quote'='"',
                     'Single Quote'="'")),
      
      tags$hr(),
      textInput('plotTitle', 'Plot Title', value = "Survival Curve"),
      
      selectInput('theme','Plot Theme',
                  c('Black and White'='bw',
                    'Dark'='dark',
                    'Grey'='grey',
                    'Void'='void',
                    'Light'='light',
                    'Classic'='classic',
                    'Minimal'='minimal',
                    'Line Drawing'='linedraw'),
                  'Grey'),
      
      selectInput('colorscale', 'ColorBrewer Scale', c(Choose='', colorOpts), selectize=TRUE)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("survPlot")
    )
  )
))
