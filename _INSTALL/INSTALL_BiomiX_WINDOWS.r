
print("looking for the BiomiX_folder")

find_folder <- function(folder_name, depth = 5) {
        # Get the root directory
        root <- normalizePath("/")
        
        # Recursive function to search for the folder within the specified depth
        search_folder <- function(directory, current_depth) {
                if (current_depth <= depth) {
                        files <- list.files(directory, full.names = TRUE)
                        
                        matching_folders <- files[file.info(files)$isdir & basename(files) == folder_name]
                        
                        if (length(matching_folders) > 0) {
                                return(matching_folders[1])
                        } else {
                                subdirectories <- files[file.info(files)$isdir]
                                for (subdir in subdirectories) {
                                        result <- search_folder(subdir, current_depth + 1)
                                        if (!is.null(result)) {
                                                return(result)
                                        }
                                }
                        }
                }
                return(NULL)
        }
        
        # Call the recursive function starting from the root directory
        found_folder <- search_folder(root, 1)
        
        # Return the path to the matching folder (if found)
        if (!is.null(found_folder)) {
                return(found_folder)
        } else {
                return(NULL)
        }
}


#tot<-find_folder("BiomiX2.2")
#setwd(tot)


print("R Package checking..")
print("getwd()")

chooseCRANmirror(48, ind = TRUE)


getPackages <- function(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL") {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Initialize a list to store package strings for each package
  package_strings_list <- list()
  
  # Get package dependencies for each input package
  for (pack in packs) {
    # Get package dependencies
    dependencies <- unlist(
      tools::package_dependencies(pack, available.packages(), which = c("Depends", "Imports"), recursive = TRUE)
    )
    
    # Add the package itself to the dependencies
    dependencies <- union(pack, dependencies)
    
    # Remove dependencies that have already been processed
    dependencies <- setdiff(dependencies, unlist(package_strings_list))
    
    # Download the packages
    download.packages(dependencies, destdir = output_dir, type = "win.binary", quiet = TRUE)
    
    # List downloaded packages
    downloaded_files <- list.files(output_dir, pattern = "\\.zip$", full.names = TRUE)
    
    # Loop through each downloaded package and create the required string
    package_strings <- character()
    for (file_path in downloaded_files) {
      package_name <- tools::file_path_sans_ext(basename(file_path))
      version <- gsub(".*_([0-9.]+)\\.zip$", "\\1", package_name)
      
      # Construct the filename
      filename <- paste0(package_name, ".zip")
      
      # Construct the all.packages string
      package_string <- paste0('install.packages("', filename, '", repos=NULL, type="source")')
      package_strings <- c(package_strings, package_string)
    }
    
    # Store the package strings for the current package
    package_strings_list[[pack]] <- package_strings
    
    # Write the package strings to a file
    output_file <- file.path(output_dir, paste0(pack, "_packages.txt"))
    writeLines(package_strings, con = output_file)
  }
  
  return(package_strings_list)
}



packs <- c("httr2","devtools","vroom","lava","recipes", "dplyr","future.apply","stringr","circlize","ggplot2",
"ggrepel", "enrichR","rlist","tidyverse","data.table","caret","reticulate","XML","xml2","rentrez","remotes", "GGally",
"ggpubr","BiocManager", "htmltools", "ncdf4", "igraph")

#all_packages <- getPackages(packs)



getPackages <- function(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL") {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Initialize a list to store package strings for each package
  package_strings_list <- list()
  
  # Get package dependencies for each input package
  for (pack in packs) {
    # Install the package
    BiocManager::install(pack)
    
    # Get the installed package details
    pkg_details <- BiocManager::available()[[1]]
    
    # Get the package dependencies
    dependencies <- pkg_details$Depends
    if (!is.null(pkg_details$Imports)) {
      dependencies <- c(dependencies, pkg_details$Imports)
    }
    
    # Construct the all.packages strings for each dependency
    package_strings <- lapply(dependencies, function(dep) {
      package_string <- paste0('install.packages("', dep, '", repos = NULL, type = "source")')
      return(package_string)
    })
    
    # Store the package strings for the current package
    package_strings_list[[pack]] <- package_strings
    
    # Write the package strings to a file
    output_file <- file.path(output_dir, paste0(pack, "_packages.txt"))
    writeLines(unlist(package_strings), con = output_file)
  }
  
  return(package_strings_list)
}


# Define your packages
packs <- c("DESeq2", "ComplexHeatmap","TxDb.Hsapiens.UCSC.hg19.knownGene","IlluminaHumanMethylationEPICanno.ilm10b4.hg19",
"ChAMP","MOFA2","MSnbase","Rdisop")

# Call the function to generate separate output files for each package
#package_strings_list <- getPackages(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL")

getPackages <- function(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL") {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Initialize a list to store package strings for each package
  package_strings_list <- list()
  
  # Get package dependencies for each input package
  for (pack in packs) {
    # Get package dependencies
    dependencies <- unlist(
      tools::package_dependencies(pack, available.packages(), which = c("Depends", "Imports"), recursive = TRUE)
    )
    
    # Add the package itself to the dependencies
    dependencies <- union(pack, dependencies)
    
    # Remove dependencies that have already been processed
    dependencies <- setdiff(dependencies, unlist(package_strings_list))
    
    # Download the packages
    download.packages(dependencies, destdir = output_dir, type = "win.binary", quiet = TRUE)
    
    # List downloaded packages
    downloaded_files <- list.files(output_dir, pattern = "\\.zip$", full.names = TRUE)
    
    # Loop through each downloaded package and create the required string
    package_strings <- character()
    for (file_path in downloaded_files) {
      package_name <- tools::file_path_sans_ext(basename(file_path))
      version <- gsub(".*_([0-9.]+)\\.zip$", "\\1", package_name)
      
      # Construct the filename
      filename <- paste0(package_name, ".zip")
      
      # Construct the all.packages string
      package_string <- paste0('install.packages("', filename, '", repos=NULL, type="source")')
      package_strings <- c(package_strings, package_string)
    }
    
    # Store the package strings for the current package
    package_strings_list[[pack]] <- package_strings
    
    # Write the package strings to a file
    output_file <- file.path(output_dir, paste0(pack, "_packages.txt"))
    writeLines(package_strings, con = output_file)
  }
  
  return(package_strings_list)
}



packs <- c("httr2","devtools","vroom","lava","recipes", "dplyr","future.apply","stringr","circlize","ggplot2",
"ggrepel", "enrichR","rlist","tidyverse","data.table","caret","reticulate","XML","xml2","rentrez","remotes", "GGally",
"ggpubr","BiocManager", "htmltools", "ncdf4", "igraph")

#all_packages <- getPackages(packs)



getPackages <- function(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL") {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Initialize a list to store package strings for each package
  package_strings_list <- list()
  
  # Get package dependencies for each input package
  for (pack in packs) {
    # Install the package
    BiocManager::install(pack)
    
    # Get the installed package details
    pkg_details <- BiocManager::available()[[1]]
    
    # Get the package dependencies
    dependencies <- pkg_details$Depends
    if (!is.null(pkg_details$Imports)) {
      dependencies <- c(dependencies, pkg_details$Imports)
    }
    
    # Construct the all.packages strings for each dependency
    package_strings <- lapply(dependencies, function(dep) {
      package_string <- paste0('install.packages("', dep, '", repos = NULL, type = "source")')
      return(package_string)
    })
    
    # Store the package strings for the current package
    package_strings_list[[pack]] <- package_strings
    
    # Write the package strings to a file
    output_file <- file.path(output_dir, paste0(pack, "_packages.txt"))
    writeLines(unlist(package_strings), con = output_file)
  }
  
  return(package_strings_list)
}


# Define your packages
packs <- c("DESeq2", "ComplexHeatmap","TxDb.Hsapiens.UCSC.hg19.knownGene","IlluminaHumanMethylationEPICanno.ilm10b4.hg19",
"ChAMP","MOFA2","MSnbase","Rdisop")

# Call the function to generate separate output files for each package
#package_strings_list <- getPackages(packs, output_dir = "C:/Users/Utente/Desktop/BiomiX2.2/_INSTALL")

install.packages("abind_1.4-5.zip", repos=NULL, type="source")
install.packages("askpass_1.1.zip", repos=NULL, type="source")
install.packages("backports_1.4.1.zip", repos=NULL, type="source")
install.packages("base64enc_0.1-3.zip", repos=NULL, type="source")
install.packages("BiocManager_1.30.20.zip", repos=NULL, type="source")
install.packages("bit_4.0.5.zip", repos=NULL, type="source")
install.packages("bit64_4.0.5.zip", repos=NULL, type="source")
install.packages("blob_1.2.4.zip", repos=NULL, type="source")
install.packages("boot_1.3-28.1.zip", repos=NULL, type="source")
install.packages("brew_1.0-8.zip", repos=NULL, type="source")
install.packages("brio_1.1.3.zip", repos=NULL, type="source")
install.packages("broom.helpers_1.13.0.zip", repos=NULL, type="source")
install.packages("broom_1.0.4.zip", repos=NULL, type="source")
install.packages("bslib_0.4.2.zip", repos=NULL, type="source")
install.packages("cachem_1.0.7.zip", repos=NULL, type="source")
install.packages("callr_3.7.3.zip", repos=NULL, type="source")
install.packages("car_3.1-2.zip", repos=NULL, type="source")
install.packages("carData_3.0-5.zip", repos=NULL, type="source")
install.packages("caret_6.0-94.zip", repos=NULL, type="source")
install.packages("cellranger_1.1.0.zip", repos=NULL, type="source")
install.packages("circlize_0.4.15.zip", repos=NULL, type="source")
install.packages("class_7.3-21.zip", repos=NULL, type="source")
install.packages("cli_3.6.1.zip", repos=NULL, type="source")
install.packages("clipr_0.8.0.zip", repos=NULL, type="source")
install.packages("clock_0.6.1.zip", repos=NULL, type="source")
install.packages("codetools_0.2-19.zip", repos=NULL, type="source")
install.packages("colorspace_2.1-0.zip", repos=NULL, type="source")
install.packages("commonmark_1.9.0.zip", repos=NULL, type="source")
install.packages("conflicted_1.2.0.zip", repos=NULL, type="source")
install.packages("corrplot_0.92.zip", repos=NULL, type="source")
install.packages("cowplot_1.1.1.zip", repos=NULL, type="source")
install.packages("crayon_1.5.2.zip", repos=NULL, type="source")
install.packages("credentials_1.3.2.zip", repos=NULL, type="source")
install.packages("curl_5.0.0.zip", repos=NULL, type="source")
install.packages("data.table_1.14.8.zip", repos=NULL, type="source")
install.packages("DBI_1.2.2.zip", repos=NULL, type="source")
install.packages("dbplyr_2.3.2.zip", repos=NULL, type="source")
install.packages("desc_1.4.2.zip", repos=NULL, type="source")
install.packages("devtools_2.4.5.zip", repos=NULL, type="source")
install.packages("diagram_1.6.5.zip", repos=NULL, type="source")
install.packages("diffobj_0.3.5.zip", repos=NULL, type="source")
install.packages("digest_0.6.31.zip", repos=NULL, type="source")
install.packages("downlit_0.4.2.zip", repos=NULL, type="source")
install.packages("dplyr_1.1.2.zip", repos=NULL, type="source")
install.packages("dtplyr_1.3.1.zip", repos=NULL, type="source")
install.packages("e1071_1.7-13.zip", repos=NULL, type="source")
install.packages("ellipsis_0.3.2.zip", repos=NULL, type="source")
install.packages("enrichR_3.2.zip", repos=NULL, type="source")
install.packages("evaluate_0.20.zip", repos=NULL, type="source")
install.packages("fansi_1.0.4.zip", repos=NULL, type="source")
install.packages("farver_2.1.1.zip", repos=NULL, type="source")
install.packages("fastmap_1.1.1.zip", repos=NULL, type="source")
install.packages("fontawesome_0.5.1.zip", repos=NULL, type="source")
install.packages("forcats_1.0.0.zip", repos=NULL, type="source")
install.packages("foreach_1.5.2.zip", repos=NULL, type="source")
install.packages("fs_1.5.2.zip", repos=NULL, type="source")
install.packages("future.apply_1.10.0.zip", repos=NULL, type="source")
install.packages("future_1.32.0.zip", repos=NULL, type="source")
install.packages("gargle_1.4.0.zip", repos=NULL, type="source")
install.packages("generics_0.1.3.zip", repos=NULL, type="source")
install.packages("gert_1.9.2.zip", repos=NULL, type="source")
install.packages("GGally_2.1.2.zip", repos=NULL, type="source")
install.packages("ggplot2_3.4.2.zip", repos=NULL, type="source")
install.packages("ggpubr_0.6.0.zip", repos=NULL, type="source")
install.packages("ggrepel_0.9.3.zip", repos=NULL, type="source")
install.packages("ggsci_3.0.0.zip", repos=NULL, type="source")
install.packages("ggsignif_0.6.4.zip", repos=NULL, type="source")
install.packages("ggstats_0.3.0.zip", repos=NULL, type="source")
install.packages("gh_1.4.0.zip", repos=NULL, type="source")
install.packages("gitcreds_0.1.2.zip", repos=NULL, type="source")
install.packages("GlobalOptions_0.1.2.zip", repos=NULL, type="source")
install.packages("globals_0.16.2.zip", repos=NULL, type="source")
install.packages("glue_1.6.2.zip", repos=NULL, type="source")
install.packages("googledrive_2.1.0.zip", repos=NULL, type="source")
install.packages("googlesheets4_1.1.0.zip", repos=NULL, type="source")
install.packages("gower_1.0.1.zip", repos=NULL, type="source")
install.packages("gridExtra_2.3.zip", repos=NULL, type="source")
install.packages("gtable_0.3.3.zip", repos=NULL, type="source")
install.packages("hardhat_1.3.0.zip", repos=NULL, type="source")
install.packages("haven_2.5.2.zip", repos=NULL, type="source")
install.packages("here_1.0.1.zip", repos=NULL, type="source")
install.packages("highr_0.10.zip", repos=NULL, type="source")
install.packages("hms_1.1.3.zip", repos=NULL, type="source")
install.packages("htmltools_0.5.5.zip", repos=NULL, type="source")
install.packages("htmlwidgets_1.6.2.zip", repos=NULL, type="source")
install.packages("httpuv_1.6.9.zip", repos=NULL, type="source")
install.packages("httr_1.4.5.zip", repos=NULL, type="source")
install.packages("httr2_0.2.2.zip", repos=NULL, type="source")
install.packages("ids_1.0.1.zip", repos=NULL, type="source")
#install.packages("igraph_1.4.2.zip", repos=NULL, type="source")
install.packages("ini_0.3.1.zip", repos=NULL, type="source")
install.packages("ipred_0.9-14.zip", repos=NULL, type="source")
install.packages("isoband_0.2.7.zip", repos=NULL, type="source")
install.packages("iterators_1.0.14.zip", repos=NULL, type="source")
install.packages("jquerylib_0.1.4.zip", repos=NULL, type="source")
install.packages("jsonlite_1.8.4.zip", repos=NULL, type="source")
install.packages("KernSmooth_2.23-20.zip", repos=NULL, type="source")
install.packages("knitr_1.42.zip", repos=NULL, type="source")
install.packages("labeling_0.4.2.zip", repos=NULL, type="source")
install.packages("labelled_2.11.0.zip", repos=NULL, type="source")
install.packages("later_1.3.0.zip", repos=NULL, type="source")
#install.packages("lattice_0.21-8.zip", repos=NULL, type="source")
install.packages("lava_1.7.2.1.zip", repos=NULL, type="source")
install.packages("lifecycle_1.0.3.zip", repos=NULL, type="source")
install.packages("listenv_0.9.0.zip", repos=NULL, type="source")
install.packages("lme4_1.1-32.zip", repos=NULL, type="source")
install.packages("lubridate_1.9.2.zip", repos=NULL, type="source")
#install.packages("magrittr_2.0.3.zip", repos=NULL, type="source")
install.packages("MASS_7.3-58.3.zip", repos=NULL, type="source")
#install.packages("Matrix_1.5-4.zip", repos=NULL, type="source")
install.packages("MatrixModels_0.5-1.zip", repos=NULL, type="source")
install.packages("memoise_2.0.1.zip", repos=NULL, type="source")
install.packages("mgcv_1.8-42.zip", repos=NULL, type="source")
install.packages("mime_0.12.zip", repos=NULL, type="source")
install.packages("miniUI_0.1.1.1.zip", repos=NULL, type="source")
install.packages("minqa_1.2.5.zip", repos=NULL, type="source")
install.packages("ModelMetrics_1.2.2.2.zip", repos=NULL, type="source")
install.packages("modelr_0.1.11.zip", repos=NULL, type="source")
install.packages("munsell_0.5.0.zip", repos=NULL, type="source")
install.packages("ncdf4_1.21.zip", repos=NULL, type="source")
install.packages("nlme_3.1-162.zip", repos=NULL, type="source")
install.packages("nloptr_2.0.3.zip", repos=NULL, type="source")
install.packages("nnet_7.3-18.zip", repos=NULL, type="source")
install.packages("numDeriv_2016.8-1.1.zip", repos=NULL, type="source")
install.packages("openssl_2.0.6.zip", repos=NULL, type="source")
install.packages("parallelly_1.35.0.zip", repos=NULL, type="source")
install.packages("patchwork_1.1.2.zip", repos=NULL, type="source")
install.packages("pbkrtest_0.5.2.zip", repos=NULL, type="source")
install.packages("pillar_1.9.0.zip", repos=NULL, type="source")
install.packages("pkgbuild_1.4.0.zip", repos=NULL, type="source")
#install.packages("pkgconfig_2.0.3.zip", repos=NULL, type="source")
install.packages("pkgdown_2.0.7.zip", repos=NULL, type="source")
install.packages("pkgload_1.3.2.zip", repos=NULL, type="source")
install.packages("plyr_1.8.8.zip", repos=NULL, type="source")
install.packages("png_0.1-8.zip", repos=NULL, type="source")
install.packages("polynom_1.4-1.zip", repos=NULL, type="source")
install.packages("praise_1.0.0.zip", repos=NULL, type="source")
install.packages("prettyunits_1.1.1.zip", repos=NULL, type="source")
install.packages("pROC_1.18.0.zip", repos=NULL, type="source")
install.packages("processx_3.8.1.zip", repos=NULL, type="source")
install.packages("prodlim_2023.03.31.zip", repos=NULL, type="source")
install.packages("profvis_0.3.7.zip", repos=NULL, type="source")
install.packages("progress_1.2.2.zip", repos=NULL, type="source")
install.packages("progressr_0.13.0.zip", repos=NULL, type="source")
install.packages("promises_1.2.0.1.zip", repos=NULL, type="source")
install.packages("proxy_0.4-27.zip", repos=NULL, type="source")
install.packages("ps_1.7.5.zip", repos=NULL, type="source")
install.packages("purrr_1.0.1.zip", repos=NULL, type="source")
install.packages("quantreg_5.95.zip", repos=NULL, type="source")
install.packages("R6_2.5.1.zip", repos=NULL, type="source")
install.packages("ragg_1.2.5.zip", repos=NULL, type="source")
install.packages("rappdirs_0.3.3.zip", repos=NULL, type="source")
install.packages("rcmdcheck_1.4.0.zip", repos=NULL, type="source")
install.packages("RColorBrewer_1.1-3.zip", repos=NULL, type="source")
install.packages("Rcpp_1.0.10.zip", repos=NULL, type="source")
install.packages("RcppTOML_0.2.2.zip", repos=NULL, type="source")
install.packages("readr_2.1.4.zip", repos=NULL, type="source")
install.packages("readxl_1.4.2.zip", repos=NULL, type="source")
install.packages("recipes_1.0.5.zip", repos=NULL, type="source")
install.packages("rematch_1.0.1.zip", repos=NULL, type="source")
install.packages("rematch2_2.1.2.zip", repos=NULL, type="source")
install.packages("remotes_2.4.2.zip", repos=NULL, type="source")
install.packages("rentrez_1.2.3.zip", repos=NULL, type="source")
install.packages("reprex_2.0.2.zip", repos=NULL, type="source")
install.packages("reshape_0.8.9.zip", repos=NULL, type="source")
install.packages("reshape2_1.4.4.zip", repos=NULL, type="source")
install.packages("reticulate_1.28.zip", repos=NULL, type="source")
install.packages("rjson_0.2.21.zip", repos=NULL, type="source")
#install.packages("rlang_1.1.0.zip", repos=NULL, type="source")
install.packages("rlist_0.4.6.2.zip", repos=NULL, type="source")
install.packages("rmarkdown_2.21.zip", repos=NULL, type="source")
install.packages("roxygen2_7.2.3.zip", repos=NULL, type="source")
install.packages("rpart_4.1.19.zip", repos=NULL, type="source")
install.packages("rprojroot_2.0.3.zip", repos=NULL, type="source")
install.packages("rstatix_0.7.2.zip", repos=NULL, type="source")
install.packages("rstudioapi_0.14.zip", repos=NULL, type="source")
install.packages("rversions_2.1.2.zip", repos=NULL, type="source")
install.packages("rvest_1.0.3.zip", repos=NULL, type="source")
install.packages("sass_0.4.5.zip", repos=NULL, type="source")
install.packages("scales_1.3.0.zip", repos=NULL, type="source")
install.packages("selectr_0.4-2.zip", repos=NULL, type="source")
install.packages("sessioninfo_1.2.2.zip", repos=NULL, type="source")
install.packages("shape_1.4.6.zip", repos=NULL, type="source")
install.packages("shiny_1.7.4.zip", repos=NULL, type="source")
install.packages("sourcetools_0.1.7-1.zip", repos=NULL, type="source")
install.packages("SparseM_1.81.zip", repos=NULL, type="source")
install.packages("SQUAREM_2021.1.zip", repos=NULL, type="source")
install.packages("stringi_1.7.12.zip", repos=NULL, type="source")
install.packages("stringr_1.5.0.zip", repos=NULL, type="source")
install.packages("survival_3.5-5.zip", repos=NULL, type="source")
install.packages("sys_3.4.1.zip", repos=NULL, type="source")
install.packages("systemfonts_1.0.4.zip", repos=NULL, type="source")
install.packages("testthat_3.1.7.zip", repos=NULL, type="source")
install.packages("textshaping_0.3.6.zip", repos=NULL, type="source")
install.packages("tibble_3.2.1.zip", repos=NULL, type="source")
install.packages("tidyr_1.3.0.zip", repos=NULL, type="source")
install.packages("tidyselect_1.2.0.zip", repos=NULL, type="source")
install.packages("tidyverse_2.0.0.zip", repos=NULL, type="source")
install.packages("timechange_0.2.0.zip", repos=NULL, type="source")
install.packages("timeDate_4022.108.zip", repos=NULL, type="source")
install.packages("tinytex_0.45.zip", repos=NULL, type="source")
install.packages("tzdb_0.3.0.zip", repos=NULL, type="source")
install.packages("urlchecker_1.0.1.zip", repos=NULL, type="source")
install.packages("usethis_2.1.6.zip", repos=NULL, type="source")
install.packages("utf8_1.2.3.zip", repos=NULL, type="source")
install.packages("uuid_1.1-0.zip", repos=NULL, type="source")
install.packages("vctrs_0.6.1.zip", repos=NULL, type="source")
install.packages("viridisLite_0.4.1.zip", repos=NULL, type="source")
install.packages("vroom_1.6.1.zip", repos=NULL, type="source")
install.packages("waldo_0.4.0.zip", repos=NULL, type="source")
install.packages("whisker_0.4.1.zip", repos=NULL, type="source")
install.packages("withr_2.5.0.zip", repos=NULL, type="source")
install.packages("WriteXLS_6.4.0.zip", repos=NULL, type="source")
install.packages("xfun_0.39.zip", repos=NULL, type="source")
install.packages("XML_3.99-0.14.zip", repos=NULL, type="source")
install.packages("xml2_1.3.3.zip", repos=NULL, type="source")
install.packages("xopen_1.0.0.zip", repos=NULL, type="source")
install.packages("xtable_1.8-4.zip", repos=NULL, type="source")
install.packages("yaml_2.3.7.zip", repos=NULL, type="source")
install.packages("zip_2.3.0.zip", repos=NULL, type="source")



library("httr2")
library("devtools")
library("vroom")
library("lava")
library("recipes")
library("dplyr")
library("future.apply")
library("stringr")
library("circlize")
library("ggplot2")
library("ggrepel")
library("enrichR")
library("rlist")
library("tidyverse")
library("data.table")
library("caret")
library("reticulate")
library("XML")
library("xml2")
library("rentrez")
library("remotes")
library("GGally")
library("ggpubr")
library("htmltools")
library("ggpubr")
library("ncdf4")
library("igraph")


install.packages("bitops_1.0-7.zip", repos=NULL, type="source")
install.packages("formatR_1.14.zip", repos=NULL, type="source")
install.packages("plogr_0.2.0.zip", repos=NULL, type="source")
install.packages("RCurl_1.98-1.12.zip", repos=NULL, type="source")
install.packages("zlibbioc_1.40.0.zip", repos=NULL, type="source")
install.packages("matrixStats_0.63.0.zip", repos=NULL, type="source")
install.packages("lambda.r_1.2.4.zip", repos=NULL, type="source")
install.packages("futile.options_1.0.1.zip", repos=NULL, type="source")
install.packages("RSQLite_2.3.1.zip", repos=NULL, type="source")
install.packages("KEGGREST_1.34.0.zip", repos=NULL, type="source")
install.packages("XVector_0.34.0.zip", repos=NULL, type="source")
install.packages("Biostrings_2.62.0.zip", repos=NULL, type="source")
install.packages("MatrixGenerics_1.6.0.zip", repos=NULL, type="source")
install.packages("GenomeInfoDb_1.30.1.zip", repos=NULL, type="source")
install.packages("futile.logger_1.4.3.zip", repos=NULL, type="source")
install.packages("snow_0.4-4.zip", repos=NULL, type="source")
install.packages("DelayedArray_0.20.0.zip", repos=NULL, type="source")
install.packages("annotate_1.72.0.zip", repos=NULL, type="source")
install.packages("S4Vectors_0.32.4.zip", repos=NULL, type="source")
install.packages("IRanges_2.28.0.zip", repos=NULL, type="source")
install.packages("AnnotationDbi_1.56.2.zip", repos=NULL, type="source")
install.packages("GenomicRanges_1.46.1.zip", repos=NULL, type="source")
install.packages("BiocGenerics_0.40.0.zip", repos=NULL, type="source")
install.packages("BiocParallel_1.28.3.zip", repos=NULL, type="source")
install.packages("Biobase_2.54.0.zip", repos=NULL, type="source")
install.packages("genefilter_1.76.0.zip", repos=NULL, type="source")
install.packages("locfit_1.5-9.7.zip", repos=NULL, type="source")
install.packages("geneplotter_1.72.0.zip", repos=NULL, type="source")
install.packages("RcppArmadillo_0.12.2.0.0.zip", repos=NULL, type="source")
install.packages("DBI_1.2.2.zip", repos=NULL, type="source")
install.packages("BH_1.84.0-0.zip", repos=NULL, type="source")
install.packages("GenomeInfoDbData_1.2.7.tar.gz", repos=NULL, type="source")
install.packages("S4Arrays_1.4.0.zip", repos=NULL, type="source")
install.packages("SummarizedExperiment_1.24.0.zip", repos=NULL, type="source")
install.packages("BiocVersion_3.14.0.zip", repos=NULL, type="source")
install.packages("DESeq2_1.34.0.zip", repos=NULL, type="source")

#BiocManager::install("SummarizedExperiment")
library(SummarizedExperiment)
#BiocManager::install("DESeq2")
library(DESeq2)

install.packages("doParallel_1.0.17.zip", repos=NULL, type="source")
install.packages("clue_0.3-64.zip", repos=NULL, type="source")
install.packages("GetoptLong_1.0.5.zip", repos=NULL, type="source")
install.packages("cluster_2.1.4.zip", repos=NULL, type="source")
install.packages("ComplexHeatmap_2.10.0.zip", repos=NULL, type="source")

library(ComplexHeatmap)

install.packages("GenomicFeatures_1.46.5.zip", repos=NULL, type="source")
install.packages("rtracklayer_1.54.0.zip", repos=NULL, type="source")
install.packages("biomaRt_2.50.3.zip", repos=NULL, type="source")
install.packages("BiocIO_1.4.0.zip", repos=NULL, type="source")
install.packages("BiocFileCache_2.2.1.zip", repos=NULL, type="source")
install.packages("Rsamtools_2.10.0.zip", repos=NULL, type="source")
install.packages("restfulr_0.0.15.zip", repos=NULL, type="source")
install.packages("GenomicAlignments_1.30.0.zip", repos=NULL, type="source")
install.packages("Rhtslib_1.26.0.zip", repos=NULL, type="source")
install.packages("filelock_1.0.2.zip", repos=NULL, type="source")
install.packages("TxDb.Hsapiens.UCSC.hg19.knownGene_3.2.2.tar.gz", repos=NULL, type="source")

library(TxDb.Hsapiens.UCSC.hg19.knownGene)

install.packages("rngtools_1.5.2.zip", repos=NULL, type="source")
install.packages("R.methodsS3_1.8.2.zip", repos=NULL, type="source")
install.packages("doRNG_1.8.6.zip", repos=NULL, type="source")
install.packages("multtest_2.50.0.zip", repos=NULL, type="source")
install.packages("scrime_1.3.5.zip", repos=NULL, type="source")
install.packages("base64_2.0.1.zip", repos=NULL, type="source")
install.packages("sparseMatrixStats_1.6.0.zip", repos=NULL, type="source")
install.packages("rhdf5filters_1.6.0.zip", repos=NULL, type="source")
install.packages("rhdf5_2.38.1.zip", repos=NULL, type="source")
install.packages("beanplot_1.3.1.zip", repos=NULL, type="source")
install.packages("bumphunter_1.36.0.zip", repos=NULL, type="source")
install.packages("siggenes_1.68.0.zip", repos=NULL, type="source")
install.packages("preprocessCore_1.56.0.zip", repos=NULL, type="source")
install.packages("limma_3.50.3.zip", repos=NULL, type="source")
install.packages("illuminaio_0.36.0.zip", repos=NULL, type="source")
install.packages("Rhdf5lib_1.16.0.zip", repos=NULL, type="source")
install.packages("DelayedMatrixStats_1.16.0.zip", repos=NULL, type="source")
install.packages("mclust_6.0.0.zip", repos=NULL, type="source")
install.packages("quadprog_1.5-8.zip", repos=NULL, type="source")
install.packages("minfi_1.40.0.zip", repos=NULL, type="source")
install.packages("R.oo_1.26.0.tar.gz", repos=NULL, type="source")
install.packages("GEOquery_2.62.2.zip", repos=NULL, type="source")
install.packages("HDF5Array_1.22.1.zip", repos=NULL, type="source")
install.packages("nor1mix_1.3-3.tar.gz", repos=NULL, type="source")
install.packages("R.utils_2.12.3.tar.gz", repos=NULL, type="source")
install.packages("IlluminaHumanMethylationEPICanno.ilm10b4.hg19_0.6.0.tar.gz", repos=NULL, type="source")

library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)

install.packages("deldir_1.0-6.zip", repos=NULL, type="source")
install.packages("RcppEigen_0.3.3.9.3.zip", repos=NULL, type="source")
install.packages("interactiveDisplayBase_1.32.0.zip", repos=NULL, type="source")
install.packages("AnnotationFilter_1.18.0.zip", repos=NULL, type="source")
install.packages("ProtGenerics_1.26.0.zip", repos=NULL, type="source")
install.packages("dichromat_2.0-0.1.zip", repos=NULL, type="source")
install.packages("jpeg_0.1-10.zip", repos=NULL, type="source")
install.packages("interp_1.1-4.zip", repos=NULL, type="source")
install.packages("affyio_1.64.0.zip", repos=NULL, type="source")
install.packages("VariantAnnotation_1.40.0.zip", repos=NULL, type="source")
install.packages("AnnotationHub_3.2.2.zip", repos=NULL, type="source")
install.packages("gtools_3.9.4.zip", repos=NULL, type="source")
install.packages("permute_0.9-7.zip", repos=NULL, type="source")
install.packages("beachmat_2.10.0.zip", repos=NULL, type="source")
install.packages("latticeExtra_0.6-30.zip", repos=NULL, type="source")
install.packages("biovizBase_1.42.0.zip", repos=NULL, type="source")
install.packages("checkmate_2.1.0.zip", repos=NULL, type="source")
install.packages("BSgenome_1.62.0.zip", repos=NULL, type="source")
install.packages("nleqslv_3.3.4.zip", repos=NULL, type="source")
install.packages("affy_1.72.0.zip", repos=NULL, type="source")
install.packages("ExperimentHub_2.2.1.zip", repos=NULL, type="source")
install.packages("bsseq_1.30.0.zip", repos=NULL, type="source")
install.packages("edgeR_3.36.0.zip", repos=NULL, type="source")
install.packages("DSS_2.42.0.zip", repos=NULL, type="source")
install.packages("foreign_0.8-84.zip", repos=NULL, type="source")
install.packages("Formula_1.2-5.zip", repos=NULL, type="source")
install.packages("Gviz_1.38.4.zip", repos=NULL, type="source")
install.packages("ROC_1.70.0.zip", repos=NULL, type="source")
install.packages("BiasedUrn_2.0.9.zip", repos=NULL, type="source")
install.packages("ruv_0.9.7.1.zip", repos=NULL, type="source")
install.packages("lumi_2.46.0.zip", repos=NULL, type="source")
install.packages("methylumi_2.40.1.zip", repos=NULL, type="source")
install.packages("statmod_1.5.0.zip", repos=NULL, type="source")
install.packages("fastICA_1.2-3.zip", repos=NULL, type="source")
install.packages("JADE_2.0-3.zip", repos=NULL, type="source")
install.packages("lazyeval_0.2.2.zip", repos=NULL, type="source")
install.packages("RPMM_1.25.zip", repos=NULL, type="source")
install.packages("prettydoc_0.4.1.zip", repos=NULL, type="source")
install.packages("Hmisc_5.0-1.zip", repos=NULL, type="source")
install.packages("globaltest_5.48.0.zip", repos=NULL, type="source")
install.packages("sva_3.42.0.zip", repos=NULL, type="source")
install.packages("DNAcopy_1.68.0.zip", repos=NULL, type="source")
install.packages("impute_1.68.0.zip", repos=NULL, type="source")
install.packages("marray_1.72.0.zip", repos=NULL, type="source")
install.packages("goseq_1.46.0.zip", repos=NULL, type="source")
install.packages("wateRmelon_2.0.0.zip", repos=NULL, type="source")
install.packages("missMethyl_1.28.0.zip", repos=NULL, type="source")
install.packages("kpmt_0.1.0.zip", repos=NULL, type="source")
install.packages("isva_1.9.zip", repos=NULL, type="source")
install.packages("qvalue_2.26.0.zip", repos=NULL, type="source")
install.packages("shinythemes_1.2.0.zip", repos=NULL, type="source")
install.packages("dendextend_1.17.1.zip", repos=NULL, type="source")
install.packages("combinat_0.0-8.zip", repos=NULL, type="source")
install.packages("crosstalk_1.2.1.tar.gz", repos=NULL, type="source")
install.packages("htmlTable_2.4.2.tar.gz", repos=NULL, type="source")
install.packages("viridis_0.6.5.tar.gz", repos=NULL, type="source")
install.packages("ensembldb_2.18.4.zip", repos=NULL, type="source")
print("ATTENTION")
install.packages("org.Hs.eg.db_3.14.0.tar.gz", repos=NULL, type="source")
print("ATTENTION")
install.packages("GO.db_3.14.0.tar.gz", repos=NULL, type="source")
install.packages("FDb.InfiniumMethylation.hg19_2.2.0.tar.gz", repos=NULL, type="source")
install.packages("Illumina450ProbeVariants.db_1.30.0.tar.gz", repos=NULL, type="source")
install.packages("DT_0.33.tar.gz", repos=NULL, type="source")
install.packages("IlluminaHumanMethylationEPICmanifest_0.3.0.tar.gz", repos=NULL, type="source")
install.packages("IlluminaHumanMethylation450kmanifest_0.4.0.tar.gz", repos=NULL, type="source")
install.packages("plotly_4.10.4.tar.gz", repos=NULL, type="source")
install.packages("IlluminaHumanMethylation450kanno.ilmn12.hg19_0.6.0.tar.gz", repos=NULL, type="source")
print("ATTENTION")
install.packages("org.Hs.eg.db_3.14.0.tar.gz", repos=NULL, type="source")
print("ATTENTION")
install.packages("geneLenDataBase_1.30.0.tar.gz", repos=NULL, type="source")
install.packages("ChAMPdata_2.26.0.tar.gz", repos=NULL, type="source")
install.packages("DMRcate_2.8.5.tar.gz", repos=NULL, type="source")
install.packages("ChAMP_2.24.0.tar.gz", repos=NULL, type="source")

library(ChAMP)

install.packages("sitmo_2.0.2.zip", repos=NULL, type="source")
install.packages("FNN_1.1.3.2.zip", repos=NULL, type="source")
install.packages("irlba_2.3.5.1.zip", repos=NULL, type="source")
install.packages("RcppAnnoy_0.0.20.zip", repos=NULL, type="source")
install.packages("RSpectra_0.16-1.zip", repos=NULL, type="source")
install.packages("dqrng_0.3.0.zip", repos=NULL, type="source")
install.packages("RcppProgress_0.4.2.zip", repos=NULL, type="source")
install.packages("dir.expiry_1.2.0.zip", repos=NULL, type="source")
install.packages("basilisk.utils_1.6.0.zip", repos=NULL, type="source")
install.packages("pheatmap_1.0.12.zip", repos=NULL, type="source")
install.packages("Rtsne_0.16.zip", repos=NULL, type="source")
install.packages("uwot_0.1.14.zip", repos=NULL, type="source")
install.packages("basilisk_1.6.0.zip", repos=NULL, type="source")
install.packages("MOFA2_1.4.0.zip", repos=NULL, type="source")

library(MOFA2)


install.packages("mzR_2.28.0.zip", repos=NULL, type="source")
install.packages("MsCoreUtils_1.6.2.zip", repos=NULL, type="source")
install.packages("vsn_3.62.0.zip", repos=NULL, type="source")
install.packages("pcaMethods_1.86.0.zip", repos=NULL, type="source")
install.packages("MALDIquant_1.22.1.zip", repos=NULL, type="source")
install.packages("mzID_1.32.0.zip", repos=NULL, type="source")
install.packages("MSnbase_2.20.1.zip", repos=NULL, type="source")

library(MSnbase)

install.packages("Rdisop_1.54.0.zip", repos=NULL, type="source")

library(Rdisop)

library(devtools)
library(remotes)
library(igraph)



install.packages("RJSONIO_1.3-1.8.zip", repos=NULL, type="source")
devtools::install_github("lzyacht/cmmr", dependencies = FALSE)

library(cmmr)

install.packages("pbapply_1.7-2.tar.gz", repos=NULL, type="source")
remotes::install_gitlab("jaspershen/masstools", dependencies = FALSE)

library(masstools)

install.packages("openxlsx_4.2.5.2.zip", repos=NULL, type="source")
remotes::install_github("tidymass/massdataset", dependencies = FALSE)

library(massdataset)

install.packages("furrr_0.3.1.zip", repos=NULL, type="source")
remotes::install_github("tidymass/metid", dependencies = FALSE)

library(metid)

install.packages("polyclip_1.10-4.zip", repos=NULL, type="source")
install.packages("tweenr_2.0.2.zip", repos=NULL, type="source")
install.packages("graphlayouts_0.8.4.zip", repos=NULL, type="source")
install.packages("tidygraph_1.2.3.zip", repos=NULL, type="source")
install.packages("ggforce_0.4.1.zip", repos=NULL, type="source")
install.packages("BiocStyle_2.22.0.zip", repos=NULL, type="source")
install.packages("ggraph_2.1.0.zip", repos=NULL, type="source")
remotes::install_gitlab("tidymass/metpath", dependencies = FALSE)

library(metpath)



install.packages("slam_0.1-50.zip", repos=NULL, type="source")
install.packages("NLP_0.2-1.zip", repos=NULL, type="source")
install.packages("stringdist_0.9.10.zip", repos=NULL, type="source")
install.packages("zoo_1.8-12.zip", repos=NULL, type="source")
install.packages("tm_0.7-11.zip", repos=NULL, type="source")
install.packages("stopwords_2.3.zip", repos=NULL, type="source")
install.packages("synthesisr_0.3.0.zip", repos=NULL, type="source")
install.packages("ngram_3.2.2.zip", repos=NULL, type="source")
install.packages("SnowballC_0.7.0.zip", repos=NULL, type="source")
install.packages("changepoint_2.2.4.zip", repos=NULL, type="source")
remotes::install_github("elizagrames/litsearchr", dependencies = FALSE)

library(litsearchr)


install.packages("sjlabelled_1.2.0.zip", repos=NULL, type="source")
install.packages("insight_0.19.11.tar.gz", repos=NULL, type="source")
install.packages("datawizard_0.10.0.tar.gz", repos=NULL, type="source")

devtools::install_github("strengejacke/sjmisc", dependencies = FALSE)

library(sjmisc)