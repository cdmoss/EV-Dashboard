library(tidyverse)
library(h2o)
library(lubridate)
library(caTools)

h2o.init()

df = read_rds("Data/WeatherBound.rds")

set.seed(101) 
sample = sample.split(df$range_remaining, SplitRatio = .75)
subset(df, sample == TRUE) %>% write_csv("Data/h2odata/train.csv")
subset(df, sample == FALSE) %>% write_csv("Data/h2odata/test.csv")

train <-  h2o.importFile("Data/h2odata/train.csv")
test = h2o.importFile("Data/h2odata/test.csv")

m = h2o.automl(x = c("economy", "blue_score",
                     "start_outside_temp",
                     "average_speed", 
                     "road_conditions"), 
               y = "range_remaining", 
               training_frame = train, 
               max_models = 15)

dtest = test %>% as_tibble

preds = h2o.predict(m, test, type = "prob")

dtest$prediction = preds[[1]] %>% as.vector

dtest %>% 
  select(range_remaining, prediction) %>% 
  mutate(diff = range_remaining - prediction) %>% 
  pull(diff) %>% mean(na.rm = T)

