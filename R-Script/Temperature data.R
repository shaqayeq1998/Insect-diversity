library(dplyr)
library(tidyr)
library(tibble)
library(lme4)
library(MASS)
library(DHARMa)
library(ggplot2)#cite
library(car)
library(vegan) #cite
library(lubridate)


#temperatures mean , min, max calculation for each day
# Read the CSV file, skipping metadata rows if needed
data <- read.csv("temperature.csv")  # Adjust the 'skip' parameter as needed

# Rename columns for clarity, based on your data structure
colnames(data) <- c("DateTime", "Unit", "Temperature")

# Convert DateTime to date-time format and extract only the date
data <- data %>%
  mutate(DateTime = dmy_hms(DateTime),  # Change format if needed
         Date = as.Date(DateTime))

# Calculate daily mean, max, and min temperatures
daily_summary <- data %>%
  group_by(Date) %>%
  summarise(
    Mean_Temperature = mean(Temperature, na.rm = TRUE),
    Max_Temperature = max(Temperature, na.rm = TRUE),
    Min_Temperature = min(Temperature, na.rm = TRUE)
  )

# View results
print(daily_summary)


# Sample data: assume `daily_summary` is calculated as shown before
# daily_summary should have columns Date, Mean_Temperature, Max_Temperature, and Min_Temperature

# Reshape data for easier plotting with ggplot
daily_summary_long <- daily_summary %>%
  pivot_longer(cols = c(Mean_Temperature, Max_Temperature, Min_Temperature),
               names_to = "Temperature_Type",
               values_to = "Temperature")

# Plot

ggplot(daily_summary_long, aes(x = Date, y = Temperature, color = Temperature_Type)) +
  geom_line(size = 1) +
  labs(title = "Daily Temperature Comparison",
       x = "Date",
       y = "Temperature (°C)",
       color = "Temperature Type") +
  scale_x_date(
    breaks = "1 week",  # marks for each week
    labels = scales::date_format("%b %d"),  # format the date labels as Month Day
    minor_breaks = "1 month"  # add minor breaks for each month
  ) +
  scale_y_continuous(
    breaks = seq(min(daily_summary_long$Temperature), max(daily_summary_long$Temperature), by = 2)  # Adjust based on your data
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # rotate x-axis labels for better visibility
    axis.text.y = element_text(size = 10)  # optional adjustment for y-axis text size
  )
