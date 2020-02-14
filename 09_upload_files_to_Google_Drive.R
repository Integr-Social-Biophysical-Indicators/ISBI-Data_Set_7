# Load the main packages
library(tidyverse)
library(googledrive)



# compiled data -------------------------------------------------

drive_upload(media = 'Output_Data/ws_updated.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'watershed_updated.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/dn07.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'dn07_updated.csv',
             type = 'spreadsheet')



# original data -------------------------------------------------

drive_upload(media = 'Output_Data/ws.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'watershed.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/cb.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'contour_buffer_strips.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/gw.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'grassed_waterway.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/pd.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'pond_dam.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/rp.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'rip_poly.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/sp.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'strip_cropping.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/tr.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'terrace.csv',
             type = 'spreadsheet')

drive_upload(media = 'Output_Data/wascob.csv',
             path = as_id('1SZ1p57zOXJRr6Z4oofwjtBj_nNU_UMiq'),
             name = 'watershed_sediment_control_basin.csv',
             type = 'spreadsheet',
             overwrite = TRUE)


