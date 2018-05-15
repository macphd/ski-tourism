library(shiny)
library(tidyverse)
library(VIM)
library(plotly)
library(leaflet)

ski_df <- read_csv("ski_knn_model.csv")[2:6] #omit index column

example_df <- read_csv("worldloppet_munged.csv")[-1,-1]
colnames(example_df) <- c('host_country', 'year', 'distance', 'style', 'month', 'week', 
                      'median_pace', 'max_pace', 'n_skiiers', 'tourists')

latlong_df <- read_csv("worldloppet_latlong.csv", col_names = FALSE) %>% 
  set_names(c('abrev', 'lat', 'long', 'name', 'link')) %>% 
  mutate(url = paste0("<b><a href='", link, "'>", name, "</a></b>"))

