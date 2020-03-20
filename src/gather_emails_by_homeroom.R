
# SET-UP ------------------------------------------------------------------
library(readr)
library(devtools)
library(tabbryverse)
library(purrr)
library(openxlsx)

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
  mutate(home_room = str_to_lower(home_room)) %>%
  mutate_if(is.character, str_trim)

source(here::here("data", "01-manual_tables.R"))

student_emails_complete <- 
  student_export_emails %>%
  left_join(cps_school_rcdts_ids, 
            by = c("SchoolID" = "schoolid"))


# FUNCTIONS ---------------------------------------------------------------

# creates csv for each homeroom (by school) and saves it to the output folder. 
homeroom_sort <- function(abbrev, dataset) {
  single_school <- 
    dataset %>%
    filter(abbr == abbrev)
  
  single_school_homeroom <- 
    unique(single_school$home_room)
  
  for (homeroom in single_school_homeroom) {
    dataset <- 
      single_school %>% 
      filter(home_room == homeroom)
    file_name = paste(abbrev, homeroom, ".xlsx")
    
    write.xlsx(dataset, 
              here::here("output", file_name), 
              row.names = FALSE
              )
  }
}

# Lists -------------------------------------------------------------------

schoolabbrs <- unique(student_emails_complete$abbr)

# Create csv file for each schools homeroom -------------------------------

for (id in schoolabbrs) {
  homeroom_sort(id, student_emails_complete)
}


