#!/bin/bash
#SBATCH --job-name=cat
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 12-00:00:00
#SBATCH --error=cat.err
#SBATCH --output=cat.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

module --force purge
module load biocontainers
module load fastqc

cd /scratch/negishi/allen715/

#cat *.fastq.gz > chicken_turtle_all.hifi_reads.fastq.gz**

fastqc chicken_turtle_all.hifi_reads.fastq.gz -o fastqc_out

#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 12-00:00:00
#SBATCH --error=fastp.err
#SBATCH --output=fastp.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

module --force purge
module load biocontainers
module load fastp
module load fastqc

cd /scratch/negishi/allen715/

fastp -i chicken_turtle_all.hifi_reads.fastq.gz -o trimmed_ct_all.fastq.gz --detect_adapter_for_pe --qualified_quality_phred 30 --length_required 5000 --length_limit 50000

fastqc trimmed_ct_all.fastq.gz -o fastqc_out
