library(tidyverse)
library(docopt)

# Define command-line arguments
'Usage: cleandata.R --input_path=<input> --output_path=<output>' -> doc
args <- docopt(doc)

# Ensure output directory exists
dir.create(dirname(args$output_path), recursive = TRUE, showWarnings = FALSE)

# Load data
airbnb <- read_csv(args$input_path, show_col_types = FALSE)

# Convert categorical variables to factors
airbnb <- airbnb %>%
  mutate(
    room_type = as.factor(room_type),
    host_is_superhost = as.factor(host_is_superhost),
    city = as.factor(city),
    weekdays = as.factor(weekdays)
  )

# Save cleaned dataset
write_csv(airbnb, args$output_path)
