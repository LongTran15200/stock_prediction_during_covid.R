# Predicting S&P 500 Prices During COVID
# Linear Regression in R

# Load necessary libraries
library(dplyr)
library(caret)
library(ggplot2)

# View and inspect dataset
View(US.Stock.Market.Dataset)
head(US.Stock.Market.Dataset)
summary(US.Stock.Market.Dataset)

# Keep only relevant columns (columns 3 to 39)
our.stocks <- US.Stock.Market.Dataset[, 3:39]

# Convert S&P 500 Price to numeric by removing commas
our.stocks$S.P_500_Price <- as.numeric(gsub(",", "", our.stocks$S.P_500_Price))

# Define other columns to convert to numeric
numeric_columns <- c("Bitcoin_Price", "Gold_Price", "Platinum_Price",
                     "Ethereum_Price", "Nasdaq_100_Price", "Berkshire_Price")

# Convert each to numeric
for (col in numeric_columns) {
  our.stocks[[col]] <- as.numeric(gsub(",", "", our.stocks[[col]]))
}

# Check if any columns are still characters
chars <- sapply(our.stocks, is.character)
print(chars)

# Summary after conversion
summary(our.stocks)

# Create a Date column starting from Jan 1, 2020
start_date <- as.Date("2020-01-01")
our.stocks$Date <- seq(from = start_date, by = "days", length.out = nrow(our.stocks))

# Arrange dates from earliest to latest
our.stocks <- our.stocks[rev(seq_len(nrow(our.stocks))), ]

# Set up the target variable: Tomorrow’s S&P 500 Price
tomorrow_500_price <- our.stocks$S.P_500_Price[-nrow(our.stocks)]
our.stocks <- our.stocks[-1, ]
our.stocks$tomorrow_500_price <- tomorrow_500_price

# Filter data for COVID-19 period (Jan 2020 - Dec 2021)
covid_period_data <- our.stocks %>%
  filter(Date >= as.Date("2020-01-01") & Date <= as.Date("2021-12-31"))

# Remove rows with missing values
covid_period_data <- na.omit(covid_period_data)

# Structure check
str(covid_period_data)
head(covid_period_data)

# ---------------------------
# Linear Regression Modeling
# ---------------------------

# Set random seed for reproducibility
set.seed(123)

# Split data into 80% training, 20% testing
train_index <- createDataPartition(covid_period_data$S.P_500_Price, p = 0.8, list = FALSE)
train_data <- covid_period_data[train_index, ]
test_data <- covid_period_data[-train_index, ]

# Train linear regression model
lm_model <- lm(S.P_500_Price ~ Bitcoin_Price + Gold_Price + Platinum_Price +
                 Ethereum_Price + Nasdaq_100_Price + Berkshire_Price,
               data = train_data)

# View model summary
summary(lm_model)

# Make predictions on test set
predictions <- predict(lm_model, newdata = test_data)

# Compare predictions vs actuals
results <- data.frame(
  Date = test_data$Date,
  Actual = test_data$S.P_500_Price,
  Predicted = predictions
)

# Show preview of results
print(head(results))

# Calculate RMSE
rmse <- sqrt(mean((results$Actual - results$Predicted)^2))
cat("RMSE:", rmse, "\n")

# Predict tomorrow's S&P 500 using most recent data
tomorrow_data <- covid_period_data[nrow(covid_period_data), , drop = FALSE]
tomorrow_prediction <- predict(lm_model, newdata = tomorrow_data)
cat("Predicted S&P 500 Price for tomorrow:", tomorrow_prediction, "\n")

# ---------------------------
# Visualization
# ---------------------------

ggplot(data = results, aes(x = Date)) +
  geom_line(aes(y = Actual, color = "Actual"), size = 1) +
  geom_line(aes(y = Predicted, color = "Predicted"), size = 1) +
  labs(title = "Actual vs Predicted S&P 500 Prices During COVID-19",
       x = "Date",
       y = "S&P 500 Price",
       color = "Legend") +
  theme_minimal() +
  scale_color_manual(values = c("Actual" = "blue", "Predicted" = "red"))
