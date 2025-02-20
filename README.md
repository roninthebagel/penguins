# using glimpse()
-> quickly inspect the structure of the dataset, including column names and types
-> good if need to quickly check dataset

______________________________________________________________________________

# using summary()
-> like using glimpse(), but also get summary statistics

______________________________________________________________________________

# using skim()
-> generates a comprehensive summary of each column
-> includes data types, missing values, and descriptive statistics

______________________________________________________________________________

# using colnames()
-> tells us the names of all columns
-> good to check column names, particulaly when checking for standardness and after editing them

______________________________________________________________________________

# using dplyr::select()
-> tells us information with only the mentioned variables
-> good for creating simplified data sets

______________________________________________________________________________

# using dplyr::filter()
-> used to select certain functions or observations
-> can select or exclude variables for a new data set

A < B	less than
A <= B	less than or equal to
A > B	greater than
A >= B	greater than or equal to
A == B	equivalence
A != B	not equal
A %in% B	in

______________________________________________________________________________

# using dplyr::arrange()
-> sorts the rows in the table according to the columns supplied
-> for example, to set variables in alphabetical order

______________________________________________________________________________

# using dplyr::mutate()
-> creates a new variable that doesn’t exist in our dataset
-> note that if you want to save your new column you must save it as an object (using tibble creation method)

______________________________________________________________________________

# using pipes |>
-> allows you to send the output from one function straight into another function
-> similar to using %>% or +

______________________________________________________________________________

# checking for typos
-> distinct() can be used to check for typos
-> mutate() and "stringr" can then be used to clean in-table names and remove leading/trailing empty spaces

-> checking for typos in "type" column

dataset_name |>  
  distinct(col.name)

-> trimming leading/trailing empty spaces in partners column

new_tibble_name <- dataset_name |>  
  mutate(col.name = str_trim(col.name))

-> formatting type column values

new_tibble_name <- dataset_name |> 
  mutate(col.name = str_to_title(col.name))

______________________________________________________________________________

# standardising text values
-> using mutate() and select()
-> ensures all in-table names are the same

new_tibble_name <- dataset_name |> 
  mutate(col.name = stringr::word(col.name, 1)

______________________________________________________________________________

# duplications
-> checking for duplications, as rows may be inputted several times. so they need to be removed

-> checking whole dataset for duplicates

dataset_name |> 
  duplicated() |>  
  sum() 

-> this will give you a value telling you how many duplicated rows are present in the data set
[1] 18
-> so in this example, there are 18 duplicates

-> removing duplicated rows

new_tibble_name <- dataset_name |> 
    distinct()

______________________________________________________________________________

# factors
-> allows for ordered categories with a fixed set of acceptable values
-> converts chactegorial values to numerical values
-> uses the "forcats" package and forcats::as.factor() function

-> creating a factor

dataset_name |> 
  mutate(
    across(.cols = c("col.name1", "col.name2"),
           .fns = forcats::as_factor)
  ) |> 
  select(where(is.factor)) |> 
glimpse()

-> can be used with 1 col.name, so remove c() if that's the case

______________________________________________________________________________

# missing data
-> missing data can skew results and reduce the power of analysis, so needs to be checked and edited/removed

-> use complete cases (>5% data) - removing data

new_tibble_name <- dataset_name |>
  filter(is.na(col.name)) |> 
  group_by(col.name) |>                 
  summarise(n_missing = n())    

#__________________________----

-> impute missing data (5-30% data) - preserving statistical power and reducing bias by assuming data is missing at random

new_tibble_name <- dataset_name |> 
  mutate(variable.name = replace_na(variable.name, 
                                  mean(dataset_name$variable.name, na.rm = T)))

-> the "mice" package can be used to support many imputation methods depending on the type of data

-> Run the mice function with maxit=0
-> This allows us to extract the default predictor matrix and methods without performing actual imputation

imp <- mice(dataset_name, maxit=0)

-> Extract the predictor matrix from the imputation object

predM <- imp$predictorMatrix

-> note that character columns will not be included for imputation unless it is coded as a factor
-> further use of the mice package and imputation methods are found in the workbook

#__________________________----

-> drop the variable (30-40% data) - explore more advanced missing data models
