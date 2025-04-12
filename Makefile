# 定义路径
RAW_DATA = data/raw/combined_airbnb.csv
CLEANED_DATA = data/cleaned/cleaned_airbnb.csv
TRAIN_DATA = data/processed/train.csv
TEST_DATA = data/processed/test.csv
PREPROCESSOR_FILE = model/preprocessor.rds
MODEL_FILE = model/model.rds
EDA_PLOTS = results/histograms.png results/correlation_matrix.png
REPORT_HTML = Milestone_1_Data_Analysis/Airbnb_Pricing_Analysis_Milestone_1.html
DOCS_INDEX = docs/index.html

# 代码脚本
DOWNLOAD_SCRIPT = scripts/downloadsdata.R
CLEAN_SCRIPT = scripts/cleandata.R
PREPROCESS_SCRIPT = scripts/preprocessdata.R
EDA_SCRIPT = scripts/edaanalysis.R
TRAIN_SCRIPT = scripts/trainmodel.R
MODEL_SCRIPT = scripts/modelanalysis.R
QMD_FILE = Milestone_1_Data_Analysis/Airbnb_Pricing_Analysis_Milestone_1.qmd

# PHONY 目标
.PHONY: all clean

# 运行完整 pipeline
all: $(DOCS_INDEX)

# 1. 下载数据
$(RAW_DATA): $(DOWNLOAD_SCRIPT)
	mkdir -p data/raw
	Rscript $(DOWNLOAD_SCRIPT) --output_path=$(RAW_DATA)

# 2. 数据清理
$(CLEANED_DATA): $(RAW_DATA) $(CLEAN_SCRIPT)
	mkdir -p data/cleaned
	Rscript $(CLEAN_SCRIPT) --input_path=$(RAW_DATA) --output_path=$(CLEANED_DATA)

# 3. 数据预处理（拆分训练/测试集）
$(TRAIN_DATA) $(TEST_DATA) $(PREPROCESSOR_FILE): $(CLEANED_DATA) $(PREPROCESS_SCRIPT)
	mkdir -p data/processed model
	Rscript $(PREPROCESS_SCRIPT) --input_path=$(CLEANED_DATA) --train_path=$(TRAIN_DATA) --test_path=$(TEST_DATA) --preprocessor_path=$(PREPROCESSOR_FILE)

# 4. 进行 EDA
$(EDA_PLOTS): $(CLEANED_DATA) $(EDA_SCRIPT)
	mkdir -p results
	Rscript $(EDA_SCRIPT) --input_path=$(CLEANED_DATA) --output_dir=results

# 5. 训练模型
$(MODEL_FILE): $(TRAIN_DATA) $(PREPROCESSOR_FILE) $(TRAIN_SCRIPT)
	mkdir -p model
	Rscript $(TRAIN_SCRIPT) --train_path=$(TRAIN_DATA) --preprocessor_path=$(PREPROCESSOR_FILE) --model_path=$(MODEL_FILE)

#5.5 
results/model_summary.txt results/residuals_plot.png: $(CLEANED_DATA) $(MODEL_SCRIPT)
	mkdir -p results
	Rscript $(MODEL_SCRIPT) --input_path=$(CLEANED_DATA) --output_dir=results

# 6. 生成 Quarto 报告
$(REPORT_HTML): $(QMD_FILE) $(EDA_PLOTS) results/model_summary.txt results/residuals_plot.png
	quarto render $(QMD_FILE) --to html

# 7. 复制到 docs 目录
$(DOCS_INDEX): $(REPORT_HTML)
	mkdir -p docs
	cp $(REPORT_HTML) $(DOCS_INDEX)
	cp -r results docs/results

# 清理临时文件
clean:
	rm -rf data/raw/* data/cleaned/* data/processed/*
	rm -rf model/*
	rm -rf results/*
	rm -rf Milestone_1_Data_Analysis/*.html docs/*