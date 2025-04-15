#!/bin/bash
#SBATCH --job-name=treemix
#SBATCH -A fnrdewoody
#SBATCH -t 12-00:00:00
#SBATCH -n 64
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

# module load biocontainers
# module load angsd

# for site in warren buller wharton alazan gordy; do
#     angsd -bam ${site}_bamlist.txt \
#           -GL 1 \
#           -doMajorMinor 1 \
#           -out ${site}_freqs \
#           -doMaf 1 \
#           -doCounts 1 \
#           -minMapQ 30 \
#           -minQ 20 \
#           -minInd 5 \
#           -SNP_pval 1e-6 \
#           -P 40
# done
# 

# prep input file
# module load anaconda
# 
# python3 format_treemix.py

# format
# mv treemix_input.gz treemix_input
# gzip treemix_input
# zcat treemix_input.gz | awk '{for (i=2; i<=NF; i++) printf "%s%s", $i, (i<NF ? OFS : ORS)}' | gzip > treemix_input_no_snp.gz


# module load gsl
# 
# TREEMIX="/home/allen715/treemix-1.13/src/treemix"
# 
# for m in {0..5}; do
#     "$TREEMIX" -i treemix_input_no_snp.gz \
#             -o treemix_output_m${m} \
#             -m ${m} \
#             -root wharton \
#             -k 500
# done


## no root
module load gsl

TREEMIX="/home/allen715/treemix-1.13/src/treemix"

# for m in {0..5}; do
#     "$TREEMIX" -i treemix_input_no_snp.gz \
#             -o treemix_output_m${m} \
#             -m ${m} \
#             -k 500
# done

module load r

source("/home/allen715/treemix-1.13/src/plotting_funcs.R")

# plot tree with migration arrows
plot_tree("treemix_output_m3")

# plot residuals to check model fit
plot_resid("treemix_output_m3", "pop_order.txt")

q()
