###mitochondrial tree (mid rooted)
# Set the working directory to the folder containing your R project files
setwd("/Users/natal/R/turtles")

# Load necessary libraries for plotting, tree manipulation, and data wrangling
library("ggplot2")     # For creating plots
library("ggtree")      # For visualizing phylogenetic trees
library("treeio")      # For handling phylogenetic tree data
library("reshape2")    # For reshaping data frames
library("ggstance")    # For horizontal dodging of ggplot elements
library("tidyverse")   # For data manipulation and visualization
library("ape")         # For phylogenetic analysis functions

# Read the phylogenetic tree from a Newick format file
turtle_tree <- read.tree("muscle_alignment_chickenturtle.fasta.treefile")

# Drop the tip labeled "F1151" from the tree
turtle_tree <- drop.tip(turtle_tree, "F1151")

# Midroot the tree at its midpoint
turtle_tree <- midpoint.root(turtle_tree)

# Read the metadata (CSV file) containing sample IDs and corresponding site information
labels <- read_csv("CT_metadata_12-23.csv")

# Filter out the individual with Fnumber "F1149" from the labels dataframe
labels <- labels %>% filter(Fnumber != "F1149")

# Merge the updated tree data (converted to tibble) with the labels dataframe using 'label' in the tree
# and 'Fnumber' in the labels as the key columns
tree1 <- full_join(as_tibble(turtle_tree), labels, by = c('label' = 'Fnumber'))

# Convert the merged tibble back into a phylogenetic tree object suitable for ggtree plotting
tree2 <- as.treedata(tree1)

# Create a circular phylogenetic tree plot using the tree2 object
#p1 <- ggtree(tree2, layout = "circular", branch.length = "none") +
  # Add a scale bar to the tree at the specified coordinates
#  geom_treescale(x=0, y=60, offset.label = 50) +
  # Add colored tip points to the tree, colored by the 'Site' variable
#  geom_tippoint(aes(color = Site), size = 4, alpha = 1, position = "identity") +
  # Manually define the colors associated with each site name
#  scale_color_manual(values = c("Alazan Bayou" = "#1E88E5",  # Deep blue
#                                "Brazoria" = "#E69F00",      # Orange
#                                "Brazos" = "#56B4E9",       # Light blue
#                                "Buller" = "#009E73",       # Green
#                                "Gordy" = "#8E44AD",        # Purple
#                                "Liberty" = "#D55E00",      # Vermilion
#                                "Warren" = "#CC79A7",       # Reddish purple
#                                "Wharton" = "#d13b68"))

p1 <- ggtree(tree2, layout = "circular", branch.length = "none") +
  # Add a scale bar to the tree at the specified coordinates
  geom_treescale(x=0, y=60, offset.label = 50) +
  # Add colored tip points to the tree, colored by the 'Site' variable
  geom_tippoint(aes(color = River), size = 4, alpha = 1, position = "identity") +
  # Manually define the colors associated with each site name
  scale_color_manual(values = c("Neches" = "#1E88E5",  # Deep blue
                                "Brazos" = "#56B4E9",       # Light blue
                                "San Jacinto" = "#009E73",       # Green
                                "Trinity" = "#8E44AD",        # Purple
                                "Colorado" = "#d13b68") )

# Display the final tree plot
p1

#####nuclear tree (mid-rooted)
# Set the working directory to the folder containing your R project files
setwd("/Users/natal/R/turtles")

# Load necessary libraries for plotting, tree manipulation, and data wrangling
library("ggplot2")     # For creating plots
library("ggtree")      # For visualizing phylogenetic trees
library("treeio")      # For handling phylogenetic tree data
library("reshape2")    # For reshaping data frames
library("ggstance")    # For horizontal dodging of ggplot elements
library("tidyverse")   # For data manipulation and visualization
library("ape")         # For phylogenetic analysis functions

# Read the phylogenetic tree from a Newick format file
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

# Merge the updated tree data (converted to tibble) with the labels dataframe using 'label' in the tree
# and 'Fnumber' in the labels as the key columns
tree1 <- full_join(as_tibble(turtle_tree), labels, by = c('label' = 'Fnumber'))

# Convert the merged tibble back into a phylogenetic tree object suitable for ggtree plotting
tree2 <- as.treedata(tree1)

# Create a circular phylogenetic tree plot using the tree2 object
#p1 <- ggtree(tree2, layout = "circular", branch.length = "none") +
#  # Add a scale bar to the tree at the specified coordinates
#  geom_treescale(x=0, y=60, offset.label = 50) +
#  # Add colored tip points to the tree, colored by the 'Site' variable
#  geom_tippoint(aes(color = Site), size = 4, alpha = 1, position = "identity") +
#  # Manually define the colors associated with each site name
#  scale_color_manual(values = c("Alazan Bayou" = "#1E88E5",  # Deep blue
                                "Brazoria" = "#E69F00",      # Orange
                                "Brazos" = "#56B4E9",       # Light blue
                                "Buller" = "#009E73",       # Green
                                "Gordy" = "#8E44AD",        # Purple
                                "Liberty" = "#D55E00",      # Vermilion
                                "Warren" = "#CC79A7",       # Reddish purple
                                "Wharton" = "#d13b68"))

p1 <- ggtree(tree2, layout = "circular", branch.length = "none") +
  # Add a scale bar to the tree at the specified coordinates
  geom_treescale(x=0, y=60, offset.label = 50) +
  # Add colored tip points to the tree, colored by the 'Site' variable
  geom_tippoint(aes(color = River), size = 4, alpha = 1, position = "identity") +
  # Manually define the colors associated with each site name
  scale_color_manual(values = c("Neches" = "#1E88E5",  # Deep blue
                                "Brazos" = "#56B4E9",       # Light blue
                                "San Jacinto" = "#009E73",       # Green
                                "Trinity" = "#8E44AD",        # Purple
                                "Colorado" = "#d13b68") )

# Display the final tree plot
p1
