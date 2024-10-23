# Load required libraries
library(dplyr)

# Read in the data
collected_data <- read.csv("./data/collected_data.csv")
treatment <- read.csv("./data/treatment.csv")

# Create a column for ID (row number) in both datasets for future reference
collected_data <- collected_data %>%
  mutate(ID = row_number())

# Define the custom treatment index mapping
#   | **Treatment Index** | **Hole Treatment** | **Liquid Treatment** |
#   |---------------------|--------------------|----------------------|
#   | 1                   | NH                 | NL                   |
#   | 2                   | H                  | NL                   |
#   | 3                   | NH                 | DC                   |
#   | 4                   | H                  | DC                   |
#   | 5                   | NH                 | M                    |
#   | 6                   | H                  | M                    |
treatment_mapping <- data.frame(
  hole_treatment = c("NH", "H", "H", "H", "NH", "NH"),
  liquid_treatment = c("NL", "NL", "M", "DC", "M", "DC"),
  treatment_idx = c(1, 2, 6, 4, 5, 3)
)

# Join the treatment and tasting_order data by row and column
joined_data <- collected_data %>%
  inner_join(treatment, by = c("row", "column")) %>%
  left_join(treatment_mapping, by = c("hole_treatment", "liquid_treatment")) %>%
  rename(taste_1 = Julian, taste_2 = Paolo, taste_3 = Feifan) %>%
  select(ID, row, column, treatment_idx, hole_treatment, liquid_treatment, color, taste_1, taste_2, taste_3)

# Save the final joined dataset to a CSV file
write.csv(joined_data, "./data/banana_data.csv", row.names = FALSE)