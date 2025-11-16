# Activity Monitoring Data Analysis
# Complete R Script for PA1 Assignment

# Load required packages
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(lubridate)) install.packages("lubridate")
library(ggplot2)
library(dplyr)
library(lubridate)

# Check if data file exists, download if needed
if (!file.exists("activity.csv")) {
  download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", 
                "activity.zip")
  unzip("activity.zip")
}

# Load and preprocess the data
cat("Loading and preprocessing data...\n")
activity <- read.csv("activity.csv", stringsAsFactors = FALSE)
activity$date <- as.Date(activity$date)

# Display data structure
cat("\n=== Data Structure ===\n")
str(activity)
cat("\nFirst few rows:\n")
print(head(activity))

# ============================================================================
# 1. What is mean total number of steps taken per day?
# ============================================================================

cat("\n\n=== 1. Total Steps Per Day Analysis ===\n")

# Calculate total steps per day (ignoring missing values)
daily_steps <- activity %>%
  group_by(date) %>%
  summarise(total_steps = sum(steps, na.rm = TRUE))

# Create histogram
cat("\nCreating histogram of total steps per day...\n")
p1 <- ggplot(daily_steps, aes(x = total_steps)) +
  geom_histogram(binwidth = 1000, fill = "blue", alpha = 0.7) +
  labs(title = "Histogram of Total Steps Taken Each Day",
       x = "Total Steps per Day",
       y = "Frequency") +
  theme_minimal()
print(p1)

# Calculate mean and median
mean_steps <- mean(daily_steps$total_steps, na.rm = TRUE)
median_steps <- median(daily_steps$total_steps, na.rm = TRUE)

cat("Mean total steps per day:", round(mean_steps, 2), "\n")
cat("Median total steps per day:", median_steps, "\n")

# ============================================================================
# 2. What is the average daily activity pattern?
# ============================================================================

cat("\n\n=== 2. Average Daily Activity Pattern ===\n")

# Calculate average steps per interval across all days
interval_avg <- activity %>%
  group_by(interval) %>%
  summarise(avg_steps = mean(steps, na.rm = TRUE))

# Create time series plot
cat("\nCreating time series plot of average steps per interval...\n")
p2 <- ggplot(interval_avg, aes(x = interval, y = avg_steps)) +
  geom_line(color = "red", linewidth = 1) +
  labs(title = "Average Daily Activity Pattern",
       x = "5-minute Interval",
       y = "Average Number of Steps") +
  theme_minimal()
print(p2)

# Find interval with maximum average steps
max_interval <- interval_avg[which.max(interval_avg$avg_steps), ]
cat("\nInterval with maximum average steps:", max_interval$interval, "\n")
cat("Maximum average steps:", round(max_interval$avg_steps, 2), "\n")

# ============================================================================
# 3. Imputing missing values
# ============================================================================

cat("\n\n=== 3. Imputing Missing Values ===\n")

# Calculate total number of missing values
total_na <- sum(is.na(activity$steps))
percent_na <- mean(is.na(activity$steps)) * 100

cat("Total number of missing values:", total_na, "\n")
cat("Percentage of missing values:", round(percent_na, 2), "%\n")

# Strategy: Use the mean for that 5-minute interval to impute missing values
cat("\nImputing missing values using interval means...\n")
activity_imputed <- activity
activity_imputed <- activity_imputed %>%
  left_join(interval_avg, by = "interval")

# Impute missing values with interval averages
activity_imputed$steps[is.na(activity_imputed$steps)] <- 
  activity_imputed$avg_steps[is.na(activity_imputed$steps)]

# Remove the temporary column
activity_imputed$avg_steps <- NULL

# Verify no more missing values
cat("Missing values after imputation:", sum(is.na(activity_imputed$steps)), "\n")

# Calculate total steps per day with imputed data
daily_steps_imputed <- activity_imputed %>%
  group_by(date) %>%
  summarise(total_steps = sum(steps))

# Create histogram with imputed data
cat("\nCreating histogram after imputation...\n")
p3 <- ggplot(daily_steps_imputed, aes(x = total_steps)) +
  geom_histogram(binwidth = 1000, fill = "green", alpha = 0.7) +
  labs(title = "Histogram of Total Steps Taken Each Day (After Imputation)",
       x = "Total Steps per Day",
       y = "Frequency") +
  theme_minimal()
print(p3)

# Calculate mean and median with imputed data
mean_steps_imputed <- mean(daily_steps_imputed$total_steps)
median_steps_imputed <- median(daily_steps_imputed$total_steps)

cat("\nAfter imputation:\n")
cat("Mean total steps per day:", round(mean_steps_imputed, 2), "\n")
cat("Median total steps per day:", round(median_steps_imputed, 2), "\n")

# Compare with original values
cat("\nComparison with original data:\n")
cat("Mean difference:", round(mean_steps_imputed - mean_steps, 2), "\n")
cat("Median difference:", round(median_steps_imputed - median_steps, 2), "\n")

# ============================================================================
# 4. Differences in activity patterns between weekdays and weekends
# ============================================================================

cat("\n\n=== 4. Weekday vs Weekend Activity Patterns ===\n")

# Create weekday/weekend factor variable
activity_imputed <- activity_imputed %>%
  mutate(day_type = ifelse(weekdays(date) %in% c("Saturday", "Sunday"), 
                          "weekend", "weekday")) %>%
  mutate(day_type = as.factor(day_type))

# Calculate average steps per interval by day type
interval_avg_daytype <- activity_imputed %>%
  group_by(interval, day_type) %>%
  summarise(avg_steps = mean(steps))

# Create panel plot
cat("\nCreating panel plot for weekday vs weekend activity...\n")
p4 <- ggplot(interval_avg_daytype, aes(x = interval, y = avg_steps)) +
  geom_line(color = "purple", linewidth = 1) +
  facet_grid(day_type ~ .) +
  labs(title = "Average Steps by 5-minute Interval: Weekdays vs Weekends",
       x = "5-minute Interval",
       y = "Average Number of Steps") +
  theme_minimal()
print(p4)

# Additional summary statistics by day type
cat("\nSummary statistics by day type:\n")
summary_stats <- activity_imputed %>%
  group_by(day_type) %>%
  summarise(
    mean_steps = mean(steps),
    median_steps = median(steps),
    total_steps = sum(steps)
  )
print(summary_stats)

# ============================================================================
# Summary
# ============================================================================

cat("\n\n=== ANALYSIS SUMMARY ===\n")
cat("1. Mean steps per day:", round(mean_steps, 2), "\n")
cat("2. Most active interval:", max_interval$interval, "with", round(max_interval$avg_steps, 2), "steps\n")
cat("3. Missing values:", total_na, "(", round(percent_na, 2), "%)\n")
cat("4. After imputation - Mean:", round(mean_steps_imputed, 2), "Median:", round(median_steps_imputed, 2), "\n")
cat("5. Weekday vs Weekend patterns analyzed and plotted\n")

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("All required plots have been generated and displayed.\n")
cat("Results have been printed to the console.\n")

# Save the plots to files
cat("\nSaving plots to files...\n")
ggsave("plot1_histogram_total_steps.png", p1, width = 8, height = 6)
ggsave("plot2_daily_activity_pattern.png", p2, width = 8, height = 6)
ggsave("plot3_histogram_after_imputation.png", p3, width = 8, height = 6)
ggsave("plot4_weekday_weekend_comparison.png", p4, width = 8, height = 6)

cat("Plots saved as PNG files in current directory.\n")
cat("Files created:\n")
cat("- plot1_histogram_total_steps.png\n")
cat("- plot2_daily_activity_pattern.png\n")
cat("- plot3_histogram_after_imputation.png\n")
cat("- plot4_weekday_weekend_comparison.png\n")