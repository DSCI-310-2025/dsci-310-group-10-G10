# Load required libraries
library(tidyverse)
library(caret)
library(docopt)

# Define command-line arguments
'Usage: trainmodel.R --train_path=<train> --preprocessor_path=<preprocessor> --model_path=<model> --metrics_path=<metrics>' -> doc
args <- docopt(doc)

# Ensure necessary directories exist
dir.create(dirname(args$model_path), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(args$metrics_path), recursive = TRUE, showWarnings = FALSE)

# Load train data
train_data <- read_csv(args$train_path, show_col_types = FALSE)

# Load preprocessor (if applicable)
preprocessor <- readRDS(args$preprocessor_path)

# Train a multiple linear regression model
model <- train(realSum ~ person_capacity + bedrooms + dist + metro_dist + 
               attr_index_norm + host_is_superhost + room_type + 
               weekdays + city + rest_index_norm, 
               data = train_data, method = "lm")

# Save the trained model
saveRDS(model, args$model_path)

# Compute evaluation metrics
predictions <- predict(model, newdata = train_data)
rmse <- sqrt(mean((predictions - train_data$realSum)^2))
mae <- mean(abs(predictions - train_data$realSum))
r2 <- cor(predictions, train_data$realSum)^2

# Save metrics to CSV
metrics <- tibble(RMSE = rmse, MAE = mae, R2 = r2)
write_csv(metrics, args$metrics_path)

print("✅ Model training completed. Model and metrics saved.")
