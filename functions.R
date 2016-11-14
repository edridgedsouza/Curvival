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

hasLabels <- function(bool, dataframe) {
  if (bool){
    labeldata <- dataframe %>% group_by(Setting) %>% filter(Time==max(Time))
    return(geom_label(
      data = labeldata,
      aes(label = Setting),
      hjust = 1,
      vjust = -0.25,
      show.legend = FALSE
    ))
  }
  else{
    return(NULL)
  }
}

# To do: doseResponseSummary summarizer function

# To do: dose response regression with nls(response ~ sSlogis(log10dose, Asym, xmid, scal), data = doseResponseSummary)
# Rudimentary: plot(log10dose, response); model <- nls(blahblah)
# lines(log10dose, predict(model))
