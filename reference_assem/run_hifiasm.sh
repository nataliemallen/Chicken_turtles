#First, all fastq.gz files were merged

#!/bin/bash
#SBATCH --job-name=ct_assemble
#SBATCH -A highmem
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 1-00:00:00
#SBATCH --error=assemble.err
#SBATCH --output=assemble.out
#SBATCH --job-name=produce_align
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

module --force purge
module load biocontainers
module load hifiasm

cd /scratch/negishi/allen715/

hifiasm -o ct_ref.asm -t 64 trimmed_ct_all.fastq.gz
