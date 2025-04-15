# Set working directory
setwd("/Users/natal/R/turtles")

library(tidyverse)

# distance matrix
dist_mat <- tribble(
  ~Site,     ~Alazan, ~Buller, ~Gordy, ~Warren, ~Wharton,
  "Alazan",    0,        NA,     NA,     NA,      NA,
  "Buller", 207.79,      0,      NA,     NA,      NA,
  "Gordy",  205.27,   126.82,    0,      NA,      NA,
  "Warren", 196.7,     10.43,  120.35,   0,       NA,
  "Wharton",256.36,   63.67,   108.9,   72,        0
)

# make long format, keeping only lower triangle (distance)
dist_long <- dist_mat |>
  pivot_longer(-Site, names_to = "Site2", values_to = "Distance_km") |>
  filter(!is.na(Distance_km)) |>
  mutate(SamplePair = paste(pmin(Site, Site2), pmax(Site, Site2), sep = "_")) |>
  select(SamplePair, Distance_km)

# FST/divergence matrix 
fst_div_mat <- tribble(
  ~Site,     ~Alazan, ~Buller, ~Gordy, ~Warren, ~Wharton,
  "Alazan",    0,     0.025,   0.018,   0.023,    0.021,
  "Buller", 0.00067,     0,     0.025,   0.024,    0.03,
  "Gordy",  0.00069,   0.00066,     0,     0.022,    0.017,
  "Warren", 0.00067,   0.00061,  0.00066,     0,      0.027,
  "Wharton",0.00063,  0.00057,  0.00062,   0.00058,      0
)

fst_div_long <- fst_div_mat |>
  pivot_longer(-Site, names_to = "Site2", values_to = "Value") |>
  filter(!is.na(Value)) |>
  mutate(SamplePair = paste(pmin(Site, Site2), pmax(Site, Site2), sep = "_")) |>
  select(SamplePair, Site, Site2, Value) |>
  mutate(
    Metric = if_else(Site < Site2, "FST", "Divergence")
  )

# join distance and FST/divergence
combined <- left_join(fst_div_long, dist_long, by = "SamplePair")

ggplot(combined |> filter(Metric == "FST"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "FST", title = "Distance vs FST")

ggplot(combined |> filter(Metric == "Divergence"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "Nucleotide Divergence", title = "Distance vs Nucleotide Divergence")


