library(h2o)
library(tidyverse)
library(caTools)

h2o.init()

set.seed(101)

sample = sample.split(diamonds$price, SplitRatio = 2/3)

subset(diamonds, sample == TRUE) %>% write_csv("Data/h2odata/d_train.csv")
subset(diamonds, sample == FALSE) %>% write_csv("Data/h2odata/d_test.csv")

train <-  h2o.importFile("Data/h2odata/d_train.csv")

train[["cut"]] = as.factor(train[["cut"]])

test <-  h2o.importFile("Data/h2odata/d_test.csv")

m = h2o.automl(x = c("carat", "price", "color", "clarity", "depth", 
                     "table", "x", "y", "z"), 
               y = "cut", 
               training_frame = train, 
               max_models = 100, max_runtime_secs = 172800)

dtest = test %>% as_tibble

preds = h2o.predict(m, test, type = "prob")

dtest$prediction = preds[[1]] %>% as.vector

caret::confusionMatrix(dtest$prediction %>% as.factor(),
                       dtest$cut %>% as.factor)

dtest %>% 
  select(price, prediction) %>% 
  mutate(diff = price - prediction) %>% 
  pull(diff) %>% hist(breaks = 1000, xlim = c(-100, 100))

dtest %>% 
  ggplot(aes(x = log(prediction), y = log(price))) + 
  geom_point(alpha = 0.05) + 
  geom_smooth()

lm(log(price) ~ log(prediction), data = dtest) %>% plot()

