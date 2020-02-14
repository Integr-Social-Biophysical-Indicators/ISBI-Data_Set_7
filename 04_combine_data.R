# Load the main packages
library(tidyverse)
library(lubridate)
library(googledrive)



# read all intermediate files
list.files('Inter_Data/') %>%
  map(function(file_name){
    file_path = paste0('Inter_Data/', file_name)
    assign(x = str_remove(file_name, '.rds'),
           value = read_rds(file_path),
           envir = .GlobalEnv)
  })


# read the corresponding data dictionary for identifying columns to keep
drive_download(as_id('1aNQuOKF8HiEPrLXG4aOnWQ-4JO9EYfcK5_Zz0wfnNjY'), 
               path = 'Input_Data/MetaData/DN_07_BMP_DataDictionary.xlsx')

read_excel('Input_Data/MetaData/DN_07_BMP_DataDictionary.xlsx') %>%
  select(DN, keep_rm = `keep/ remove`, internal_sort = `Internal Sort`, 
         spreadsheet_name = `Spreadsheet Name`, `variable_name` = `Variable Name`) %>%
  mutate(spreadsheet_name = ifelse(spreadsheet_name == '*Universal', NA, spreadsheet_name)) %>%
  fill(spreadsheet_name, .direction = 'up') -> columns_to_keep


# add a function to choose 
column_select <- function(SPN, KR = 'keep') {
  columns_to_keep %>% 
    filter(keep_rm == KR & spreadsheet_name == SPN) %>%
    pull(variable_name) -> column_names
  return(column_names)
  }

  
# Watershed 
ws %>% 
  select(column_select('Watershed')) ->
  ws_new

# Contour Buffer Strips
cb %>% 
  select(column_select('Contour_Buffer_Strips')) ->
  cb_new

# Grassed Waterway
gw %>% 
  select(column_select('Grassed_Waterway')) ->
  gw_new

# Pond Dam
pd %>% 
  select(column_select('Pond_Dam')) ->
  pd_new

# Rip Poly
rp %>%
  mutate(PRACTICE = "Rip Poly",
         SHAPE_Area = ifelse(is.na(SHAPE_Area), Shape_Area, SHAPE_Area),
         SHAPE_Length = ifelse(is.na(SHAPE_Length), Shape_Length, SHAPE_Length)) %>%
  mutate(Present2010 = ifelse(Present2010 == 'Yes', 1, Present2010),
         Present2010 = as.character(Present2010)) %>%
  select(column_select('Rip_Poly')) ->
  rp_new

# Strip Cropping
sp %>%
  select(column_select('Stripcropping')) ->
  sp_new

# Terrace
tr %>% 
  select(column_select('Terrace')) ->
  tr_new

# Watershed Sediment Control Basin
wascob  %>% 
  select(column_select('WASCOB')) ->
  wascob_new



# combind data
mget(ls(pattern = '*_new')) %>%
  # remove watershed data from the list
  .[names(.) != 'ws_new'] %>%
  bind_rows() %>%
  rownames_to_column() %>%
  gather(key, value, starts_with('Present')) %>%
  mutate(value2 = ifelse(is.na(value), 0, value)) %>%  
  left_join(tribble(~key, ~coefficient,
                    'Present80s',   2,
                    'Present2010',  4,
                    'Present2016',  8),
            by = 'key') %>%
  mutate(value2 = as.numeric(value2) * coefficient) %>%
  group_by(rowname) %>%
  mutate(CHECK = sum(value2)) %>%
  ungroup() %>%
  select(-value2, -coefficient) %>%
  spread(key, value) %>%
  mutate(flag = ifelse(CHECK %in% c(0, 8, 12, 14), 'OK', 'NOT OK')) %>%
  select(-rowname, -CHECK) -> 
  dn07_combined_7_sheets


# THIS IS AN ALTERNATIVE (BETTER) WAY to FIND CORRECT SEQUECES
mget(ls(pattern = '*_new')) %>%
  # remove watershed data from the list
  .[names(.) != 'ws_new'] %>%
  bind_rows() %>%
  mutate(COMMENTS = paste(Present80s, Present2010, Present2016, sep ='') %>%
           str_replace_all('NA', '0') %>% 
           strtoi(2)) %>%
  mutate(SHAPE_Length = ifelse(COMMENTS %in% (2^(0:3)-1), 'good', 'bad'))
  


# save data
ws_new %>% 
  mutate(huc12_id = paste('huc', huc12_id, sep = '-')) %>%
  write_csv('Output_Data/ws_updated.csv', na = 'n/a')

dn07_combined_7_sheets %>%
  mutate(huc12_id = paste('huc', huc12_id, sep = '-')) %>%
  write_csv('Output_Data/dn07.csv', na = 'n/a')
  

  
