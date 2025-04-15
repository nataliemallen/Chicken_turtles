#!/bin/bash
#SBATCH -A highmem
#SBATCH --job-name=eval_admix
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -t 00:30:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load angsd

# Set the path to the Beagle file
beagle="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/turtle.beagle.gz"  # Change this to your actual Beagle file

#/home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K2_run16.fopt.gz -qname admix_K2_run16.qopt -P 32
# mv output.corres.txt K2_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K3_run13.fopt.gz -qname admix_K3_run13.qopt -P 32
# mv output.corres.txt K3_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K4_run13.fopt.gz -qname admix_K4_run13.qopt -P 32
# mv output.corres.txt K4_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K5_run13.fopt.gz -qname admix_K5_run13.qopt -P 32
# mv output.corres.txt K5_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K6_run13.fopt.gz -qname admix_K6_run13.qopt -P 32
# mv output.corres.txt K6_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K7_run13.fopt.gz -qname admix_K7_run13.qopt -P 32
# mv output.corres.txt K7_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K8_run13.fopt.gz -qname admix_K8_run13.qopt -P 32
# mv output.corres.txt K8_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K9_run13.fopt.gz -qname admix_K9_run13.qopt -P 32
# mv output.corres.txt K9_output.corres.txt
# 
# /home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K10_run13.fopt.gz -qname admix_K10_run13.qopt -P 32
# mv output.corres.txt K10_output.corres.txt

/home/allen715/evalAdmix/evalAdmix -beagle "$beagle" -fname admix_K1_run13.fopt.gz -qname admix_K1_run13.qopt -P 32
mv output.corres.txt K1_output.corres.txt
