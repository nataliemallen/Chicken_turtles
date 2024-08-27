#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH --job-name=admix
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 13-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load angsd


reference_genome="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa"
fai_file="/scratch/negishi/allen715/chicken_turtles/reference/ref.fa.fai"
beagle="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/turtle.beagle.gz" # Path to the Beagle file

cd ADX

# Loop over K values
for K in 1 2 3 4 5 6 7 8 9 10; do
  # Loop to run NGSadmix 20 times for each K
  for i in {1..20}; do
    # Construct the output filename
    output_file="admix_K${K}_run${i}"
    # Run NGSadmix
    NGSadmix -likes "$beagle" -K $K -o $output_file -P 64
  done
done


###combine runs for admix
#!/bin/bash
#SBATCH --job-name=admix
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 7-00:00:00
#SBATCH --error=admix_ins.err
#SBATCH --output=admix_ins.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

# Directory containing the modified .qopt files
input_dir="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/ADX/"
output_dir="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/combined/"
mkdir -p $output_dir

# Loop over K values
for K in 1 2 3 4 5 6 7 8 9 10; do
  # Initialize an empty file for the combined data
  output_file="$output_dir/whale_k${K}_combined.csv"
  echo "" > $output_file

  # Add headers to the combined file (assuming 4 clusters for K=4)
  echo "Cluster1,Cluster2,Cluster3,Cluster4,POP,Order" > $output_file

  # Get the number of individuals by reading the first file
  first_file="$input_dir/admix_K${K}_run1.qopt"
  num_individuals=$(wc -l < $first_file)

  # Loop over each individual
  for ((i=1; i<=$num_individuals; i++)); do
    # Loop over the runs
    for run in {1..20}; do
      input_file="$input_dir/admix_K${K}_run${run}.qopt"

      # Check if the file exists
      if [ -f "$input_file" ]; then
        # Extract the line corresponding to the current individual and append it to the combined file
        sed -n "${i}p" "$input_file" >> $output_file
      else
        echo "File $input_file does not exist."
      fi
    done
  done
done

###get log likelihoods for deltaK
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

# Directory containing the log files
log_dir="/scratch/negishi/allen715/chicken_turtles/admixture/new_admix/ADX/"

# Output file
output_file="log_likelihoods.txt"

# Empty the output file if it exists
#> $output_file

# Loop through all log files in the directory
for log_file in "$log_dir"/*.log; do
  # Extract the run name from the file name
  run_name=$(grep "outfiles=" "$log_file" | sed 's/.*outfiles=//')
  
  # Extract the log likelihood value
  log_likelihood=$(grep "best like=" "$log_file" | sed 's/.*best like=//;s/ after.*//')
  
  # Write the run name and log likelihood value to the output file
  echo "$run_name $log_likelihood" >> $output_file
done
