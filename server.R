
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  output$caption <- renderText("Blah Blah")
  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    range <- max(x) - min(x)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    p <- ggplot(faithful, aes(eruptions)) + geom_histogram(binwidth=(range/input$bins))
    print(p)
  })

})
