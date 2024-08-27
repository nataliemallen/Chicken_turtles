### R code for admixture plot
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(mapmixture)

# File name
admixture_df <- read.csv("admix_K7_run1_poster.csv", header = TRUE)

# Rename the first two columns
colnames(admixture_df)[1] <- "ind"   # Rename the first column to "ind"
colnames(admixture_df)[2] <- "site"  # Rename the second column to "site"

# Generate a color palette with 7 colors
pal <- grDevices::colorRampPalette(c("green", "blue", "red", "purple", "orange", "yellow", "pink"))
cluster_cols <- pal(7) # Generate 7 colors

# Function for creating the structure plot
structure_plot <- function(admixture_df,
                           type = "structure", cluster_cols = NULL, cluster_names = NULL,
                           legend = "none",
                           labels = "site", flip_axis = FALSE,
                           ylabel = "Proportion",
                           site_dividers = TRUE, divider_width = 1, divider_col = "white", divider_type = "dashed",
                           site_order = NULL, site_labels_size = 2,
                           site_labels_x = 0, site_labels_y = -0.025,
                           site_labels_angle = 0,
                           site_ticks = TRUE, site_ticks_size = -0.01,
                           facet_col = NULL, facet_row = NULL) {
  
  # Check valid input file
  if ( !"data.frame" %in% class(admixture_df) ) {
    stop("Invalid input: admixture_df should be a data.frame or tibble in the correct format. Run ?structure_plot to check valid input format.")
  }
  
  # Number of clusters
  num_clusters <- length(colnames(admixture_df[3:ncol(admixture_df)])) # Adjusted this line
  
  # Convert data.frame from wide to long format
  df_long <- tidyr::pivot_longer(
    data = admixture_df,
    cols = 3:ncol(admixture_df),
    names_to = "cluster",
    values_to = "value"
  )
  
  # Sort data.frame by site and then by individual
  df_long <- dplyr::arrange(df_long, df_long[["site"]], df_long[["ind"]])
  
  # Convert site and individual column to factor
  df_long$site <- factor(df_long$site, levels = unique(df_long$site))
  df_long$ind <- factor(df_long$ind, levels = unique(df_long$ind))
  
  # Create a vector of default cluster names if parameter is not set
  if (is.null(cluster_names)) {
    cluster_names <- colnames(admixture_df)[3:ncol(admixture_df)]
  }
  
  # Create a plot based on the type specified
  if(type == "facet") {
    
    # Facet bar chart
    facet_plt <- ggplot2::ggplot(data = df_long)+
      ggplot2::geom_bar(
        ggplot2::aes(x = !!as.name("ind"), y = !!as.name("value"), fill = !!as.name("cluster")),
        stat = "identity",
        width = 1
      )+
      ggplot2::scale_y_continuous(expand = c(0,0))+
      ggplot2::facet_wrap(~ site, scales = "fixed", nrow = facet_row, ncol = facet_col)+  # Set scales to "fixed"
      ggplot2::scale_fill_manual(values = cluster_cols, labels = stringr::str_to_title(cluster_names))+
      ggplot2::ylab(paste0(ylabel,"\n"))+
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        strip.text = ggplot2::element_blank(),  # Remove facet headers
        panel.grid = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.position = legend,
        legend.title = ggplot2::element_blank(),
      )
    
    return(facet_plt)
  }
}

# Generate the plot
plot <- structure_plot(admixture_df, type = "facet", cluster_cols = cluster_cols)

# Print the plot to display it
print(plot)
