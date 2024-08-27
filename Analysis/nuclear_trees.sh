#!/bin/bash
#SBATCH -A highmem
#SBATCH --job-name=tree
#SBATCH -N 1
#SBATCH -n 128
#SBATCH -t 1-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

### generating Beagle

####run angsd the same as admix but with -doBcf 1
# module load biocontainers
# module load angsd
# 
# # Set your input BAM file list
# BAM_LIST="/scratch/negishi/allen715/chicken_turtles/final_bams/bams_list.txt"
# # Set the reference genome FASTA file path
# REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
# OUT="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/tree/turtletree"
# 
# angsd -bam "$BAM_LIST" -P 64 -doCounts 1 -GL 1 -doGlf 2 -doMajorMinor 4 -doMaf 2 -doBcf 1 -SNP_pval 1e-6 \
# -doHWE 1 -remove_bads 1 -only_proper_pairs 1 -ref "$REF" \
# -minInd 44 -uniqueOnly 1 -minMapQ 20 -minQ 20 -out "$OUT"

# gzip -d turtle.beagle.gz
# awk '{print $1}' turtle.beagle | sed 's/NW_/NW./g' | sed 's/_/\t/g' | sed 's/NW./NW_/g' | tail -n +2 > FINAL.SITES
# wc -l turtle.beagle | awk '{print $1 - 1}' #total sites 2848762
# gzip turtle.beagle

# module load biocontainers
# module load bcftools
# module load samtools
# module load vcftools
# module load htslib
# 
# # # Convert BCF to VCF
# bcftools view -O v -o turtletree.vcf turtletree.bcf
# # 
# # # Compress the VCF file
# bgzip -c turtletree.vcf > turtletree.vcf.gz
# # 
# # # Index the compressed VCF file (optional)
# tabix -p vcf turtletree.vcf.gz
# 
# ######
# #step 2 java
# ######
# module load openjdk/11.0.17_8
# java  -Xss4m -Xmx256g -jar /home/allen715/beagle.27Jan18.7e1.jar gl=turtletree.vcf.gz out=turtle_beagled

# module load anaconda
# python3 vcf2phylip.py --input turtle_beagled.vcf.gz  --fasta --nexus --output-prefix  turtle_beagled.not.iupac.resolved

module purge
module load biocontainers
module load iqtree/2.2.2.2

#step 1 TREE with IUPAC not resolved ##use this
iqtree2 -s turtle_beagled.not.iupac.resolved.min4.fasta -m GTR -B 1000 -T 64 -pre angsdput.not.iupac.resolved -st DNA

#step 2
#iqtree2 -s angsdput.not.iupac.resolved.varsites.phy -m GTR+ASC -B 1000 -T 64 -pre angsdput.not.iupac.resolved.FINAL -st DNA
