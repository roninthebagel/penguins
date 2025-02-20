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

# formatting type column values
penguins_format_species <- penguins_clean_sex |> 
  mutate(species = str_to_title(species))

#__________________________----

# fixing typos and standardising text - standardise
penguins_standard_columns <- penguins_format_species |> 
  separate(
    species,
    into = c("species", "full_latin_name"),
    sep = "(?=\\()"
  ) |> 
  mutate(species = stringr::word(species, 1))

#__________________________----

# duplications

# checking whole data set for duplications
penguins_standard_columns |> 
  duplicated() |>  
  sum() 
# 18 duplicated rows

# removing unwanted rows
# Inspect duplicated rows
penguins_no_dupes <- penguins_standard_columns |> 
  distinct()

# checking all unwanted rows were removed
penguins_no_dupes |> 
  duplicated() |>  
  sum() 
# 0 duplicated rows

#__________________________----

# factors

# setting type as a factor
penguins_no_dupes |> 
  mutate(
    across(.cols = c("species", "region", "island", "stage", "sex"),
           .fns = forcats::as_factor)
  ) |> 
  select(where(is.factor)) |> 
  glimpse()
# we only do this with worded values, not numerical ones

# specifying correct order
penguins_factor_specific <- penguins_no_dupes |> 
  mutate(mass_range = case_when(
    body_mass_g <= 3500 ~ "smol penguin",
    body_mass_g >3500 & body_mass_g < 4500 ~ "mid penguin",
    body_mass_g >= 4500 ~ "chonk penguin",
    .default = NA)
  )

# bar creation
penguins_factor_bar <- penguins_factor_specific |> 
  drop_na(mass_range) |> 
  ggplot(aes(x = mass_range))+
  geom_bar()

ggsave("figures/penguins_factor_bar.pdf",
       plot = penguins_factor_bar, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

# converting character and numeric columns to class factor
penguins_factor <- penguins_factor_specific |> 
  mutate(mass_range = as_factor(mass_range))

levels(penguins_factor$mass_range)

# Correct the code in your script with this version
penguins_factor <- penguins_factor |> 
  mutate(mass_range = fct_relevel(mass_range, 
                                  "smol penguin", 
                                  "mid penguin", 
                                  "chonk penguin")
  )

levels(penguins_factor$mass_range)

# new bar plot
penguins_factor_bar_new <- penguins_factor |> 
  drop_na(mass_range) |>  
  ggplot(aes(x = mass_range))+
  geom_bar()

ggsave("figures/penguins_factor_bar_new.pdf",
       plot = penguins_factor_bar_new, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

#__________________________----

# dates

# minimum and maximum dates
penguins_no_dupes |> 
  summarise(min_date=min(date_egg),
            max_date=max(date_egg))

# extracting dates
penguins_dates <- penguins_no_dupes |> 
  mutate(year = lubridate::year(date_egg))

#__________________________----

# missing data

# identifying missing data in study name column
penguins_dates |>
  filter(is.na(study_name)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in sample number column
penguins_dates |>
  filter(is.na(sample_number)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in species column
penguins_dates |>
  filter(is.na(species)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in full latin name column
penguins_dates |>
  filter(is.na(full_latin_name)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in region column
penguins_dates |>
  filter(is.na(region)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in island column
penguins_dates |>
  filter(is.na(island)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in stage column
penguins_dates |>
  filter(is.na(stage)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in individual id column
penguins_dates |>
  filter(is.na(individual_id)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in clutch completion column
penguins_dates |>
  filter(is.na(clutch_completion)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in date egg column
penguins_dates |>
  filter(is.na(date_egg)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# no missing data

# identifying missing data in culmen length column
penguins_dates |>
  filter(is.na(culmen_length_mm)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# 2 missing data points

# identifying missing data in culmen depth column
penguins_dates |>
  filter(is.na(culmen_depth_mm)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# 2 missing data points

# identifying missing data in flipper length column
penguins_dates |>
  filter(is.na(flipper_length_mm)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# 2 missing data points

# identifying missing data in body mass column
penguins_dates |>
  filter(is.na(body_mass_g)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# 13 missing data points

# identifying missing data in sex column
penguins_dates |>
  filter(is.na(sex)) |> 
  group_by(species, sex, island) |>                 
  summarise(n_missing = n())    
# 5 missing data points

# removing missing data
penguins_clean <- penguins_dates|> 
  drop_na(culmen_length_mm, culmen_depth_mm, flipper_length_mm, body_mass_g, sex)

#__________________________----

# exploring patterns of missing data

# graphs and script gets messy, but this bit isn't really required
# the data should now be clean, this bit is more statistical analysis on missing data

# Visualise missing data
penguins_missing_data_plot <- naniar::vis_miss(penguins_clean)

ggsave("figures/penguins_missing_data_plot.pdf",
       plot = penguins_missing_data_plot, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

# Visualize missing data by variable
penguins_missing_data_variable_plot <- gg_miss_var(penguins_clean)

ggsave("figures/penguins_missing_data_variable_plot.pdf",
       plot = penguins_missing_data_variable_plot, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

# exploring patterns of missingness
# Explore missing data patterns
miss_var_summary(penguins_clean)

penguins_clean |> 
  select(species, island, sex) |> 
  group_by(species, island) |> 
  miss_var_summary()

penguins_missingness_pattern_plot <- gg_miss_upset(penguins_clean)

ggsave("figures/penguins_missingness_pattern_plot.pdf",
       plot = penguins_missingness_pattern_plot, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")

# Explore missing data by species
penguins_missing_data_species <- gg_miss_fct(penguins_clean, fct = island)

ggsave("figures/penguins_missing_data_species_plot.pdf",
       plot = penguins_missing_data_species, 
       width = 15,
       height = 10, 
       units = "cm", 
       device = "pdf")
