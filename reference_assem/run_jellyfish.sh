#!/bin/bash
#SBATCH --job-name=assem_stats
#SBATCH -A fnrdewoody
#SBATCH -t 12-00:00:00
#SBATCH -n 64
#SBATCH -N 1
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load kmer-jellyfish

# Path to your genome file
#genome_file="/scratch/negishi/allen715/chicken_turtles/hifiasm/ct_ref.asm.bp.hap1.p_ctg.gfa"
genome_file="/scratch/negishi/allen715/chicken_turtles/hifiasm/ct_ref.asm.bp.hap1.fa"

# K-mer size
kmer_size=21

# Output files
jellyfish_output="jellyfish_output.jf"
histogram_output="histogram_output.txt"

# Run Jellyfish
jellyfish count -m $kmer_size -s 100M -t 64 -C -o $jellyfish_output $genome_file

# Generate histogram
jellyfish histo -t 64 $jellyfish_output > $histogram_output
