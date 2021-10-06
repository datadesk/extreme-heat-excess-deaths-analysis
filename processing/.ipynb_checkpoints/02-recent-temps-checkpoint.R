library(tidyverse)
library(lubridate)

### 
# handle temp data for years in our study period, 2010-2019
###

# Import each CSV file in the target directory
recent.prism <-
  list.files(
    path="./input/raw/prism/study_period",
    pattern = "*.csv",
    full.names = TRUE,
    recursive = FALSE
  ) %>% map_df(~read_csv(., skip=10))

# rename columns
recent.clean = recent.prism %>% 
  rename(
    county = Name,
    date = Date,
    longitude = Longitude,
    latitude = Latitude,
    elevation = "Elevation (ft)",
    tmax_f = "tmax (degrees F)"
  ) %>% mutate(
    # Fix truncated names
    county = case_when(
      county == "San Bernardi" ~ "San Bernardino",
      county == "San Francisc" ~ "San Francisco",
      county == "San Luis Obi" ~ "San Luis Obispo",
      county == "Santa Barbar" ~ "Santa Barbara",
      TRUE ~ county
    )
  )

# Filter to the dates we want
recent.filtered <-recent.clean %>% filter(date < as.Date("2020-01-01"))

# drop unneeded stuff
column_blacklist <- c("longitude", "latitude", "elevation", "tmin (degrees F)")
recent.export = recent.filtered[,!(names(recent.filtered) %in% column_blacklist)]

#export
recent.export %>% write_csv('./input/processed/recent-temps-by-county.csv')