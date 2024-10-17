# Makefile to render all Rmd files and create output directory

# List all Rmd files in the analysis folder
RMD_FILES := $(wildcard analysis/*.Rmd)

# Output directory for the rendered files
OUTPUT_DIR := output

# Default rule: Create output directory and render Rmd files to HTML
all: $(RMD_FILES:analysis/%.Rmd=$(OUTPUT_DIR)/%.html)

# Rule to create the output directory if it does not exist
$(OUTPUT_DIR):
	@echo "Creating output directory..."
	mkdir -p $(OUTPUT_DIR)

# Rule to render each Rmd file to HTML and place the output in the output folder
$(OUTPUT_DIR)/%.html: analysis/%.Rmd | $(OUTPUT_DIR)
	@echo "Rendering $< to $@"
	Rscript -e "rmarkdown::render('$<', output_file = '../$@')" || (echo "Error rendering $<"; exit 1)

clean:
	rm -rf $(OUTPUT_DIR)/*.html
	rmdir $(OUTPUT_DIR)
	