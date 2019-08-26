library(shiny)
library(plotly)
library(shinycustomloader)
library(shinythemes)
library(shinyjs)

# Define UI for application
shinyUI(
  # Important for saving states
  function(request){
    fluidPage(
      useShinyjs(),
      theme = shinytheme("paper"),
      
      tags$style("#mainChart {
                 margin-bottom: 50px;
                 "),
      
      tags$style("#quick-tips {
                  margin-top: 20px;
                 "),
      
      tags$style("#title2 {
                  float: left;
                  margin-bottom: 10px;
                  text-shadow: 1px 1px 5px #D8D8D8;
                 }"),

      tags$style("#context-banner2 {
                  padding: 5px 20px;
                  background-color: white;
                  float:left;
                  width: 100%;
                  box-shadow: 1px 1px 3px 1px #D8D8D8;
                  border-top: 1px;
                  border-radius: 3px;
                  margin: 10px 0px;
                 }"),

      
      tags$style("#welcome-text2 {
                  border-top: 1px solid #D8D8D8;
                  padding-top: 20px;
                  float:left;
                  width: 70%;
                  margin-top: 10px;
                 }"),
      
      tags$style("#car-image2 {
                  float: right;
                  width: 25%;
                  margin: 10px;
                  border-radius: 5px;
                  box-shadow: 1px 1px 6px 2px #D8D8D8;
                 }"),
      
      tags$style(".main-container {
                 box-shadow: 1px 1px 6px 2px #D8D8D8;
                }"),
      
      tags$head(includeHTML("analytics.html")),
      
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
      
      #tags$h2(id="title", 
       #       tags$span("Volkswagen", style = "color: #2196f3"),
        #      tags$span("E-Golf", style = "font-weight: bold;"),
         #     "Data Explorer"
      #),
      
      #tags$div(id="separator-1"),
      
      #tags$img(id="car-image", src = "EV_439.jpg", alt="Volkswagen_logo.png"),
      
      #withTags({
      #  div(id="context-banner",
       #   p(id="welcome-text", "Welcome to the Medicine Hat College Electric Vehicle Dashboard! Last November,
        #    MHC partnered with Southland Volkswagen in order to learn about electric vehicles. 
         #   This tool was created to answer some common questions about the E-golf and electric vehicles,
          #  and to allow anyone to explore the data that we have collected over the course of this project.")
        #)
      #}),
      
      tags$div(id="separator-test"),
      
      withTags({
        div(id="context-banner2",
            h2(id="title2", 
              span("Volkswagen", style = "color: #2196f3"),
              span("E-Golf", style = "font-weight: bold;"),
              "Data Explorer"
            ),
            img(id="car-image2", src = "EV_439.jpg", alt="Volkswagen_logo.png"),
            p(id="welcome-text2", "Welcome to the Medicine Hat College Electric Vehicle Dashboard! Last November,
            MHC partnered with Southland Volkswagen in order to learn about electric vehicles. 
            This tool was created to answer some common questions about the E-golf and electric vehicles,
            and to allow anyone to explore the data that we have collected over the course of this project.")
        )
      }),
      
      tags$div(id="separator-2"),
      
      tabsetPanel(
        tabPanel("Common Questions",
                 icon = icon("book-reader"),
                 tags$iframe(src = 'FAQ15.html', 
                             width = '100%', height = '1400px', 
                             frameborder = 0, scrolling = 'auto')
        ),
        tabPanel("Explore",
                 icon = icon("binoculars"),
                 
                 sidebarLayout(
                              sidebarPanel(
                                width = 3,
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
                                    #"Humidity" = "rel_hum",
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
                                
                                bookmarkButton(label = "Save", icon = icon("bookmark")),
                                
                                tags$div(id="quick-tips",
                                         tags$h6("Quick Tips:"),
                                         tags$p("1. A strong relationship will cause a blue line
                                                of best fit to display."),
                                         tags$p("2. Hide/show groups by clicking the group names in the legend."),
                                         tags$p("3. Use the mouse to select an area to be zoomed,
                                                double click the chart to zoom back out."),
                                         tags$p("Check the help tab for more information about using the tool.")
                                )
                                
                                
                                
                              ),
                              
                              
                              mainPanel(width = 9,
                                plotlyOutput("mainChart",
                                              height = "700px",
                                              width = "100%"
                                )
                              )
                              
        
                            )
        ),
        
        tabPanel("Help",
                 icon = icon("question-circle"),
                 includeMarkdown("Help.Rmd")
        )
      )
    )}
)

