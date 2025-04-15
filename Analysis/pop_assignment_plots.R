# Set working directory
setwd("/Users/natal/R/turtles")

# Load required libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# Load data from CSV
df <- read.csv("pop_assignment.csv") 
df

# Convert to factors for ordered plotting
df <- df %>%
  mutate(`True Sample` = factor(`TRUE.`),
         `Assigned Site` = factor(`Assigned`))

# 1. Confusion Matrix Heatmap
conf_matrix <- df %>%
  count(`True Sample`, `Assigned Site`) %>%
  group_by(`True Sample`) %>%
  mutate(Prop = n / sum(n)) # Get proportions

heatmap_plot <- ggplot(conf_matrix, aes(x = `Assigned Site`, y = `True Sample`, fill = Prop)) +
  geom_tile(color = "white") +
  geom_text(aes(label = n), color = "black") + # Add counts
  scale_fill_gradient(low = "white", high = "blue") +
  labs(x = "Assigned Population", y = "True Population", fill = "Proportion") +
  theme_minimal()

# 2. accuracy plot
accuracy_plot <- df %>%
  mutate(Correct = as.character(`True Sample`) == as.character(`Assigned Site`)) %>%
  group_by(`True Sample`) %>%
  summarise(Correct_Assignments = sum(Correct), Total = n()) %>%
  mutate(Accuracy = Correct_Assignments / Total) %>%
  ggplot(aes(x = `True Sample`, y = Accuracy, fill = `True Sample`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = percent(Accuracy, accuracy = 1)), vjust = -0.5) +
  scale_y_continuous(labels = percent) +
  labs(x = "True Population", y = "Assignment Accuracy", fill = "Population") +
  theme_minimal()


# 3. Stacked Bar Chart of Assignments
stacked_bar_plot <- df %>%
  count(`True Sample`, `Assigned Site`) %>%
  ggplot(aes(x = `True Sample`, y = n, fill = `Assigned Site`)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = percent) +
  labs(x = "True Population", y = "Proportion Assigned", fill = "Assigned Population") +
  theme_minimal()

# Print plots to console
print(heatmap_plot)
print(accuracy_plot)
print(stacked_bar_plot)

# Save or display plots
ggsave("confusion_matrix_heatmap.png", heatmap_plot, width = 6, height = 4, dpi = 300)
ggsave("assignment_accuracy_bar.png", accuracy_plot, width = 6, height = 4, dpi = 300)
ggsave("stacked_bar_assignments.png", stacked_bar_plot, width = 6, height = 4, dpi = 300)


# Define a color palette for populations
populations <- levels(df$`True Sample`)
pop_colors <- setNames(RColorBrewer::brewer.pal(length(populations), "Set3"), populations)

# 1. Confusion Matrix Heatmap
conf_matrix <- df %>%
  count(`True Sample`, `Assigned Site`) %>%
  group_by(`True Sample`) %>%
  mutate(Prop = n / sum(n)) # Get proportions

heatmap_plot <- ggplot(conf_matrix, aes(x = `Assigned Site`, y = `True Sample`, fill = Prop)) +
  geom_tile(color = "white") +
  geom_text(aes(label = n), color = "black") + # Add counts
  scale_fill_gradient(low = "white", high = "blue") +
  labs(x = "Assigned Population", y = "True Population", fill = "Proportion") +
  theme_minimal()

# 2. Bar Plot of Assignment Accuracy (Using Fixed Colors)
accuracy_plot <- df %>%
  mutate(Correct = as.character(`True Sample`) == as.character(`Assigned Site`)) %>%
  group_by(`True Sample`) %>%
  summarise(Correct_Assignments = sum(Correct), Total = n()) %>%
  mutate(Accuracy = Correct_Assignments / Total) %>%
  ggplot(aes(x = `True Sample`, y = Accuracy, fill = `True Sample`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = percent(Accuracy, accuracy = 1)), vjust = -0.5) +
  scale_y_continuous(labels = percent) +
  scale_fill_manual(values = pop_colors) +  # Consistent colors
  labs(x = "True Population", y = "Assignment Accuracy", fill = "Population") +
  theme_minimal()

# 3. Stacked Bar Chart of Assignments (Using Fixed Colors)
stacked_bar_plot <- df %>%
  count(`True Sample`, `Assigned Site`) %>%
  ggplot(aes(x = `True Sample`, y = n, fill = `Assigned Site`)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = percent) +
  scale_fill_manual(values = pop_colors) +  # Consistent colors
  labs(x = "True Population", y = "Proportion Assigned", fill = "Assigned Population") +
  theme_minimal()

# Print plots to console
print(heatmap_plot)
print(accuracy_plot)
print(stacked_bar_plot)

# Save or display plots
ggsave("confusion_matrix_heatmap.png", heatmap_plot, width = 6, height = 4, dpi = 300)
ggsave("assignment_accuracy_bar.png", accuracy_plot, width = 6, height = 4, dpi = 300)
ggsave("stacked_bar_assignments.png", stacked_bar_plot, width = 6, height = 4, dpi = 300)



