
library(readr)
library(devtools)
library(tidyverse)
library(purrr)
# github version of package has function we need, CRAN version does not
install_github("tidyverse/googlesheets4", force = TRUE)

# Upload file
student_export_emails <- read_csv("~/Downloads/student.export.emails.csv") %>%
  rename(email = U_LD_Account_Management.Student_Email)

# Function to filter only for KAC homeroom
homeroom_sort <- function(homeroom_name){
  student_export_emails %>%
    filter(SchoolID == 400146) %>%
    filter(home_room == homeroom_name) %>%
    select(student_number, First_Name, Last_Name, email)
}

# Run for each homeroom
jackson_state <- homeroom_sort("5th Jackson State")

depaul <- homeroom_sort("5th DePaul University")

marist <- homeroom_sort("5th Marist College")

northwestern <- homeroom_sort("6th Northwestern University")

michigan <- homeroom_sort("6th University of Michigan")

wisconsin <- homeroom_sort("6th University of Wisconsin")

columbia <- homeroom_sort("7th Columbia College")

siu <- homeroom_sort("7th Southern Illinois University")

ui <- homeroom_sort("7th University of Illinois")

howard <- homeroom_sort("8th Howard University")

fam <- homeroom_sort("8th Florida A&M University")

clark <- homeroom_sort("8th Clark Atlanta University")


# Final final, creates a sheet on google drive
kac_sheet <- sheets_create("KAC - Emails by Homeroom", 
                           sheets = list("5th Jackson State" = jackson_state, 
                                         "5th DePaul University" = depaul,
                                         "5th Marist College" = marist,
                                         "6th Northwestern University" = northwestern,
                                         "6th University of Wisconsin" = wisconsin,
                                         "7th Columbia College" = columbia,
                                         "7th Southern Illinois University" = siu,
                                         "7th University of Illinois" = ui,
                                         "8th Howard University" = howard,
                                         "8th Florida A&M University" = fam,
                                         "8th Clark Atlanta University" = clark))

