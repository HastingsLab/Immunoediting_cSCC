## Load in libraries:
library(ggplot2)
library(dplyr)
library(data.table)
library(plyr)
library(abc)

## Compiles simulation results

## Read in metadata
clinical_data <- as.data.frame(read.csv("Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

## Read in purities and match to metadata
purities <- as.data.frame(read.table("Output_purities_puree_formatted.tsv"))
purities <- purities[match(paste(clinical_data$RNA_ID, "_RNA_count", sep=""), purities$V1),]
identical(paste(clinical_data$RNA_ID, "_RNA_count", sep=""), purities$V1)
clinical_data$sample_purity <- purities$V2

#print(clinical_data)

for (i in 1:length(clinical_data[,1])){
	#print(i)
	results <- as.data.frame(read.csv(paste("Optimized_parameters", i, "_relative_mutation_CN2.csv", sep="")))
	print(results)
	clinical_data$growth[i] <- results[1,2]
	clinical_data$ratio[i] <- results[1,3]
}


write.csv(clinical_data, "Compiled_growth_ratio_results_relative_mutation_CN2.csv")
