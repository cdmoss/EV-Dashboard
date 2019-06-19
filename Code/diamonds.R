library(tidyverse)

diamonds = ggplot2::diamonds

diamonds %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_smooth(alpha = 0.2) + 
  geom_point(aes(color = clarity)) +
  facet_wrap(~cut) + 
  theme_minimal() + 
  theme(axis.text.x = element_blank())
