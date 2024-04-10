#!/bin/bash
#SBATCH --job-name=busco
#SBATCH -A johnwayne
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 14-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module --force purge
ml biocontainers busco

## The augustus config step is only required for the first time to use BUSCO
mkdir -p $RCAC_SCRATCH/augustus
copy_augustus_config $RCAC_SCRATCH/augustus

## This is required for eukaryotic genomes
export AUGUSTUS_CONFIG_PATH=$RCAC_SCRATCH/augustus/config

## Print the full lineage datasets, and find the dataset fitting your organism.
busco --list-datasets

## run the evaluation
busco -f -c 12 -l vertebrata_odb10 -i ct_ref.asm.bp.hap1.purged.fa -o busco_out_protein  -m protein
busco -f -c 12 --augustus -l vertebrata_odb10 -i ct_ref.asm.bp.hap1.purged.fa -o busco_out_genome  -m genome

## generate a simple summary plot
generate_plot.py -wd busco_out_protein
generate_plot.py -wd busco_out_genome
