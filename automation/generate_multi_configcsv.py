import pandas as pd
import os

# Load the uploaded CSV file with SRA IDs and timepoints
file_path = '/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2047/srasheet_Subj2047.csv'
df = pd.read_csv(file_path)

# Base directory where the CSV files will be saved
output_dir = '/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2047/multi_configs'
os.makedirs(output_dir, exist_ok=True)

# Template for the CSV content, excluding the libraries section which will be generated dynamically
csv_template_header = """[gene-expression]
reference,/gpfs/gibbs/data/genomes/10xgenomics/refdata-gex-GRCh38-2020-A
chemistry,SC3Pv3

[libraries]
fastq_id,fastqs,feature_types
"""

csv_template_footer = """
[feature]
reference,/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/scripts/TotalSeq_A_Human_Universal_Cocktail_399907_Antibody_reference_UMI_counting.csv
"""

# Function to create multi-config CSV content for a given timepoint
def create_multi_config_content(gex_sra, adt_sra):
    libraries_section = ""
    if pd.notna(gex_sra):
        libraries_section += f"{gex_sra},/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2047/{gex_sra},Gene Expression\n"
    if pd.notna(adt_sra):
        libraries_section += f"{adt_sra},/vast/palmer/scratch/kleinstein/bhs27/compendium/SRP314557/Subject2047/{adt_sra},Antibody Capture\n"
    return csv_template_header + libraries_section + csv_template_footer

# Generate a CSV file for each timepoint
for timepoint, group in df.groupby('timepoint'):
    output_csv_path = os.path.join(output_dir, f'multi_config_{timepoint}.csv')
    with open(output_csv_path, 'w') as file:
        content = create_multi_config_content(group['GEX'].values[0], group['ADT'].values[0])
        file.write(content)

print(f'CSV files generated in {output_dir}.')