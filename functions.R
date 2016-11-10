library(ggplot2)
library(dplyr)
library(magrittr)

returnTheme <- function(themetext){
  switch(themetext,
         'bw' = theme_bw(),
         'dark' = theme_dark(),
         'grey' = theme_grey(),
         'void' = theme_void(),
         'light' = theme_light(),
         'minimal' = theme_minimal(),
         'classic' = theme_classic(),
         'linedraw' = theme_linedraw()
         )
}

returnColorScale <- function(colortext){
  if (colortext == ''){
    return(NULL)
  }
  else{
    return(scale_color_brewer(palette = colortext))
    
  }
}

returnTransparent <- function(bool){
  if (bool) {
    x <- theme( # https://stackoverflow.com/a/7455481/5905166
      panel.background = element_blank(),
      plot.background = element_rect(fill = "transparent",colour = "transparent"),
      legend.key = element_rect(fill = "transparent", colour = "transparent")
    )
    return(x)
  }
  else {
    return(NULL)
  }
  }
  
