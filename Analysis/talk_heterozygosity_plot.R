#rio = near threatened/not warranted
#olive = vulnerable/threatened
#hawksbill = critically endangered/endangered
#loggerhead = vulnerable/endangered
#green = endangered/endangered
#leatherback = vulnerable = endangered

###IUCN
#Magdalena river turtle = critically endangered = 0.000542
#Dahl's toad-headed turtle = critically endangered = 0.000703
#Western Santa Cruz giant tortoise = critically endangered = 0.000558
#Wolf volcano giant tortoise = vulnerable = 0.000647
#Eastern musk turtle = least concern = 0.002968
#Intermediate musk turtle = not listed = 0.002095
#Flattened musk turtle = critically endangered = 0.001068
#Ornate box turtle = near threatened = 0.003089

rm(list = ls())
setwd("/Users/natal/R/turtles")

# Load the necessary libraries
library(ggplot2)
library(dplyr)
library(ggtext)

# Create a data frame with the heterozygosity values and species labels
data <- data.frame(
  species = factor(c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                     "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle"),
                   levels = c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                              "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle")),
  heterozygosity = c(0.0009, 0.0003, 0.0006, 
                     0.0013, 0.00095, 0.00195, 0.0008)
)


# Create a data frame with the heterozygosity values, species labels, and conservation status
##based on IUCN only
data <- data.frame(
  species = factor(c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                     "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle", "Magdalena river turtle",
                    "Dahl's toad-headed turtle", "Western Santa Cruz giant tortoise", "Wolf volcano giant tortoise", "Eastern musk turtle",
                    "Intermediate musk turtle", "Flattened musk turtle", "Ornate box turtle"),
                   levels = c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                              "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle", "Magdalena river turtle",
                              "Dahl's toad-headed turtle", "Western Santa Cruz giant tortoise", "Wolf volcano giant tortoise", "Eastern musk turtle",
                              "Intermediate musk turtle", "Flattened musk turtle", "Ornate box turtle")),
  heterozygosity = c(0.0009, 0.0003, 0.0006, 
                     0.0013, 0.00095, 0.00195, 0.0008, 0.000542, 0.000703, 0.000558, 0.000647, 0.002968, 0.002095, 0.001068, 0.003089),
  conservation_status = factor(c("Under review (USFWS)", "Near threatened", "Vulnerable", 
                                 "Critically endangered", "Vulnerable", "Endangered", "Vulnerable", "Critically endangered", "Critically endangered",
                                 "Critically endangered", "Vulnerable", "Least concern", "Not listed", "Critically endangered", 
                                 "Near threatened"),
                               levels = c("Under review (USFWS)",
                                          "Not listed",
                                          "Least concern",
                                          "Near threatened",
                                          "Threatened", 
                                          "Vulnerable",
                                          "Endangered",
                                          "Critically endangered"))
)

# Reorder species based on heterozygosity values
data <- data %>%
  mutate(species = factor(species, levels = species[order(heterozygosity)]))

# use this plot

# Create a custom labeling function
bold_label <- function(x) {
  ifelse(x == "Western chicken turtle", 
         paste0("**", x, "**"), 
         x)
}


p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(
    axis.text.x = element_markdown(angle = 45, hjust = 1, size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    plot.margin = margin(15, 15, 15, 15),  # add space to all sides
    axis.title.x = element_text(size = 16, margin = margin(t = 10)),  # set x-axis label size and margin
    axis.title.y = element_text(size = 16, margin = margin(r = 10))   # set y-axis label size and margin
    # ... rest of your existing theme code
  ) +
  scale_x_discrete(labels = function(x) {
    ifelse(x == "Western chicken turtle", 
           paste0("**", x, "**"), 
           x)
  }) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status") +
  scale_fill_manual(values = c(
    "Least concern" = "#1e8019",
    "Under review (USFWS)" = "gray",
    "Not listed" = "#4d94ff",
    "Near threatened" = "#d5d15b",
    "Threatened" = "#ffc100", 
    "Vulnerable" = "#f1853a",
    "Endangered" = "#ff580f",
    "Critically endangered" = "#ce2138"
  ))
  # ... rest of your plot code

print(p)
ggsave(filename = "het_barplot.pdf", plot = p, dpi = 300)

library(svglite)
ggsave("het_barplot.svg", plot = p, device = "svg", dpi = 1000)

#########--------------------------------------------------------------------------------------------

# original
p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    plot.margin = margin(15, 15, 15, 15),  # add space to all sides
    axis.title.x = element_text(size = 16, margin = margin(t = 10)),  # set x-axis label size and margin
    axis.title.y = element_text(size = 16, margin = margin(r = 10))   # set y-axis label size and margin
    # ... rest of your existing theme code
  ) +
  scale_x_discrete(labels = bold_label) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status") +
  scale_fill_manual(values = c(
    "Least concern" = "#1e8019",
    "Under review (USFWS)" = "gray",
    "Not listed" = "#4d94ff",
    "Near threatened" = "#d5d15b",
    "Threatened" = "#ffc100", 
    "Vulnerable" = "#f1853a",
    "Endangered" = "#ff580f",
    "Critically endangered" = "#ce2138"
  ))
# ... rest of your plot code

# Create the bar plot with different colors for each conservation status
p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 14)) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status", size = 14) +
  scale_fill_manual(values = c("Least concern" = "#1e8019",
                               "Under review (USFWS)" = "gray",
                               "Not listed" = "lightblue",
                               "Near threatened" = "#d5d15b",
                               "Threatened" = "#ffc100", 
                               "Vulnerable" = "#f1853a",
                               "Endangered" = "#ff580f",
                               "Critically endangered" = "#ce2138"))

p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    plot.margin = margin(15, 15, 15, 15)  # add space (in points) to all sides
  ) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status", size = 20) +
  scale_fill_manual(values = c(
    "Least concern" = "#1e8019",
    "Under review (USFWS)" = "gray",
    "Not listed" = "lightblue",
    "Near threatened" = "#d5d15b",
    "Threatened" = "#ffc100", 
    "Vulnerable" = "#f1853a",
    "Endangered" = "#ff580f",
    "Critically endangered" = "#ce2138"
  ))

p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    axis.title.y = element_text(size = 16, margin = margin(r = 10)),  # Move y-axis label
    plot.margin = margin(15, 15, 15, 15)
  ) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status", size = 20) +
  scale_fill_manual(values = c(
    "Least concern" = "#1e8019",
    "Under review (USFWS)" = "gray",
    "Not listed" = "lightblue",
    "Near threatened" = "#d5d15b",
    "Threatened" = "#ffc100", 
    "Vulnerable" = "#f1853a",
    "Endangered" = "#ff580f",
    "Critically endangered" = "#ce2138"
  ))

p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    plot.margin = margin(15, 15, 15, 15),  # add space to all sides
    axis.title.x = element_text(size = 16, margin = margin(t = 10)),  # set x-axis label size and margin
    axis.title.y = element_text(size = 16, margin = margin(r = 10))   # set y-axis label size and margin
  ) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "IUCN Conservation Status") +
  scale_fill_manual(values = c(
    "Least concern" = "#1e8019",
    "Under review (USFWS)" = "gray",
    "Not listed" = "lightblue",
    "Near threatened" = "#d5d15b",
    "Threatened" = "#ffc100", 
    "Vulnerable" = "#f1853a",
    "Endangered" = "#ff580f",
    "Critically endangered" = "#ce2138"
  ))


print(p)
ggsave(filename = "het_barplot.png", plot = p, dpi = 300)

##based on IUCN or USFWS
#data <- data.frame(
#  species = factor(c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
#                     "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle", "Magdalena river turtle",
#                     "Dahl's toad-headed turtle", "Western Santa Cruz giant tortoise", "Wolf volcano giant tortoise", "Eastern musk turtle",
#                     "Intermediate musk turtle", "Flattened musk turtle", "Ornate box turtle"),
#                   levels = c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
#                              "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle", "Magdalena river turtle",
#                              "Dahl's toad-headed turtle", "Western Santa Cruz giant tortoise", "Wolf volcano giant tortoise", "Eastern musk turtle",
#                              "Intermediate musk turtle", "Flattened musk turtle", "Ornate box turtle")),
#  heterozygosity = c(0.0009, 0.0003, 0.0006, 
#                     0.0013, 0.00095, 0.00195, 0.0008, 0.000542, 0.000703, 0.000558, 0.000647, 0.002968, 0.002095, 0.001068, 0.003089),
#  conservation_status = factor(c("Under review (USFWS)", "Not listed", "Threatened (USFWS)", 
#                                 "Endangered (USFWS)", "Endangered (USFWS)", "Endangered (USFWS)", "Endangered (USFWS)", "Critically endangered (IUCN)", "Critically endangered (IUCN)",
#                                 "Critically endangered (IUCN)", "Vulnerable (IUCN)", "Least concern (IUCN)", "Not listed", "Critically endangered (IUCN)", 
#                                 "Near threatened (IUCN)"),
#                               levels = c("Under review (USFWS)",
#                                          "Not listed",
#                                          "Least concern (IUCN)",
#                                          "Near threatened (IUCN)",
#                                          "Threatened (USFWS)", 
#                                          "Vulnerable (IUCN)",
#                                          "Endangered (USFWS)",
#                                          "Critically endangered (IUCN)"))
#)

#levels = c("Least concern (IUCN)",
#                             "Under review (USFWS)",
#                             "Not listed",
#                             "Near threatened (IUCN)",
#                             "Threatened (USFWS)", 
#                             "Vulnerable (IUCN)",
#                             "Endangered (USFWS)",
#                             "Critically endangered (IUCN)"))

# Create the bar plot with different colors for each conservation status
p <- ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "USFWS Conservation Status") +
  scale_fill_manual(values = c("Least concern (IUCN)" = "#1e8019",
                              "Under review (USFWS)" = "gray",
                               "Not listed" = "lightblue",
                               "Near threatened (IUCN)" = "#d5d15b",
                               "Threatened (USFWS)" = "#ffc100", 
                               "Vulnerable (IUCN)" = "#f1853a",
                               "Endangered (USFWS)" = "#ff580f",
                               "Critically endangered (IUCN)" = "#ce2138"))


print(p)


# Reorder species based on heterozygosity values
data <- data %>%
  mutate(species = factor(species, levels = species[order(heterozygosity)]))

# Create the bar plot with different colors for each conservation status
ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12)) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "Conservation Status") +
  scale_fill_manual(values = c("Least concern (IUCN)" = "#1e8019",
                               "Under review (USFWS)" = "gray",
                               "Not listed" = "lightblue",
                               "Near threatened (IUCN)" = "#d5d15b",
                               "Threatened (USFWS)" = "#ffc100", 
                               "Vulnerable (IUCN)" = "#f1853a",
                               "Endangered (USFWS)" = "#ff580f",
                               "Critically endangered (IUCN)" = "#ce2138"))

