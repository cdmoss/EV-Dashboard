library(tidyverse)
library(plotly)

df = read_csv("Dashboard/ChaseDashboard/data.csv")

p = df %>% 
  ggplot(aes(x = average_speed, y = economy)) + 
  geom_point(aes(color = lighting)) + 
  geom_smooth() + 
  theme_minimal() + 
  facet_wrap(~lighting)

plotly::ggplotly(p)
