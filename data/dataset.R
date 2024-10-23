# Load required libraries
library(dplyr)

# Read in the data
tasting_order <- read.csv("./data/tasting_order_01.csv")
treatment <- read.csv("./data/treatment.csv")

# Create a column for ID (row number) in both datasets for future reference
tasting_order <- tasting_order %>%
  mutate(ID = row_number())

# Sample color uniformly between [0, 1]
set.seed(123)  # Set seed for reproducibility
tasting_order <- tasting_order %>%
  mutate(color = runif(n()))

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
joined_data <- tasting_order %>%
  inner_join(treatment, by = c("row", "col" = "column")) %>%
  left_join(treatment_mapping, by = c("hole_treatment", "liquid_treatment")) %>%
  rename(column = col, taste_1 = Julian, taste_2 = Paolo, taste_3 = Feifan) %>%
  select(ID, row, column, treatment_idx, hole_treatment, liquid_treatment, color, taste_1, taste_2, taste_3)

# Save the final joined dataset to a CSV file
write.csv(joined_data, "./data/banana_data.csv", row.names = FALSE)