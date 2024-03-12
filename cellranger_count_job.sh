#!/bin/bash
#SBATCH --job-name=cellranger_cnt_$SRR_ID
#SBATCH --output=cellranger_$SRR_ID.out
#SBATCH --error=cellranger_$SRR_ID.err
#SBATCH --time=23:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH --partition=day

# Load the Cell Ranger module
module load CellRanger/7.0.1

# Change to the directory with your input data
cd /vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2049

# Run Cell Ranger count for the current SRR ID
cellranger count --id="cell_ranger_$SRR_ID" \
                 --transcriptome=/gpfs/gibbs/data/genomes/10xgenomics/refdata-gex-GRCh38-2020-A \
                 --fastqs="$SRR_ID" \
                 --sample="$SRR_ID" \
                 --localcores=$SLURM_CPUS_PER_TASK \
                 --localmem=$SLURM_MEM_PER_NODE
