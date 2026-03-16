library(readxl)
library(rmarkdown)

args <- commandArgs(trailingOnly = TRUE)
metadata_path <- args[1]
srr_id <- args[2]
path_base <- args[3]

# Read the Excel file
#metadata <- read_metadata(excel_path)
sheet_names <- excel_sheets(metadata_path)
metadata <- lapply(sheet_names, function(s) read_excel(metadata_path, sheet = s))
names(metadata) <- sheet_names

samples_df <- metadata$Samples
i <- which(samples_df$sample_alternate_name == srr_id)
sample_id <- as.character(samples_df$sample_name[i])
subject_id <- as.character(samples_df$subject_name[i])

data_files_df <- metadata$`Data Files`
j <- which(data_files_df$sample_name == sample_id)

# path_base <- file.path("/home", "ajy28", "palmer_scratch", "terzoli_dataset")
ig_tr_file <- file.path(path_base, "pipeline", "Seurat Pipeline", "resources", "QC_features_meta_human_v112.rds")
metadata_file <- basename(metadata_path)
p10x_file <- as.character(data_files_df$file_path[j])
output_dir <- file.path(path_base, "processed_files", subject_id, srr_id)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

# Set CRAN Mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))
  
# Debugging p10x_file location
print(p10x_file)

# Render the R Markdown document
rmarkdown::render(file.path(path_base, "pipeline", "Seurat Pipeline", "single-cell-processing.rmd"), 
                  output_file = file.path(output_dir, paste0("output_", sample_id, ".html")),
                  params = list(
                    path_base = path_base,
                    data_root = "data",
                    data_id = srr_id,
                    sample_id = sample_id,
                    subject_id = subject_id,
                    metadata_file = metadata_file,
                    ig_tr_file = ig_tr_file,
                    p10x_file = p10x_file,
                    min.features = 200,
                    min.cells = 5,
                    max.mitocondrial.percentage = 20,
                    is.multi.processed = FALSE
                    ),
                  envir = new.env()
                  )
