library(tidyverse)

source("Code/import_data.R")

df = df %>% 
  mutate(
    range_diff = range_start - range_remaining,
    odo_diff = lead(odometer, 1) - odometer,
    range_err = range_diff - odo_diff,
    trip_dist_err = trip_distance - odo_diff
  )

a
