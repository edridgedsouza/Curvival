library(ggplot2)
library(dplyr)
library(magrittr)

returnTheme <- function(themetext){
  switch(themetext,
         'bw'=theme_bw(),
         'dark'=theme_dark(),
         'grey'=theme_grey(),
         'void'=theme_void(),
         'light'=theme_light(),
         'minimal'=theme_minimal(),
         'classic'=theme_classic(),
         'linedraw'=theme_linedraw()
         )
}

returnColorScale <- function(colortext){
  if (colortext==''){
    return(NULL)
  }
  else{
    return(scale_color_brewer(palette = colortext))
    
  }
}