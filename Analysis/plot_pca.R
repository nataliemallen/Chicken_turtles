### R code for pca 
setwd("/Users/natal/R/turtles")

library(ggplot2)
library(dplyr)

# Load metadata dataframe
meta <- read.csv("CT_metadata_12-23_w_sex.csv")  

# Load covariance matrix
turtles.cov <- as.matrix(read.table("poster_turtles.cov"))

pca_result <- prcomp(turtles.cov, scale = TRUE)

# Combine PCA results with metadata
pca_df <- data.frame(pca_result$x)
pca_df <- cbind(meta, pca_df)  # Combining metadata and PCA results

# Extract % variation explained
var_explained <- (pca_result$sdev^2 / sum(pca_result$sdev^2)) * 100

site_colors <- c("Alazan Bayou " = "#1E88E5",  # Deep blue
                 "Brazoria" = "#E69F00",      # Orange
                 "Brazos" = "#56B4E9",       # Light blue
                 "Buller" = "#009E73",       # Green
                 "Gordy" = "#8E44AD",        # Purple
                 "Liberty" = "#D55E00",      # Vermilion
                 "Warren" = "#CC79A7",       # Reddish purple
                 "Wharton" = "#d13b68")      # Blue

# plot
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Site)) +
  geom_point() +
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)")) +
  theme(axis.title.x = element_text(size = 14),  # Adjust size as needed
        axis.title.y = element_text(size = 14))  # Adjust size as needed

# bigger and transparent points 
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Site)) +
  geom_point(size = 6, alpha = 0.8) +  # Increase size to 3 and set transparency to 0.7
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)")) +
  theme(axis.title.x = element_text(size = 16),  # Adjust size as needed
        axis.title.y = element_text(size = 16))  # Adjust size as needed

# bigger and transparent points with larger tick labels
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Site)) +
  geom_point(size = 5, alpha = 0.8) +  # Increase size to 6 and set transparency to 0.8
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)")) + 
  theme(axis.title.x = element_text(size = 16),  # Axis titles size
        axis.title.y = element_text(size = 16),  # Axis titles size
        axis.text.x = element_text(size = 14),  # Tick labels on x-axis size
        axis.text.y = element_text(size = 14))  # Tick labels on y-axis size

print(pca_plot)


print(pca_plot)

#install.packages("svglite")
library(svglite)

# Save the plot as a PDF with 300 dpi
ggsave("pca_final.svg", plot = pca_plot, device = "svg", dpi = 1000)

# eigenvalues 
eigenvalues <- pca_result$sdev^2
print(eigenvalues)

sum(eigenvalues) == sum(pca_result$sdev^2)

# proprotion of varinace
proportion_variance <- eigenvalues / sum(eigenvalues)
print(proportion_variance)

# unrelated PCA -----------------------------------------------------------

### R code for pca 
setwd("/Users/natal/R/turtles")

library(ggplot2)
library(dplyr)

meta <- read.csv("unrelated_plus_3rd_degree_with_pop.csv")

turtles.cov <- as.matrix(read.table("unrelated_turtles.cov"))

pca_result <- prcomp(turtles.cov, scale = TRUE)

pca_df <- data.frame(pca_result$x)
pca_df <- cbind(meta, pca_df)  # Combining metadata and PCA results

var_explained <- (pca_result$sdev^2 / sum(pca_result$sdev^2)) * 100

site_colors <- c("Alazan " = "#1E88E5",  # Deep blue
                 "Brazoria" = "#E69F00",      # Orange
                 "Brazos" = "#56B4E9",       # Light blue
                 "Buller" = "#009E73",       # Green
                 "Gordy" = "#8E44AD",        # Purple
                 "Liberty" = "#D55E00",      # Vermilion
                 "Warren" = "#CC79A7",       # Reddish purple
                 "Wharton" = "#d13b68")      # Blue

# plot
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = pop)) +
  geom_point() +
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)")) +
  theme(axis.title.x = element_text(size = 14),  # Adjust size as needed
        axis.title.y = element_text(size = 14))  # Adjust size as needed

print(pca_plot)

pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = pop)) +
  geom_point(size = 5, alpha = 0.8) +  # Increase size to 6 and set transparency to 0.8
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
       y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)")) + 
  theme(axis.title.x = element_text(size = 16),  # Axis titles size
        axis.title.y = element_text(size = 16),  # Axis titles size
        axis.text.x = element_text(size = 14),  # Tick labels on x-axis size
        axis.text.y = element_text(size = 14))  # Tick labels on y-axis size

print(pca_plot)

pca_df$pop <- recode(pca_df$pop, "Alazan " = "Alazan Bayou")

site_colors <- c("Alazan Bayou" = "#1E88E5",  # Deep blue
                 "Brazoria" = "#E69F00",      
                 "Brazos" = "#56B4E9",       
                 "Buller" = "#009E73",       
                 "Gordy" = "#8E44AD",        
                 "Liberty" = "#D55E00",      
                 "Warren" = "#CC79A7",       
                 "Wharton" = "#d13b68")

# updated plot
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = pop)) +
  geom_point(size = 5, alpha = 0.8) +
  scale_color_manual(values = site_colors) +
  theme_classic() + 
  labs(
    x = paste0("Principal Component 1 (", round(var_explained[1], 2), "%)"), 
    y = paste0("Principal Component 2 (", round(var_explained[2], 2), "%)"),
    color = "Site"  # Change legend title here
  ) + 
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14)
  )

print(pca_plot)

