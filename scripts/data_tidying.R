# reading .csv file
data <- read_csv("data/messy_penguins.csv")

# using library(here) - builds a path to a select directory (i.e. dataset)
library(here)
raw_data <- read_csv(here("data", "messy_penguins.csv"))

# using glimpse()
# Quickly inspect the structure of the dataset, including column names and types
glimpse(raw_data)

# using summary()
# like using glimpse(), but also get summary statistics
summary(raw_data)

# using skim()
# generates a comprehensive summary of each column, 
# including data types, missing values, and descriptive statistics
skim(raw_data)

# using colnames()
# tells us the names of all columns
colnames(raw_data)

#using "janitor" package and "clean_names" function to standardise column names
penguins_clean_names <- janitor::clean_names(raw_data) 

# view new column names
colnames(penguins_clean_names) 

