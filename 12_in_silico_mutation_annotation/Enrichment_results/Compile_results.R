## Libraries
library(stringr)
library(ggplot2)
library(stringi)
library(dplyr)

## Read in clinical data
clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[which(clinical_data$Include_in_study=="Yes"),]

clinical_data$in_silico_enrichment <- NA
for (i in 1:length(clinical_data[,1])){
patient <- clinical_data$ID[i]
if (file.exists(paste(patient,"_enrichment_results.csv",sep=""))){
	results <- as.data.frame(read.csv(paste(patient,"_enrichment_results.csv",sep=""), header=TRUE))
	print(is.numeric(results$result))
	if (is.numeric(results$result)==FALSE){
		print(results$result)
	}
	clinical_data$in_silico_enrichment[i] <- mean(as.numeric(results$result))
} else {print("Skipping, file does not exist") }
}

write.csv(clinical_data, "Compiled_in_silico_enrichment.csv")
