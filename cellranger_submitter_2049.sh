#!/bin/bash
#SBATCH --job-name=cellranger_submitter
#SBATCH --output=cellranger_submitter_%j.out
#SBATCH --error=cellranger_submitter_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2
#SBATCH --partition=pi_kleinstein

# Note: For subject 2049, we only have gene expression data. Therefore, this script is only intended to run cellranger count.

# Load the Cell Ranger module
module load CellRanger/7.0.1

# Path to the CSV files with SRA IDs
SRA_SHEET="/path/to/srasheet_Subj2049.csv

# Read SRA IDs from the CSV file into a variable
SRR_LIST=$(awk -F ',' 'NR>1 {print $2}' $SRA_SHEET)

# Iterate over each SRR ID and submit cellranger count job
for SRR_ID in $SRR_LIST; do
    sbatch --export=SRR_ID="$SRR_ID" --job-name=cellranger_cnt_$SRR_ID --output=cellranger_$SRR_ID.out --error=cellranger_$SRR_ID.err cellranger_count_job.sh
done
