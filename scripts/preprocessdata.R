# Load required libraries
library(tidyverse)
library(caret)
library(docopt)

# Define command-line arguments
'Usage: preprocessdata.R --input_path=<input> --train_path=<train> --test_path=<test> --preprocessor_path=<preprocessor>' -> doc
args <- docopt(doc)

# Ensure necessary directories exist
dir.create(dirname(args$train_path), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(args$test_path), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(args$preprocessor_path), recursive = TRUE, showWarnings = FALSE)

# Load cleaned data
airbnb <- read_csv(args$input_path, show_col_types = FALSE)

# Split data into 80% train, 20% test
set.seed(123)
train_indices <- createDataPartition(airbnb$realSum, p = 0.8, list = FALSE)
train_data <- airbnb[train_indices, ]
test_data <- airbnb[-train_indices, ]

# Save train and test datasets
write_csv(train_data, args$train_path)
write_csv(test_data, args$test_path)

# Save preprocessor (if transformations are applied in the future)
preprocessor <- list(scaling = FALSE, encoding = FALSE)  # Placeholder for transformations
saveRDS(preprocessor, args$preprocessor_path)

print("✅ Preprocessing completed. Train and test data saved.")
