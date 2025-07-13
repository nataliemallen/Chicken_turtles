etwd("/Users/natal/R/turtles")

library(geosphere)  # for distance calculation
library(tidyverse)  # for data manipulation

# read file
df <- read.csv("heterozygosity_prelim.csv")

# fix lat long spaces
df$GPS <- gsub("\u00A0", " ", df$GPS.coordinates..Decimal.Degrees.)

df <- df %>%
  mutate(
    Latitude = as.numeric(str_extract(GPS, "^[0-9\\.]+")),
    Longitude = as.numeric(str_extract(GPS, "-[0-9\\.]+"))
  )

head(df[, c("Latitude", "Longitude")])

# define approximate range center
range_center <- c(lon = -94.029481, lat = 31.998916)


# compute distance from each sample to the range center
df$Distance_km <- distHaversine(
  p1 = df[, c("Longitude", "Latitude")],
  p2 = matrix(range_center, nrow = nrow(df), ncol = 2, byrow = TRUE)
) / 1000  # convert meters to km

# model heterozygosity as a function of distance from range center
model <- lm(Heterozygosity ~ Distance_km, data = df)
summary(model)

# model results
r2 <- summary(model)$r.squared
pval <- summary(model)$coefficients[2, 4]

# plot
ggplot(df, aes(x = Distance_km, y = Heterozygosity)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  annotate("text", 
           x = max(df$Distance_km) * 0.6, 
           y = max(df$Heterozygosity), 
           label = paste0("R² = ", round(r2, 3), 
                          "\np = ", signif(pval, 3)), 
           size = 5, hjust = -2) +
  labs(title = "Heterozygosity vs. Distance from Range Center",
       x = "Distance from Center (km)",
       y = "Heterozygosity") +
  theme_minimal()

ggplot(df, aes(x = Distance_km, y = Heterozygosity)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(x = "Distance from Range Center (km)",
       y = "Heterozygosity",
       title = "Heterozygosity vs. Distance from Range Center") +
  theme_minimal()
