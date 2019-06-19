library(tidyverse)

df = read_csv("vehicle data/merged_data.csv")

df %>% 
  ggplot(aes_string(x = "average_speed", y = "blue_score")) + 
  geom_point()
