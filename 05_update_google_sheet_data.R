# Load the main packages
library(readxl)
library(tidyverse)
library(lubridate)
library(googledrive)
library(googlesheets4)



# NEW FILES
# read all intermediate files
list.files('Inter_Data/2020-12-03/') %>%
  map(function(file_name){
    file_path = paste0('Inter_Data/2020-12-03/', file_name)
    assign(x = str_remove(file_name, '.rds'),
           value = read_rds(file_path),
           envir = .GlobalEnv)
  })


# read HUC12 keys
huc12_keys <-
  googlesheets4::read_sheet(
    googlesheets4::as_sheets_id("12et7X9z1DxvpjKCYHp3sdCpagk2jmeiy6wKzilgGIl4"),
    range = "A:C") %>%
  select(-2)


# function to add Project ID and to rename column headings to standard names
column_rename <- function(df) {
  df %>%
    left_join(huc12_keys, by = c("HUC_12" = "ID_HUC12")) %>%
    rename("wsp_id" = "ProjectID", "huc12_id" = "HUC_12") %>%
    select(wsp_id, huc12_id, everything())
}


# function to find google sheet corresponding to the data file and obtaining its id
find_google_sheet <-
  function(df) {
    drive_ls(as_id("1CoCiMcqlC51SVMaIxPDD7P_Z7w18Jg4k")) %>%
      filter(str_detect(name, 
                        unique(df$PRACTICE) %>%
                          # next two lines need to handle WASCOB file name 
                          str_remove(" \\(WASCOB\\)") %>%
                          str_replace(" and", "shed") %>%
                          str_to_lower() %>%
                          str_replace_all(" ", "_"))) %>%
      pull(id)
  }


# function to clean the spreadsheet and to write new data in the same sheet
update_google_sheet <- 
  function(df) {
    GS <- find_google_sheet(df)
    SHEET <- sheet_names(GS)[1]
    range_clear(GS, SHEET, reformat = TRUE)
    column_rename(df) %>%
      sheet_write(GS, SHEET)
  }


# Contour Buffer Strips
update_google_sheet(cb)

# Grassed Waterway
update_google_sheet(gw)

# Pond Dam
update_google_sheet(pd)

# Strip Cropping
update_google_sheet(sp)

# Terrace
update_google_sheet(tr)

# Watershed Sediment Control Basin
update_google_sheet(wascob)


