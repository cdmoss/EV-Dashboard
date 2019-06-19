library(tidyverse)

df = read_csv("Dashboard/CD2/data.csv")

lm(range_start~start_outside_temp, data = df) %>% 
  summary()


df %>% 
  select(range_start, start_outside_temp) %>% 
  mutate(below_zero = ifelse(start_outside_temp < -10, 1, 0)) %>% 
  group_by(below_zero) %>% 
  summarise(range = mean(range_start, na.rm = T), count = n())

lm(blue_score~average_speed, data = df) %>% 
  summary()

