#!/bin/bash
#SBATCH -A johnwayne
#SBATCH --job-name=beagle
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 1-08:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

### generating Beagle

module load biocontainers
module load angsd

###first run angsd on all individuals to get sites file 
# # Set your input BAM file list
# BAM_LIST="/scratch/negishi/allen715/chicken_turtles/final_bams/bams_list.txt"
# # Set the reference genome FASTA file path
# REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
# OUT="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/dxy_calc"
# 
# estimate major and minor alleles for ALL individuals 
# angsd -bam "$BAM_LIST" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT.filtered"

# get sites
# zcat "$OUT.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT.filtered.sites"

###rerun for each population
ALAZAN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/alazan_bamlist.txt
BRAZORIA=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazoria_bamlist.txt
BRAZOS=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazos_bamlist.txt
BULLER=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/buller_bamlist.txt
GORDY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/gordy_bamlist.txt
LIBERTY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/liberty_bamlist.txt
WARREN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/warren_bamlist.txt
WHARTON=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/wharton_bamlist.txt

#SITES="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/dxy_calc.filtered.sites"
SITES="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/nohead.filtered.sites"

REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
OUT_ALAZAN="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/alazan"
OUT_BRAZORIA="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/brazoria"
OUT_BRAZOS="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/brazos"
OUT_BULLER="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/buller"
OUT_GORDY="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/gordy"
OUT_LIBERTY="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/liberty"
OUT_WARREN="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/warren"
OUT_WHARTON="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/mafs/wharton"

# ###ALAZAN###
# #rerun with sites command
# angsd -bam "$ALAZAN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_ALAZAN.nohead.allele_freq"

###BRAZORIA###
#rerun with sites command
angsd -bam "$BRAZORIA" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_BRAZORIA.nohead.allele_freq"

###BRAZOS###
#rerun with sites command
angsd -bam "$BRAZOS" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_BRAZOS.nohead.allele_freq"

###BULLER###
#rerun with sites command
angsd -bam "$BULLER" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_BULLER.nohead.allele_freq"

###GORDY###
#rerun with sites command
angsd -bam "$GORDY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_GORDY.nohead.allele_freq"

###LIBERTY###
#rerun with sites command
angsd -bam "$LIBERTY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_LIBERTY.nohead.allele_freq"

###WARREN###
#rerun with sites command
angsd -bam "$WARREN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_WARREN.nohead.allele_freq"

###WHARTON###
#rerun with sites command
angsd -bam "$WHARTON" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_WHARTON.nohead.allele_freq"



# #rerun with sites command
# angsd -bam "$BAM_LIST" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT.filtered.sites" -out "$OUT.allele_freq"

#calculate Dxy
# R Script to calculate Dxy
# library(NGSTools)
# calcDxy(maf_files = list.files(pattern = "\\.maf$"), out_file = "dxy_results.txt")


###IGNORE####

# ALAZAN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/alazan_bamlist.txt
# BRAZORIA=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazoria_bamlist.txt
# BRAZOS=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazos_bamlist.txt
# BULLER=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/buller_bamlist.txt
# GORDY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/gordy_bamlist.txt
# LIBERTY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/liberty_bamlist.txt
# WARREN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/warren_bamlist.txt
# WHARTON=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/wharton_bamlist.txt
# 
# REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
# OUT_ALAZAN="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/alazan"
# OUT_BRAZORIA="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazoria"
# OUT_BRAZOS="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazos"
# OUT_BULLER="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/buller"
# OUT_GORDY="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/gordy"
# OUT_LIBERTY="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/liberty"
# OUT_WARREN="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/warren"
# OUT_WHARTON="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/wharton"


# ###ALAZAN###
# angsd -bam "$ALAZAN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_ALAZAN.filtered"
# 
# #get sites
# zcat "$OUT_ALAZAN.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_ALAZAN.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_ALAZAN.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$ALAZAN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_ALAZAN.filtered.sites" -out "$OUT_ALAZAN.allele_freq"
# 
# ###BRAZORIA###
# angsd -bam "$BRAZORIA" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_BRAZORIA.filtered"
# 
# #get sites
# zcat "$OUT_BRAZORIA.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_BRAZORIA.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_BRAZORIA.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$BRAZORIA" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_BRAZORIA.filtered.sites" -out "$OUT_BRAZORIA.allele_freq"
# 
# ###BRAZOS###
# angsd -bam "$BRAZOS" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_BRAZOS.filtered"
# 
# #get sites
# zcat "$OUT_BRAZOS.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_BRAZOS.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_BRAZOS.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$BRAZOS" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_BRAZOS.filtered.sites" -out "$OUT_BRAZOS.allele_freq"
# 
# ###BULLER###
# angsd -bam "$BULLER" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_BULLER.filtered"
# 
# #get sites
# zcat "$OUT_BULLER.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_BULLER.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_BULLER.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$BULLER" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_BULLER.filtered.sites" -out "$OUT_BULLER.allele_freq"
# 
# ###GORDY###
# angsd -bam "$GORDY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_GORDY.filtered"
# 
# #get sites
# zcat "$OUT_GORDY.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_GORDY.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_GORDY.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$GORDY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_GORDY.filtered.sites" -out "$OUT_GORDY.allele_freq"
# 
# ###LIBERTY###
# angsd -bam "$LIBERTY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_LIBERTY.filtered"
# 
# #get sites
# zcat "$OUT_LIBERTY.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_LIBERTY.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_LIBERTY.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$LIBERTY" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_LIBERTY.filtered.sites" -out "$OUT_LIBERTY.allele_freq"
# 
# ###WARREN###
# angsd -bam "$WARREN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_WARREN.filtered"
# 
# #get sites
# zcat "$OUT_WARREN.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_WARREN.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_WARREN.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$WARREN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_WARREN.filtered.sites" -out "$OUT_WARREN.allele_freq"
# 
# ###WHARTON###
# angsd -bam "$WHARTON" -P 64 -doCounts 1 -GL 1 -doMaf 1 -SNP_pval 1e-6 -doMajorMinor 1 \
# -skipTriallelic 1 -only_proper_pairs 1 -ref "$REF" -minMapQ 20 -minQ 20 -out "$OUT_WHARTON.filtered"
# 
# #get sites
# zcat "$OUT_WHARTON.filtered.mafs.gz" | awk '{print $1, $2}' > "$OUT_WHARTON.filtered.sites"
# 
# #index sites
# angsd sites index "$OUT_WHARTON.filtered.sites"
# 
# #rerun with sites command
# angsd -bam "$WHARTON" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
# -ref "$REF" -minMapQ 20 -minQ 20 -sites "$OUT_WHARTON.filtered.sites" -out "$OUT_WHARTON.allele_freq"
