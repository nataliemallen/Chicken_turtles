#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=admix
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -t 1-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load angsd

# Set the path to evalAdmix
evalAdmix_bin="/home/allen715/evalAdmix/evalAdmix"

# Set the path to the Beagle file
beagle="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/turtle.beagle.gz"  # Change this to your actual Beagle file

# Number of threads to use
threads=64

cd /scratch/negishi/allen715/chicken_turtles/admixture/new_admix/ADX/

# Loop over K values
for K in {1..10}; do
  # Loop over 20 replicates
  for i in {1..20}; do
    # Define input file names
    qopt_file="admix_K${K}_run${i}.qopt"
    fopt_file="admix_K${K}_run${i}.fopt.gz"
    
    # Check if required files exist before running evalAdmix
    if [[ -f "$qopt_file" && -f "$fopt_file" ]]; then
      echo "Running evalAdmix for K=${K}, replicate=${i}..."
      "$evalAdmix_bin" -beagle "$beagle" -qname "$qopt_file" -fname "$fopt_file" -P $threads > "evalAdmix_K${K}_run${i}.log"
    else
      echo "Missing files for K=${K}, replicate=${i}. Skipping..."
    fi
  done
done

echo "All evalAdmix runs completed."

#after running, get z scores
#grep "Mean Z-score" evalAdmix_K*_run*.log | awk -F'[_ .]' '{print $(NF-2), $(NF), $NF}' > zscores.txt
