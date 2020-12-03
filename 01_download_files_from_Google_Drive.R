# Load the main packages
library(tidyverse)
library(googledrive)



# NEW FILES (Updated in 2020-11-24)
# store the URL you have
folder_url <- "1aW8H5BjfYRwq3B5bMPHu0noNBf51NBd4"


# list all files in the folder
files <- drive_ls(as_id(folder_url))


# download them
walk2(files$id, 
      files$name, 
      ~ drive_download(as_id(.x),
                       path = paste0('Input_Data/Exported_from_BMP_2020.11.24/', .y),
                       overwrite = TRUE))



# OLD FILES
# store the URL you have
folder_url <- "https://drive.google.com/drive/u/1/folders/1UEgbfd7nAhfSvBzwIevM9--l5ZVeJirp"


# identify this folder on Drive
# let googledrive know this is a file ID or URL, as opposed to file name
folder <- drive_get(as_id(folder_url))


# identify the subfolders in that folder
ws_folders <- drive_ls(folder, type = 'folder')


# identify the xlsx files in each subfolder
files <- vector(mode = 'list', length = nrow(ws_folders))
for (i in 1:nrow(ws_folders)) {
  files[[i]] <- drive_ls(ws_folders[i, ], type = 'xlsx') %>%
    mutate(ws = ws_folders$name[i])
  }
csv_files <- bind_rows(files) %>%
  select(ws, everything())


# download them
walk2(csv_files$id, 
      csv_files$name, 
      ~ drive_download(as_id(.x),
                       path = paste0('Input_Data/', .y),
                       overwrite = TRUE))


# save keys for files
csv_files %>%
  select(wsp_id = ws,
         file_name = name,
         file_id = id) %>%
  write_csv('Input_Data/file_keys.txt')



