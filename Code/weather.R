library(tidyverse)
library(rclimateca)

ec_climate_search_locations("Medicine Hat")
 
df = ec_climate_data(location = 48949,
                timeframe = "hourly", 
                start = "2018-01-01",
                end = "2019-06-02")

write_rds(df, "Data/WeatherData.rds")

