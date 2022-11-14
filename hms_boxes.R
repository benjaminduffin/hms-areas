### Create HMS Catch Area boxes 
## 7/22/2022 BD

# load libraries 
library(sf)
library(sp)
library(readxl)
library(writexl) 
library(ggmap)
library(ggplot2)
library(plyr) 
library(dplyr)
library(tidyr)
library(purrr)

# read data
hms <- read_xlsx("./data/HMS_CATCH_AREAS_bbox.xlsx")

# split to list 
hms_l <- hms %>%
  group_by(HMS_CATCH_AREA) %>%
  group_split()

# function to create the boxes from corner points 
box_from_extent <- function(x) {
  
  # get top left/bottom right 
  # lons <- c(hms_l[[1]]$TOP_LON, hms_l[[1]]$BOT_LON)
  # lats <- c(hms_l[[1]]$TOP_LAT, hms_l[[1]]$BOT_LAT)
  lons <- c(x$TOP_LON, x$BOT_LON)
  lats <- c(x$TOP_LAT, x$BOT_LAT)

  
  box_coords <- data.frame(lons, lats)

  # generate the box 
  pol <- box_coords %>% 
    st_as_sf(coords = c("lons", "lats"), 
             crs = 4326) %>%
    st_bbox() %>% 
    st_as_sfc()
  
}

# lapply to the hms catch areas 
res <- lapply(hms_l, box_from_extent)
# rename
names(res) <- hms$HMS_CATCH_AREA

# combine to one object
# intiate the data
res_poly <- res[[1]]

for (i in 2:length(res)) {
  res_poly <- c(res_poly, res[[i]])
}

# check plot
ggplot(res_poly) + 
  geom_sf()



## write the file 
# cast to sf object from sfc
sf_res_poly <- res_poly %>%
  st_sf() %>%
  mutate(HMS_CATCH_AREA = hms$HMS_CATCH_AREA) %>%
  st_cast()

# write
st_write(sf_res_poly, 
         "./output/hms_catch_areas.gpkg", 
         driver = "GPKG")

