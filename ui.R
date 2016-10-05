library(shiny)

shinyUI(fluidPage(
  includeCSS("style.css"),
  
  headerPanel("Seismic Intensity Scale Predictor"),
  
  sidebarPanel(
    h3('Operation Panel'),
    sliderInput(inputId = "magnitude",
                label = "Choose a magnitude",
                value = 5, min = 0, max = 10, step=0.1),
    sliderInput(inputId = "depth",
                label = "Choose a depth in km",
                value = 0, min = 0, max = 700, step=1),
    radioButtons(inputId = "location",
                 label = "Choose a location of the epicenter",
                 choices = c("Land" = "land", "Sea" = "sea"),
                 selected = "land", inline = TRUE),
    hr(),
    h3('How to Use'),
    p('Choose a ', tags$i('magnitude,'), ' a ', tags$i('depth'), 
      '(in km) and a ', tags$i('location'), ' of the epicenter',
      ' from the Operation Panel, then the predicted ',
      tags$i('maximum seismic intensity scale'), 
      'will be shown on the right panel.'),
    p('For example, try these:', tags$br(), 
      'magnitude=6.2, depth=4, location=land (Accumli Italy, August 24 2016)',
      tags$br(), 
      'magnitude=4.1, depth=62, location=sea (Ibaraki Japan, May 23 2016)',
      tags$br(), 
      'magnitude=8.1, depth=682, location=sea (Ogasawara Japan, May 30 2015)'),
    p('Visit ', tags$a('https://torigon.github.io/earthquake/', 
                       href='https://torigon.github.io/earthquake/', 
                       target="_blank"), ' for more details.'),
    width = 5
  ),
  
  mainPanel(
    # scale <- textOutput("scale"),
    # scaleClass <- paste("shindo", scale, sep=""),
    fluidRow(
      h3('Predicted Maximum Seismic Intensity Scale')
    ),
    fluidRow(
      # tags$div(class="shindo3", p("test!")),
      # h3(textOutput("scale")), tags$br(),
      uiOutput("scale")
    ),
    width = 7
  )
))
