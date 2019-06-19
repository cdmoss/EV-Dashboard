library(shiny)
library(echarts4r)

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
                    BlueScore = "blue_score",
                    Speed = "average_speed",
                    `Energy Economy` = "economy",
                    `Outside Temp at Start` = "starting_outside_temp"
                )
            ),
            
            shiny::selectInput(
                "x",
                "Choose a horizontal axis variable:",
                choices = c(
                    Speed = "average_speed",
                    `Inside Temp at Start` = "starting_inside_temp",
                    `Outside Temp at Start` = "starting_outside_temp",
                    `Range at Start` = "range_start",
                    `Blue Score` = "blue_score",
                    "lighting"
                )
            ),
            
            selectInput(
                "group",
                "Choose a variable to be grouped by color:",
                choices = c(
                    Lighting = "lighting",
                    `Road Conditions` = "road_conditions",
                    `Drive Mode` = "drive_mode",
                    `Brake Mode` = "brakemode"
                )
            )
            #checkboxInput("facet", "Split Groups", value = F),
            #checkboxInput("trend", "Show Trend", value = F),
            #uiOutput("trend_type")
        ),
        mainPanel(width = 9,
                  #plotOutput("scatter", height = "700px", width = "100%"),
                  htmlOutput("e_scatter")
                  )
    )
))
