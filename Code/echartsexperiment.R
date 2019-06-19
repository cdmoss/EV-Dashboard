library(tidyverse)
library(echarts4r)
library(echarts4r.assets)
library(sRa)

df = get_enrolment("FLE", i = "MH", ages = 2) %>% 
  xmr2(FLE)

df_plot = df %>% 
  mutate(FLE = round(FLE, digits = 2))%>% 
  rename(Year = `Academic Year`, 
         Central = `Central Line`,
         Lower = `Lower Natural Process Limit`, 
         Upper = `Upper Natural Process Limit`)

xmr_echart <- function(dataframe, time, measure){
  dataframe %>% 
    e_charts_(x = time) %>% 
    e_line(serie = Upper, color = sRa2:::crimson, legend = F,
           lineStyle = list(type = "dashed"), symbol = "none")  %>% 
    e_line(serie = Lower, color = sRa2:::crimson, legend = F,
           lineStyle = list(type = "dashed"), symbol = "none")  %>% 
    e_line(serie = Central, color = sRa2:::slate, legend = F,
           lineStyle = list(type = "dotted"), symbol = "none")  %>% 
    e_line_(serie = measure, 
            color = sRa2:::seafoam, 
            legend = F,
            symbolSize = 9, 
            label = list(show = T,
                         color = sRa2:::slate, 
                         padding = 1, 
                         backgroundColor = "#ffffff")) %>% 
    e_y_axis(min = min(dataframe$Lower, na.rm = T) * 0.975,
             max = max(dataframe$Upper, na.rm = T) * 1.025,
             formatter = e_axis_formatter(digits = 0), show = F) %>% 
    e_toolbox_feature(feature = "saveAsImage")
}


xmr_echart(df_plot, "Year", "FLE")




