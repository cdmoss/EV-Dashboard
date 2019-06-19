library(shiny)
library(tidyverse)
library(ggsci)
library(echarts4r)

# Define server logic
shinyServer(function(input, output) {
  # Load data
  df <- reactive({
    dat = read_csv("merged_data.csv")
    dat = dat[c(input$x, input$y, input$group)]
    names(dat)[1] <- "x_var"
    names(dat)[2] <- "y_var"
    names(dat)[3] <- "group_var"
    dat
  })

  output$trend_type <- renderUI({
    if (input$trend == T) {
      radioButtons(
        "trend_type",
        label = "Type of trend:",
        choices = c(
          `Straight as an arrow` = "lm",
          `Smooth as silk` = "loess"
        )
      )
    }
  })
  
  output$e_scatter <- renderUI({
    
    plotr <- function(dataframe){
      dataframe %>% 
        e_charts(x = x_var) %>% 
        e_scatter(serie = y_var, legend = F, symbol_size = 9) %>% 
        e_loess(smooth = T, formula = y_var ~ x_var, legend = F, symbol = "none") %>% 
        e_x_axis(min = min(df()$x_var)) %>% 
        e_y_axis(min = min(df()$y_var)) %>% 
        e_tooltip( axisPointer = list(
          type = "cross"
        )) %>% 
      e_datazoom(show = T, y_index = 0, fillerColor = "#f2f2f2") %>% 
      e_datazoom(show = T, x_index = 0, fillerColor = "#f2f2f2")
    }
    
    printr = function(echart, title){
      echart %>% 
        e_title(title)
    }
    
    test <<- df() %>% 
      drop_na %>% 
      split(.$group_var) %>% 
      map(plotr) %>% 
      map2(names(.), printr)
    
    e_arrange(test)

  })
})
