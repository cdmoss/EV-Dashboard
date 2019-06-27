library(tidyverse)
library(lubridate)

charge = read_csv("Data/vehicle data/newest/charge.csv")
start = read_csv("Data/vehicle data/newest/start.csv")
finish = read_csv("Data/vehicle data/newest/finish.csv")

charge = charge %>% 
  rename(
  "charge_location" = "Charge Location",
  "charge_date" = "Date",
  "charge_time" = "Time",
  "trip_num" = "Prior Trip #",
  "plugin_temp" = "Plug in temp ?C",
  "unplug_temp" = "Unplug temp ?C",
  "charge_departure" = "Departure utilized",
  "power_usage" = "Power usage Kwh",
  "cost" = "Cost",
  "charge_notes" = "Notes: convenience issues/benefits, plug availability, did the car need to be moved"
  )

finish = finish %>% 
  rename(
  "trip_num" = "Trip #",
  "post_trip" = "Post-trip",
  "finish_outside_temp" = "Outside temp ?C",
  "finish_inside_temp" = "Inside Temp ?C",
  "blue_score" = "Blue score",
  "trip_distance" = "Distance Since start Km",
  "average_speed" = "Average Speed Since start Km/hr",
  "trip_duration" = "Time Since start (includes key on)",
  "economy" = "Economy Since start Kwh/100km",
  "range_remaining" = "range indicator Km",
  "brake_mode" = "Brake Mode",
  "climate_control" = "Climate control usage",
  "road_style" = "Road style",
  "reset_meters" = "Reset Meters",
  "finish_notes" = "Notes: Driving area, warnings, reminders, incedents, issues, feeling"
) %>% 
  drop_na('post_trip')

start = start %>% 
  rename(
  "trip_num" = "Trip #",
  "driver_num" = "Driver #",
  "num_occupants" = "# of occupants",
  "pre_trip" = "Pre-trip",
  "trip_date" = "Date",
  "start_time" = "Time",
  "lighting" = "Lighting",
  "road_conditions" = "Road conditions",
  "odometer" = "Odometer",
  "start_outside_temp" = "Outside temp ?C",
  "start_inside_temp" = "Inside temp ?C",
  "start_departure" = "Departure used Y/N",
  "range_start" = "range indicator",
  "drive_mode" = "Driving mode N/E/+",
  "start_notes" = "Notes"
) %>% 
  drop_na('pre_trip')

df = start %>%
  full_join(finish) %>%
  full_join(charge) %>% 
  mutate(
    charge_date = charge_date %>% mdy(),
    trip_date = trip_date %>% mdy(),
    #charge_time = str_remove(charge_time, ".*," %>% trimws()),
    #start_time = str_remove(start_time, ".*" %>% trimws())
    trip_duration = str_remove(trip_duration, ":") %>% as.integer(),
    finish_inside_temp = finish_inside_temp %>% as.double(),
    pre_trip = pre_trip %>% str_replace("Y", "Yes"),
    pre_trip = pre_trip %>% str_replace("N", "No"),
    climate_control = climate_control %>% str_replace("Y", "Yes"),
    climate_control = climate_control %>% str_replace("N", "No"),
    start_departure = start_departure %>% str_replace("Y", "Yes"),
    start_departure = start_departure %>% str_replace("N", "No"),
    #drive_mode = drive_mode %>% str_replace("N", "Normal"),
    #drive_mode = drive_mode %>% str_replace("E", "Eco"),
    #drive_mode = drive_mode %>% str_replace("E?+", "Eco Plus"),
    post_trip = post_trip %>% str_replace("Y", "Yes"),
    post_trip = post_trip %>% str_replace("N", "No"),
    charge_departure = charge_departure %>% str_replace("Y", "Yes"),
    charge_departure = charge_departure %>% str_replace("N", "No"),
    reset_meters = reset_meters %>% str_replace("Y", "Yes"),
    reset_meters = reset_meters %>% str_replace("N", "No")
  )
  #filter(start_outside_temp < 50)
  

charge_ids = df %>% 
  select(trip_num, charge_date, charge_time) %>% 
  drop_na %>% 
  mutate(charge_datetime = paste(charge_date, charge_time) %>% 
           lubridate::as_datetime(),
         charge_id = seq(1:nrow(.)))

df = df %>% 
  mutate(trip_datetime = paste(trip_date, start_time) %>% 
           lubridate::as_datetime()) %>% 
  full_join(charge_ids) %>% 
  mutate(charge_id = ifelse(is.na(charge_id), 
                            zoo::na.locf(charge_id, fromLast = T), 
                            charge_id)) %>% 
  select(-contains("datetime"))

df %>% write_csv("Data/vehicle data/newest/data.csv")
df %>% write_csv("Dashboard/ChaseDashboard/data.csv")
df %>% write_csv("Dashboard/CD2/data.csv")




