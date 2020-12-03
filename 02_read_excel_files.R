# Load the main packages
library(tidyverse)
library(readxl)



# NEW FILES (Updated in 2020-11-24)
# list all files to be read
files <- list.files('Input_Data/Exported_from_BMP_2020.11.24/', full.names = TRUE)


# read all files
ws_data <- vector('list', length = length(files))
for (i in seq_along(files)) {
  ws_data[[i]] <- read_csv(files[i])
}


# combine list
ws_all_combined <-
  ws_data %>%
  map(~ .x %>% mutate_all(as.character)) %>%
  bind_rows()


# # Watershed 
# ws <- filter(ws_all_combined, PRACTICE == 'Watershed')

# Contour Buffer Strips
cb <- filter(ws_all_combined, PRACTICE == 'Contour Buffer Strips')

# Grassed Waterway
gw <- filter(ws_all_combined, PRACTICE == 'Grassed Waterway')

# Pond Dam
pd <- filter(ws_all_combined, PRACTICE == 'Pond Dam')

# # Rip Poly
# rp <- filter(ws_all_combined, PRACTICE == 'Rip_Poly')

# Strip Cropping
sp <- filter(ws_all_combined, PRACTICE == 'Stripcropping')

# Terrace
tr <- filter(ws_all_combined, PRACTICE == 'Terrace')

# Watershed Sediment Control Basin
wascob <- filter(ws_all_combined, PRACTICE == 'Water and Sediment Control Basin (WASCOB)')


# Save data 
sheet_names <- 
  # not available with the new data 'ws', rp'
  c('cb', 'gw', 'pd', 'sp', 'tr', 'wascob') 

# create folder to save today generated data
dir.create(paste0('Inter_Data/', Sys.Date()))

output_data <-  function(data, names){
  folder_path <- paste0('Inter_Data/', Sys.Date(), '/')
  write_rds(data, paste0(folder_path, names, '.rds'))
}

lapply(sheet_names, get) %>%
  list(data = .,
       names = sheet_names) %>%
  pmap(output_data)



# OLD FILES
# read keys for files
keys <- read_csv('Input_Data/file_keys.txt') 


# function to read excel files
ReadExcelSheets <-
  function(PATH, GUESS = 30000){
    sheets <- excel_sheets(PATH)
    dl <- vector('list', length = length(sheets))
    for (i in seq_along(sheets)){
      dl[[i]] <- read_excel(path = PATH,
                            sheet = i, 
                            guess_max = GUESS,
                            na = c('NA', 'N/A', 'n/a', 'NaN')) %>%
        mutate(sheet = sheets[i],
               file_name = basename(PATH))
    }
    sheets[str_detect(sheets, '[0-9]{10,12}')] <- 'Watershed'
    names(dl) <- sheets
    return(dl)
  }


# read all files
ws_data <- vector('list', length = length(keys$file_name))
for (i in seq_along(keys$file_name)) {
  ws_data[[i]] <- ReadExcelSheets(PATH = paste0('Input_Data/', keys$file_name[i]))
}


# combine 7 sheets
CombineSheets <-
  function(SHEET_NAME){
    map(ws_data, SHEET_NAME) %>%
      compact() %>%
      map(~ .x %>% mutate_all(as.character)) %>%
      bind_rows() %>%
      left_join(keys %>% select(1:2), by = 'file_name') %>%
      mutate(huc12_id = word(file_name, sep = '_')) %>%
      select(wsp_id, huc12_id, everything(), -sheet, -file_name) 
  }


# Watershed 
ws <- CombineSheets('Watershed') 

# Contour Buffer Strips
cb <- CombineSheets('Contour_Buffer_Strips')

# Grassed Waterway
gw <- CombineSheets('Grassed_Waterway')

# Pond Dam
pd <- CombineSheets('Pond_Dam')

# Rip Poly
rp <- CombineSheets('Rip_Poly')

# Strip Cropping
sp <- CombineSheets('Stripcropping')

# Terrace
tr <- CombineSheets('Terrace')

# Watershed Sediment Control Basin
wascob <- CombineSheets('WASCOB')


# Save data 
sheet_names <- c('ws', 'cb', 'gw', 'pd', 'rp', 'sp', 'tr', 'wascob')

output_data <-  function(data, names){
  folder_path <- 'Inter_Data/'
  write_rds(data, paste0(folder_path, names, '.rds'))
  }

lapply(sheet_names, get) %>%
  list(data = .,
       names = sheet_names) %>%
 pmap(output_data)
  

