# working directory
setwd("/Users/natal/R/turtles")

library(tidyverse)

# distance matrix
dist_mat <- tribble(
  ~Site,     ~Alazan, ~Buller, ~Gordy, ~Warren, ~Wharton,
  "Alazan",    NA,        NA,     NA,     NA,      NA,
  "Buller", 207.79,      NA,      NA,     NA,      NA,
  "Gordy",  205.27,   126.82,    NA,      NA,      NA,
  "Warren", 196.7,     10.43,  120.35,   NA,       NA,
  "Wharton",256.36,   63.67,   108.9,   72,        NA
)

dist_long <- dist_mat |>
  pivot_longer(-Site, names_to = "Site2", values_to = "Distance_km") |>
  filter(!is.na(Distance_km)) |>
  mutate(SamplePair = paste(pmin(Site, Site2), pmax(Site, Site2), sep = "_")) |>
  select(SamplePair, Distance_km)

# FST/divergence matrix 

fst_div_mat <- tribble(
  ~Site,     ~Alazan, ~Buller, ~Gordy, ~Warren, ~Wharton,
  "Alazan",    NA,     0.025,   0.018,   0.023,    0.021,
  "Buller", 0.00067,     NA,     0.025,   0.024,    0.03,
  "Gordy",  0.00069,   0.00066,     NA,     0.022,    0.017,
  "Warren", 0.00067,   0.00061,  0.00066,     NA,      0.027,
  "Wharton",0.00063,  0.00057,  0.00062,   0.00058,      NA
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

str(combined)

# plot
ggplot(combined |> filter(Metric == "FST"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "FST", title = "Distance vs FST")

ggplot(combined |> filter(Metric == "Divergence"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "Nucleotide Divergence", title = "Distance vs Nucleotide Divergence")

library(patchwork)  # for side-by-side plots

# fst
fst_plot <- ggplot(combined |> filter(Metric == "FST"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "FST", title = "Distance vs FST") +
  theme_classic()

# dxy
dxy_plot <- ggplot(combined |> filter(Metric == "Divergence"), aes(x = Distance_km, y = Value)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Distance (km)", y = "Nucleotide Divergence", title = "Distance vs Nucleotide Divergence") +
  theme_classic()

# side by side
fst_plot + dxy_plot




### mantel test with fst
library("vegan")

## get fst and dxy in correct format
sites <- unique(c(fst_div_long$Site, fst_div_long$Site2))

fst_mat <- matrix(NA, nrow = length(sites), ncol = length(sites),
                  dimnames = list(sites, sites))

for (i in 1:nrow(fst_div_long)) {
  s1 <- fst_div_long$Site[i]
  s2 <- fst_div_long$Site2[i]
  val <- fst_div_long$Value[i]
  if (fst_div_long$Metric[i] == "FST") {
    fst_mat[s1, s2] <- val
    fst_mat[s2, s1] <- val  # Symmetrize
  }
}

fst_dist <- as.dist(fst_mat)

# get distances in right format
geo_sites <- unique(c(dist_long$SamplePair |> str_split("_", simplify = TRUE)) |> as.vector())

geo_mat <- matrix(NA, nrow = length(geo_sites), ncol = length(geo_sites),
                  dimnames = list(geo_sites, geo_sites))

for (i in 1:nrow(dist_long)) {
  pair <- str_split(dist_long$SamplePair[i], "_", simplify = TRUE)
  s1 <- pair[1]
  s2 <- pair[2]
  d <- dist_long$Distance_km[i]
  geo_mat[s1, s2] <- d
  geo_mat[s2, s1] <- d  # Symmetrize
}

geo_dist <- as.dist(geo_mat)

mantel_result <- mantel(fst_dist, geo_dist, method = "pearson", permutations = 9999)
print(mantel_result)

### mantel test with dxy

dxy_mat <- matrix(NA, nrow = length(sites), ncol = length(sites),
                  dimnames = list(sites, sites))

for (i in 1:nrow(fst_div_long)) {
  s1 <- fst_div_long$Site[i]
  s2 <- fst_div_long$Site2[i]
  val <- fst_div_long$Value[i]
  if (fst_div_long$Metric[i] == "Divergence") {
    dxy_mat[s1, s2] <- val
    dxy_mat[s2, s1] <- val  # Symmetrize
  }
}

dxy_dist <- as.dist(dxy_mat)

mantel_result_dxy <- mantel(dxy_dist, geo_dist, method = "pearson", permutations = 9999)
print(mantel_result_dxy)


