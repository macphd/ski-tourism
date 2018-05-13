library(shiny)
library(tidyverse)
library(VIM)

ski_df <- read_csv("ski_knn_model.csv")[2:6] #omit index column
