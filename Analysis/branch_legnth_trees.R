# Set the working directory
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library("ggplot2")
library("ggtree")
library("treeio")
library("ape")
library("tidyverse")

# Read the phylogenetic tree
turtle_tree <- read.tree("updated_mito.treefile")


# Drop the tip labeled "F1151" from the tree
turtle_tree <- drop.tip(turtle_tree, "F1151")

# Midroot the tree at its midpoint
turtle_tree <- midpoint.root(turtle_tree)

# Read metadata
labels <- read_csv("CT_metadata_12-23.csv")

# Filter out the individual with Fnumber "F1149"
labels <- labels %>% filter(Fnumber != "F1149")

# Merge tree data with labels
tree1 <- full_join(as_tibble(turtle_tree), labels, by = c('label' = 'Fnumber'))

# Convert tibble back to tree data
tree2 <- as.treedata(tree1)

# Create the phylogenetic tree plot
p1 <- ggtree(tree2) + 
  geom_treescale(x = 0, y = 60, offset = 5, width = 0.1, fontsize = 4, color = "black") +
  geom_tippoint(aes(color = Site), size = 4, alpha = 1, position = "identity") +
  geom_tiplab(align = TRUE, linesize = 0.5, linetype = "dotted") + # Add dotted line extensions
  scale_color_manual(values = c(
    "Alazan Bayou" = "#1E88E5",
    "Brazoria" = "#E69F00",
    "Brazos" = "#56B4E9",
    "Buller" = "#009E73",
    "Gordy" = "#8E44AD",
    "Liberty" = "#D55E00",
    "Warren" = "#CC79A7",
    "Wharton" = "#d13b68"
  ))

# Display the plot
p1


# Set the working directory
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library("ggplot2")
library("ggtree")
library("treeio")
library("ape")
library("tidyverse")

# Read the phylogenetic tree
turtle_tree <- read.tree("updated_mito.treefile")

# Drop the tip labeled "F1151" from the tree
turtle_tree <- drop.tip(turtle_tree, "F1151")

# Midroot the tree at its midpoint
turtle_tree <- midpoint.root(turtle_tree)

# Read metadata
labels <- read_csv("CT_metadata_12-23.csv")

# Filter out the individual with Fnumber "F1149"
labels <- labels %>% filter(Fnumber != "F1149")

# Merge tree data with labels
tree1 <- full_join(as_tibble(turtle_tree), labels, by = c('label' = 'Fnumber'))

# Convert tibble back to tree data
tree2 <- as.treedata(tree1)

# Create the phylogenetic tree plot
p1 <- ggtree(tree2) +
  geom_treescale(x = 0, y = 80, offset = 5, width = 0.1, fontsize = 4, color = "black") +
  # Add dotted lines from tips to aligned positions
  geom_segment(data = p1$data %>% filter(isTip), 
               aes(x = x, xend = max(x), y = y, yend = y),
               linetype = "dotted", color = "gray") +
  # Add colored circles at the end of the dotted lines
  geom_point(data = p1$data %>% filter(isTip),
             aes(x = max(x), y = y, color = Site), size = 3) +
  # Define color scale
  scale_color_manual(values = c(
    "Alazan Bayou" = "#1E88E5",
    "Brazoria" = "#E69F00",
    "Brazos" = "#56B4E9",
    "Buller" = "#009E73",
    "Gordy" = "#8E44AD",
    "Liberty" = "#D55E00",
    "Warren" = "#CC79A7",
    "Wharton" = "#d13b68"
  ))

# Display the plot
p1

ggsave("mito_tree.svg", plot = p1, device = "svg", dpi = 1000)
ggsave("mito_tree.tiff", plot = p1, device = "tiff", dpi = 1000)

# Set the working directory to the folder containing your R project files
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library("ggplot2")
library("ggtree")
library("treeio")
library("ape")
library("tidyverse")

# Read the phylogenetic tree
turtle_tree <- read.tree("genome_tree.nwk")

# Read the metadata (CSV file) containing sample IDs and corresponding site information
labels <- read_csv("CT_metadata_12-23.csv")

# Create a named vector where the names are the file paths and the values are the corresponding Fnumbers
path_to_fnumber <- setNames(labels$Fnumber, labels$Path)

# Replace the file paths in the tree with the corresponding Fnumbers
turtle_tree$tip.label <- path_to_fnumber[turtle_tree$tip.label]

# Drop the tip labeled "F1151" from the tree
turtle_tree <- drop.tip(turtle_tree, "F1151")

# Midroot the tree at its midpoint
turtle_tree <- midpoint.root(turtle_tree)

# Filter out the individual with Fnumber "F1149" from the labels dataframe
labels <- labels %>% filter(Fnumber != "F1149")

# Merge the updated tree data (converted to tibble) with the labels dataframe
tree1 <- full_join(as_tibble(turtle_tree), labels, by = c('label' = 'Fnumber'))

# Convert the merged tibble back into a phylogenetic tree object suitable for ggtree plotting
tree2 <- as.treedata(tree1)

# Create a normal phylogenetic tree plot with branch lengths
p2 <- ggtree(tree2) +
  geom_treescale(x = 0, y = 80, offset = 5, width = 0.1, fontsize = 4, color = "black") +  # Adjust y position
  # Add dotted lines from tips to aligned positions
  geom_segment(data = p2$data %>% filter(isTip), 
               aes(x = x, xend = max(x), y = y, yend = y),
               linetype = "dotted", color = "gray") +
  # Add colored circles at the end of the dotted lines
  geom_point(data = p2$data %>% filter(isTip),
             aes(x = max(x), y = y, color = Site), size = 3) +
  # Define color scale
  scale_color_manual(values = c(
    "Alazan Bayou" = "#1E88E5",
    "Brazoria" = "#E69F00",
    "Brazos" = "#56B4E9",
    "Buller" = "#009E73",
    "Gordy" = "#8E44AD",
    "Liberty" = "#D55E00",
    "Warren" = "#CC79A7",
    "Wharton" = "#d13b68"
  ))

# Create a normal phylogenetic tree plot with branch lengths
p2 <- ggtree(tree2) + 
  geom_treescale(x = 0, y = 80, offset = 5, width = 0.1, fontsize = 4, color = "black") +  # Adjust y position
  
  # Use fortify to extract the tree data as a data frame
  geom_segment(data = fortify(tree2) %>% filter(isTip), 
               aes(x = x, xend = max(x), y = y, yend = y), 
               linetype = "dotted", color = "gray") + 
  
  # Add colored circles at the end of the dotted lines
  geom_point(data = fortify(tree2) %>% filter(isTip), 
             aes(x = max(x), y = y, color = Site), size = 3) + 
  
  # Define color scale
  scale_color_manual(values = c(
    "Alazan Bayou" = "#1E88E5", 
    "Brazoria" = "#E69F00", 
    "Brazos" = "#56B4E9", 
    "Buller" = "#009E73", 
    "Gordy" = "#8E44AD", 
    "Liberty" = "#D55E00", 
    "Warren" = "#CC79A7", 
    "Wharton" = "#d13b68"
  ))

# Display the plot
p2

library(svglite)
ggsave("nuc_tree.svg", plot = p2, device = "svg", dpi = 1000)
ggsave("nuc_tree.tiff", plot = p2, device = "tiff", dpi = 1000)



# Display the plot
p2

