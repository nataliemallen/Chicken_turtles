#!/bin/bash
#SBATCH --job-name="ct_trim_reads"
#SBATCH -A johnwayne
#SBATCH -t 5-0:00:00
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -e %x_%j.err
#SBATCH -o %x-%j.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

module load biocontainers
module load fastqc
module load multiqc

#first run fastqc on all og reads
cd /scratch/negishi/allen715/chicken_turtles/CT_reads/
mkdir fastqc_out
fastqc *fastq.gz -o fastqc_out
cd fastqc_out

mkdir QC
multiqc . -o ./QC

#clean and trim reads
module purge
module load biocontainers
module load samtools
module load bedtools/2.31.0
module load trim-galore/0.6.10

cd /scratch/negishi/allen715/chicken_turtles/CT_reads/
# Make a directory to house the cleaned/cutadapt samples. Also make a directory to house the FastQC and MultiQC reports.
mkdir -p ../cleaned/fastqc_out/QC

for i in $(ls -1 *_R1_*fastq.gz)
do
    SAMPLENAME=$(echo $i | cut -c 1-6)
    R1FILE=$(echo $i | sed -r 's/_R2_/_R1_/')
    R2FILE=$(echo $i | sed -r 's/_R1_/_R2_/')

    # Trim low-quality ends from reads in addition to adapter removal. Phred 20.
    # Run TrimGalore.
    trim_galore --stringency 1 --length 30 --quality 20 --paired -o /scratch/negishi/allen715/chicken_turtles/cleaned/ $R1FILE $R2FILE

done


# Run FastQC followed by MultiQC to assess read quality.
module purge
module load biocontainers
module load fastqc
module load multiqc

cd /scratch/negishi/allen715/chicken_turtles/cleaned/
mkdir fastqc_out
fastqc *fq.gz -o fastqc_out
cd fastqc_out

mkdir QC
multiqc . -o ./QC
