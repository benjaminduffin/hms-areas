### Data prep for HMS-FIN fished areas cross reference 
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


### QUESTIONS: 
# CLARIFY ON THE FL KEYS REGION
  # for sharks, wraps around to [a specific point]?
  # else BF60B ends at the 25.33 N parallel? 
  # so "Triangle is the area of concern? 
# split keys ?


## TODO
# add BF 64's (rest of A, B, C)
# fix geometries 
# cross reference table


# read rectified HMS data 
hms <- st_read("./data/HMSCatchAreasFinal.gpkg")

# check plot
ggplot(hms) + 
  geom_sf(aes(fill = catcharea), alpha = 0.2) +
  geom_sf_label(aes(label = catcharea))
  

# read in the FIN Areas ("Coastal Areas Centroid")
fin <- st_read("C:/Users/benjamin.duffin/Desktop/bd/hms-areas/data/Atlantic_Gulf_Stat_Areas/Coastal_Areas_Centroid.shp")

ggplot(fin) + 
  geom_sf(fill = "red", alpha = 0.1)




# read in the intersect table 
# these show which areas bisect other areas (and which map 1:1)
int_hms <- read.csv("./data/intersect_hmsInput.csv", stringsAsFactors = F)
head(int_hms)
int_fin <- read.csv("./data/intersect_finInput.csv", stringsAsFactors = F)
head(int_fin)

xref_hms <- int_hms %>%
  select(catcharea, CODE) %>% 
  group_by(CODE) %>%
  mutate(hms_areas = paste(unique(catcharea), collapse = ", "), 
         n_hms_areas = n_distinct(catcharea))

table(xref_hms$n_hms_areas)

# flags: 
# 744 - edges don't line up? 
# 740 - is this the extent of the Gulf Sharks? 
