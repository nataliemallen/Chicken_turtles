#!/bin/bash
#SBATCH --job-name=fst
#SBATCH -A highmem
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 1-00:00:00
#SBATCH --error=admix_ins.err
#SBATCH --output=admix_ins.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=allen715@purdue.edu

module load biocontainers
module load angsd

#!/bin/bash

# List of site identifiers
sites=("alazan" "brazoria" "brazos" "buller" "gordy" "liberty" "warren" "wharton")

# Initialize the Fst matrix
declare -A fst_matrix

# Loop through each pair of sites
for ((i=0; i<${#sites[@]}; i++)); do
    for ((j=i; j<${#sites[@]}; j++)); do
        if [ $i -eq $j ]; then
            # Diagonal elements (same site comparison) are zero
            fst_matrix[$i,$j]=0
        else
            # Read the first number (weighted Fst) from the .fst.txt file
            fst_value=$(awk -F '\t' '{print $1}' ${sites[$i]}_${sites[$j]}_fst.txt)
            fst_matrix[$i,$j]=$fst_value
            fst_matrix[$j,$i]=$fst_value
        fi
    done
done

# Output CSV file
output_file="fst_matrix.csv"

# Print the header
{
    echo -n ","
    for site in "${sites[@]}"; do
        echo -n "$site,"
    done
    echo

    # Print the Fst matrix
    for ((i=0; i<${#sites[@]}; i++)); do
        echo -n "${sites[$i]},"
        for ((j=0; j<${#sites[@]}; j++)); do
            if [ $j -eq $((${#sites[@]}-1)) ]; then
                echo -n "${fst_matrix[$i,$j]}"
            else
                echo -n "${fst_matrix[$i,$j]},"
            fi
        done
        echo
    done
} > "$output_file"


# # List of site identifiers
# sites=("alazan" "brazoria" "brazos" "buller" "gordy" "liberty" "warren" "wharton")
# 
# # Initialize the Fst matrix
# declare -A fst_matrix
# 
# # Loop through each pair of sites
# for ((i=0; i<${#sites[@]}; i++)); do
#     for ((j=i; j<${#sites[@]}; j++)); do
#         if [ $i -eq $j ]; then
#             # Diagonal elements (same site comparison) are zero
#             fst_matrix[$i,$j]=0
#         else
#             # Read the first number (weighted Fst) from the .fst.txt file
#             fst_value=$(awk -F '\t' '{print $1}' ${sites[$i]}_${sites[$j]}_fst.txt)
#             fst_matrix[$i,$j]=$fst_value
#             fst_matrix[$j,$i]=$fst_value
#         fi
#     done
# done
# 
# # Print the Fst matrix
# for ((i=0; i<${#sites[@]}; i++)); do
#     for ((j=0; j<${#sites[@]}; j++)); do
#         printf "%s\t" "${fst_matrix[$i,$j]}"
#     done
#     printf "\n"
# done


# # Initialize the FST matrix file
# echo "alazan,brazoria,brazos,buller,gordy,liberty,warren,wharton" > FST_matrix.csv
# 
# # Loop through each site to fill the FST matrix
# for ((i=0; i<${#sites[@]}; i++)); do
#     site1=${sites[$i]}
#     line="$site1"
#     for ((j=0; j<${#sites[@]}; j++)); do
#         if [ $i -eq $j ]; then
#             line+=",0"
#         elif [ $i -lt $j ]; then
#             site2=${sites[$j]}
#             fst_value=$(cat ${site1}_${site2}_fst.txt | grep -oP '(?<=global Fst estimate: )\S+')
#             line+=",${fst_value}"
#         else
#             site2=${sites[$j]}
#             fst_value=$(cat ${site2}_${site1}_fst.txt | grep -oP '(?<=global Fst estimate: )\S+')
#             line+=",${fst_value}"
#         fi
#     done
#     echo $line >> FST_matrix.csv
# done
