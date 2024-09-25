## Libraries
library(stringr)
library(ggplot2)
library(stringi)
library(dplyr)

## Read in clinical data
clinical_data <- as.data.frame(read.csv("/home/u1/knodele/Immunoediting_Human_cSCC/13_growth_rate_simulations/Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

clinical_data$in_silico_enrichment <- NA
for (i in 1:length(clinical_data[,1])){
patient <- clinical_data$ID[i]
if (file.exists(paste(patient,"_enrichment_results.csv",sep=""))){
	results <- as.data.frame(read.csv(paste(patient,"_enrichment_results.csv",sep=""), header=TRUE))
	clinical_data$in_silico_enrichment[i] <- mean(results$result)
} else {print("Skipping, file does not exist") }
}

write.csv(clinical_data, "Compiled_in_silico_enrichment.csv")
