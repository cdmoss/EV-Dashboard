library(shiny)
library(plotly)

# Define UI for application
shinyUI(fluidPage(
  
  tags$style(".selectize-input.focus {
             border-color: #e1f2ec;
             border-width: 1.5px;
             outline: 0;
             -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,0), 0 0 3px rgba(0, 0, 0, 0);
             box-shadow: inset 0 1px 1px rgba(0,0,0,0), 0 0 3px rgba(0, 0, 0, 0);
             }"),
  
  tags$style(".well {
    min-height: 20px;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #fcfcfc;
    border: 1px solid #e3e3e3;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.05);}"), 
  
  titlePanel("Volkswagen E-Golf Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,
      
      shiny::selectInput(
        "y",
        "Choose a vertical axis variable:",
        choices = c(
          `Economy (Kwh/100km)` = "economy",
          'Blue Score' = "blue_score",
          'Average Speed (km/h)' = "average_speed",
          `Outside Temperature at Start` = "start_outside_temp",
          'Inside Temperature at Start' = "start_inside_temp",
          'Outside Temperature at End' = "finish_outside_temp",
          'Inside Temperature at End' = "finish_inside_temp"
        )
      ),
      
      shiny::selectInput(
        "x",
        "Choose a horizontal axis variable:",
        choices = c(
          `Outside Temp at Start` = "start_outside_temp",
          'Average Speed' = "average_speed",
          `Inside Temp at Start` = "start_inside_temp",
          `Range at Start` = "range_start",
          `Blue Score` = "blue_score",
          'Outside Temperature at End' = "finish_outside_temp",
          'Inside Temperature at End' = "finish_inside_temp",
          'Economy (Kwh/100km)' = "economy"
        )
      ),
      
      selectInput(
        "group",
        "Choose a variable to be grouped by color:",
        choices = c(
          Lighting = "lighting",
          `Road Conditions` = "road_conditions",
          `Drive Mode` = "drive_mode",
          `Brake Mode` = "brake_mode"
        )
      ),
      
      radioButtons(
        "trend_type",
        label = "Type of trend:",
        choices = c(
          `Straight as an arrow` = "lm",
          `Smooth as silk` = "loess",
          'None' = "none"
        )
      )

    ),
    mainPanel(width = 9,
              plotlyOutput("mainChart", height = "700px", width = "100%")
              #plotOutput("mainChart", height = "700px", width = "100%")
              #echarts4rOutput("mainChart", height = "700px", width = "100%")
    )
  )
))