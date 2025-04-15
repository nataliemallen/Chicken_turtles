#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=whale_rohs_bcf
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 12-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load bcftools
module load htslib
module load angsd

BAM_LIST="/scratch/negishi/allen715/chicken_turtles/final_bams/bams_list.txt"
# set reference genome path
REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
# out directory
# OUT="/scratch/negishi/allen715/chicken_turtles/ROHs/turtle_for_rohs"

# run angsd
angsd -bam "$BAM_LIST" -GL 1 -P 64 -doBcf 1 -dopost 1 -doMajorMinor 1 -doMaf 1 -minQ 30 \
--ignore-RG 0 -dogeno 1 -docounts 1 -SNP_pval 1e-6 -ref "$REF" -out "$OUT"

module load bcftools
module load samtools

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%INFO/AF\n' turtle_for_rohs.bcf | bgzip -c > turtle.freqs.tab.gz
tabix -s1 -b2 -e2 turtle.freqs.tab.gz
bcftools roh --AF-file turtle.freqs.tab.gz --output turtle_roh_PLraw.txt --threads 64 turtle_for_rohs.bcf
 
awk '$1=="RG"' turtle_roh_PLraw.txt > ROH_RG_all.txt
for i in `cat sample_names.txt`; do  grep $i ROH_RG_all.txt  > $i.ROH.txt ; done

# get summary file
echo -e "Individual\tNum_ROHs\tTotal_kb\tAvg_kb" > ROH_summary_stats.txt

# loop through each individual ROH file
for file in *.ROH.txt; do
    # extract the individual name from the file name (remove ".ROH.txt")
    individual=$(basename "$file" .ROH.txt)
    
    # count the number of ROH segments (lines in the file)
    num_rohs=$(wc -l < "$file")
    
    # check if the number of ROHs is valid (greater than zero)
    if [[ -z "$num_rohs" || "$num_rohs" -eq 0 ]]; then
        total_kb=0
        avg_kb=0
    else
        # calculate the total ROH length (in kb) using column 6
        total_kb=$(awk '{sum += $6/1000} END {print sum}' "$file")
        
        # ensure total_kb is a valid number
        if [[ -z "$total_kb" || "$total_kb" == "" ]]; then
            total_kb=0
        fi

        # calculate the average ROH length (in kb)
        if [[ "$num_rohs" -gt 0 ]]; then
            avg_kb=$(echo "$total_kb / $num_rohs" | bc -l)
        else
            avg_kb=0
        fi
    fi

    # append the results to the summary file
    echo -e "${individual}\t${num_rohs}\t${total_kb}\t${avg_kb}" >> ROH_summary_stats.txt
done

echo "Summary statistics written to ROH_summary_stats.txt"
