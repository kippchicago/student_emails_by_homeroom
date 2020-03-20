

# SET-UP ------------------------------------------------------------------
library(readr)
library(devtools)
library(tidyverse)
library(purrr)

# github version of package has function we need, CRAN version does not
install_github("tidyverse/googlesheets4", force = TRUE)

# Upload file
student_export_emails <- read_csv(here::here("data", "student_export_emails.csv"), 
  col_types = list(
    col_character(),
    col_character(),
    col_character(),
    col_character(),
    col_character(),
    col_character(),
    col_character()
    ), 
  trim_ws = TRUE
  ) %>%
  rename("email" = "U_LD_Account_Management.Student_Email") %>%
  mutate(home_room = str_to_lower(home_room))


# FUNCTIONS ---------------------------------------------------------------

# creates csv for each homeroom (by school) and saves it to the output folder. 
homeroom_sort <- function(id, dataset) {
  single_school <- 
    dataset %>%
    filter(SchoolID == id)
  
  single_school_homeroom <- 
    unique(single_school$home_room)
  
  for (homeroom in single_school_homeroom) {
    dataset <- 
      single_school %>% 
      filter(home_room == homeroom)
    file_name = paste(id, homeroom, ".csv")
    
    write.csv(dataset, here::here("output", file_name))
  }
}


# Create csv file for each schools homeroom -------------------------------

schoolids <- unique(student_export_emails$SchoolID)

for (schoolid in schoolids) {
  homeroom_sort(schoolid, student_export_emails)
}


