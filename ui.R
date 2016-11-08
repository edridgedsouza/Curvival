
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

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
      radioButtons('sep', 'Separator',
                   c(Tab='\t',
                     Comma=',',
                     Semicolon=';')),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '')
      ),

    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("survPlot")
    )
  )
))
