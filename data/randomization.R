# Load required packages
library(ggplot2)
library(reshape2)

# Set the seed for reproducibility
set.seed(123)

# Define the treatment levels
hole_treatment_levels <- c("NH", "H")  # NH = No Holes, H = Holes
liquid_treatment_levels <- c("NL", "DC", "M")  # NL = No Liquid, DC = Diet Coke, M = Milk

# Number of shelves
n_shelves <- 5

# Number of positions per shelf (6 treatments total: 2 hole levels × 3 liquid levels)
n_positions_per_shelf <- length(hole_treatment_levels) * length(liquid_treatment_levels)

# Create an empty list to store the data
treatment_data <- data.frame(row = integer(), column = integer(), hole_treatment = character(), liquid_treatment = character())

# For each shelf, create the random assignment and populate the dataframe
for (shelf in 1:n_shelves) {
  # Create the full factorial design of treatment combinations
  treatments <- expand.grid(hole_treatment = hole_treatment_levels, liquid_treatment = liquid_treatment_levels)
  
  # Shuffle the order of treatments for randomization on this shelf
  randomized_treatments <- treatments[sample(nrow(treatments)), ]
  
  # Create a dataframe for this shelf with row, column (position), and treatments
  shelf_data <- data.frame(
    row = shelf,
    column = 1:n_positions_per_shelf,
    hole_treatment = randomized_treatments$hole_treatment,
    liquid_treatment = randomized_treatments$liquid_treatment
  )
  
  # Append to the main data
  treatment_data <- rbind(treatment_data, shelf_data)
}

treatment_data$row <- 6 - treatment_data$row

# Create a combined treatment label
treatment_data$treatment <- paste(treatment_data$hole_treatment, treatment_data$liquid_treatment, sep = " + ")

# Visualize as a matrix with text labels
ggplot(treatment_data, aes(x = column, y = row, fill = treatment)) +
  geom_tile(color = "black") +
  geom_text(aes(label = treatment), size = 3, color = "black") +  # Add treatment text
  scale_fill_brewer(palette = "Set3") +
  labs(x = "Position within Shelf (Column)", y = "Shelf (Row)", title = "Randomized Treatment Assignment with Labels") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  scale_y_reverse()

# Save the data to a file called "csv"
write.csv(treatment_data, file = "./data/treatment.csv", row.names = FALSE)