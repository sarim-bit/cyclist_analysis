# Loading the required libraries
library(tidyverse)
library(lubridate)

# Loading the data
cyclist_april_2022 <- read_csv("./data/raw/202204-divvy-tripdata.csv")
cyclist_may_2022 <- read_csv("./data/raw/202205-divvy-tripdata.csv")
cyclist_june_2022 <- read_csv("./data/raw/202206-divvy-tripdata.csv")
cyclist_july_2022 <- read_csv("./data/raw/202207-divvy-tripdata.csv")
cyclist_aug_2022 <- read_csv("./data/raw/202208-divvy-tripdata.csv")
cyclist_sep_2022 <- read_csv("./data/raw/202209-divvy-publictripdata.csv")
cyclist_oct_2022 <- read_csv("./data/raw/202210-divvy-tripdata.csv")
cyclist_nov_2022 <- read_csv("./data/raw/202211-divvy-tripdata.csv")
cyclist_dec_2022 <- read_csv("./data/raw/202212-divvy-tripdata.csv")
cyclist_jan_2023 <- read_csv("./data/raw/202301-divvy-tripdata.csv")
cyclist_feb_2023 <- read_csv("./data/raw/202302-divvy-tripdata.csv")
cyclist_mar_2023 <- read_csv("./data/raw/202303-divvy-tripdata.csv")

# Storing Quarterly data
q2_2022 <- bind_rows(cyclist_april_2022, cyclist_may_2022, cyclist_june_2022)
q3_2022 <- bind_rows(cyclist_july_2022, cyclist_aug_2022, cyclist_sep_2022)
q4_2022 <- bind_rows(cyclist_oct_2022, cyclist_nov_2022, cyclist_dec_2022)
q1_2023 <- bind_rows(cyclist_jan_2023, cyclist_feb_2023, cyclist_mar_2023)

write_csv(q2_2022, "./data/raw/cyclist_q2_2022.csv")
write_csv(q3_2022, "./data/raw/cyclist_q3_2022.csv")
write_csv(q4_2022, "./data/raw/cyclist_q4_2022.csv")
write_csv(q1_2023, "./data/raw/cyclist_q1_2023.csv")

# Removing monthly data from memory
rm(cyclist_april_2022, cyclist_may_2022, cyclist_june_2022, cyclist_july_2022,
       cyclist_aug_2022, cyclist_sep_2022, cyclist_oct_2022, cyclist_nov_2022, 
       cyclist_dec_2022, cyclist_jan_2023, cyclist_feb_2023, cyclist_mar_2023)

# Creating a single dataset
all_trips <- bind_rows(q2_2022,q3_2022,q4_2022,q1_2023)
write_csv(all_trips, "./data/raw/cyclist_all_trips_raw.csv")
all_trips <- as.data.frame(all_trips)
str(all_trips)

all_trips_clean <- all_trips %>%
  mutate(
    started_at = ymd_hms(started_at),
    ended_at = ymd_hms(ended_at),
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week = wday(started_at, label = TRUE, week_start = 1),
    hour = hour(started_at),
    month = month(started_at, label = TRUE),
    date = date(started_at)
  ) %>%
  filter(
    !is.na(started_at),
    !is.na(ended_at),
    ride_length > 0 
  )

summary(all_trips_clean)

# Removing rides with ride length more than a day, most likely were not locked properly 
all_trips_clean <- all_trips_clean %>% filter(ride_length <= 1440)
prop.table(table(all_trips_clean$rideable_type))

#Removing docked bikes as they are less than 3%
all_trips_clean <- all_trips_clean %>% filter(rideable_type != 'docked_bike')

write_csv(all_trips_clean, "./data/clean/cyclistic_cleaned.csv")
summary(all_trips_clean)

