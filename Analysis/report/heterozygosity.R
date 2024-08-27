
### R code for heterozygosity 
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library(ggplot2)

# Read the CSV file
data <- read.csv("heterozygosity_prelim.csv")

# Reorder ID based on heterozygosity
#data$ID <- factor(data$Plot_order, levels = data$ID[order(data$Heterozygosity, decreasing = TRUE)])
data$ID <- factor(data$Plot_order)


# Plot
ggplot(data, aes(x = Plot_order, y = Heterozygosity, fill = Site)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Heterozygosity by ID",
       x = "ID",
       y = "Heterozygosity") +
  scale_fill_manual(values = c("Alazan Bayou " = "#882255", "Brazoria" = "#117733", "Brazos" = "#44AA99", 
                               "Buller" = "#ac840c", "Gordy" = "#88CCEE", "Liberty" = "#DDCC77", "Warren" = "#CC6677", "Wharton" = "#AA4499")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

###box and whisker plots

# Load necessary libraries
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(ggsignif)

# Read the CSV file
data <- read.csv("heterozygosity_prelim.csv")

# Define the colors for each site
Site_colors <- c("Alazan Bayou " = "#1E88E5", "Brazoria" = "#D81B60", "Brazos" = "#700a46", "Buller" = "#ac840c", "Gordy" = "#3bb796", "Liberty" = "#3f5a36", "Warren" = "#b30d8d", "Wharton" = "#9fc5e8")

# Filter out sites with only one or two individuals
filtered_data <- data %>%
  group_by(Site) %>%
  filter(n() > 2)

# Create the box and whisker plot
p <- ggplot(filtered_data, aes(x = Site, y = Heterozygosity, color = Site)) +
  geom_boxplot() +
  geom_jitter(data = data %>% group_by(Site) %>% filter(n() <= 2), aes(x = Site, y = Heterozygosity), width = 0.2) +
  theme_minimal() +
  ylim(0, 0.0025) +  # Set y-axis scale
  scale_color_manual(values = Site_colors)  # Apply custom colors

# Perform pairwise comparisons and add significance markers
pairwise_comparisons <- pairwise.t.test(data$Heterozygosity, data$Site, p.adjust.method = "bonferroni")

# Extract significant pairs
significant_pairs <- which(pairwise_comparisons$p.value < 0.05, arr.ind = TRUE)

# Add significance markers to the plot
for (i in 1:nrow(significant_pairs)) {
  site1 <- rownames(pairwise_comparisons$p.value)[significant_pairs[i, 1]]
  site2 <- colnames(pairwise_comparisons$p.value)[significant_pairs[i, 2]]
  p <- p + geom_signif(comparisons = list(c(site1, site2)), annotations = "*", y_position = 0.0012 + i * 0.0001, color = "red")
}

# Display the plot
print(p)







############################
# Load necessary libraries
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(ggsignif)

# Read the CSV file
data <- read.csv("heterozygosity_prelim.csv")

# Define the colors for each site
Site_colors <- c("Alazan Bayou " = "#1E88E5", "Brazoria" = "#D81B60", "Brazos" = "#700a46", "Buller" = "#ac840c", "Gordy" = "#3bb796", "Liberty" = "#3f5a36", "Warren" = "#b30d8d", "Wharton" = "#9fc5e8")

# Filter out sites with only one or two individuals
filtered_data <- data %>%
  group_by(Site) %>%
  filter(n() > 2)

# Create the box and whisker plot
p <- ggplot(filtered_data, aes(x = Site, y = Heterozygosity, color = Site)) +
  geom_boxplot() +
  geom_jitter(data = data %>% group_by(Site) %>% filter(n() <= 2), aes(x = Site, y = Heterozygosity), width = 0.2) +
  theme_minimal() +
  ylim(0, 0.005) +  # Set y-axis scale
  scale_color_manual(values = Site_colors)  # Apply custom colors

# Perform pairwise comparisons and extract significant pairs
pairwise_comparisons <- pairwise.t.test(data$Heterozygosity, data$Site, p.adjust.method = "bonferroni")

# Prepare comparisons list and annotations
comparison_pairs <- as.data.frame(which(pairwise_comparisons$p.value < 0.05, arr.ind = TRUE))
comparison_pairs$Site1 <- rownames(pairwise_comparisons$p.value)[comparison_pairs$row]
comparison_pairs$Site2 <- colnames(pairwise_comparisons$p.value)[comparison_pairs$col]
comparison_pairs$comparison <- paste(comparison_pairs$Site1, comparison_pairs$Site2, sep = "-")

# Print significant pairs for verification
print(comparison_pairs)

# Prepare the annotations for ggsignif
annotations <- comparison_pairs %>%
  mutate(
    y.position = max(filtered_data$Heterozygosity) + 0.0005 * (1:n()),  # Offset each comparison marker
    label = "*"
  )

# Convert the annotations to the format required by geom_signif
comparisons_list <- split(comparison_pairs[, c("Site1", "Site2")], seq(nrow(comparison_pairs)))
comparisons_list <- lapply(comparisons_list, function(x) as.character(unlist(x)))

# Add significance annotations to the plot
p <- p + geom_signif(
  comparisons = comparisons_list,
  annotations = annotations$label,
  y_position = annotations$y.position,
  color = "red",  # Set color for the significance markers
  tip_length = 0.03
)

# Display the plot
print(p)


###Closest
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(ggsignif)

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

# Create the box and whisker plot
p <- ggplot(filtered_data, aes(x = Site, y = Heterozygosity, color = Site)) +
  geom_boxplot() +
  geom_jitter(data = data %>% group_by(Site) %>% filter(n() <= 2), aes(x = Site, y = Heterozygosity), width = 0.2) +
  theme_minimal() +
  ylim(0, 0.0016) +  # Further increase y-axis scale to accommodate significance markers
  scale_color_manual(values = Site_colors)  # Apply custom colors

# Perform pairwise comparisons and extract significant pairs
pairwise_comparisons <- pairwise.t.test(data$Heterozygosity, data$Site, p.adjust.method = "bonferroni")

# Prepare comparisons list and annotations
comparison_pairs <- as.data.frame(which(pairwise_comparisons$p.value < 0.05, arr.ind = TRUE))
comparison_pairs$Site1 <- rownames(pairwise_comparisons$p.value)[comparison_pairs$row]
comparison_pairs$Site2 <- colnames(pairwise_comparisons$p.value)[comparison_pairs$col]
comparison_pairs$comparison <- paste(comparison_pairs$Site1, comparison_pairs$Site2, sep = "-")
comparison_pairs$p.value <- as.vector(pairwise_comparisons$p.value[comparison_pairs$row + (comparison_pairs$col - 1) * nrow(pairwise_comparisons$p.value)])  # Extract p-values

# Print significant pairs with p-values for verification
print(comparison_pairs)

# Check for presence of "Wharton" in the comparison pairs
wharton_comparisons <- comparison_pairs %>%
  filter(Site1 == "Wharton" | Site2 == "Wharton")

print(wharton_comparisons)

# Prepare the annotations for ggsignif
annotations <- comparison_pairs %>%
  mutate(
    y.position = max(filtered_data$Heterozygosity) + 0.0005 * (1:n()),  # Offset each comparison marker
    label = paste0("* (p=", round(p.value, 3), ")")  # Include p-values in labels
  )

# Print annotation details for debugging
print(annotations)

# Convert the annotations to the format required by geom_signif
comparisons_list <- split(comparison_pairs[, c("Site1", "Site2")], seq(nrow(comparison_pairs)))
comparisons_list <- lapply(comparisons_list, function(x) as.character(unlist(x)))

# Add significance annotations to the plot
p <- p + geom_signif(
  comparisons = comparisons_list,
  annotations = annotations$label,
  y_position = annotations$y.position,
  color = "red",  # Set color for the significance markers
  tip_length = 0.03
)

# Display the plot
print(p)


# Load necessary libraries
library(ggplot2)
library(dplyr)
library(ggsignif)

# Read the CSV file
data <- read.csv("heterozygosity_prelim.csv")

# Ensure the 'Site' column is treated as a factor with correct order
data$Site <- factor(data$Site, levels = c("Alazan Bayou ", "Brazoria", "Brazos", "Buller", "Gordy", "Liberty", "Warren", "Wharton"))

# Define the colors for each site
Site_colors <- c("Alazan Bayou " = "#1E88E5", "Brazoria" = "#D81B60", "Brazos" = "#700a46", "Buller" = "#ac840c", "Gordy" = "#3bb796", "Liberty" = "#3f5a36", "Warren" = "#b30d8d", "Wharton" = "#9fc5e8")

# Filter out sites with only one or two individuals
filtered_data <- data %>%
  group_by(Site) %>%
  filter(n() > 2)

# Calculate the maximum y value for plot scaling
max_y <- max(filtered_data$Heterozygosity) * 1.2  # 20% higher than the max value

# Create the box and whisker plot
p <- ggplot(filtered_data, aes(x = Site, y = Heterozygosity, color = Site)) +
  geom_boxplot() +
  geom_jitter(data = data %>% group_by(Site) %>% filter(n() <= 2), aes(x = Site, y = Heterozygosity), width = 0.2) +
  theme_minimal() +
  ylim(0, max_y) +  # Use dynamic y-axis limit
  scale_color_manual(values = Site_colors)  # Apply custom colors

# Perform pairwise comparisons and extract significant pairs
pairwise_comparisons <- pairwise.t.test(filtered_data$Heterozygosity, filtered_data$Site, p.adjust.method = "bonferroni")

# Prepare comparisons list and annotations
comparison_pairs <- as.data.frame(which(pairwise_comparisons$p.value < 0.05, arr.ind = TRUE))
comparison_pairs$Site1 <- rownames(pairwise_comparisons$p.value)[comparison_pairs$row]
comparison_pairs$Site2 <- colnames(pairwise_comparisons$p.value)[comparison_pairs$col]
comparison_pairs$comparison <- paste(comparison_pairs$Site1, comparison_pairs$Site2, sep = "-")
comparison_pairs$p.value <- as.vector(pairwise_comparisons$p.value[comparison_pairs$row + (comparison_pairs$col - 1) * nrow(pairwise_comparisons$p.value)])  # Extract p-values

# Print significant pairs with p-values for verification
print(comparison_pairs)

# Check for presence of "Wharton" in the comparison pairs
wharton_comparisons <- comparison_pairs %>%
  filter(Site1 == "Wharton" | Site2 == "Wharton")
print(wharton_comparisons)

# Prepare the annotations for ggsignif
annotations <- comparison_pairs %>%
  mutate(
    y.position = max(filtered_data$Heterozygosity) + (max_y - max(filtered_data$Heterozygosity)) * (1:n()) / (n() + 1),  # Adjusted y-position calculation
    label = paste0("* (p=", round(p.value, 3), ")")  # Include p-values in labels
  )

# Print annotation details for debugging
print(annotations)

# Convert the annotations to the format required by geom_signif
comparisons_list <- split(comparison_pairs[, c("Site1", "Site2")], seq(nrow(comparison_pairs)))
comparisons_list <- lapply(comparisons_list, function(x) as.character(unlist(x)))

# Add significance annotations to the plot
p <- p + geom_signif(
  comparisons = comparisons_list,
  annotations = annotations$label,
  y_position = annotations$y.position,
  color = "red",  # Set color for the significance markers
  tip_length = 0.03
)

# Print diagnostic information
print(paste("Number of significant comparisons:", nrow(comparison_pairs)))
print(paste("Number of annotations:", length(comparisons_list)))

# Check if any comparisons involve filtered-out sites
missing_sites <- setdiff(unique(c(comparison_pairs$Site1, comparison_pairs$Site2)), levels(filtered_data$Site))
print(paste("Sites in comparisons but not in filtered data:", paste(missing_sites, collapse=", ")))

# Display the plot
print(p)
