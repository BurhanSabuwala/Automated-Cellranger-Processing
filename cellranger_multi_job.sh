#!/bin/bash
#SBATCH --job-name=cellranger_multi_$TIMEPOINT
#SBATCH --output=cellranger_$TIMEPOINT.out
#SBATCH --error=cellranger_$TIMEPOINT.err
#SBATCH --time=23:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH --partition=day

# Load the Cell Ranger module
module load CellRanger/7.0.1

# Change to the folder containing the fastq files
cd "$FILE_LOCATION"

# Construct the path to the multi config file
MULTI_CONFIG_PATH="${MULTI_CONFIG_DIR}/multi_config_${TIMEPOINT}.csv"

# Run Cell Ranger multi for the current timepoint
cellranger multi --id="cell_ranger_${TIMEPOINT// /_}" \
                 --csv=$MULTI_CONFIG_PATH \
                 --localcores=$SLURM_CPUS_PER_TASK \
                 --localmem=$SLURM_MEM_PER_NODE
