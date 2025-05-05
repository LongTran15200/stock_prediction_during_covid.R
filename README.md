# 📈 Predicting S&P 500 Prices During COVID-19 with Linear Regression in R

This project explores how various financial indicators influenced the S&P 500 stock index during the COVID-19 pandemic period (January 2020 to December 2021). Using R, we clean and transform the dataset, perform feature engineering, and build a linear regression model to predict the S&P 500 price.

---

## 📊 Dataset Overview

The dataset contains historical daily prices for:
- S&P 500 Index
- Bitcoin
- Ethereum
- Gold
- Platinum
- Nasdaq 100
- Berkshire Hathaway (BRK.A)

📅 **Date Range**: January 1, 2020 – December 31, 2021  
🔢 **Columns Used**: Columns 3 to 39 from the original dataset

> **Note**: Dataset should be named `US.Stock.Market.Dataset` in your environment.

---

## 🧹 Data Preparation

The following transformations were performed:
- Removed commas from numeric strings (e.g., "3,200.50" → 3200.50)
- Converted selected columns to numeric type
- Created a `Date` column starting from January 1, 2020
- Reversed the dataset to order it chronologically
- Created a target variable: **tomorrow's S&P 500 price**
- Filtered data to only include COVID-19 period (2020-2021)
- Removed any rows with missing values

---

## 🧠 Machine Learning Approach

### ✅ Model Used:
- **Linear Regression** (`lm()` function in R)

### 🎯 Features Used:
- Bitcoin_Price
- Ethereum_Price
- Gold_Price
- Platinum_Price
- Nasdaq_100_Price
- Berkshire_Price

### 🧪 Train-Test Split:
- 80% training data
- 20% test data
- Reproducible split using `set.seed(123)`

---

## 📈 Results

### 🔍 Model Evaluation:
- **RMSE (Root Mean Squared Error)** is calculated to assess prediction accuracy.

### 📅 Prediction:
- A prediction is made for **tomorrow’s S&P 500 price** using the latest data point.

### 📊 Visualization:
A line graph compares:
- Actual S&P 500 Prices (Blue)
- Predicted S&P 500 Prices (Red)

Using `ggplot2` for a clean and informative visual.

---

## 📂 Folder Structure
