# Reproducible Research: Peer Assessment 1

## Introduction
This repository contains the submission for Peer Assessment 1 of the Reproducible Research course. The analysis examines data from a personal activity monitoring device that collects data at 5-minute intervals throughout the day.

## Dataset
The dataset contains two months of data from an anonymous individual collected during October and November, 2012. The variables included are:

- **steps**: Number of steps taken in a 5-minute interval (missing values coded as `NA`)
- **date**: The date of measurement in YYYY-MM-DD format
- **interval**: Identifier for the 5-minute interval

## Files in Repository

- `PA1_analysis.R` - Complete R script that performs all analyses
- `activity.csv` - Raw data file
- `plot1_histogram_total_steps.png` - Histogram of total steps per day
- `plot2_daily_activity_pattern.png` - Time series of average steps per interval
- `plot3_histogram_after_imputation.png` - Histogram after missing value imputation
- `plot4_weekday_weekend_comparison.png` - Panel plot comparing weekdays vs weekends
- `README.md` - This file

## Analysis Summary

### 1. Loading and Preprocessing Data
- Loaded the activity monitoring dataset
- Converted date column to proper Date format
- Examined data structure and missing values

### 2. Total Steps Per Day
- Calculated total steps taken each day (ignoring missing values)
- Created histogram of total daily steps
- **Mean**: 9,354.23 steps per day
- **Median**: 10,395 steps per day

### 3. Average Daily Activity Pattern
- Calculated average steps for each 5-minute interval across all days
- Created time series plot of average steps by interval
- **Most active interval**: 835 (8:35 AM) with 206.17 average steps

### 4. Imputing Missing Values
- **Missing values**: 2,304 (13.11% of data)
- **Strategy**: Used mean of corresponding 5-minute interval for imputation
- After imputation:
  - **Mean**: 10,766.19 steps per day
  - **Median**: 10,766.19 steps per day
- Imputation increased both mean and median estimates

### 5. Weekday vs Weekend Activity Patterns
- Created factor variable to distinguish weekdays and weekends
- Panel plot shows different activity patterns:
  - Weekdays: Peak activity around 8:35 AM
  - Weekends: More consistent activity throughout the day
- **Weekday mean**: 35.6 steps per interval
- **Weekend mean**: 42.4 steps per interval

## How to Reproduce

1. Clone this repository
2. Open `PA1_analysis.R` in RStudio
3. Run the entire script
4. All plots will be displayed and saved as PNG files
5. Results will be printed to the console

## Requirements
- R (version 3.5 or higher)
- R packages: ggplot2, dplyr, lubridate

## Author
[Zafar Wazir]

## Course
Reproducible Research - Johns Hopkins University via Coursera
