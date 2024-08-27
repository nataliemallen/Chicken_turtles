# Load the necessary libraries
library(ggplot2)
library(dplyr)

# Create a data frame with the heterozygosity values and species labels
data <- data.frame(
  species = factor(c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                     "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle"),
                   levels = c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                              "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle")),
  heterozygosity = c(0.0009, 0.0003, 0.0006, 
                     0.0013, 0.00095, 0.00195, 0.0008)
)

# Create the bar plot with different colors for each species
ggplot(data, aes(x = species, y = heterozygosity, fill = species)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Species", y = "Heterozygosity") +
  scale_fill_manual(values = c("Western chicken turtle" = "skyblue", 
                               "Rio Grande cooter" = "#316d16", 
                               "Olive Ridley sea turtle" = "#cc79a7", 
                               "Hawksbill sea turtle" = "#d55e00", 
                               "Loggerhead sea turtle" = "#f0e442", 
                               "Green sea turtle" = "#9882cf", 
                               "Leatherback sea turtle" = "turquoise"))


#rio = near threatened/not warranted
#olive = vulnerable/threatened
#hawksbill = critically endangered/endangered
#loggerhead = vulnerable/endangered
#green = endangered/endangered
#leatherback = vulnerable = endangered

# Load the necessary libraries
library(ggplot2)
library(dplyr)

# Create a data frame with the heterozygosity values, species labels, and conservation status
data <- data.frame(
  species = factor(c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                     "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle"),
                   levels = c("Western chicken turtle", "Rio Grande cooter", "Olive Ridley sea turtle", 
                              "Hawksbill sea turtle", "Loggerhead sea turtle", "Green sea turtle", "Leatherback sea turtle")),
  heterozygosity = c(0.0009, 0.0003, 0.0006, 
                     0.0013, 0.00095, 0.00195, 0.0008),
  conservation_status = factor(c("Under review", "Not listed", "Threatened", 
                                 "Endangered", "Endangered", "Endangered", "Endangered"),
                               levels = c("Under review", "Not listed", "Threatened", "Endangered"))
)

# Create the bar plot with different colors for each conservation status
ggplot(data, aes(x = species, y = heterozygosity, fill = conservation_status)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Species", y = "Genome-wide Heterozygosity", fill = "USFWS Conservation Status") +
  scale_fill_manual(values = c("Under review" = "gray",
                               "Not listed" = "lightblue",
                               "Threatened" = "#ffc100", 
                               "Endangered" = "#ff580f"))



