# Makefile to render all Rmd files and create output directory and plots folder

# List all Rmd files in the analysis folder
RMD_FILES := $(wildcard analysis/*.Rmd)

# Output directory for the rendered files
OUTPUT_DIR := output

# Plots directory (within the pre-existing images folder)
PLOTS_DIR := images/plots

# Default rule: Create output directory, plots directory, and render Rmd files to PDF
all: $(OUTPUT_DIR) $(PLOTS_DIR) $(RMD_FILES:analysis/%.Rmd=$(OUTPUT_DIR)/%.pdf)

# EDA rule: Create directories and render only 01_EDA.Rmd to PDF
eda: $(OUTPUT_DIR) $(PLOTS_DIR) $(OUTPUT_DIR)/01_EDA.pdf

# Tests rule: Render 02_Tests.Rmd to PDF
tests: $(OUTPUT_DIR)/02_Tests.pdf

# Report rule: Render the report located in the 'report' directory to PDF in the output folder
report: $(OUTPUT_DIR)/report.pdf

# Rule to create the output directory if it does not exist
$(OUTPUT_DIR):
	@echo "Creating output directory..."
	mkdir -p $(OUTPUT_DIR)

# Rule to create the plots directory if it does not exist
$(PLOTS_DIR):
	@echo "Creating plots directory inside images..."
	mkdir -p $(PLOTS_DIR)

# Rule to render each Rmd file in the analysis folder to PDF and place the output in the output folder
$(OUTPUT_DIR)/%.pdf: analysis/%.Rmd | $(OUTPUT_DIR) $(PLOTS_DIR)
	@echo "Rendering $< to $@"
	Rscript -e "rmarkdown::render('$<', output_format = 'pdf_document', output_file = '../$@')" || (echo "Error rendering $<"; exit 1)

# Rule to render report.Rmd in the 'report' directory to PDF and place it in the output folder
$(OUTPUT_DIR)/report.pdf: report/report.Rmd | $(OUTPUT_DIR)
	@echo "Rendering report.Rmd to PDF in the output folder..."
	Rscript -e "rmarkdown::render('report/report.Rmd', output_format = 'pdf_document', output_file = '../$(OUTPUT_DIR)/report.pdf')" || (echo "Error rendering report.Rmd"; exit 1)

# Rule to clean PDF files and delete the plots folder and its PNG files
clean:
	@echo "Cleaning PDF files and plots..."
	@if [ -d $(OUTPUT_DIR) ]; then \
		echo "Removing PDF files..."; \
		rm -rf $(OUTPUT_DIR)/*.pdf; \
		if [ -z "$$(ls -A $(OUTPUT_DIR))" ]; then \
			rmdir $(OUTPUT_DIR); \
		else \
			echo "$(OUTPUT_DIR) is not empty, skipping directory removal."; \
		fi \
	else \
		echo "$(OUTPUT_DIR) does not exist, skipping PDF cleanup."; \
	fi
	@if [ -d $(PLOTS_DIR) ]; then \
		echo "Removing plot PNG files..."; \
		rm -rf $(PLOTS_DIR)/*.png; \
		if [ -z "$$(ls -A $(PLOTS_DIR))" ]; then \
			rmdir $(PLOTS_DIR); \
		else \
			echo "$(PLOTS_DIR) is not empty, skipping directory removal."; \
		fi \
	else \
		echo "$(PLOTS_DIR) does not exist, skipping plot cleanup."; \
	fi
	@echo "Cleanup completed."