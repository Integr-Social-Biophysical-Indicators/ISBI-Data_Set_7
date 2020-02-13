# Load the main packages
library(tidyverse)
library(lubridate)



# read all intermediate files
list.files('Inter_Data/') %>%
  map(function(file_name){
    file_path = paste0('Inter_Data/', file_name)
    assign(x = str_remove(file_name, '.rds'),
           value = read_rds(file_path),
           envir = .GlobalEnv)
  })


# Watershed 
ws %>% names()

# Contour Buffer Strips
cb %>% View()

# Grassed Waterway
gw %>% View()

# Pond Dam
pd

# Rip Poly
rp 

# Strip Cropping
sp
 
# Terrace
tr
 
# Watershed Sediment Control Basin
wascob 



# Save data as individual csv files
sheet_names <- c('ws', 'cb', 'gw', 'pd', 'rp', 'sp', 'tr', 'wascob')

output_data <-  function(data, names){
  folder_path <- 'Output_Data/'
  write_csv(data, paste0(folder_path, names, '.csv'))
}

lapply(sheet_names, get) %>%
  list(data = .,
       names = sheet_names) %>%
  pmap(output_data)





