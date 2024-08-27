# Load required libraries
library(ape)
library(phytools)
library(readr)
library(dplyr)

setwd("/Users/natal/R/turtles")

# Read the CSV file
data <- read_csv("CT_metadata_12-23.csv")

# Read the Newick tree
tree <- read.tree("genome_tree.nwk")

# Extract the file paths and Site information
file_paths <- data$Path
Site_info <- data %>% select(Path, Site)

# Create a named vector for the Siteulations
Site_vector <- setNames(Site_info$Site, Site_info$Path)

# Replace file paths with Siteulation names in the tree's tip labels
tree$tip.label <- Site_vector[tree$tip.label]

# Manually set colors for each Siteulation using hex codes
Site_colors <- c("Alazan Bayou" = "#1E88E5", "Brazoria" = "#D81B60", "Brazos" = "#700a46", "Buller" = "#ac840c", "Gordy" = "#3bb796", "Liberty" = "#3f5a36", "Warren" = "#b30d8d", "Wharton" = "#9fc5e8")

# Assign colors to the tips based on Siteulation
tip_colors <- Site_colors[tree$tip.label]

# Plot the tree without tip labels
plot(tree, show.tip.label = FALSE)

# Add colored circles to the tips
tiplabels(pch = 21, bg = tip_colors, col = "black", cex = 1.5)

# Add legend
legend("bottomleft", legend = names(Site_colors), fill = Site_colors, title = "Site")



###new tree with "east" and "west" tip labels 
# Create a named vector for the Siteulations
Site_vector <- setNames(data$Site, data$Path)

# Replace the tip labels in the tree with the corresponding Site names
tree$tip.label <- Site_vector[tree$tip.label]

# Write the new tree to a Newick file
write.tree(tree, file="new_newicktree.nwk")


# Load required libraries
library(ape)
library(phytools)
library(readr)
library(dplyr)

setwd("/Users/natal/R/turtles")

# Read the CSV file
data <- read_csv("CT_metadata_12-23.csv")

# Read the Newick tree
tree <- read.tree("genome_tree.nwk")

# Extract the file paths and Site information
file_paths <- data$Path
Site_info <- data %>% select(Path, Site)

# Create a named vector for the Siteulations
Site_vector <- setNames(Site_info$Site, Site_info$Path)

# Replace file paths with Siteulation names in the tree's tip labels
tree$tip.label <- Site_vector[tree$tip.label]

# Mid-root the tree
tree <- midpoint.root(tree)

# Manually set colors for each Siteulation using hex codes
Site_colors <- c("Alazan Bayou" = "#1E88E5", "Brazoria" = "#D81B60", "Brazos" = "#700a46", "Buller" = "#ac840c", "Gordy" = "#3bb796", "Liberty" = "#3f5a36", "Warren" = "#b30d8d", "Wharton" = "#9fc5e8")

# Assign colors to the tips based on Siteulation
tip_colors <- Site_colors[tree$tip.label]

# Plot the tree without tip labels
plot(tree, show.tip.label = FALSE)

# Add colored circles to the tips
tiplabels(pch = 21, bg = tip_colors, col = "black", cex = 1.5)

# Add legend
legend("bottomleft", legend = names(Site_colors), fill = Site_colors, title = "Site")
legend(x = 0, y = 0.95, legend = names(Site_colors), fill = Site_colors, title = "Site")

###circular tree
# Load required libraries
library(ape)
library(phytools)
library(readr)
library(dplyr)

setwd("/Users/natal/R/turtles")

# Read the CSV file
data <- read_csv("CT_metadata_12-23.csv")

# Read the Newick tree
tree <- read.tree("genome_tree.nwk")

# Extract the file paths and Site information
file_paths <- data$Path
Site_info <- data %>% select(Path, Site)

# Create a named vector for the Site information
Site_vector <- setNames(Site_info$Site, Site_info$Path)

# Replace file paths with Site names in the tree's tip labels
tree$tip.label <- Site_vector[tree$tip.label]

# Mid-root the tree
tree <- midpoint.root(tree)

# Manually set colors for each Site using hex codes
Site_colors <- c("Alazan Bayou" = "#882255", "Brazoria" = "#117733", "Brazos" = "#44AA99", 
                 "Buller" = "#ac840c", "Gordy" = "#88CCEE", "Liberty" = "#DDCC77", "Warren" = "#CC6677", "Wharton" = "#AA4499")

# Assign colors to the tips based on Site
tip_colors <- Site_colors[tree$tip.label]

# Plot the circular tree without tip labels
plot(tree, type = "fan", show.tip.label = FALSE)

# Add colored circles to the tips
tiplabels(pch = 21, bg = tip_colors, col = "black", cex = 1.5)

# Add legend
legend("topright", legend = names(Site_colors), fill = Site_colors, title = "Site")

###mito tree
# Load required libraries
library(ape)
library(phytools)
library(readr)
library(dplyr)

setwd("/Users/natal/R/turtles")

# Read the CSV file
data <- read_csv("CT_metadata_12-23.csv")

# Read the Newick tree
tree <- read.tree("mito_tree2.nwk")

# Extract the file paths and Site information
file_paths <- data$Fnumber
Site_info <- data %>% select(Fnumber, Site)

# Create a named vector for the Site information
Site_vector <- setNames(Site_info$Site, Site_info$Fnumber)

# Replace file paths with Site names in the tree's tip labels
tree$tip.label <- Site_vector[tree$tip.label]

# Mid-root the tree
tree <- midpoint.root(tree)

# Manually set colors for each Site using hex codes
Site_colors <- c("Alazan Bayou" = "#882255", "Brazoria" = "#117733", "Brazos" = "#44AA99", 
                 "Buller" = "#ac840c", "Gordy" = "#88CCEE", "Liberty" = "#DDCC77", "Warren" = "#CC6677", "Wharton" = "#AA4499")

# Assign colors to the tips based on Site
tip_colors <- Site_colors[tree$tip.label]

# Plot the circular tree without tip labels
plot(tree, type = "fan", show.tip.label = FALSE)

# Add colored circles to the tips
tiplabels(pch = 21, bg = tip_colors, col = "black", cex = 1.5)

# Add legend
legend("bottomright", legend = names(Site_colors), fill = Site_colors, title = "Site")


# Load required libraries
library(ape)
library(phytools)
library(readr)
library(dplyr)

setwd("/Users/natal/R/turtles")

# Read the CSV file
data <- read_csv("CT_metadata_12-23.csv")

# Read the Newick tree
tree <- read.tree("mito_tree2.nwk")

# Extract the file paths and Site information
file_paths <- data$Fnumber
Site_info <- data %>% select(Fnumber, Site)

# Create a named vector for the Site information
Site_vector <- setNames(Site_info$Site, Site_info$Fnumber)

# Replace file paths with Site names in the tree's tip labels
tree$tip.label <- Site_vector[tree$tip.label]

# Mid-root the tree
tree <- midpoint.root(tree)

# Manually set colors for each Site using hex codes
Site_colors <- c("Alazan Bayou" = "#882255", "Brazoria" = "#117733", "Brazos" = "#44AA99", 
                 "Buller" = "#ac840c", "Gordy" = "#88CCEE", "Liberty" = "#DDCC77", "Warren" = "#CC6677", "Wharton" = "#AA4499")

# Assign colors to the tips based on Site
tip_colors <- Site_colors[tree$tip.label]

# Calculate the maximum branch length
max_depth <- max(node.depth.edgelength(tree))

# Function to extend branches with dotted lines
extend_branches <- function(tree, max_depth) {
  for (i in 1:length(tree$tip.label)) {
    current_depth <- sum(tree$edge.length[tree$edge[,2] == i])
    if (current_depth < max_depth) {
      extra_length <- max_depth - current_depth
      tree$edge.length <- c(tree$edge.length, extra_length)
      tree$edge <- rbind(tree$edge, c(length(tree$tip.label) + i, i))
    }
  }
  return(tree)
}

# Extend branches
extended_tree <- extend_branches(tree, max_depth)

# Plot the circular tree
plot(extended_tree, type = "fan", show.tip.label = FALSE, edge.color = "black", edge.width = 2)

# Add dotted lines for extended branches
for (i in 1:length(tree$tip.label)) {
  current_depth <- sum(tree$edge.length[tree$edge[,2] == i])
  if (current_depth < max_depth) {
    extra_length <- max_depth - current_depth
    last_node <- length(tree$tip.label) + i
    segments(
      x0 = cos(2 * pi * i / length(tree$tip.label)) * current_depth,
      y0 = sin(2 * pi * i / length(tree$tip.label)) * current_depth,
      x1 = cos(2 * pi * i / length(tree$tip.label)) * max_depth,
      y1 = sin(2 * pi * i / length(tree$tip.label)) * max_depth,
      lty = 2, col = "black"
    )
  }
}

# Add colored circles to the tips
tiplabels(pch = 21, bg = tip_colors, col = "black", cex = 1.5)

# Add legend
legend("topright", legend = names(Site_colors), fill = Site_colors, title = "Site")
