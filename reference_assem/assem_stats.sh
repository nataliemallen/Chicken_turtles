###gets assembly stats from assembly-stats and quast

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
ml biocontainers assembly-stats

assembly-stats ct_ref.asm.bp.hap1.purged.fa

module --force purge
ml biocontainers
ml quast
quast.py ct_ref.asm.bp.hap1.purged.fa
