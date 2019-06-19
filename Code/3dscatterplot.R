library(tidyverse)
library(plotly)

df = read_rds("Data/WeatherBound.rds")

df %>% 
  plot_ly(x = ~range_start, y = ~start_outside_temp, 
          z = ~average_speed, color = ~lighting, symbol = ~lighting) %>%
  add_trace(marker = list(opacity = 0.5))

