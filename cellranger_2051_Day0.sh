#!/bin/bash
#SBATCH --job-name=Subj2051_Day0
#SBATCH --output=Subj2051_Day0_%j.out
#SBATCH --error=Subj2051_Day0_%j.err
#SBATCH --time=2-00:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=3
#SBATCH --partition=pi_kleinstein

set -euo pipefail
# Load the Cell Ranger module
module load CellRanger/7.0.1

# Change to the directory with your input data
cd /vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2051

# Run Cell Ranger count or other commands
cellranger multi --id=Day0-run1\
		 --csv=/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2051/multi_configs/multi_config_Day0.csv
