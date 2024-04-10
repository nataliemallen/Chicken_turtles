#!/bin/bash
#SBATCH --job-name=blobtools1
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 128
#SBATCH -t 14-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

# module load biocontainers
# module load minimap2
# module load samtools

cd /scratch/negishi/allen715/chicken_turtles/hifiasm/blobtools1/

HOME=/scratch/negishi/allen715/
# 
# #Map reads to use for coverage information
# minimap2 -ax map-hifi ct_ref.asm.bp.hap1.purged.fa ${HOME}/Dewoody_chicken_turtle_1_m64108e_230717_235931.hifi_reads.fastq.gz ${HOME}/Dewoody_chicken_turtle_2_m64108e_230719_091942.hifi_reads.fastq.gz ${HOME}/Dewoody_chicken_turtle_3_m64108e_230720_183914.hifi_reads.fastq.gz -t 60 > aln.sam
# 
# #convert to bam
# samtools view -Sb aln.sam > aln.bam  
# #Sort bam
# samtools sort -@ 64 aln.bam > aln_sort.bam
# #index
# samtools index -@ 64 aln_sort.bam  
# # 
module purge
ml biocontainers
ml blobtools
ml blast
ml minimap2

#produce hits file
#blastn -task megablast -query ct_ref.asm.bp.hap1.purged.fa -db nt -outfmt 6 -max_target_seqs 10 -max_hsps 1 -num_threads 128 -out blast_out_ct.txt -evalue 1e-25
#produce coverage file
#blobtools map2cov -i ct_ref.asm.bp.hap1.purged.fa -b aln_sort.bam -o aln_sort.bam.cov
#create blobdir
blobtools create -i ct_ref.asm.bp.hap1.purged.fa -c aln_sort.bam.cov -o db -t blast_out_ct.txt --names /scratch/negishi/allen715/chicken_turtles/hifiasm/blobtools1/names.dmp --nodes /scratch/negishi/allen715/chicken_turtles/hifiasm/blobtools1/nodes.dmp
#VIew output table
blobtools view  -i db.blobDB.json  -o results_table.txt --rank order
