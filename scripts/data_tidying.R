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

#__________________________----

# fixing typos and standardising text - typos

# checking for typos in "species" column
penguins_clean_names |>  
  distinct(species)

# checking for typos in "region" column
penguins_clean_names |>  
  distinct(region)

# checking for typos in "island" column
penguins_clean_names |>  
  distinct(island)

# checking for typos in "stage" column
penguins_clean_names |>  
  distinct(stage)

# checking for typos in "sex" column
penguins_clean_names |>  
  distinct(sex)

# trimming leading/trailing empty spaces in study name column
penguins_clean_study_name <- penguins_clean_names |>  
  mutate(study_name = str_trim(study_name))

# trimming leading/trailing empty spaces in sample number column
penguins_clean_sample_number <- penguins_clean_study_name |>  
  mutate(sample_number = str_trim(sample_number))

# trimming leading/trailing empty spaces in species column
penguins_clean_species <- penguins_clean_sample_number |>  
  mutate(species = str_trim(species))

# trimming leading/trailing empty spaces in region column
penguins_clean_region <- penguins_clean_species |>  
  mutate(region = str_trim(region))

# trimming leading/trailing empty spaces in island column
penguins_clean_island <- penguins_clean_region |>  
  mutate(island = str_trim(island))

# trimming leading/trailing empty spaces in stage column
penguins_clean_stage <- penguins_clean_island |>  
  mutate(stage = str_trim(stage))

# trimming leading/trailing empty spaces in individual_id column
penguins_clean_individual_id <- penguins_clean_stage |>  
  mutate(individual_id = str_trim(individual_id))

# trimming leading/trailing empty spaces in clutch completion column
penguins_clean_clutch_completion <- penguins_clean_individual_id |>  
  mutate(clutch_completion = str_trim(clutch_completion))

# trimming leading/trailing empty spaces in date egg column
penguins_clean_date_egg <- penguins_clean_clutch_completion |>  
  mutate(date_egg = str_trim(date_egg))

# trimming leading/trailing empty spaces in culmen length column
penguins_clean_culmen_length <- penguins_clean_date_egg |>  
  mutate(culmen_length_mm = str_trim(culmen_length_mm))

# trimming leading/trailing empty spaces in culmen depth column
penguins_clean_culmen_depth <- penguins_clean_culmen_length |>  
  mutate(culmen_depth_mm = str_trim(culmen_depth_mm))

# trimming leading/trailing empty spaces in flipper length column
penguins_clean_flipper_length <- penguins_clean_culmen_depth |>  
  mutate(flipper_length_mm = str_trim(flipper_length_mm))

# trimming leading/trailing empty spaces in body mass column
penguins_clean_body_mass <- penguins_clean_flipper_length |>  
  mutate(body_mass_g = str_trim(body_mass_g))

# trimming leading/trailing empty spaces in sex column
penguins_clean_sex <- penguins_clean_body_mass |>  
  mutate(sex = str_trim(sex))
