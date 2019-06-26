library(shiny)
library(plotly)
library(shinycustomloader)
library(shinythemes)

# Define UI for application
shinyUI(
  # Important for saving states
  function(request){
    fluidPage(
      
      theme = shinytheme("paper"),
      
      tags$style(".selectize-input.focus {
             border-color: #2196f3;
             border-width: 1.5px;
             outline: 0;
            -webkit-box-shadow: 0px 1px 1px rgba(0,0,0,.1);
              box-shadow: 0px 1px 1px rgba(0,0,0,0.1);}"),
      
      tags$style(".well {
              min-height: 20px;
              padding: 19px;
              margin: 15px;
              margin-bottom: 20px;
              background-color: #fbfbfb;
              border-color: #f2f2f2;
              border-radius: 2px;
              -webkit-box-shadow: 0px 3px 3px rgba(0,0,0,.3);
              box-shadow: 0px 3px 3px rgba(0,0,0,0.3);}"), 
      
      
      tags$style(".nav-tabs {
              border-bottom: 1px solid transparent;
              padding-bottom: 10px}"),
      
      tags$style(".btn-default {
              color: #ffffff;
              background-color: #2196f3;
              border-radius: 2px;    
              -webkit-box-shadow: 0px 3px 3px rgba(0,0,0,.0);
              box-shadow: 0px 3px 3px rgba(0,0,0,0.0);}"),
      
      tags$style("label {
              font-weight: bold;, 
              font-size: large}"),
      
      
      titlePanel(HTML("<font color = '#2196f3'>Volkswagen</font>
                  <b>E-Golf</b> Data Explorer"), 
                 windowTitle = "EVDB"),
      
      tabsetPanel(
        tabPanel("Common Questions",
                 icon = icon("book-reader"),
                 includeMarkdown("FAQ.rmd")
        ),
        tabPanel("Explore",
                 icon = icon("binoculars"),
                            sidebarLayout(
                              sidebarPanel(
                                width = 2,
                                shiny::selectInput(
                                  "y",
                                  "Vertical Variable:",
                                  selected = "range_start",
                                  choices = c(
                                    "Range at Start" = "range_start",
                                    "Energy Use (Kwh/100km)" = "economy",
                                    "Blue Score" = "blue_score",
                                    "Average Speed (km/h)" = "average_speed"
                                  )
                                ),
                                
                                shiny::selectInput(
                                  "x",
                                  "Horizontal Variable:",
                                  selected = "start_outside_temp",
                                  choices = c(
                                    "Outside Temp at Start" = "start_outside_temp",
                                    "Inside Temp at Start" = "start_inside_temp",
                                    "Outside Temperature at End" = "finish_outside_temp",
                                    "Inside Temperature at End" = "finish_inside_temp",
                                    "Average Speed" = "average_speed",
                                    "Energy use (Kwh/100km)" = "economy",
                                    "Humidity" = "rel_hum",
                                    "Trip Duration" = "trip_duration",
                                    "Range Remaining" = "range_remaining"
                                  )
                                ),
                                
                                shiny::selectInput(
                                  "group",
                                  "Group Variable:",
                                  choices = c("Lighting" = "lighting",
                                              "Road Conditions" = "road_conditions",
                                              "Brake Mode" = "brake_mode",
                                              "Number of Occupants" = "num_occupants",
                                              "Climate control" = "climate_control"
                                  )
                                ),
                                
                                checkboxInput("facet_plot", "Split Groups", value = F),
                                bookmarkButton(label = "Bookmark", icon = icon("bookmark"))
                              ),
                              
                              mainPanel(width = 10,
                                plotlyOutput("mainChart",
                                              height = "700px",
                                              width = "100%"
                                )
                              )
                            )
                                
        ),
        

        
        tabPanel("Help",
                 icon = icon("question-circle"),
                 includeMarkdown("Help.rmd")
        )
      )
    )}
)

