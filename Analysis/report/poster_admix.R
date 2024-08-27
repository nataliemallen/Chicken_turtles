### R code for admixture plot
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# File names and corresponding K values
files <- c("admix_K2_run1.csv", "admix_K3_run1.csv", "admix_K4_run1.csv", "admix_K5_run1.csv", "admix_K6_run1.csv", "admix_K7_run1.csv", "admix_K8_run1.csv", "admix_K9_run1.csv", "admix_K10_run1.csv")
k_values <- c(2, 3, 4, 5, 6, 7, 8, 9, 10)

# Function to load and process data
load_and_process_data <- function(file, k) {
  # Load .csv dataframe
  qopt_data <- read.csv(file, header = TRUE)
  
  # Sort the dataframe based on the "Plot_order" column
  qopt_data <- qopt_data[order(qopt_data$Plot_order), ]
  
  # Convert cluster columns to numeric
  for (i in 1:k) {
    qopt_data[[paste0("Cluster", i)]] <- as.numeric(qopt_data[[paste0("Cluster", i)]])
  }
  
  # Reshape the data to long format
  plot_data <- qopt_data %>%
    pivot_longer(cols = starts_with("Cluster"), names_to = "Cluster", values_to = "Proportion") %>%
    arrange(Plot_order)  # Arrange the data by the "Plot_order" column
  
  # Add the K value to the dataframe
  plot_data$K <- k
  
  return(plot_data)
}

# Load and process data for all K values
plot_data_list <- lapply(seq_along(files), function(i) load_and_process_data(files[i], k_values[i]))
plot_data <- bind_rows(plot_data_list)

# Define custom colors for the clusters
cluster_colors <- c("#0072b2","#cc79a7","#009e73","#d55e00","#f0e442", "#700a46", "#cb3434", "#9fc5e8", "#006400", "#835543")

# Create the bar plot
admixture_plot <- ggplot(plot_data, aes(x = factor(Plot_order), y = Proportion, fill = Cluster)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_grid(rows = vars(K), scales = "free_x") +
  labs(x = "Individual", y = "Admixture Proportion") +
  theme(axis.text.x = element_blank(),  # Remove x-axis text
        axis.ticks.x = element_blank()) +
  scale_fill_manual(values = cluster_colors) +
  ggtitle("Admixture Plots for K=2, 3, 4, and 5")

# Display the plot
print(admixture_plot)

# Save the final plot if needed
ggsave("admixture_plots.png", admixture_plot, width = 10, height = 20)



###K=7 for report
### R code for admixture plot
setwd("/Users/natal/R/turtles")

# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# File names and corresponding K values
files <- c("admix_K7_run1_poster.csv")
k_values <- c(7)

# Function to load and process data
load_and_process_data <- function(file, k) {
  # Load .csv dataframe
  qopt_data <- read.csv(file, header = TRUE)
  
  # Sort the dataframe based on the "Plot_order" column
  qopt_data <- qopt_data[order(qopt_data$Plot_order), ]
  
  # Convert cluster columns to numeric
  for (i in 1:k) {
    qopt_data[[paste0("Cluster", i)]] <- as.numeric(qopt_data[[paste0("Cluster", i)]])
  }
  
  # Reshape the data to long format
  plot_data <- qopt_data %>%
    pivot_longer(cols = starts_with("Cluster"), names_to = "Cluster", values_to = "Proportion") %>%
    arrange(Plot_order)  # Arrange the data by the "Plot_order" column
  
  # Add the K value to the dataframe
  plot_data$K <- k
  
  return(plot_data)
}

# Load and process data for all K values
plot_data_list <- lapply(seq_along(files), function(i) load_and_process_data(files[i], k_values[i]))
plot_data <- bind_rows(plot_data_list)

# Define custom colors for the clusters
cluster_colors <- c("#0072b2","#cc79a7","#009e73","#d55e00","#f0e442", "#700a46", "#cb3434", "#9fc5e8", "#006400", "#835543")

# Create the bar plot
admixture_plot <- ggplot(plot_data, aes(x = factor(Plot_order), y = Proportion, fill = Cluster)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_grid(rows = vars(K), scales = "free_x") +
  labs(x = "Individual", y = "Admixture Proportion") +
  theme(axis.text.x = element_blank(),  # Remove x-axis text
        axis.ticks.x = element_blank()) +
  scale_fill_manual(values = cluster_colors) +
  ggtitle("Admixture Plots for K=2, 3, 4, and 5")

# Display the plot
print(admixture_plot)

# Save the final plot if needed
ggsave("admixture_plots.png", admixture_plot, width = 10, height = 20)

###
### R code for admixture plot
# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# File names and corresponding K values
files <- c("admix_K7_run1_poster.csv")
k_values <- c(7)

# Function to load and process data
load_and_process_data <- function(file, k) {
  # Load .csv dataframe
  qopt_data <- read.csv(file, header = TRUE)
  
  # Sort the dataframe based on the "Plot_order" column
  qopt_data <- qopt_data[order(qopt_data$Plot_order), ]
  
  # Convert cluster columns to numeric
  for (i in 1:k) {
    qopt_data[[paste0("Cluster", i)]] <- as.numeric(qopt_data[[paste0("Cluster", i)]])
  }
  
  # Reshape the data to long format
  plot_data <- qopt_data %>%
    pivot_longer(cols = starts_with("Cluster"), names_to = "Cluster", values_to = "Proportion") %>%
    arrange(Plot_order)  # Arrange the data by the "Plot_order" column
  
  # Add the K value to the dataframe
  plot_data$K <- k
  
  return(plot_data)
}

# Load and process data for all K values
plot_data_list <- lapply(seq_along(files), function(i) load_and_process_data(files[i], k_values[i]))
plot_data <- bind_rows(plot_data_list)

# Define custom colors for the clusters
cluster_colors <- c("#0072b2","#cc79a7","#009e73","#d55e00","#f0e442", "#700a46", "#cb3434", "#9fc5e8", "#006400", "#835543")

# Create a factor for sample sites with the desired order
plot_data$Site <- factor(plot_data$Site, 
                                levels = c("Alazan Bayou", "Brazoria", "Brazos", "Buller", 
                                           "Gordy", "Liberty", "Warren", "Wharton"))

# Create the bar plot with facets and diagonal labels
admixture_plot <- ggplot(plot_data, aes(x = factor(Plot_order), y = Proportion, fill = Cluster)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ Site, scales = "free_x", ncol = 1) +  # Facet by Site
  labs(x = "Individual", y = "Admixture Proportion") +
  theme(axis.text.x = element_blank(),  # Remove x-axis text
        axis.ticks.x = element_blank(),
        strip.text.x = element_text(angle = 45, hjust = 1)) +  # Diagonal labels
  scale_fill_manual(values = cluster_colors) +
  ggtitle("Admixture Plots for K=7")

# Display the plot
print(admixture_plot)
