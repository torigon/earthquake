library(shiny)
library(caret)
library(C50)

# Constants
seismic <<- c("3", "4", "5_lower", "5_upper", "6_lower","6_upper", "7")
mercalli <<- c("III.Weak - IV.Light", "V.Moderate - VII.Very strong", 
                   "V.Moderate - VIII.Severe", "VI.Strong - IX.Violent", 
                   "VIII.Severe - X.Extreme", "IX.Violent - X.Extreme", 
                   "X.Extreme - XII.Extreme")
kScale <<- data.frame(seismic, mercalli)

trainHypocenterData <- function() {
  # Trains hypocenterdata with C5.0 Decision Trees.
  #
  # Returns:
  #   A trained tree model.
  hypocenters <- read.csv("hypocenter_list.csv")
  hypocenters <- na.omit(hypocenters)
  hypocenters <- hypocenters[,2:5]
  
  model <- C5.0(hypocenters[-4], hypocenters$max_seismic_scale,
                trials = 10)
  model
}

# Trains data
hypoModel <<- trainHypocenterData()

predictSeismicScale <- function(magnitude, depth, location) {
  # Predict a seismic intensity code.
  #
  # Args:
  #   magnitude:  A magnitude of the hypocenter.
  #   depth:      A depth of the hypocenter. 
  #   location:   a location of the epicenter. (land or sea) 
  # Returns:
  #   A predicted seismic intensity scale.
  target <- data.frame(location=factor(location), depth=depth, 
                       magnitude=magnitude)  
  scale <- predict(hypoModel, target) 
  scale
}

shinyServer(function(input, output) {
  # The server function.
  #
  # Args:
  #   input:  Input data.
  #   output: Output data.
  #   A predicted seismic intensity code.
  scale <- reactive({
    predictSeismicScale(input$magnitude, input$depth, input$location)
  })
  
  output$scale <- renderUI(
    tags$div(
      class=paste("shindo", scale(), sep=""),
      p('The Japan Meteorological Agency seismic intensity scale is :'),
      h3(gsub("_", "-", as.character(scale())), style="text-align: center"),
      p('The equivalent rating on Mercalli Scale is :'),
      h4(as.character(kScale[kScale$seismic==scale(),]$mercalli),
         style="text-align: center")
    )    
  )
})
