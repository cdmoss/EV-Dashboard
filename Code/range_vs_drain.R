dff = df %>% 
  mutate(range_ind_diff = range_start - range_remaining,
         drain_rate = range_ind_diff/trip_distance
         ) %>% 
  filter(drain_rate != Inf)

a = dff %>% ggplot(aes(x = start_outside_temp, y = drain_rate)) +
  geom_point()

a

