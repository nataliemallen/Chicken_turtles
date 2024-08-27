#Plot fst from fst matrix
rm(list = ls())
setwd("/Users/natal/R/turtles")

###Dendrogram
# Load necessary libraries
library(ape)

# Read the Fst matrix CSV file
fst_matrix <- read.csv("dxy_matrix.csv", row.names = 1)

# Perform hierarchical clustering
dist_matrix <- as.dist(fst_matrix)
hc <- hclust(dist_matrix, method = "average")

# Plot the dendrogram
plot(as.phylo(hc), type = "phylogram", main = "Dendrogram of Sample Sites Based on Fst Values")

###Heatmap
# Load necessary library
library(ggplot2)
library(reshape2)

# Read the Fst matrix CSV file
fst_matrix <- read.csv("dxy_matrix.csv", row.names = 1)

# Melt the data for ggplot2
melted_fst <- melt(as.matrix(fst_matrix))

# Create the heatmap
ggplot(data = melted_fst, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0.05, limit = c(0, max(melted_fst$value)), 
                       space = "Lab", name="Fst Value") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Pairwise Fst Heatmap", x = "Site", y = "Site")

###Ordered heatmap (can match dendrogram)
# Load necessary libraries
library(ggplot2)
library(reshape2)

# Read the Fst matrix CSV file
fst_matrix <- read.csv("weighted_fst_matrix_trimmed.csv", row.names = 1)

# Melt the data for ggplot2
melted_fst <- melt(as.matrix(fst_matrix))

# Define the desired order of the sites
#desired_order <- c("liberty", "brazos", "brazoria", "alazan", "gordy", "wharton", "buller", "warren")
desired_order <- c("alazan", "gordy", "wharton", "buller", "warren")

# Set the factor levels for Var1 and Var2 to the desired order
melted_fst$Var1 <- factor(melted_fst$Var1, levels = desired_order)
melted_fst$Var2 <- factor(melted_fst$Var2, levels = desired_order)

# Create the heatmap
ggplot(data = melted_fst, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0.05, limit = c(0, max(melted_fst$value)), 
                       space = "Lab", name="Fst Value") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Pairwise Fst Heatmap", x = "Site", y = "Site")
