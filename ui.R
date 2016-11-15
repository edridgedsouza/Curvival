# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(shinythemes)
library(htmltools)
library(DT)

source("functions.R")
source("datasets.R")

shinyUI(
  navbarPage(
    theme = shinytheme("yeti"),
    #Looks best with yeti, but use slate for testing transparency
    
    title = "Curvival!",
    
    # https://github.com/rstudio/shiny-examples/blob/master/066-upload-file/ui.R
    tabPanel(
      "Survival Plot",
      headerPanel("Curvival Survival Plot", windowTitle = "Curvival App"),
      sidebarLayout(
        sidebarPanel(
          fileInput(
            'datafile',
            'Choose file to upload',
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              'text/tab-separated-values',
              'text/plain',
              '.csv',
              '.tsv'
            )
          ),
          
          selectInput('sep', 'Separator',
                      c(
                        Tab = '\t',
                        Comma = ',',
                        Semicolon = ';'
                      )),
          selectInput(
            'quote',
            'Quote',
            c(
              'No quotes' = '',
              'Double Quote' = '"',
              'Single Quote' = "'"
            )
          ),
          
          tags$hr(),
          textInput('plotTitle', 'Plot Title', value = "Survival Curve"),
          
          selectInput(
            'theme',
            'Plot Theme',
            c(
              'Black and White' = 'bw',
              'Dark' = 'dark',
              'Grey' = 'grey',
              'Void' = 'void',
              'Light' = 'light',
              'Classic' = 'classic',
              'Minimal' = 'minimal',
              'Line Drawing' = 'linedraw'
            ),
            'grey',
            multiple = FALSE
          ),
          
          selectInput(
            'colorscale',
            'ColorBrewer Scale',
            c(Choose = '', colorOpts),
            selectize = TRUE,
            multiple = FALSE
          ),
          checkboxInput('transparent', 'Transparency', value = FALSE),
          checkboxInput('labels', 'Labels', value = FALSE),
          
          checkboxInput('bool.percentage', 'Include dose response threshold', value = FALSE),
          sliderInput("percentage", "Dose response  threshold", 
            value = 50, 
            min = 0,
            max = 100,
            step = 0.5),
          
          sliderInput(
            'asprat',
            'Aspect Ratio',
            value = 1,
            min = 0 ,
            max = 3,
            step = 0.01
          )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(plotOutput("survPlot"))
      )
    ),
    tabPanel(
      "Dose Response",
      headerPanel("Curvival Dose Response Plot", windowTitle = "Curvival App"),
      sidebarLayout(
        sidebarPanel(
          textInput('dr.plotTitle', 'Plot Title', value = "Dose Response Curve"),
          
          selectInput(
            'dr.theme',
            'Plot Theme',
            c(
              'Black and White' = 'bw',
              'Dark' = 'dark',
              'Grey' = 'grey',
              'Void' = 'void',
              'Light' = 'light',
              'Classic' = 'classic',
              'Minimal' = 'minimal',
              'Line Drawing' = 'linedraw'
            ),
            'grey',
            multiple = FALSE
          ),
          
          selectInput(
            'dr.colorscale',
            'ColorBrewer Scale',
            c(Choose = '', colorOpts),
            selectize = TRUE,
            multiple = FALSE
          ),
          checkboxInput('dr.transparent', 'Transparency', value = FALSE),
          checkboxInput('dr.labels', 'Labels', value = FALSE),
        
          
          sliderInput(
            'dr.asprat',
            'Aspect Ratio',
            value = 1,
            min = 0 ,
            max = 3,
            step = 0.01
          )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(plotOutput("doseResponse"))
      )
      
      
    ),
    tabPanel(
      "Help",
      headerPanel("Curvival Help", windowTitle = "Curvival App")
    ),
    
    # Footer
    hr(),
    div(
      style = "text-align:center; padding: 10px;line-height: 1.7em;",
      "2016 Edridge D'Souza, Markstein Lab. Distributed under the MIT License.",
      br(),
      a(href = "https://github.com/edridgedsouza/Curvival", img(
        src = "img/github.png",
        height = 25,
        width = 25
      )),
      # Credit: Google Material icons used here, under Apache License
      a(href = "http://marksteinlab.org/", img(
        src = "img/globe.svg",
        height = 25,
        width = 25
      )),
      a(href = "mailto:mmarkstein@bio.umass.edu&cc=edsouza@umass.edu;edridge@gmail.com&subject=Curvival", img(
        src = "img/mail.svg",
        height = 25,
        width = 25
      )),
      a(href = "https://www.bio.umass.edu/biology/", img(
        src = "img/umass.png",
        height = 25,
        width = 25
      ))
    )
    
  )
)
