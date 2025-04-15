### plot eval admix
### K = 2
# Set working directory
setwd("/Users/natal/R/turtles")

source("visFuns.R")
# read population labels and estimated admixture proportions

pop<-read.table("eval_admix.info",as.is=T)

q<-read.table("admix_K2_run16.qopt")

head(pop)

# order according to population and plot the NGSadmix reults
ord<-orderInds(pop = as.vector(pop[,1]), q = q)
barplot(t(q)[,ord],col=2:10,space=0,border=NA,xlab="Individuals",ylab="Demo2 Admixture proportions for K=2")
text(sort(tapply(1:nrow(pop),pop[ord,1],mean)),-0.05,unique(pop[ord,1]),xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)

r<-read.table("K2_output.corres.txt")

# Plot correlation of residuals

plotCorRes(cor_mat = r, pop = as.vector(pop[,1]), ord = ord, title="Evaluation of 1000G admixture proportions with K=3", max_z=0.1, min_z=-0.1)


### other K values

# Set working directory
setwd("/Users/natal/R/turtles")

# Load necessary functions
source("visFuns.R")

# Read population labels (same for all K)
pop <- read.table("eval_admix.info", as.is = TRUE)

# Define K values
K_values <- c(1, 3, 4, 5, 6, 7, 8, 9, 10)

# Loop over K values
for (K in K_values) {
  
  # Construct file names
  q_file <- paste0("admix_K", K, "_run13.qopt")
  r_file <- paste0("K", K, "_output.corres.txt")
  
  # Read Q matrix
  q <- read.table(q_file)
  
  # Order individuals by population
  ord <- orderInds(pop = as.vector(pop[,1]), q = q)
  
  # Plot admixture proportions
  barplot(t(q)[,ord], col = 2:10, space = 0, border = NA, 
          xlab = "Individuals", 
          ylab = paste("Demo2 Admixture proportions for K=", K, sep=""))
  
  text(sort(tapply(1:nrow(pop), pop[ord,1], mean)), -0.05, unique(pop[ord,1]), xpd = TRUE)
  abline(v = cumsum(sapply(unique(pop[ord,1]), function(x) { sum(pop[ord,1] == x) })), col = 1, lwd = 1.2)
  
  # Read correlation residuals
  r <- read.table(r_file)
  
  # Plot correlation of residuals
  plotCorRes(cor_mat = r, pop = as.vector(pop[,1]), ord = ord, 
             title = paste("Evaluation of 1000G admixture proportions with K=", K, sep=""),
             max_z = 0.1, min_z = -0.1)
}
