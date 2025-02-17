# reading .csv file
data <- read_csv("data/messy_penguins.csv")

#__________________________----

# using library(here) - builds a path to a select directory (i.e. dataset)
library(here)
raw_data <- read_csv(here("data", "messy_penguins.csv"))

#__________________________----

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

#__________________________----

# using colnames()
# tells us the names of all columns
colnames(raw_data)

#using "janitor" package and "clean_names" function to standardise column names
penguins_clean_names <- janitor::clean_names(raw_data) 

# view new column names
colnames(penguins_clean_names) 

#__________________________----

# using dplyr::select()
# tells us information with only the mentioned variables
select(
  .data = penguins_clean_names,
  species, sex, flipper_length_mm, body_mass_g)

# or using dplyr::select() to eliminate columns
select(.data = penguins_clean_names,
       -study_name, -sample_number)

# saved progress as a new tibble
new_penguins <- select(.data = penguins_clean_names, 
                       species, sex, flipper_length_mm, body_mass_g)

# using dplyr::filter()
# used to select certain functions or observations

# selecting only adelie penguins
filter(.data = new_penguins, 
       species == "Adelie Penguin (Pygoscelis adeliae)")

# selecting all species but adelie penguins
filter(.data = new_penguins, 
       species != "Adelie Penguin (Pygoscelis adeliae)")

# or
filter(.data = new_penguins, 
       species %in% c("Chinstrap penguin (Pygoscelis antarctica)",
                      "Gentoo penguin (Pygoscelis papua)")
)

# can include multiple expressions too
filter(.data = new_penguins, 
       species == "Adelie Penguin (Pygoscelis adeliae)", 
       flipper_length_mm > 190)

# using dplyr::arrange()
# sorts the rows in the table according to the columns supplied
arrange(.data = new_penguins, 
        sex)

# data arranged in alphabetical order, but can be reversed with desc()
arrange(.data = new_penguins, 
        desc(sex))

# also sort more than one column
arrange(.data = new_penguins,
        sex,
        desc(species),
        desc(flipper_length_mm))

# using dplyr::mutate()
# creates a new variable that doesn’t exist in our dataset
# note that if you want to save your new column you must save it as an object
new_penguins <- mutate(.data = new_penguins,
                       body_mass_kg = body_mass_g/1000)

# using pipes |>
# allows you to send the output from one function straight into another function

# this example uses brackets to nest and order functions
arrange(.data = filter(
  .data = select(
    .data = new_penguins, 
    species, sex, flipper_length_mm), 
  sex == "MALE"), 
  desc(flipper_length_mm))

# this example uses sequential R objects 
object_1 <- select(.data = new_penguins, 
                   species, sex, flipper_length_mm)
object_2 <- filter(.data = object_1, 
                   sex == "MALE")
arrange(object_2, 
        desc(flipper_length_mm))

# this example is human readable without intermediate objects
new_penguins |>  
  select(species, sex, flipper_length_mm) |>  
  filter(sex == "MALE") |>  
  arrange(flipper_length_mm)

# fixing typos and standardising  text

# checking for typos
# Print only unique character strings in this variable
penguins_clean_names |>  
  distinct(sex)

# triming leading or trailing empty spaces
penguins_clean_names |>  
  mutate(sex = str_trim(sex))

# checking species names
penguins_clean_names |>  
  distinct(species)

# editing species names
penguins_clean_names |>
  mutate(species = case_when(species == "adelie penguin (pygoscelis adeliae)"|
                               species ==  "ADELIE PENGUIN (PYGOSCELIS ADELIAE)" ~ "Adelie Penguin (Pygoscelis adeliae)",
                             species == "gentoo penguin (pygoscelis papua)"|
                               species ==  "GENTOO PENGUIN (PYGOSCELIS PAPUA)" ~ "Gentoo penguin (Pygoscelis papua)",
                             species == "chinstrap penguin (pygoscelis antarctica)"|
                               species ==  "CHINSTRAP PENGUIN (PYGOSCELIS ANTARCTICA)" ~ "Chinstrap penguin (Pygoscelis antarctica)",
                             .default = as.character(species))) 

# using stringr again to simplify the task
# str_to_title is used to assign capital letters to the first letter of each word, we also have str_to_lower and str_to_upper
penguins_clean_names |> 
  mutate(species = str_to_title(species))

# standardising text
# use mutate and case_when 
# for a statement that conditionally changes 
# the names of the values in a variable
penguins_clean_names |> 
  mutate(species = stringr::word(species, 1)
  ) |> 
  mutate(sex = stringr::str_to_title(sex)) |> 
  select(species, sex)

# scientific names in spearate column
penguins_clean_names |> 
  separate(
    species,
    into = c("species", "full_latin_name"),
    sep = "(?=\\()"
  ) |> 
  mutate(species = stringr::word(species, 1)

# checking for duplications
# check for whole duplicate 
# rows in the data
penguins_clean_names |> 
  duplicated() |>  
  sum() 

# removing duplicated rows
# Inspect duplicated rows
penguins_clean_names |> 
  distinct()

# inspecting duplicated rows
penguins_clean_names |>
  dplyr::group_by(dplyr::across(everything())) |>
  dplyr::filter(dplyr::n() > 1) |>
  dplyr::ungroup() |> view()

# applying functions to columns
penguins_clean_names |> 
  mutate(
    across(.cols = c("species", "region", "island", "stage", "sex"),
           .fns = forcats::as_factor)
  ) |> 
  select(where(is.factor)) |> 
  glimpse()

# setting factor levels
# specicify correct order
penguins_factor <- penguins_clean_names |> 
  mutate(mass_range = case_when(
    body_mass_g <= 3500 ~ "smol penguin",
    body_mass_g >3500 & body_mass_g < 4500 ~ "mid penguin",
    body_mass_g >= 4500 ~ "chonk penguin",
    .default = NA)
  )

# mking bar plot from data
penguins_factor |> 
  drop_na(mass_range) |> 
  ggplot(aes(x = mass_range))+
  geom_bar()

# converting characters or numeric columns to class value
penguins_factor <- penguins_factor |> 
  mutate(mass_range = as_factor(mass_range))
levels(penguins_factor$mass_range)

# using mutate() and as_factor() to convert the column flipper_range from class character to class factor
# Correct the code in your script with this version
penguins_factor <- penguins_factor |> 
  mutate(mass_range = fct_relevel(mass_range, 
                                  "smol penguin", 
                                  "mid penguin", 
                                  "chonk penguin")
  )

levels(penguins_factor$mass_range)

# remaking bar plot
penguins_factor |> 
  drop_na(mass_range) |>  
  ggplot(aes(x = mass_range))+
  geom_bar()
