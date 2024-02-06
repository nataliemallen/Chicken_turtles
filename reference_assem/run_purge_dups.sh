#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=purge_dups
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 5:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module purge
module load biocontainers
module load purge_dups
module load minimap2/2.26

#step 1 generate config file
#pd_config.py /scratch/negishi/allen715/chicken_turtles/hifiasm/ct_ref.asm.bp.hap1.fa pb.fofn

#step 2 run purge dups
run_purge_dups.py -p bash config.json /usr/local/bin ChiTur
