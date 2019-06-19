library(tidyverse)

weather = read_rds("Data/WeatherData.rds")

trips = read_csv("Data/vehicle data/5-27-19/data(charge_ids).csv") 

library(lubridate)

a = trips %>% 
  mutate(date_time_local = paste(trip_date, start_time) %>% 
           as_datetime() %>% round_date("hour")) %>% 
  left_join(weather)

b = a %>% select(trip_date, start_time, date_time_local, 
             temp_c, start_outside_temp, start_inside_temp, finish_outside_temp,
             climate_control, start_departure, driver_num) %>% mutate(diff = temp_c - finish_outside_temp,
                                                          insidediff = temp_c - start_inside_temp)

write_rds(a, "Data/WeatherBound.rds")