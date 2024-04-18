#!/bin/bash
#SBATCH --job-name=cellranger_submitter
#SBATCH --output=cellranger_submitter_%j.out
#SBATCH --error=cellranger_submitter_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=2
#SBATCH --partition=pi_kleinstein

# Load the Cell Ranger module
module load CellRanger/7.0.1

# Location of the CSV file and multi_configs directory
FILE_LOCATION="/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2052/"
CSV_FILE="/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2052/srasheet_Subj2052.csv"
MULTI_CONFIG_DIR="/vast/palmer/home.mccleary/bhs27/palmer_scratch/compendium/SRP314557/Subject2052/multi_configs/"

# Read each line of the CSV file
tail -n +2 $CSV_FILE | while IFS=',' read -r timepoint gex adt; do
    # Construct the job name from the timepoint
    JOB_NAME="cellranger_multi_${timepoint// /_}"

    # Submit the job, passing necessary variables
    sbatch --export=TIMEPOINT="$timepoint",GEX="$gex",ADT="$adt",MULTI_CONFIG_DIR="$MULTI_CONFIG_DIR",FILE_LOCATION="$FILE_LOCATION" \
           --job-name=$JOB_NAME \
           --output=${JOB_NAME}.out \
           --error=${JOB_NAME}.err \
           cellranger_multi_job.sh
done
