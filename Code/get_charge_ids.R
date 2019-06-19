library(tidyverse)

df = read_csv("Dashboard/AlexDashboard/merged_data.csv") 

charge_ids = df %>% 
  select(`trip#`, date_charge, time) %>% 
  drop_na %>% 
  mutate(charge_datetime = paste(date_charge, time) %>% 
           lubridate::as_datetime(),
         charge_id = seq(1:nrow(.)))

dat = df %>% 
  mutate(trip_datetime = paste(date_trip, time_start) %>% 
           lubridate::as_datetime()) %>% 
  full_join(charge_ids) %>% 
  mutate(charge_id = ifelse(is.na(charge_id), 
                            zoo::na.locf(charge_id, fromLast = T), 
                            charge_id)) %>% 
  select(-contains("datetime"))

