# Codes for processing single cell files through cellranger

The processing steps are shown in the image below: 

![Pipeline](/execution_DARPA_AIM.png)

To run the pipeline:

[To do: I will write a script to generate the srasheet_Subjxxxx.csv from the lab metaDataTemplate.xlsx]

**Step 1:** Generate the srasheet_Subjxxxx.csv file. Some example files are 'srasheet_Subj2049.csv', 'srasheet_Subj2047.csv'

**Step 2:** Modify the fastqdumper_xxxx.sh file to the appropriate directories and point to the appropriate srasheet_Subjxxxx.csv sheet. Run the fastqdumper_xxxx.sh

Note: You might want to check if the right files are being renamed to R1, R2, L1, etc. before running cellranger. As a thumb rule, the files with the largest size often tends to be R2 followed by R1.

This step will prefetch, run fastq-dump and rename the files. 

**Step 3:** Run generate_multi_configcsv.py in the appropriate folder containing the srasheet_Subjxxxx.csv file. This file will generate the multi_config.csv file required for running cellranger multi.

Note1: The current generate_multi_confgcsv.py assumes CITE-seq data. If you intend to add more modalities, make sure to make the appropriate changes or ask Burhan.

Note2: This step is not required if you intend to use cellranger count for gene expression data only.


See **Step 4a** for running cellranger count and **Step 4b** for celranger multi.


**Step 4a:** Run cellranger_submitter_xxxx.sh with appropriate changes in specifying the srasheet csv file and cd into the appropriate location in the drive.

**Step 5a:** Run cellranger_multi_submitter_xxxx.sh with appropriate changes in specifying the srasheet csv file, location of the multiconfig files generated in step 3 and the cd into the appropriate location in the drive. The corresponding file is under development.
