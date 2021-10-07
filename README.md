# extreme-heat-excess-deaths-analysis

The Los Angeles Times conducted a statistical analysis of excess deaths attributable to extreme heat in California's most populous counties. The newspaper's findings are reported in <a href="https://www.latimes.com/projects/california-extreme-heat-deaths-show-climate-change-risks">this article</a>.

The analysis was conducted in consultation with data analyst Logan Arnold and reviewed by four independent experts in the fields of epidemiology and bioclimatology.

### Findings

Statewide, we estimate there were 3,923 excess deaths due to heat during California’s hot season between 2010 and 2019. due to statistical uncertainty, the estimate range as low as 1,826 and as high as 5,962.

The study covers California’s 26 most populous counties, representing about 91% of the state’s population. Areas with fewer than 250,000 residents were not included due to the small population sizes. Our results were statistically significant in all but two counties, Monterey and Santa Cruz on the central coast. In Los Angeles County, we estimate there were just over 1,000 excess deaths due to heat, or 100 per year. 

Our estimates suggest about an average of 370 people died per year during extreme heat between 2010 and 2019. This average is likely an underestimate because we limited our analysis to the six-month hot season.

Still, our findings represent a significant departure from official counts of heat-related death in California.

A [CDC](https://wonder.cdc.gov/mcd.html) database counts 657 deaths with heat-related issues as a cause of death between 2010-2019, about 66 per year. Other counts compiled by [Tracking California](https://trackingcalifornia.org/heat-related-illness/heat-related-deaths-summary-tables) place the total at 599 between 2010-2019. According to data provided by CDPH, 535 people died due heat or heat-related causes, an average of 89 per year, in all counties between 2015-2020. 

### Methodology

We began by requesting the California Department of Public Health’s public-use death index files for the years 2010-2020. The records, which include deaths by any cause, contain columns for date of birth, date of death and county of death. Any records with missing or invalid dates were excluded. The data released by the state is not comprehensive of all deaths and contains some duplicate records. We removed duplicate rows in the data containing matching first and last names, sex, date of birth, date of death and county of death. We excluded 2020 from the analysis to avoid confounding results due to the COVID-19 pandemic.

We compared the result to a [Centers for Disease Control database](https://wonder.cdc.gov/mcd.html) containing a monthly breakdown of deaths for all U.S. counties. The state’s daily records vary slightly from the federal dataset, more noticeably so in smaller counties. However, the trends in deaths over time shown in both sources match closely, and the total deaths in the de-duplicated CDPH data are 1.1% higher than those of the CDC.

Because these data contained no description of cause of death, we were unable to exclude accidental or traumatic deaths, which is a common practice in the [scientific](https://bmcpublichealth.biomedcentral.com/articles/10.1186/1471-2458-12-133) [literature](https://journals.lww.com/environepidem/fulltext/2020/06000/estimating_the_number_of_excess_deaths.1.aspx). However, there is evidence to suggest a link between high temperatures and accidental death, said [Kate Weinberger](https://www.spph.ubc.ca/person/kate-weinberger/), an environmental epidemiologist at the University of British Columbia School of Population and Public Health, who conducted a study of excess deaths in 297 U.S. counties.

Next, we transformed the individual deaths-by-day data to find the total number of deaths per day in each of California’s 58 counties. Annual population estimates were downloaded from the [California Department of Finance](https://www.dof.ca.gov/forecasting/demographics/projections/).

We defined a heat event as any day between the months of May and October on which the max temperature exceeded the 95th percentile of a given county’s “normal” temperature distribution. To establish a baseline of normal temperatures, we calculated a 30-year average max temperature for each day and month of the year in each county using data downloaded from Oregon State University’s [PRISM Climate Group](https://prism.oregonstate.edu/). This average is based on data starting in 1981, the earliest year available, and 2010.

Using a normal temperature distribution allows us to define a heat event differently across California’s diverse climate and account for adaptation and acclimatization in various regions. Using this method, we can compare any temperature for a given day and county to what's normal or expected. In theory, a county could end up with no heat events for the summer or see multiple week-long heat waves.

The [PRISM website](https://prism.oregonstate.edu/explorer/bulk.php) allows users to download gridded temperature data for multiple locations. We obtained max temperature data at the max resolution available, 4 km, and centered the points according to the U.S. Census’s [2010 Centers of Population report](https://www.census.gov/geographies/reference-files/2010/geo/2010-centers-population.html). This allowed us to estimate the max temperature felt by the most people in each area.

Working with Logan Arnold, a health data analyst, we created a negative binomial regression model to predict the number of deaths that would be expected to occur in the absence of a heat event in a given county. The model controls for weekends, month and population changes over time.

We then calculated excess deaths by simply subtracting the number of observed deaths on an extreme heat day by the number of predicted deaths, as well as a margin of error, for each county included in the analysis and a state total. These calculations are based on the methods outlined in a [2010 paper](https://www.researchgate.net/profile/Sumi-Hoshiko/publication/26741879_A_simple_method_for_estimating_excess_mortality_due_to_heat_waves_as_applied_to_the_2006_California_heat_wave/links/0fcfd50dc84d2222fb000000/A-simple-method-for-estimating-excess-mortality-due-to-heat-waves-as-applied-to-the-2006-California-heat-wave.pdf) by Hoshiko et al, which estimated excess deaths related to the deadly 2006 California heatwave.
