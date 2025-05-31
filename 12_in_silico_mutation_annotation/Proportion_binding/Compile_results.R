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

clinical_data$total_proportion <- NA
for (i in 1:length(clinical_data[,1])){
if (file.exists(paste("All_binding_ratio_results", clinical_data$ID[i], ".txt", sep=""))){
	results <- as.data.frame(read.csv(paste("All_binding_ratio_results", clinical_data$ID[i], ".txt", sep=""), header=TRUE))
	results$total_proportion <- (results$binding_clonal)/(results$count)
	head(results)
	clinical_data$total_proportion[i] <- mean(results$total_proportion)
	#write.csv(results, paste("All_binding_ratio_results", clinical_data$ID[i], ".txt", sep=""))
} else {print(paste("Skipping,", clinical_data$ID[i], "file does not exist", sep=" ")) }
}

write.csv(clinical_data, "Compiled_binding_proportion.csv")
