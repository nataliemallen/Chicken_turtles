#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=beagle
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 12-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

### generating Beagle

module load biocontainers
module load angsd

# Set your input BAM file list
BAM_LIST="/scratch/negishi/allen715/chicken_turtles/final_bams/bams_list.txt"
# Set the reference genome FASTA file path
REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
OUT="/scratch/negishi/allen715/chicken_turtles/plink_angsd/"

angsd -bam "$BAM_LIST" -P 64 -doCounts 1 -doPlink 2 -GL 1 -doGlf 2 -doMajorMinor 4 -doMaf 1 -SNP_pval 1e-6 \
-doPost 1 -doGeno 4 -geno_minDepth 5 -remove_bads 1 -only_proper_pairs 1 -ref "$REF" \
-postCutoff 0.99 -minMaf 0.05 -minInd 70 -uniqueOnly 1 -minMapQ 30 -minQ 30 -out "$OUT"


# gzip -d turtle.beagle.gz
# awk '{print $1}' turtle.beagle | sed 's/NW_/NW./g' | sed 's/_/\t/g' | sed 's/NW./NW_/g' | tail -n +2 > FINAL.SITES
# wc -l turtle.beagle | awk '{print $1 - 1}' #total sites 2848762
# gzip turtle.beagle
