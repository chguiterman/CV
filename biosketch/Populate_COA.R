# Fill in author/collaborator region of NSF COA template
## CHG 2022-04-25

library(tidyverse)
library(lubridate)
library(readxl)
library(openxlsx)

auths_in <- read_csv("biosketch/Authors_list.csv",
                     col_types = "ccccccc") %>% 
  mutate(last_active = ym(paste(year, month)))

# templ_in <- loadWorkbook("biosketch/Guiterman_coa_template.xlsx")

# Configure collaborator list -- active in last 48 months
active_period <- interval(today() - months(48), today())
auths <- auths_in %>% 
  filter(last_active %within% active_period,
         ! duplicated(name)) %>% 
  arrange(name, last_active) %>% 
  select(-year, -month)

# writeDataTable(templ_in, 
#                sheet = "NSF COA Template",
#                x = auths, startCol = 1, startRow = 51, colNames = FALSE)

# can't figure out how to "insert" the table into the spreadsheet
# Write out table for copy/paste

write_csv(auths, str_glue("biosketch/{today()}_COA_data.csv"), na = "")
