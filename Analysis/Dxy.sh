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

###remove header from .filtered.sites file before proceeding

###rerun for each population
ALAZAN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/alazan_bamlist.txt
BRAZORIA=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazoria_bamlist.txt
BRAZOS=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/brazos_bamlist.txt
BULLER=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/buller_bamlist.txt
GORDY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/gordy_bamlist.txt
LIBERTY=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/liberty_bamlist.txt
WARREN=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/warren_bamlist.txt
WHARTON=/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/nucdiv/wharton_bamlist.txt

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
#rerun with sites command
angsd -bam "$ALAZAN" -P 64 -doCounts 1 -GL 1 -doMaf 1 -doMajorMinor 1 -only_proper_pairs 1 \
-ref "$REF" -minMapQ 20 -minQ 20 -sites "$SITES" -out "$OUT_ALAZAN.nohead.allele_freq"

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

###now, calculate Dxy using calcDxy.R from angsd
#!/bin/bash
#SBATCH -A johnwayne
#SBATCH --job-name=dxy
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 08-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load r

populations=("alazan.nohead.allele_freq.mafs" "brazoria.nohead.allele_freq.mafs" "brazos.nohead.allele_freq.mafs" "buller.nohead.allele_freq.mafs" "gordy.nohead.allele_freq.mafs" "liberty.nohead.allele_freq.mafs" "warren.nohead.allele_freq.mafs" "wharton.nohead.allele_freq.mafs")

for i in "${!populations[@]}"; do
  for j in $(seq $((i+1)) $((${#populations[@]}-1))); do
    popA=${populations[$i]}
    popB=${populations[$j]}
    Rscript calcDxy.R --popA $popA --popB $popB --totLen 3000000000
  done
done



