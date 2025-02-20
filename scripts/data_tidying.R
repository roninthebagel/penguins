# reading .csv file
raw_data <- read_csv("data/messy_penguins.csv")

#__________________________----

# Quickly inspect the structure of the dataset, including column names and types
glimpse(raw_data)

# statistic inspection
summary(raw_data)

# viewing data statistics with histograms
skim(raw_data)

#__________________________----

# cleaning column names

# inspecting column names
colnames(raw_data)

# cleaning column names
penguins_clean_names <- janitor::clean_names(raw_data)

# viewing new column names
colnames(penguins_clean_names) 

