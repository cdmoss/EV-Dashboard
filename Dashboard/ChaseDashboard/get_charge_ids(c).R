library(tidyverse)
library(lubridate)

df = read_csv("Dashboard/ChaseDashboard/data.csv")

charge_ids = df %>% 
  select(trip_num, charge_date, charge_time) %>% 
  drop_na %>% 
  mutate(charge_datetime = paste(charge_date, charge_time) %>% 
           lubridate::as_datetime(),
         charge_id = seq(1:nrow(.)))

dat = df %>% 
  mutate(trip_datetime = paste(trip_date, start_time) %>% 
           lubridate::as_datetime()) %>% 
  full_join(charge_ids) %>% 
  mutate(charge_id = ifelse(is.na(charge_id), 
                            zoo::na.locf(charge_id, fromLast = T), 
                            charge_id)) %>% 
  select(-contains("datetime"))
