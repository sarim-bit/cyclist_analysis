# -------------------------------
# Cyclistic Case Study - Exploratory Analysis
# -------------------------------

# Load required libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

# Load cleaned data
all_trips_clean <- read_csv("./data/clean/cyclistic_cleaned.csv")
all_trips_clean <- as.data.frame(all_trips_clean)

# Convert to factors
all_trips_clean <- all_trips_clean %>%
  mutate(
    member_casual = factor(member_casual, levels = c("member", "casual")),
    rideable_type = factor(rideable_type),
    month = factor(month, levels = month.abb[c(4:12, 1:3)]),
    day_of_week = factor(day_of_week, levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
  )
summary(all_trips_clean)

# --------------------------------------
# Summary Statistics by Rider Type
# --------------------------------------
rider_type_summary <- all_trips_clean %>%
  group_by(member_casual) %>%
  summarise(
    mean_ride = mean(ride_length),
    median_ride = median(ride_length),
    max_ride = max(ride_length),
    min_ride = min(ride_length),
    count = n(),
    .groups = "drop"
  )
rider_type_summary

# --------------------------------------
# Rides by Day of Week
# --------------------------------------
rides_by_day <- all_trips_clean %>%
  group_by(day_of_week, member_casual) %>%
  summarise(
    count = n(),
    avg_ride = mean(ride_length),
    .groups = "drop"
  )
rides_by_day

ggplot(rides_by_day, aes(x = day_of_week, y = count, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Ride Volume by Day of Week", x = "Day", y = "Number of Rides", fill = "Rider Type") +
  theme_minimal() +
  theme(legend.position = "inside",
        legend.position.inside = c(0.9, 0.95),
        legend.background = element_rect(fill = "white", color = "gray"),
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8))


# --------------------------------------
# Average Ride Duration by Day of Week
# --------------------------------------
ggplot(rides_by_day, aes(x = day_of_week, y = avg_ride, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Average Ride Duration by Day", x = "Day", y = "Avg Ride Length (min)", fill = "Rider Type") +
  theme_minimal()

# --------------------------------------
# Ride Frequency by Hour of Day
# --------------------------------------
hourly_rides <- all_trips_clean %>%
  group_by(hour, member_casual) %>%
  summarise(count = n(), .groups = "drop")
hourly_rides

ggplot(hourly_rides, aes(x = hour, y = count, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Ride Frequency by Hour of Day", x = "Hour", y = "Number of Rides", fill = "Rider Type") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 23, by = 2)) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.9, 0.9),
        legend.background = element_rect(fill = "white", color = "gray"),
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8))

# --------------------------------------
# Monthly Trends
# --------------------------------------
monthly_rides <- all_trips_clean %>%
  group_by(month, member_casual) %>%
  summarise(count = n(), avg_ride = mean(ride_length), .groups = "drop")
monthly_rides

ggplot(monthly_rides, aes(x = month, y = count, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Monthly Ride Volume by Rider Type", x = "Month", y = "Number of Rides", fill = "Rider Type") +
  theme_minimal() + 
  theme(legend.position = "inside",
        legend.position.inside = c(0.9, 0.9),
        legend.background = element_rect(fill = "white", color = "gray"),
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8))

# --------------------------------------
# Rideable Type Usage by Rider Type
# --------------------------------------
all_trips_clean %>%
  count(rideable_type, member_casual) %>%
  ggplot(aes(x = rideable_type, y = n, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Rideable Type Usage by Rider Type", x = "Bike Type", y = "Number of Rides", fill = "Rider Type") +
  theme_minimal()

# --------------------------------------
# Weekend vs Weekday Usage
# --------------------------------------
all_trips_clean %>%
  mutate(weekend = ifelse(day_of_week %in% c("Sat", "Sun"), "Weekend", "Weekday")) %>%
  group_by(weekend, member_casual) %>%
  summarise(count = n(), avg_duration = mean(ride_length), .groups = "drop") %>%
  print()

# --------------------------------------
# Ride Length Distribution (under 60 mins)
# --------------------------------------
ggplot(all_trips_clean, aes(x = ride_length, fill = member_casual)) +
  geom_density(alpha = 0.6) +
  coord_cartesian(xlim = c(0, 60)) +
  labs(title = "Ride Length Density (Under 60 min)",
    x = "Ride Duration (min)", y = "Density", fill = "Rider Type") +
  theme_minimal() +
  theme(legend.position = "inside",
    legend.position.inside = c(0.9, 0.85),
    legend.background = element_rect(fill = "white", color = "gray"),
    legend.title = element_text(size = 9),
    legend.text = element_text(size = 8))

# --------------------------------------
# Starting point comparison
# --------------------------------------

# Filter out missing points and optionally sample to reduce overplotting
start_points <- all_trips_clean %>%
  filter(!is.na(start_lat), !is.na(start_lng)) %>%
  sample_n(100000)

# Create heatmap
ggplot(start_points, aes(x = start_lng, y = start_lat)) +
  stat_density_2d(aes(fill = after_stat(level)), geom = "polygon", contour = TRUE, alpha = 0.7) +
  facet_wrap(~ member_casual) +
  scale_fill_viridis_c(option = "magma") +
  labs(
    title = "Heatmap of Ride Starting Points",
    subtitle = "Comparison of Casual vs. Member Riders",
    x = "Longitude", y = "Latitude", fill = "Density Level"
  ) +
  theme_minimal()


# --------------------------------------
# Ending point comparison
# --------------------------------------

# Filter out missing points and optionally sample to reduce overplotting
end_points <- all_trips_clean %>%
  filter(!is.na(end_lat), !is.na(end_lng)) %>%
  sample_n(100000)

# Create heatmap
ggplot(end_points, aes(x = end_lng, y = end_lat)) +
  stat_density_2d(aes(fill = after_stat(level)), geom = "polygon", contour = TRUE, alpha = 0.7) +
  facet_wrap(~ member_casual) +
  scale_fill_viridis_c(option = "magma") +
  labs(
    title = "Heatmap of Ride Ending Points",
    subtitle = "Comparison of Casual vs. Member Riders",
    x = "Longitude", y = "Latitude", fill = "Density Level"
  ) +
  theme_minimal()
