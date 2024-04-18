#!/bin/bash
#SBATCH --job-name=run-fastq
#SBATCH --output=fastqdumper_%j.out
#SBATCH --error=fastqdumper_%j.err
#SBATCH --time=6-00:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=3
#SBATCH --partition=week

# Set shell options
set -euo pipefail

# Load and activate miniconda environment
module load miniconda
conda activate sratoolkit

# cd to the correct directory
cd /vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2055

# CSV file path as command-line argument
CSV_FILE="/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2055/srasheet_Subj2055.csv"

# Base directory for the results
RESULTS_DIR="results"
mkdir -p "$RESULTS_DIR"

# Log file
LOG_FILE="$RESULTS_DIR/log.txt"

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

log_message "Starting script"

# Function to process each SRA ID
process_sra_id() {
    local sra_id=$1

    log_message "Processing $sra_id"    

    # Download dataset
    log_message "Downloading dataset for $sra_id"
    prefetch "$sra_id"

    log_message "Downloading completed for $sra_id"

    fastq-dump --split-files --origfmt --outdir "${sra_id}" "${sra_id}/${sra_id}.sra"

    mv "${sra_id}/${sra_id}_1.fastq" "${sra_id}/${sra_id}_S1_L001_L1_001.fastq"
    mv "${sra_id}/${sra_id}_2.fastq" "${sra_id}/${sra_id}_S1_L001_R1_001.fastq"
    mv "${sra_id}/${sra_id}_3.fastq" "${sra_id}/${sra_id}_S1_L001_R2_001.fastq"

    log_message "Fastq-dump completed for $sra_id"
}

# Read SRA IDs from the CSV file and process them
tail -n +2 "$CSV_FILE" | while IFS=, read -r timepoint gex adt; do
    process_sra_id "$gex" || { log_message "Processing failed for $gex"; exit 1; }
    process_sra_id "$adt" || { log_message "Processing failed for $adt"; exit 1; }
done

log_message "All SRA IDs have been processed."
