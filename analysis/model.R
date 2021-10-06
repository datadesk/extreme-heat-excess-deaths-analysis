library(tidyverse)

# Read in processed data
data = read_csv('./output/totals-by-day.csv')

# Trim down to the columns we need
# and limit to counties with more
# than 250,000 residents.
# This type of cutoff is the academic studies
# we're basing our analysis on.
data.prepped <- data %>% 
  select(
    date,
    county,
    population,
    is_weekend,
    month,
    year,
    tmax_f,
    heat_event_threshold_f,
    is_heat_event,
    deaths
  ) %>% filter(population > 250000)

# Get a list of all the counties
counties = unique(data.prepped$county)

output = NULL
dailyOutput = NULL
# Loop through the counties
for(c in seq(counties)) {
  
  # filter data to that county
  countyDf = data.prepped %>% 
    filter(county == counties[[c]])

  # the model
  mod <- mgcv::gam(
      deaths ~ 
      is_heat_event +
      as.factor(month) + 
      as.factor(is_weekend) +
      offset(log(population)),
      family = mgcv::nb(link=log), 
      data = countyDf
  )

  #create new data for daily predicted values, based on observed time series
  newCounty = countyDf

  # suppose there were no heat days
  newCounty$is_heat_event <- FALSE
  
  # predict daily deaths had there been no heat days
  ginv <- mod$family$linkinv  ## inverse link function
  prs <- predict(
    mod,
    newdata = newCounty,
    type = "link",
    se.fit = TRUE,
    interval = "predictions"
  )
  newCounty$pred <- ginv(prs[[1]])
  newCounty$lo <- ginv(prs[[1]] - 1.96 * prs[[2]])
  newCounty$up <- ginv(prs[[1]] + 1.96 * prs[[2]])

  # go back to original distribution of heat days
  newCounty$is_heat_event <- countyDf$is_heat_event
  
  # subset to just heat days
  newCountyHeatDays <- subset(newCounty, is_heat_event == TRUE)
  
  # subset of days without extreme heat
  newCountyNonHeatDays <- subset(newCounty, is_heat_event == FALSE)
  
  # Tally up the number of observed deaths on heat event days
  deaths.heatdays <- sum(newCountyHeatDays$deaths)
  
  # Tally up the predicted number of deaths on heat even days
  deaths.predicted <- sum(newCountyHeatDays$pred)
  
  # Calculate relative risk
  rr <- deaths.heatdays / deaths.predicted
  # And its margin for error
  rr.lo <- exp(log(rr - 1.96*sqrt(1/deaths.heatdays + 1/deaths.predicted)))
  rr.up <- exp(log(rr + 1.96*sqrt(1/deaths.heatdays + 1/deaths.predicted)))
  
  # Calculate attributable fraction
  af <- (rr-1)/rr

  # excess deaths is difference between observed and expected
  excess <- sum(newCountyHeatDays$deaths - newCountyHeatDays$pred)
  # And its margin of error
  # note that the lower bound of predicted deaths is used to estimate the upper bound of excess deaths
  excess_up <- sum(newCountyHeatDays$deaths - newCountyHeatDays$lo)
  excess_lo <- sum(newCountyHeatDays$deaths - newCountyHeatDays$up)
  
  # Get the average population of the county
  avg_population <- mean(countyDf$population)

  # Output a dataframe with one row per day for all counties and calculated values
  dailyOutput = rbind(
   dailyOutput,
   newCounty
  )
  
  # Throw it into a computed dataframe
  output = rbind(
    output,
    data.frame(counties[c],
      avg_population,
      deaths.heatdays,
      deaths.predicted,
      rr,
      rr.lo,
      rr.up,
      af,
      excess,
      excess_up,
      excess_lo
    )
  )
}


# Clean up the headers
output = output %>% rename(county = counties.c.)

# Grand total of excess deaths
sum(output$excess)
sum(output$excess_up)
sum(output$excess_lo)

# Share of all deaths linked to excess deaths
sum(output$excess) / sum(data.prepped$deaths)

# Trimming the output to positive results
output %>% select(
  county,
  avg_population,
  excess,
  excess_lo,
  excess_up
) %>% filter(excess < 0) 

# Writing it out
output %>% write_csv('output/excess-deaths-by-county.csv')

dailyOutput %>% write_csv('output/daily-deaths-by-county.csv')
