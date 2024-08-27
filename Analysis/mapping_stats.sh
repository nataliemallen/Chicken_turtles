#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 6-00:00:00
#SBATCH --job-name=stats
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load biocontainers
module load samtools

# Directory containing BAM files
cd /scratch/negishi/allen715/chicken_turtles/final_bams/

# Initialize variables for averages
total_breadth=0
total_depth=0
total_mapping_rate=0
file_count=0

# Create a file for the statistics
echo -e "File\tBreadth\tDepth\tMapping Rate" > stats.txt

# Loop over each .bam file
for file in *_filt.bam
do
  # Increment the file count
  file_count=$((file_count+1))

  # Calculate breadth
  breadth=$(samtools depth -a $file | awk '{c++; if($3>0) total+=1} END {print (total/c)*100}')
  total_breadth=$(echo "$total_breadth + $breadth" | bc)

  # Calculate depth
  depth=$(samtools depth $file | awk '{sum+=$3; cnt++} END {print sum/cnt}')
  total_depth=$(echo "$total_depth + $depth" | bc)

  # Calculate mapping rate
  mapping_rate=$(samtools flagstat $file | grep 'mapped (' | cut -d '(' -f 2 | cut -d ':' -f 1)
  total_mapping_rate=$(echo "$total_mapping_rate + $mapping_rate" | bc)

  # Write the statistics to the file
  echo -e "$file\t$breadth\t$depth\t$mapping_rate" >> stats.txt
done

# Calculate averages
avg_breadth=$(echo "$total_breadth / $file_count" | bc -l)
avg_depth=$(echo "$total_depth / $file_count" | bc -l)
avg_mapping_rate=$(echo "$total_mapping_rate / $file_count" | bc -l)

# Print averages
echo "Average Breadth: $avg_breadth"
echo "Average Depth: $avg_depth"
echo "Average Mapping Rate: $avg_mapping_rate"
