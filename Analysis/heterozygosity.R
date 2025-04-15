### R code for heterozygosity 
rm(list = ls())
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Read the CSV file
data <- read.csv("heterozygosity_prelim.csv")

# Ensure the 'Site' column is treated as a factor with correct order
data$Site <- factor(data$Site, levels = c("Alazan Bayou ", "Brazoria", "Brazos", "Buller", "Gordy", "Liberty", "Warren", "Wharton"))

# Define the colors for each site
Site_colors <- c("Alazan Bayou " = "#1E88E5",  # Deep blue
                 "Brazoria" = "#E69F00",      # Orange
                 "Brazos" = "#56B4E9",       # Light blue
                 "Buller" = "#009E73",       # Green
                 "Gordy" = "#8E44AD",        # Purple
                 "Liberty" = "#D55E00",      # Vermilion
                 "Warren" = "#CC79A7",       # Reddish purple
                 "Wharton" = "#d13b68")

# Filter out sites with only one or two individuals
filtered_data <- data %>%
  group_by(Site) %>%
  filter(n() > 2)

p <- ggplot(filtered_data, aes(x = Site, y = Heterozygosity, color = Site)) +
  geom_boxplot(outlier.shape = NA) +  # Avoid plotting outliers twice
  geom_jitter(data = data, aes(x = Site, y = Heterozygosity), width = 0.2, size = 2, alpha = 0.6) +  # Add individual data points with transparency
  theme_minimal() +
  ylim(0, 0.0016) +  # Further increase y-axis scale if needed
  scale_color_manual(values = Site_colors) +  # Apply custom colors
  theme(
    axis.title = element_text(size = 18),  # Increase axis titles
    axis.text = element_text(size = 14),   # Increase axis text
    legend.text = element_text(size = 14),  # Increase legend text size
    legend.title = element_text(size = 16), # Increase legend title size (optional)
    axis.title.x = element_text(margin = margin(t = 15)),  # Move x-axis label down
    axis.title.y = element_text(margin = margin(r = 15))   # Move y-axis label to the right
  ) +
  labs(x = "Sample Site", y = "Genome-wide Heterozygosity", color = "Site")


# Display the plot
print(p)
library(svglite)
ggsave("het_boxplot.svg", plot = p, device = "svg", dpi = 1000)

ggsave("het_boxplot.pdf", plot = p, device = "pdf", dpi = 300)


# significance calculation ------------------------------------------------
# load necessary libraries
library(dplyr)
library(tidyr)

# read data
data <- read.csv("heterozygosity_prelim.csv")

# filter sites with at least two samples (Wilcoxon requires at least one value per group)
site_counts <- data %>%
  group_by(Site) %>%
  summarize(n = n(), .groups = 'drop')

valid_sites <- site_counts %>%
  filter(n >= 2) %>%
  pull(Site)

filtered_data <- data %>%
  filter(Site %in% valid_sites)

# generate all pairwise site combinations
site_pairs <- combn(valid_sites, 2, simplify = FALSE)

# perform pairwise wilcoxon tests
results <- lapply(site_pairs, function(pair) {
  site1_data <- filtered_data %>% filter(Site == pair[1]) %>% pull(Heterozygosity)
  site2_data <- filtered_data %>% filter(Site == pair[2]) %>% pull(Heterozygosity)
  
  # perform test
  test <- wilcox.test(site1_data, site2_data, exact = FALSE)
  
  # return results as a tibble
  tibble(
    Site1 = pair[1],
    Site2 = pair[2],
    p_value = test$p.value
  )
})

# combine results into a single table
results_table <- bind_rows(results)

# adjust p-values for multiple testing (optional, e.g., Bonferroni or FDR)
results_table <- results_table %>%
  mutate(adjusted_p_value = p.adjust(p_value, method = "fdr"))

# view results
print(results_table)

# save results to csv
write.csv(results_table, "pairwise_wilcoxon_results.csv", row.names = FALSE)



