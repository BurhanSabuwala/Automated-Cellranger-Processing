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

# List of SRR IDs
SRR_LIST="SRR14219617 SRR14219618 SRR14219619 SRR14219620 SRR14219621 SRR14219622 SRR14219623 SRR14219624"

# Iterate over each SRR ID and submit cellranger count job
for SRR_ID in $SRR_LIST; do
    sbatch --export=SRR_ID="$SRR_ID" --job-name=cellranger_cnt_$SRR_ID --output=cellranger_$SRR_ID.out --error=cellranger_$SRR_ID.err cellranger_count_job.sh
done
