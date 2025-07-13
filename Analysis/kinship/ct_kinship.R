#Clear RStudio’s memory
rm(list = ls())
library(ggplot2)
setwd("/Users/natal/R")
kin<-read.csv("ct_nobo_relate.csv",header = T)
#check number of sites compared and remove bad sites. In here sites less than 9950000 are removed
hist(kin$nSites)

#kin <- kin[-which(kin$nSites < 16800000),]
dev.off()
# population assignment

pop<-read.csv("/Users/natal/R/ct_nobo_pop.csv", header = T)

head(pop)
#colnames(pop)[1]<-"ind"

#change the a and b values of kin data set to population labels
library(DataCombine)
r1 <- data.frame(from = pop$ind,
                 to=pop$pop)
r2 <- data.frame(from = pop$ind,
                 to=pop$sample_ID)
colnames(kin)[1]<-"a"

kin_new <- kin
kin_new$ind_a <- kin_new$a #new
kin_new$ind_b <- kin_new$b #new

#replace with pop data
kin_new$a<-as.character(kin_new$a)
kin_new <- FindReplace(data = kin_new, Var = "a", replaceData = r1,
                       from = "from", to = "to", exact = T)
kin_new$b<-as.character(kin_new$b)
kin_new <- FindReplace(data = kin_new, Var = "b", replaceData = r1,
                       from = "from", to = "to", exact = T)

#change to individual names 
#View(kin_new)

#change the ind_a and ind_b values of kin data set to sample IDs
kin_new$ind_a<-as.character(kin_new$ind_a)
kin_new <- FindReplace(data = kin_new, Var = "ind_a", replaceData = r2,
                       from = "from", to = "to", exact = T)
kin_new$ind_b<-as.character(kin_new$ind_b)
kin_new <- FindReplace(data = kin_new, Var = "ind_b", replaceData = r2,
                       from = "from", to = "to", exact = T)

# Export kin_new
write.csv(kin_new, "ct_kin_new.csv", row.names = FALSE)

all_individuals <- kin_new
Buller <- kin_new[which(kin_new$a =="Buller"  & kin_new$b =="Buller" ),]
Warren <- kin_new[which(kin_new$a =="Warren"  & kin_new$b =="Warren" ),]
Alazan <- kin_new[which(kin_new$a =="Alazan "  & kin_new$b =="Alazan " ),]
Brazoria <- kin_new[which(kin_new$a =="Brazoria"  & kin_new$b =="Brazoria" ),]
Gordy <- kin_new[which(kin_new$a =="Gordy"  & kin_new$b =="Gordy" ),]
Wharton <- kin_new[which(kin_new$a =="Wharton"  & kin_new$b =="Wharton" ),]

# filter for unrelated ----------------------------------------------------

bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# define unrelated individuals based on bounds (R1 and KING)
unrelated_pairs <- kin_new[
  kin_new$R1 >= bounds[4,1] & kin_new$R1 <= bounds[4,2] &
    kin_new$KING >= bounds[4,3] & kin_new$KING <= bounds[4,4], ]

# related = anything NOT classified as unrelated
related_pairs <- kin_new[!(
  kin_new$R1 >= bounds[4,1] & kin_new$R1 <= bounds[4,2] &
    kin_new$KING >= bounds[4,3] & kin_new$KING <= bounds[4,4]
), ]

# all individuals that appear in any related pair
related_individuals <- unique(c(related_pairs$ind_a, related_pairs$ind_b))

# all individuals
all_individuals <- unique(c(kin_new$ind_a, kin_new$ind_b))

# individuals not involved in any related pair
unrelated_individuals <- setdiff(all_individuals, related_individuals)

# join pop info to unrelated individuals
unrelated_df <- data.frame(sample_ID = unrelated_individuals)
unrelated_with_pop <- merge(unrelated_df, pop[, c("sample_ID", "pop")], by = "sample_ID")

# export
write.csv(unrelated_with_pop, "unrelated_individuals_with_pop.csv", row.names = FALSE)


# distantly related -------------------------------------------------------

# keep unrelated (row 4) OR first cousins (row 3)
keep_pairs <- kin_new[
  (
    kin_new$R1 >= bounds[3,1] & kin_new$R1 <= bounds[3,2] &
      kin_new$KING >= bounds[3,3] & kin_new$KING <= bounds[3,4]
  ) |
    (
      kin_new$R1 >= bounds[4,1] & kin_new$R1 <= bounds[4,2] &
        kin_new$KING >= bounds[4,3] & kin_new$KING <= bounds[4,4]
    ),
]

# define related pairs = anything closer than first cousins (rows 1 and 2)
related_pairs <- kin_new[
  (
    kin_new$R1 >= bounds[1,1] & kin_new$R1 <= bounds[1,2] &
      kin_new$KING >= bounds[1,3] & kin_new$KING <= bounds[1,4]
  ) |
    (
      kin_new$R1 >= bounds[2,1] & kin_new$R1 <= bounds[2,2] &
        kin_new$KING >= bounds[2,3] & kin_new$KING <= bounds[2,4]
    ),
]

# individuals involved in closer relationships (PO or half-sib)
related_individuals <- unique(c(related_pairs$ind_a, related_pairs$ind_b))

# all individuals from the kept pairs (unrelated or 3rd-degree)
all_included <- unique(c(keep_pairs$ind_a, keep_pairs$ind_b))

# remove anyone who shows up in a closer relationship
filtered_individuals <- setdiff(all_included, related_individuals)

# join pop info
final_df <- data.frame(sample_ID = filtered_individuals)
final_with_pop <- merge(final_df, pop[, c("sample_ID", "pop")], by = "sample_ID")

write.csv(final_with_pop, "unrelated_plus_3rd_degree_with_pop.csv", row.names = FALSE)


# relatedness plots ------------------------------------------------------

###plot with dots as relationships - all individuals
# Set up the plot
plot(all_individuals$R1, all_individuals$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(kin_new$R1[kin_new$R1 >= bounds[i,1] & kin_new$R1 <= bounds[i,2] &
                      kin_new$KING >= bounds[i,3] & kin_new$KING <= bounds[i,4]], 
         kin_new$KING[kin_new$R1 >= bounds[i,1] & kin_new$R1 <= bounds[i,2] &
                        kin_new$KING >= bounds[i,3] & kin_new$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)

###plot with dots as relationships - Buller
# Set up the plot
plot(Buller$R1, Buller$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Buller$R1[Buller$R1 >= bounds[i,1] & Buller$R1 <= bounds[i,2] &
                      Buller$KING >= bounds[i,3] & Buller$KING <= bounds[i,4]], 
         Buller$KING[Buller$R1 >= bounds[i,1] & Buller$R1 <= bounds[i,2] &
                        Buller$KING >= bounds[i,3] & Buller$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)

###plot with dots as relationships - Warren
# Set up the plot
plot(Warren$R1, Warren$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Warren$R1[Warren$R1 >= bounds[i,1] & Warren$R1 <= bounds[i,2] &
                     Warren$KING >= bounds[i,3] & Warren$KING <= bounds[i,4]], 
         Warren$KING[Warren$R1 >= bounds[i,1] & Warren$R1 <= bounds[i,2] &
                       Warren$KING >= bounds[i,3] & Warren$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)

###plot with dots as relationships - Alazan Bayou
# Set up the plot
plot(Alazan$R1, Alazan$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Alazan$R1[Alazan$R1 >= bounds[i,1] & Alazan$R1 <= bounds[i,2] &
                     Alazan$KING >= bounds[i,3] & Alazan$KING <= bounds[i,4]], 
         Alazan$KING[Alazan$R1 >= bounds[i,1] & Alazan$R1 <= bounds[i,2] &
                       Alazan$KING >= bounds[i,3] & Alazan$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)

###plot with dots as relationships - Brazoria
# Set up the plot
plot(Brazoria$R1, Brazoria$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Brazoria$R1[Brazoria$R1 >= bounds[i,1] & Brazoria$R1 <= bounds[i,2] &
                     Brazoria$KING >= bounds[i,3] & Brazoria$KING <= bounds[i,4]], 
         Brazoria$KING[Brazoria$R1 >= bounds[i,1] & Brazoria$R1 <= bounds[i,2] &
                       Brazoria$KING >= bounds[i,3] & Brazoria$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)

###plot with dots as relationships - ###plot with dots as relationships - Gordy
# Set up the plot
plot(Gordy$R1, Gordy$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Gordy$R1[Gordy$R1 >= bounds[i,1] & Gordy$R1 <= bounds[i,2] &
                       Gordy$KING >= bounds[i,3] & Gordy$KING <= bounds[i,4]], 
         Gordy$KING[Gordy$R1 >= bounds[i,1] & Gordy$R1 <= bounds[i,2] &
                         Gordy$KING >= bounds[i,3] & Gordy$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)


###plot with dots as relationships - ###plot with dots as relationships - Wharton
# Set up the plot
plot(Wharton$R1, Wharton$KING, pch=20, cex=1, col="black", xlim=c(0.1,1), ylim=c(-0.2,0.5),
     xlab="R1", ylab="KING")


bounds <- matrix(c(0.423128, Inf, 0.1767767, 0.3535534,   # Parent Offspring
                   0.2, 0.5, 0.08838835, 0.1767767,       # Half Sib
                   0.07142857, 0.4210526, 0.04419417, 0.08838835,  # First cousins
                   -Inf, Inf, -Inf, 0.04419417),          # Unrelated
                 ncol = 4, byrow = TRUE)

# Define colors based on the bounds
colors <- c("#E76BF3", "#00A5FF", "#00BC59", "#F8766D")

# Loop through each relationship category and plot the points with the corresponding color
for (i in 1:length(colors)) {
  points(Wharton$R1[Wharton$R1 >= bounds[i,1] & Wharton$R1 <= bounds[i,2] &
                    Wharton$KING >= bounds[i,3] & Wharton$KING <= bounds[i,4]], 
         Wharton$KING[Wharton$R1 >= bounds[i,1] & Wharton$R1 <= bounds[i,2] &
                      Wharton$KING >= bounds[i,3] & Wharton$KING <= bounds[i,4]], 
         pch=20, cex=1, col=colors[i])
}

# Add legend
legend(c(0.7, 0.7), c(0.1, 0), text.font=1,
       legend=c("1st degree", "2nd degree", "3rd degree", "Unrelated"),
       fill=colors, bty='n', border=NA,
       pt.cex=2, x.intersp=1, text.width=2, xpd=TRUE, y.intersp=1.5)
