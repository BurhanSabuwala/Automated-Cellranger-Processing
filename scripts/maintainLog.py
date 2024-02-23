import subprocess
import os
import datetime
import pandas as pd

# Paths and filenames
csv_file_path = '/path/to/srasheet_Subj2051.csv'
log_file_path = '/path/to/pipeline_log.txt'
base_results_dir = '/path/to/results'
base_work_dir = '/path/to/work'

# Function to log messages
def log_message(message):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    full_message = f"{timestamp} - {message}\n"
    with open(log_file_path, 'a') as log_file:
        log_file.write(full_message)
    print(full_message, end='')

# Function to run a command and log its output
def run_command(command, stage, sra_id):
    log_message(f"Starting {stage} for {sra_id}")
    try:
        subprocess.run(command, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        log_message(f"Completed {stage} for {sra_id}")
    except subprocess.CalledProcessError as e:
        log_message(f"Error during {stage} for {sra_id}: {e}")

# Load SRA IDs from CSV
df = pd.read_csv(csv_file_path)

# Main process function
def process_sra_ids():
    for index, row in df.iterrows():
        sra_ids = [row['GEX'], row['ADT']]  # Assuming these are the columns with SRA IDs
        timepoint = row['timepoint']

        # Generate multi-config.csv for each timepoint
        # Implementation depends on your specific CSV format requirements

        for sra_id in sra_ids:
            work_dir = os.path.join(base_work_dir, sra_id)
            results_dir = os.path.join(base_results_dir, timepoint, sra_id)
            os.makedirs(work_dir, exist_ok=True)
            os.makedirs(results_dir, exist_ok=True)

            # Prefetch
            command = f"prefetch {sra_id}"
            run_command(command, "prefetch", sra_id)

            # fastq-dump
            command = f"fastq-dump --split-files --origfmt --gzip --outdir {work_dir} {work_dir}/{sra_id}.sra"
            run_command(command, "fastq-dump", sra_id)

            # Cell Ranger
            # Replace <your_multi_config.csv> with the path to your config file
            command = f"cellranger multi --id={sra_id} --csv=<your_multi_config.csv> --fastqs={work_dir}"
            run_command(command, "cellranger", sra_id)

            # Copy results
            # Adjust paths as necessary based on cellranger output structure
            #command = f"cp -r {work_dir}/{sra_id}/outs {results_dir}"
            #run_command(command, "copy results", sra_id)

            # Delete work directory
            #command = f"rm -rf {work_dir}"
            #run_command(command, "delete work directory", sra_id)

if __name__ == "__main__":
    process_sra_ids()
