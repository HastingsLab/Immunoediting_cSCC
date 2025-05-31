## Load in libraries:
library(ggplot2)
library(dplyr)
library(data.table)
library(plyr)
library(abc)

## Compiles simulation results

## Read in metadata
clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[which(clinical_data$Include_in_study=="Yes"),]

## Read in purities and match to metadata
#purities <- as.data.frame(read.table("All_purity_estimates_renamed.txt", header=FALSE))
#purities <- purities[match(clinical_data$RNA_ID, purities$V1),]
#identical(clinical_data$RNA_ID, purities$V1)
#clinical_data$sample_purity <- purities$V2

#print(clinical_data)

for (i in 1:length(clinical_data[,1])){
	#print(i)
	results <- as.data.frame(read.csv(paste("Optimized_parameters", i, "_relative_mutation.csv", sep="")))
	print(results)
	clinical_data$growth[i] <- results[1,2]
	clinical_data$ratio[i] <- results[1,3]
#	clinical_data$purity[i] <- results[1,4]
}


write.csv(clinical_data, "Compiled_growth_ratio_results_relative_mutation.csv")
