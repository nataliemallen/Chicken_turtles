### R code for pca 
setwd("/Users/natal/R/turtles")

library(ggplot2)
library(dplyr)

# Load metadata dataframe
meta <- read.csv("CT_metadata_12-23.csv")  # Update with the actual path

# Load covariance matrix
turtles.cov <- as.matrix(read.table("turtles.cov"))

pca_result <- prcomp(turtles.cov, scale = TRUE)

# Combine PCA results with metadata
pca_df <- data.frame(pca_result$x)
pca_df <- cbind(meta, pca_df)  # Combining metadata and PCA results

# Extract % variation explained
var_explained <- (pca_result$sdev^2 / sum(pca_result$sdev^2)) * 100

# Create scatter plot
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Site)) +
  geom_point() +
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)"), 
       title = "PCA Scatter Plot")

print(pca_plot)


### R code for pca 
setwd("/Users/natal/R/turtles")

library(ggplot2)
library(dplyr)

# Load metadata dataframe
meta <- read.csv("CT_metadata_12-23.csv")  # Update with the actual path

# Load covariance matrix
turtles.cov <- as.matrix(read.table("turtles.cov"))

pca_result <- prcomp(turtles.cov, scale = TRUE)

# Combine PCA results with metadata
pca_df <- data.frame(pca_result$x)
pca_df <- cbind(meta, pca_df)  # Combining metadata and PCA results

# Extract % variation explained
var_explained <- (pca_result$sdev^2 / sum(pca_result$sdev^2)) * 100

# Define colors for each site
#site_colors <- c("Alazan Bayou " = "#1E88E5", "Brazoria" = "#117733", "Brazos" = "#44AA99", 
#                 "Buller" = "#ac840c", "Gordy" = "#88CCEE", "Liberty" = "#fcb603", "Warren" = "#CC6677", "Wharton" = "#AA4499")

#site_colors <- c("Alazan Bayou " = "#1E88E5",  # Deep blue
#                 "Brazoria" = "#E69F00",      # Orange
#                 "Brazos" = "#56B4E9",       # Light blue
#                 "Buller" = "#009E73",       # Green
#                 "Gordy" = "#8E44AD",        # Purple
#                 "Liberty" = "#D55E00",      # Vermilion
#                 "Warren" = "#CC79A7",       # Reddish purple
#                 "Wharton" = "#d13b68")      # Blue
site_colors <- c("Neches" = "#1E88E5",  # Deep blue
                 "Brazos" = "#56B4E9",       # Light blue
                 "San Jacinto" = "#009E73",       # Green
                 "Trinity" = "#8E44AD",        # Purple
                 "Colorado" = "#d13b68")      # Blue


# Create scatter plot
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = River)) +
  geom_point() +
  scale_color_manual(values = site_colors) +
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)"), 
       title = "PCA Scatter Plot")

print(pca_plot)

