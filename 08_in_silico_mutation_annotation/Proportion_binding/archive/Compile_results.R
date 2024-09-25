## Libraries
library(stringr)
library(ggplot2)
library(stringi)
library(dplyr)

## Read in clinical data
clinical_data <- as.data.frame(read.csv("/home/u1/knodele/Immunoediting_Human_cSCC/13_growth_rate_simulations/Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

clinical_data$total_proportion <- NA
for (i in 1:length(clinical_data[,1])){
if (file.exists(paste("All_binding_ratio_results", i, ".txt", sep=""))){
	results <- as.data.frame(read.csv(paste("All_binding_ratio_results", i, ".txt", sep=""), header=TRUE))
	results$total_proportion <- (results$binding_clonal + results$binding_subclonal)/(results$clonal_count + results$subclonal_count)
	clinical_data$proportion_binding[i] <- mean(results$total_proportion)
} else {print("Skipping, file does not exist") }
}

write.csv(clinical_data, "Compiled_binding_proportion.csv")
