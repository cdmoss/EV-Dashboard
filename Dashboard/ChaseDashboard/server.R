library(shiny)
library(tidyverse)
library(plotly)

# Define server logic
shinyServer(function(input, output) {
  # Load data
  df <- reactive({
    dat = read_csv("data.csv")
    dat = dat[c(input$x, input$y, input$group)]
    names(dat)[1] <- "x_var"
    names(dat)[2] <- "y_var"
    names(dat)[3] <- "group_var"
    dat
  })
  
  # Should think about if there is a better way to write these if/else chains. 
  # As it is now, most of the code is repeated over and over..
  # Look into dplyr::case_when()
  y_label <- reactive({
    req(input$y)
    if(input$y == "economy") {y_label = "Economy (Kwh/100km)"}
    else if(input$y == "blue_score") {y_label <- "Blue Score"}
    else if(input$y == "average_speed") {y_label <- "Average Speed (km/h)"}
    else if(input$y == "start_outside_temp") {y_label <- "Outside Temperature at Start"}
    else if(input$y == "start_inside_temp") {y_label <- "Inside Temperature at Start"}
    else if(input$y == "finish_outside_temp") {y_label <- "Outside Temperature at End"}
    else if(input$y == "finish_inside_temp") {y_label <- "Inside Temperature at Finish"}
  })
  
  # Looks to be the same code here as above
  # Good case for writing a more general labeling function. 
  x_label <- reactive({
    req(input$x)
    if(input$x == "economy") {y_label = "Economy (Kwh/100km)"}
    else if(input$x == "blue_score") {x_label = "Blue Score"}
    else if(input$x == "average_speed") {x_label = "Average Speed (km/h)"}
    else if(input$x == "start_outside_temp") {x_label = "Outside Temperature at Start"}
    else if(input$x == "start_inside_temp") {x_label = "Inside Temperature at Start"}
    else if(input$x == "finish_outside_temp") {x_label = "Outside Temperature at End"}
    else if(input$x == "finish_inside_temp") {x_label = "Inside Temperature at Finish"}
  })
  
  group_label <- reactive({
    req(input$group) # didn't even know req() existed, would have solved some headaches in the past for me
    if(input$group == "lighting") {group_label = "Lighting"}
    else if(input$group == "brake_mode") {group_label = "Brake Mode"}
    else if(input$group == "drive_mode") {group_label = "Drive Mode"}
    else if(input$group == "road_conditions") {group_label = "Road Conditions"}
  })

  
  output$mainChart <- renderPlotly({
    # Uh oh....
    names = c("Economy (Kwh/100km)",
               "Blue Score",
               "Average Speed (km/h)",
               "Inside Temperature at Start",
               "Outside Temperature at start",
               "Inside Temperature at End",
               "Outside Temperature at End"
               )
    
    p = df() %>% 
      ggplot(aes(x = x_var, y = y_var, color = group_var)) +
      geom_point() +
      xlim(min(df()$x_var), max(df()$y_var)) +
      ylim(min(df()$y_var), max(df()$y_var)) +
      labs(x = x_label, y = y_label) + 
      labs(color = group_label)
        
    
    if (input$trend_type == "lm") {
      q = p + geom_smooth(method = "lm", formula=y~x)
    }
    
    if (input$trend_type == "loess") {
      q = p + geom_smooth(method = "loess", formula=y~x)
    }
  
    if (input$trend_type == "none") {
      q = p 
    }
    
    q = q %>% ggplotly()
  })
  
  #output$mainChart <- renderEcharts4r({
    #p = df() %>%
      #drop_na() %>% 
      #group_by(group_var) %>% 
      #e_charts(x = x_var) %>% 
      #e_scatter(serie = y_var, legend = T, symbol_size = 9) %>% 
      #e_lm(y_var~x_var, symbol = "none") %>% 
      #e_loess(y_var~x_var, symbol = "none") %>% 
    #if (input$trend_type == "lm"){p = p %>% e_lm(y_var ~ x_var)}
    #else if (input$trend_type == "loess"){p = p %>% e_loess(y_var ~ x_var)}
      #e_x_axis(min = min(df()$x_var)) %>% 
      #e_y_axis(min = min(df()$y_var)) %>% 
      #e_tooltip( axisPointer = list(
      #type = "cross"
      #)) %>% 
      #e_datazoom(show = T, y_index = 0) %>% 
      #e_datazoom(show = T, x_index = 0)
    
    #p
    
  #})
  
})
