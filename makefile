# Makefile to render all Rmd files and create output directory and plots folder

# List all Rmd files in the analysis folder
RMD_FILES := $(wildcard analysis/*.Rmd)

# Output directory for the rendered files
OUTPUT_DIR := output

# Plots directory (within the pre-existing images folder)
PLOTS_DIR := images/plots

# Default rule: Create output directory, plots directory, and render Rmd files to HTML
all: $(OUTPUT_DIR) $(PLOTS_DIR) $(RMD_FILES:analysis/%.Rmd=$(OUTPUT_DIR)/%.html)

# EDA rule: Create directories and render only 01_EDA.Rmd
eda: $(OUTPUT_DIR) $(PLOTS_DIR) $(OUTPUT_DIR)/01_EDA.html

# Rule to create the output directory if it does not exist
$(OUTPUT_DIR):
	@echo "Creating output directory..."
	mkdir -p $(OUTPUT_DIR)

# Rule to create the plots directory if it does not exist
$(PLOTS_DIR):
	@echo "Creating plots directory inside images..."
	mkdir -p $(PLOTS_DIR)

# Rule to render each Rmd file to HTML and place the output in the output folder
$(OUTPUT_DIR)/%.html: analysis/%.Rmd | $(OUTPUT_DIR) $(PLOTS_DIR)
	@echo "Rendering $< to $@"
	Rscript -e "rmarkdown::render('$<', output_file = '../$@')" || (echo "Error rendering $<"; exit 1)

# Rule to clean HTML files and delete the plots folder and its PNG files
clean:
	@echo "Cleaning HTML files and plots..."
	rm -rf $(OUTPUT_DIR)/*.html
	rm -rf $(PLOTS_DIR)/*.png
	@echo "Cleaning folders..."
	rmdir $(PLOTS_DIR)
	rmdir $(OUTPUT_DIR)
	