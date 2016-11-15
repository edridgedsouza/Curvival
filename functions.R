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

returnPercentageLine <- function(bool, yint){
  if (!bool){
    return(NULL)
  }
  else{
    return(geom_hline(yintercept = as.numeric(yint), linetype = 3))
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


# Take the long data table and summarize it such that:
# for a given percentage survival, you find the amount of time
# at each concentration that it takes to get to that percentage.

summarizeDoses <- function(pureLongdata , survPercent = 50) {
  
  meanTime <- function(time, survival) {
    whichAbove <- which(survival >= survPercent)
    whichBelow <- which(survival <= survPercent)
    
    # Unsuccessful attempt to fix problems when the threshold is set very low
    if (whichAbove %>% any){
      above <- max(whichAbove)
    }
    else above <- max(which(survival == max(survival)))
    
    if (whichBelow %>% any){
      below <- min(whichBelow)
    }
    else below <- 1 # When there are no lower values, you default to the first element.
    
    
    if (above == below){
      return(time[min(which(survival == survPercent))])
    }
    else{
        aboveSurv <- survival[above]
        belowSurv <- survival[below]
        aboveTime <- time[above]
        belowTime <- time[below]
        
        ratio <- (survPercent - belowSurv)/(aboveSurv - belowSurv)
        
        meantime <- belowTime + ratio * (aboveTime - belowTime)
        return(meantime)
    }
  }
  
  
  summarized <- pureLongdata %>% group_by(Setting) %>%
    summarize(
      Time = meanTime(Time, Survival),
      Survival = survPercent # Rather than taking a simple mean and approximating this, we find an exact ratio so we always get the exact survPercent
    )
  
  return(summarized)
}

# To do: dose response regression with nls(response ~ sSlogis(log10dose, Asym, xmid, scal), data = doseResponseSummary)
# Rudimentary: plot(log10dose, response); model <- nls(blahblah)
# lines(log10dose, predict(model))
