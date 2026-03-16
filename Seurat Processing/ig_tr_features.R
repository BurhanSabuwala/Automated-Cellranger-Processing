# -------------------------------------
# Author(s): Ed Lee
# Date Created: 2022-09
# Last Updated: 2024-05-10
#
# Title: AIRR Features from Ensembl
# Description: This code shows how to create the Rdata object commonly used in
#              analyses to remove IG/TR genes from GEX data (so they are not
#              double counted)
#
# Notes:
#   * See the "filter-features" code chunk in "notebooks/general_qc.Rmd" for a
#     usage example
#   * We typically use version 93 in the lab
#
# Credit to:
#   * Hailong for modifying the script to work for multiple genomes
#   * Edel for standardization/styling and minor additions
# -------------------------------------
# make sure the environment is clear of user objects
# note that custom set working directories, loaded libraries, etc. will be unaffected
# you may need to fully restart R for reproducibility
rm(list = ls())

# list (and install if needed) CRAN packages
packages <- c("tidyverse")
new_pkg <- packages[!(packages %in% installed.packages())]
if (length(new_pkg)) {install.packages(new_pkg)}

# list (and install if needed) Bioconductor packages
packages_additional <- c("biomaRt")
new_pkg_additional <- packages_additional[!(packages_additional %in% installed.packages())]
if (length(new_pkg_additional)) {BiocManager::install(new_pkg_additional)}

# load packages
packages <- sort(append(packages, packages_additional)) # so the list of versions will be in order
for (n in seq_along(packages)) {
  suppressPackageStartupMessages(library(packages[n], character.only = TRUE))
  cat(paste0(packages[n], ": ", packageVersion(packages[n]), "\n")) # print simplified package versions
}

# remove unnecessary variables
rm(n, new_pkg, new_pkg_additional, packages, packages_additional)
# -------------------------------------

# define your species and genome of interest (use listDatasets below for other choices)
species <- "mouse" # or "human"
genome <- "mmusculus" # or "hsapiens"

# get the current version
current_version <- listEnsemblArchives() %>%
  dplyr::filter(current_release == "*") %>%
  pull(name)
cat(paste("The current version is:", current_version))
current_version <- str_split(current_version, " ")[[1]][2] # just the number

# search Ensembl's datasets
listEnsembl() # as of 2/6/24 dbplyr v2.4.0 breaks this. Use version 2.3.4 (last release before 2.4.0)
# devtools::install_version("dbplyr", version = "2.3.4")
ensembl <- useEnsembl(biomart = "genes", mirror = "useast") # change mirror as desired
datasets <- listDatasets(ensembl)
searchDatasets(mart = ensembl, pattern = genome)
ensembl <- useDataset(dataset = paste0(genome, "_gene_ensembl"), mart = ensembl)

# filter for the features of interest
filters <- listFilters(ensembl)
attributes <- listAttributes(ensembl)
attributes <-  dplyr::filter(attributes, name %in% c("ensembl_gene_id",
                                                     "external_gene_name",
                                                     "gene_biotype",
                                                     "hgnc_symbol",
                                                     "description") &
                               page == "feature_page")

# known biotypes
tr_ig_biotypes <- c("TR_C_gene", "TR_D_gene",
                    "TR_J_gene", "TR_J_pseudogene",
                    "TR_V_gene", "TR_V_pseudogene",
                    "IG_C_gene", "IG_C_pseudogene",
                    "IG_D_gene", "IG_D_pseudogene",
                    "IG_J_gene", "IG_LV_gene", "IG_pseudogene",
                    "IG_V_gene", "IG_V_pseudogene")

features_meta <- getBM(attributes = c("ensembl_gene_id",
                                      "external_gene_name",
                                      "gene_biotype",
                                      "hgnc_symbol",
                                      "description"),
                       filters = 'biotype',
                       values = tr_ig_biotypes,
                       mart = ensembl)

# save the file (change as needed)
file_name <- paste0("QC_features_meta_", species, "_v", current_version, ".rds")
write_rds(features_meta, file = file.path("~", "Research", "pipeline", "Seurat Processing", "resources", file_name))
