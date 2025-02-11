# Required packages
library(here)
library(tidyverse)
library(GGally)
library(skimr)
library(naniar)
library(mice)
library(ggridges)

# Replace 'path/to/your/file.csv' with the actual file path
data <- read_csv("data/messy_penguins.csv")

