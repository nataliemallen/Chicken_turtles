#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=LD_prune
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 14-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

### prune LD

module purge
module load biocontainers
module load angsd
module load ngsld

BAM="/scratch/negishi/allen715/chicken_turtles/final_bams/bams_list.txt"
REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
OUT="/scratch/negishi/allen715/chicken_turtles/LD_prune/turtle"

# run angsd
angsd -bam "$BAM" \
      -doCounts 1 \
      -GL 1 \
      -doGlf 2 \
      -doMajorMinor 1 \
      -doMaf 1 \
      -minMaf 0.05 \
      -SNP_pval 1e-6 \
      -minMapQ 20 \
      -minQ 20 \
      -baq 1 \
      -ref "$REF" \
      -nThreads 60 \
      -out "$OUT" \

zcat turtle.beagle.gz | cut -f 1 | tail -n +2 | sed 's/_/\t/' > turtle.pos.txt

# calculate ld 
turtle_IND=$(wc -l < "$BAM")
less turtle.beagle.gz --pos | cut -f1 | sed 's/1_/1\t/g' | sed '1d' > turtle.sites.txt
turtle_SITES=$(less turtle.sites.txt | wc -l)

# check for extra line in sites file, do this, then redo site number calculation
head -n -1 turtle.sites.txt > temp.txt ; mv temp.txt turtle.sites.txt

ngsLD --geno turtle.beagle.gz --probs \
    --pos turtle.sites.txt \
    --max_kb_dist 10 --min_maf 0.05 --extend_out \
        --N_thresh 0.3 --call_thresh 0.9 \
        --n_threads 60 --verbose 1 \
        --n_ind 89 --n_sites 3214781 | \
             sort -k 1,1Vr -k 2,2V > turtle.allSNPs.ld

######run prune_graph separately on long contigs
module purge
module load biocontainers
module load angsd
module load pcangsd
module load ngsld
module load samtools  

# reference
REF="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
# create contig_lengths.txt from .fai file
awk '{print $1, $2}' "${REF}.fai" > contig_lengths.txt
# extract contig names from turtle.pos.txt
cut -f 1 turtle.sites.txt | sort -u > contig_list.txt

# split contigs into "large" and "small"
awk '{if ($2 > 85000000) print $1 > "large_contigs.txt"; else print $1 > "small_contigs.txt"}' contig_lengths.txt

# process large contigs 
while read -r contig; do
    grep -w "$contig" turtle.allSNPs.ld > "${contig}.ld"
    /home/allen715/prune_graph/target/release/prune_graph --in "${contig}.ld" \
        --weight-field "column_7" \
        --weight-filter "column_3 <= 10000 && column_7 >= 0.5" \
        --n-threads 40 \
        --out "${contig}_unlinked.ld"
done < large_contigs.txt

# combine large contig results
cat *_unlinked.ld > large_contigs_unlinked.ld

# process small contigs 
grep -wf small_contigs.txt turtle.allSNPs.ld > small_contigs.ld
/home/allen715/prune_graph/target/release/prune_graph --in small_contigs.ld \
    --weight-field "column_7" \
    --weight-filter "column_3 <= 10000 && column_7 >= 0.5" \
    --n-threads 40 \
    --out small_contigs_unlinked.ld

# combine all results 
cat large_contigs_unlinked.ld small_contigs_unlinked.ld > turtle_unlinked.ld

# make output compatible with beagle
sed 's/:/_/g' turtle_unlinked.ld > turtle_unlinked

zcat turtle.beagle.gz | head -n 1 > turtle_unlinked.beagleheader  # Extract the header
zcat turtle.beagle.gz | grep -Fwf turtle_unlinked > turtle_unlinked.beagle  # Keep only unlinked loci
cat turtle_unlinked.beagleheader turtle_unlinked.beagle | gzip > turtle_unlinked.beagle.gz  # Combine header and SNP data


# run pcangsd on ld pruned data 
pcangsd -b turtle_unlinked.beagle.gz -o unlinked_turtle_pca -t 64

# count loci
cat turtle_unlinked | wc -l  # Count the number of unlinked loci
zcat turtle_unlinked.beagle.gz | tail -n +2 | wc -l  # Check the number of rows (SNPs) in the final `beagle` file
