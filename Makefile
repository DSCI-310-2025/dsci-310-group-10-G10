# Define variables
RAW_DATA = data/raw/combined_airbnb.csv
CLEANED_DATA = data/cleaned/cleaned_airbnb.csv
TRAIN_DATA = data/processed/train.csv
TEST_DATA = data/processed/test.csv
PREPROCESSOR_FILE = model/preprocessor.rds
MODEL_FILE = model/model.rds
METRICS_FILE = model/model_metrics.csv
EDA_PLOTS = results/histograms.png results/correlation_matrix.png
MODEL_SUMMARY = results/model_summary.txt
RESIDUALS_PLOT = results/residuals_plot.png
RESULTS_DIR = results/
MODEL_DIR = model/
REPORT_DIR = report/
REPORT_BUILD = report/_build/html/index.html

# Scripts
DOWNLOAD_SCRIPT = scripts/downloadsdata.R
CLEAN_SCRIPT = scripts/cleandata.R
PREPROCESS_SCRIPT = scripts/preprocessdata.R
EDA_SCRIPT = scripts/edaanalysis.R
TRAIN_SCRIPT = scripts/trainmodel.R
MODEL_SCRIPT = scripts/modelanalysis.R
JUPYTER_BOOK = jupyter-book  # Ensure Jupyter-Book is installed

# PHONY Targets
.PHONY: all clean

# Run the entire pipeline
all: $(RAW_DATA) $(CLEANED_DATA) $(TRAIN_DATA) $(EDA_PLOTS) $(MODEL_FILE) $(METRICS_FILE) $(MODEL_SUMMARY) $(RESIDUALS_PLOT) $(REPORT_BUILD)

# Step 1: Download Data
$(RAW_DATA): $(DOWNLOAD_SCRIPT)
	Rscript $(DOWNLOAD_SCRIPT) --output_path=$(RAW_DATA)

# Step 2: Clean Data
$(CLEANED_DATA): $(RAW_DATA) $(CLEAN_SCRIPT)
	Rscript $(CLEAN_SCRIPT) --input_path=$(RAW_DATA) --output_path=$(CLEANED_DATA)

# Step 3: Preprocess Data (Train/Test Split)
$(TRAIN_DATA) $(TEST_DATA) $(PREPROCESSOR_FILE): $(CLEANED_DATA) $(PREPROCESS_SCRIPT)
	Rscript $(PREPROCESS_SCRIPT) --input_path=$(CLEANED_DATA) --train_path=$(TRAIN_DATA) --test_path=$(TEST_DATA) --preprocessor_path=$(PREPROCESSOR_FILE)

# Step 4: Exploratory Data Analysis (EDA)
$(EDA_PLOTS): $(CLEANED_DATA) $(EDA_SCRIPT)
	Rscript $(EDA_SCRIPT) --input_path=$(CLEANED_DATA) --output_dir=$(RESULTS_DIR)

# Step 5: Train the Model
$(MODEL_FILE) $(METRICS_FILE): $(TRAIN_DATA) $(PREPROCESSOR_FILE) $(TRAIN_SCRIPT)
	Rscript $(TRAIN_SCRIPT) --train_path=$(TRAIN_DATA) --preprocessor_path=$(PREPROCESSOR_FILE) --model_path=$(MODEL_FILE) --metrics_path=$(METRICS_FILE)

# Step 6: Analyze Model (Residuals, Summary)
$(MODEL_SUMMARY) $(RESIDUALS_PLOT): $(MODEL_FILE) $(MODEL_SCRIPT)
	Rscript $(MODEL_SCRIPT) --model_path=$(MODEL_FILE) --output_dir=$(RESULTS_DIR)

# Step 7: Build HTML Report Using Jupyter-Book
$(REPORT_BUILD): $(MODEL_SUMMARY) $(EDA_PLOTS)
	$(JUPYTER_BOOK) build $(REPORT_DIR)
	mkdir -p docs
	cp -r report/_build/html/* docs
	if [ ! -f ".nojekyll" ]; then touch docs/.nojekyll; fi

# Clean all generated files
clean:
	rm -f $(RAW_DATA) $(CLEANED_DATA) $(TRAIN_DATA) $(TEST_DATA) $(PREPROCESSOR_FILE) $(EDA_PLOTS) $(MODEL_FILE) $(METRICS_FILE) $(MODEL_SUMMARY) $(RESIDUALS_PLOT)
	rm -rf report/_build docs/*
