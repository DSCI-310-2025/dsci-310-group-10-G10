# Load necessary libraries
library(tidyverse)
library(docopt)

# Define command-line arguments
'Usage: modelanalysis.R --model_path=<model> --output_dir=<output>' -> doc
args <- docopt(doc)

# Load trained model
model <- readRDS(args$model_path)

# Save model summary
summary_output <- capture.output(summary(model))
writeLines(summary_output, file.path(args$output_dir, "model_summary.txt"))

# Plot residuals
png(filename = file.path(args$output_dir, "residuals_plot.png"), width = 800, height = 600)
plot(model$finalModel$residuals, main = "Residuals Plot", col = "blue", pch = 20)
abline(h = 0, col = "red")
dev.off()

print("Model analysis completed. Outputs saved.")
