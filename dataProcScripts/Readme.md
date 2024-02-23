# Data Processing Workflow

This document outlines the workflow for processing sequencing data from SRA files to Cell Ranger output.

1. **Compile Data**: Aggregate necessary information into a CSV file to guide the download and processing of SRA files.

2. **Prefetch SRA Files**: Utilize the SRA Toolkit's `prefetch` command to download the SRA files specified in the CSV.

3. **Run fastq-dump**: Convert SRA files to FASTQ format using `fastq-dump`.

4. **Generate multi_config.csv**: Prepare a CSV file required by Cell Ranger to identify libraries and samples for processing.

5. **Run Cellranger**: Execute the Cell Ranger pipeline to analyze the FASTQ files, producing outputs such as gene expression matrices.

6. **Secure Data**: Copy the Cell Ranger output to a secure, specified location for long-term storage.

7. **Clean Workspace**: Remove the FASTQ and intermediate files from the work directory to conserve space.
