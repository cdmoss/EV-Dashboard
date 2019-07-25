library(shiny)
library(tidyverse)
library(plotly)
library(glue)
library(ggsci)

# Define server logic
shinyServer(function(input, output, session) {
  
  # function that creates more user friendly labels for each variable
  labeller = function(x){
    y = case_when(
      x == "economy" ~ "Energy Use (Kwh/100km)",
      x == "blue_score" ~ "Blue Score",
      x == "average_speed" ~ "Average Speed (km/h)",
      x == "start_outside_temp" ~ "Outside Temperature at Start",
      x == "start_inside_temp" ~ "Inside Temperature at Start",
      x == "finish_outside_temp" ~ "Outside Temperature at End",
      x == "finish_inside_temp" ~ "Inside Temperature at Finish",
      x == "lighting" ~ "Lighting",
      x == "brake_mode" ~ "Brake Mode",
      x == "drive_mode" ~ "Drive Mode",
      x == "road_conditions" ~ "Road Conditions",
      x == "range_start" ~ "Range at Start",
      x == "num_occupants" ~ "Number of Occupants",
      x == "climate_control" ~ "Climate Control",
      x == "rel_hum" ~ "Relative Humidity",
      x == "trip_duration" ~ "Trip Duration",
      x == "range_remaining" ~ "Range Remaining",
      TRUE ~ x
    )
    return(y)
  }
  
  # Load data
  df <- reactive({
    dat <- read_csv("data.csv")
    #tyy <<- dat
    dat = dat[c(input$x, input$y, input$group, "start_notes", "finish_notes")]
    names(dat)[1] <- "x_var"
    names(dat)[2] <- "y_var"
    names(dat)[3] <- "group_var"
    dat
  })
  
  limiter = function(dataframe, x = "x_var", y = "y_var", 
                     cor_lim = 0.7, rsq_lim = 0.5){
    a = cor(dataframe[[y]], dataframe[[x]], use = "pairwise.complete.obs") 
    b = a ** 2
    print(glue::glue("Cor: {a}"))
    print(glue::glue("RSQ: {b}"))
    
    dataframe$show_trend = ifelse(abs(a) > cor_lim && b > rsq_lim, 1, 0) %>% 
      factor(c(1, 0))
    
    print(dataframe)
    return(dataframe)
  }
  
  
  output$mainChart <- renderPlotly({
    plot_data = df() %>% 
      mutate(Notes = paste0("<b>Start Notes:</b> ", start_notes, 
                            "\n<b>Finish Notes:</b> ", finish_notes) %>% 
               str_remove_all("NA"),
             Notes = ifelse(Notes == "<b>Start Notes:</b> \n<b>Finish Notes:</b> ", "", Notes),
             color_var = ifelse(Notes == "", "0", "1")
             ) %>% 
      mutate(group_var = as.character(group_var)) %>% 
      drop_na(group_var)
    
    if (input$facet_plot == T){
      p = plot_data %>%
        group_by(group_var) %>% 
        do(limiter(.)) %>% 
        ungroup() %>%
        ggplot(aes(x = x_var, y = y_var, group = group_var)) + 
        facet_wrap(~group_var, scales = "free", ncol = 1)
    } else {
      p = plot_data %>%
          limiter() %>%
        ggplot(aes(x = x_var, y = y_var))
    }
    
    p = p + 
      labs(x = labeller(input$x),
           y = labeller(input$y)) + 
      geom_point(aes(fill = group_var, 
                     shape = group_var, 
                     text = Notes),
                 alpha = 0.15, 
                 size = 4,
                 stroke = 0)
        
     #if (input$trend == T) {
       p = p + 
         #geom_smooth(method = "lm", alpha = 0.25, color = NA) + 
         geom_smooth(method = "lm", show.legend = F, se = F, 
                     aes(color = ifelse(show_trend == 1, "1", NA_character_))) + 
         scale_color_manual(values = c("#2196f3", NA), 
                            breaks = c(1, 0), 
                            labels = c("Significant Trend", "Insignificant Trend"))
     #}
    
   p = p +
      ggtitle(label = 
                glue("{labeller(input$y)} & {labeller(input$x)}")) + 
      theme_minimal() + 
      theme(legend.title = element_blank(), 
            plot.title = element_text(size = 15, vjust = 20, hjust = 0), 
            axis.title = element_text(size = 10)
            ) + 
     scale_fill_manual(values = c("#2196f3", "#771a39", "#358a93", "#1b1e47", "#bfaac1"))
    
    ggplot_plot <<- p
   
    plotly_plot <<- p %>% 
      ggplotly(tooltip = "text") %>% 
      config(displayModeBar = F)
    
    # this gets me the length of how many objects the legend is created for
    # i need to know where to stop my loop at
    ll = plotly_plot$x$data %>% length
    
    # this gets the length of unique group_variables
    # i need to know how many legends to 'skip' in my loop when i'm turning off legends
    gvll = p$data$group_var %>% unique %>% length
    
    # this turns off the legend for 'geoms' added after the scatter points
    # it begins at the start of everything outside of the group vars 'gvll'
    # and it ends at the last index of the plotly object
    for(i in (gvll + 1):ll){
      plotly_plot$x$data[[i]]$showlegend = F
    }
    
    # ggplotly when you've got multiple aesthetics really messes with the legend format
    # this little loop goes through the plotly object and fixes the formatting
    for(i in 1:gvll){
      plotly_plot$x$data[[i]]$name = plotly_plot$x$data[[i]]$name %>% 
        str_remove("\\(") %>% 
        str_remove(",.*")
    }
    
    plot_gg(plotly_plot)
    
  })
  
})
