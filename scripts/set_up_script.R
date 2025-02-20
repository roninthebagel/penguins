# Required packages
library(here)
library(tidyverse)
library(GGally)
library(skimr)
library(naniar)
library(mice)
library(ggridges)
library(usethis)
library(gitcreds)
library(janitor)
library(forcats)
library(lubridate)

# github credentials
library(usethis) 
use_git_config(user.name  = "roninthebagel",
               user.email = "ronin@run2online.com")

usethis::create_github_token()

gitcreds::gitcreds_set()
