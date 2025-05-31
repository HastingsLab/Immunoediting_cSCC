library(stringr)

# Define a function that splits the wildtype peptides into every possible 9mer for comparison
combinated_letters <- function(string, n) {
  length_ <- str_length(string)
  str_sub(string, seq(1, length_ + 1 - n), seq(n, length_))
}

## Read in data

clinical_data <- as.data.frame(read.csv("/home/u1/knodele/Immunoediting_Human_cSCC/13_growth_rate_simulations/Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
#clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

## Apply function
print(clinical_data$ID)
a=1
for (k in clinical_data$ID){
  print(k)
  original_file <- paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", k, "_fake_mutations_vep_WT_17.peptides", sep="")
  output_file <- paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", k, ".WT_n_mers_in_silico.peptides", sep="")
  print(original_file)
  print(output_file)
  if (file.exists(original_file) && !file.exists(output_file)){
      print(a)
      wt_all <- as.data.frame(read.table(original_file, header=FALSE))
      wt <- wt_all$V8
      wt_expanded <- matrix(NA, nrow=1)
      colnames(wt_expanded) <- "peptides"
      for (i in 1:length(wt)){
          temp = combinated_letters(wt[i], 9)
          temp <- as.data.frame(temp)
          colnames(temp) <- "peptides"
          wt_expanded <- rbind(wt_expanded, temp)
      }
      a=a+1
      write.csv(wt_expanded$peptides, output_file)
  } else {
    message("Skipping - Either original file is missing or output file already exists.")
  }
}
