library(tidyverse)
library(lubridate)

###
# handle historical temperature data for 30-year baseline
###

#import
historic.raw <-
  list.files(
    path = "./input/raw/prism/historical",
    pattern = "*.csv",
    full.names = TRUE,
    recursive = FALSE
  ) %>% map_df(~read_csv(.,skip=10))

# rename columns
historic.clean = historic.raw %>% 
  rename(
    county = Name,
    date = Date,
    longitude = Longitude,
    latitude = Latitude,
    elevation = "Elevation (ft)",
    tmax = "tmax (degrees F)",
  ) %>% mutate(
    # fix truncated names
    county = case_when(
      county == "San Bernardi" ~ "San Bernardino",
      county == "San Francisc" ~ "San Francisco",
      county == "San Luis Obi" ~ "San Luis Obispo",
      county == "Santa Barbar" ~ "Santa Barbara",
      TRUE ~ county
    )
  )

# filter to just years 1981-2010
historic.filtered <- historic.clean %>% filter(date < as.Date("2011-01-01"))

historic.calculated = historic.filtered  %>%
  group_by(
    county = county,
    month = month(date),
    day = day(date)
  ) %>% summarize(
    tmax_avg = mean(tmax),
    tmax_95 = quantile(tmax, probs=0.95)
  )

# filter dataframe to just the state's hot months
months_whitelist = c(5, 6, 7,8, 9, 10)
historic.export <- historic.calculated %>% filter(month %in% months_whitelist)

# Trim the columns to our keepers
column_blacklist <- c("longitude", "latitude", "elevation", "tmin (degrees F)")
historic.export = historic.export[,!(names(historic.export) %in% column_blacklist)]

# Dump it out
historic.export %>% write_csv('input/processed/historic-temps-by-county.csv')