library(ggplot2)
library(dplyr)
library(magrittr)
library(minpack.lm)

returnTheme <- function(themetext) {
  switch(
    themetext,
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

returnColorScale <- function(colortext) {
  if (colortext == '') {
    return(NULL)
  }
  else{
    return(scale_color_brewer(palette = colortext))
    
  }
}

returnPercentageLine <- function(bool, yint) {
  if (!bool) {
    return(NULL)
  }
  else{
    return(geom_hline(yintercept = as.numeric(yint), linetype = 3))
  }
}

returnTransparent <- function(bool) {
  if (bool) {
    x <- theme(
      # https://stackoverflow.com/a/7455481/5905166
      panel.background = element_blank(),
      plot.background = element_rect(fill = "transparent", colour = "transparent"),
      legend.key = element_rect(fill = "transparent", colour = "transparent")
    )
    return(x)
  }
  else {
    return(NULL)
  }
}

hasLabels <- function(bool, dataframe) {
  if (bool) {
    labeldata <-
      dataframe %>% group_by(Setting) %>% filter(Time == max(Time))
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
    if (whichAbove %>% any) {
      above <- max(whichAbove)
    }
    else
      above <- max(which(survival == max(survival)))
    
    if (whichBelow %>% any) {
      below <- min(whichBelow)
    }
    else{
      below <-
        1 # When there are no lower values, you default to the first element.
    }
    
    if (above == below) {
      return(time[min(which(survival == survPercent))])
    }
    else{
      aboveSurv <- survival[above]
      belowSurv <- survival[below]
      aboveTime <- time[above]
      belowTime <- time[below]
      
      if (aboveTime == belowTime) {
        return(aboveTime)
      }
      
      else{
        ratio <- (survPercent - belowSurv) / (aboveSurv - belowSurv)
        
        meantime <- belowTime + ratio * (aboveTime - belowTime)
        return(meantime)
      }
    }
  }
  
  
  summarized <- pureLongdata %>% group_by(Setting) %>%
    summarize(Time = meanTime(Time, Survival),
              Survival = survPercent) # Rather than taking a simple mean and approximating this,
  # we find an exact ratio so we always get the exact survPercent
  return(summarized)
}

drawLine <- function(bool, dataframe) {
  if (!bool) {
    return(NULL)
  }
  else{
    setting <- dataframe["Setting"] %>% unlist %>% as.numeric
    time <- dataframe["Time"] %>% unlist %>% as.numeric
    numSettings <- setting %>% length
    
    if (numSettings < 2) {
      return(NULL)
    }
    else if (numSettings == 2) {
      regression <- lm(time ~ setting)
      
      m <- coef(regression)["setting"]
      b <- coef(regression)["(Intercept)"]
      
      fit <-
        data.frame(Conc = seq(min(setting), max(setting), length.out = 500)) %>%
        mutate(Pred = m * Conc + b)
    }
    
    else{
      # Help from http://datascienceplus.com/first-steps-with-non-linear-regression-in-r/
      # https://bscheng.com/2014/05/07/modeling-logistic-growth-data-in-r/
      Asym_start <- 1.704e+04 #max(time)
      xmid_start <- 9.513e+00 #mean(setting)
      scal_start <- 9.167e-01 #max(time)
      
      regression <-
        nlsLM(
          time ~ Asym / (1 + exp((xmid - setting) / scal)),
          start = list(
            Asym = Asym_start,
            xmid = xmid_start,
            scal = scal_start
          ),
          control = nls.lm.control(maxiter = 500)
        )
      
      Asym <- coef(regression)["Asym"]
      xmid <- coef(regression)["xmid"]
      scal <- coef(regression)["scal"]
      
      fit <-
        data.frame(Conc = seq(min(setting), max(setting), length.out = 500)) %>%
        mutate(Pred = Asym / (1 + exp((xmid - Conc) / scal))) # A high-resolution prediction
    }
    
    
    
    layer <- geom_line(data = fit, aes(Conc, Pred), linetype = 3)
    
    return(layer)
    
  }
  
}

# To do: dose response regression with nls(response ~ sSlogis(log10dose, Asym, xmid, scal), data = doseResponseSummary)
# Rudimentary: plot(log10dose, response); model <- nls(blahblah)
# lines(log10dose, predict(model))
