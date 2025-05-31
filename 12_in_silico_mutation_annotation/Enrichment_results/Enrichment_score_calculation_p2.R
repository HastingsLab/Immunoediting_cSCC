## Libraries
library(ggplot2)
library(stringr)
library(DGEobj.utils)

## Define variable for this iteration
args <- commandArgs(trailingOnly = TRUE)
a <- as.numeric(args[1])
print(a)
## Read in clinical data
clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[which(clinical_data$Include_in_study=="Yes"),]
print("Read in clinical data")

patient <- clinical_data$ID[a]
print(patient)
if (!file.exists(paste(patient,"_enrichment_results_", args[2], ".csv",sep=""))){
sample <- clinical_data$Tumor_Sample_Barcode[a]
MAF_subset <- as.data.frame(read.csv(paste("/xdisk/khasting/knodele/Mayo_data/", patient,"_intermediate_results_MAF.csv",sep="")))
print("Read in MAF_subset")
binding <- as.data.frame(read.csv(paste("/xdisk/khasting/knodele/Mayo_data/", patient,"_intermediate_results_binding.csv",sep=""))) 
print("Read in data") 

iterations <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/", patient, "_fake_mutations.txt", sep=""), header=FALSE)) # Read in data frame assigning each mutation to an iteration
iterations$ID <- paste("chr", iterations$V1, sep="") # Create appropriate ID for matching
iterations$ID <- paste(iterations$ID, iterations$V2-1, iterations$V3, iterations$V4, sep=":")

iteration_results <- matrix(nrow=1, ncol=2) # Create an output file
colnames(iteration_results) <- c("iteration", "result")
print("Read in and formatted data")  

for (j in args[2]){
    iteration <- iterations[which(iterations[,(as.numeric(j)+5)]==1),] # Restrict to one iteration
    MAF_subset_iteration <- MAF_subset[which(MAF_subset$ID %in% iteration$ID),]
    for (i in 1:length(MAF_subset_iteration$ID)){
         binding_subset <- binding[which(binding$ID==MAF_subset_iteration$ID_lim[i]),]
         MAF_subset_iteration$binding[i] <- min(binding_subset$nM, binding_subset$nM.1, binding_subset$nM.2, binding_subset$nM.3, binding_subset$nM.4, binding_subset$nM.5)
    }
    MAF_subset_rank_order <- MAF_subset_iteration[order(as.numeric(MAF_subset_iteration$Expression)),]
    MAF_subset_rank_order$rank <- dplyr::dense_rank(as.numeric(MAF_subset_rank_order$Expression))
    ## True binders
    not_neo <- MAF_subset_rank_order[which(MAF_subset_rank_order$binding>=500),]
    not_neo_sum <- sum(not_neo$rank)/length(not_neo[,1])
    neo <- MAF_subset_rank_order[which(MAF_subset_rank_order$binding<500),]
    neo_sum <- sum(neo$rank)/length(neo[,1])
    iteration_results[1,1] <- j
    iteration_results[1,2] <- not_neo_sum - neo_sum
}

print("Completed iteration")
write.csv(iteration_results, paste(patient,"_enrichment_results_", args[2], ".csv",sep=""))
print("Wrote to file successfully")
} else {print("File not available or already ran")}
