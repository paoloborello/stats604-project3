# Load required packages
library(dplyr)
library(magick)

# First, we initialize the tasting order and store the collected data
conditions <- c()
for(i in 1:5){
  for(j in 1:6){
    conditions <- c(conditions, paste0(i,j))
  }
}
set.seed(123)
tasting_order <- sample(conditions)
row <- substr(tasting_order, 1, 1)
column <- substr(tasting_order, 2, 2)

tasting_order <- data.frame(row = row,
                            column = column,
                            Julian = c(3, 3, 3.5, 2.5, 2.5, 2.5, 3, 3, 2, 2.5, 1.5, 3, 2, 2.5, 3, 3, 2, 2.5, 2.5, 3, 3, 2.5, 3, 3.5, 3, 2.5, 3, 2, 2.5, 1.5),
                            Paolo = c(3.5, 3, 3.5, 2.5, 2, 3.5, 3, 2, 4, 3, 2, 4, 3, 2, 4, 4, 4, 2.5, 3.5, 3, 3.5, 2, 2.5, 3.5, 2.5, 2, 3, 2.5, 3.5, 2.5),
                            Feifan = c(3, 2.5, 3, 3.5, 2.5, 3.5, 4, 2.5, 3.5, 2.5, 3.5, 2.5, 2.5, 3, 3, 2.5, 3, 3, 4, 2.5, 3.5, 3, 3.5, 4, 3, 3, 4, 3, 3.5, 4))

# Now, we generate the color data
mean_rgb <- function(banana_index){
  image_path <- paste0("./images/bananas/", banana_index, ".png")
  img <- image_read(image_path)
  print(paste0("Reading image at ", image_path))
  dim(image_data(img))
  
  readable_red <- strtoi(image_data(img)[1,,], base = 16)
  meanred <- mean(readable_red[which(readable_red != 255)])
  
  readable_green <- strtoi(image_data(img)[2,,], base = 16)
  meangreen <- mean(readable_green[which(readable_green != 255)])
  
  readable_blue <- strtoi(image_data(img)[3,,], base = 16)
  meanblue <- mean(readable_blue[which(readable_blue != 255)])
  
  return(c(meanred, meangreen, meanblue))
}

rgb_matrix <- function(){
  banana_matrix <- matrix(data = 0, nrow = 30, ncol = 4)
  row <- 1
  for(i in 1:5){
    for(j in 1:6){
      banana_matrix[row, 1] <- as.integer(paste0(i, j))
      mean_vals <- mean_rgb(paste0(i,j))
      banana_matrix[row, 2] <- mean_vals[1]
      banana_matrix[row, 3] <- mean_vals[2]
      banana_matrix[row, 4] <- mean_vals[3]
      row = row + 1
    }
  }
  return(banana_matrix)
}

ripeness_scores <- function(rgb_matrix, reference_points){
  # Transform rgb_matrix into ripeness_df with columns: row, column, r, g, b
  ripeness_df <- data.frame(rgb_matrix)
  colnames(ripeness_df) <- c("row_column", "r", "g", "b")
  
  # Number of segments
  N <- nrow(reference_points)
  num_segments <- N - 1
  
  # Initialize ripeness column
  ripeness_df$color <- NA
  
  # For each row in ripeness_df
  for (i in 1:nrow(ripeness_df)) {
    x <- as.numeric(ripeness_df[i, c("r", "g", "b")]) # Extract (r, g, b)
    min_distance2 <- Inf
    best_ripeness <- NA
    
    # For each segment S_j
    for (j in 1:num_segments) {
      a <- reference_points[j, ]
      b <- reference_points[j+1, ]
      v <- b - a
      v_dot_v <- sum(v * v)
      if (v_dot_v == 0) {
        # Segment of zero length, skip
        next
      }
      t <- sum((x - a) * v) / v_dot_v
      t_clamped <- max(0, min(1, t))
      p <- a + t_clamped * v
      distance2 <- sum((x - p)^2)
      if (distance2 < min_distance2) {
        min_distance2 <- distance2
        # ripeness score r = j + t_clamped
        r <- j + t_clamped
        best_ripeness <- r / N # Normalize ripeness to [0,1]
      }
    }
    # Assign ripeness value
    ripeness_df$color[i] <- best_ripeness
  }
  
  return(ripeness_df)
}

reference_points = matrix(data = c(167,198,39,
                                   237,231,78,
                                   242,154,79,
                                   201,129,62,
                                   144,86,45,
                                   86,51,23),
                          nrow = 6,
                          ncol = 3,
                          byrow = TRUE)

banana_matrix <- rgb_matrix()

df <- ripeness_scores(banana_matrix, reference_points)
df <- df %>%
  mutate(row = substr(row_column, 1, 1)) %>%
  mutate(column = substr(row_column, 2, 2)) %>%
  select(c("row", "column", "color"))

# And we join and output the resulting data
collected_data <- tasting_order %>%
  left_join(df)

write.csv(collected_data, "./data/collected_data.csv")