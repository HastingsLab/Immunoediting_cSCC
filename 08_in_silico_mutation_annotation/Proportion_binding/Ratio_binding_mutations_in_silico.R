## Libraries
library(stringr)
library(ggplot2)
library(stringi)
library(dplyr)

## Define variable for this iteration
args <- commandArgs(trailingOnly = TRUE)
k <- as.numeric(args[1])
print(k)

## Read in clinical data
clinical_data <- as.data.frame(read.csv("/home/u1/knodele/Immunoediting_Human_cSCC/13_growth_rate_simulations/Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

# Define a function for reading in and processing netMHC files
process_netMHC <- function(file){
    netMHC_matrix <- as.data.frame(read.table(file, skip=1, header=TRUE))
    netMHC_matrix <- netMHC_matrix[,which(colnames(netMHC_matrix) %in% c("Peptide", "ID", "nM", "nM.1", "nM.2", "nM.3", 
                                              "nM.4", "nM.5"))] # Restrict to relevant columns
    netMHC_matrix <- netMHC_matrix[-which(netMHC_matrix$Peptide %in% wt_all$Peptide),] # Remove peptides present in WT 
    netMHC_matrix <- netMHC_matrix[-1,] # Remove the first row since this one is always a nonsense peptide
    netMHC_matrix <- unique(netMHC_matrix) # Keep only unique peptides
    ID <- str_split_fixed(netMHC_matrix$ID, "_", 4) # Create appropriate ID for matching to peptide file
    netMHC_matrix$ID <- paste(ID[,1], ID[,2], sep=":")
    return(netMHC_matrix)
  }

## Read in peptides
sample=clinical_data$ID[k]

if (file.exists(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", sample, "_netmhc_fake_mutations_WT.xsl", sep="")) && !file.exists(paste("All_binding_ratio_results", k, ".txt", sep=""))){
peptides <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", sample, "_fake_mutations_vep_17.peptides", sep=""), header=FALSE)) # Read in peptide list
length(unique(peptides$V5)) 
ID <- str_split_fixed(peptides$V5, ":", 4) # Create appropriate ID for matching to netMHC file
peptides$ID_lim <- paste(ID[,1], ID[,2], sep=":")
  
## Read in and process all netMHC files
wt_all <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", sample, "_netmhc_fake_mutations_WT.xsl", sep=""),skip=1, header=TRUE)) # Read in WT file for reference
netMHC <- process_netMHC(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", sample, "_netmhc_fake_mutations.xsl", sep="")) # Read in NetMHC results

# Find min binding
for (i in 1:length(peptides$V1)){ 
  netMHC_subset <- netMHC[which(netMHC$ID==peptides$ID_lim[i]),]
  peptides$min_binding[i] <- min(netMHC_subset$nM, netMHC_subset$nM.1, netMHC_subset$nM.2, netMHC_subset$nM.3, netMHC_subset$nM.4, netMHC_subset$nM.5)
}

iterations <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", sample, "_fake_mutations.txt", sep=""), header=FALSE)) # Read in data frame assigning each mutation to an iteration
iterations$ID <- paste("chr", iterations$V1, sep="") # Create appropriate ID for matching
iterations$ID <- paste(iterations$ID, iterations$V2-1, iterations$V3, iterations$V4, sep=":")
  
iteration_results <- matrix(nrow=100, ncol=4) # Create an output file
colnames(iteration_results) <- c("clonal_count", "subclonal_count", "binding_clonal", "binding_subclonal")

CCF <- as.data.frame(read.csv(paste("MAF_files/", clinical_data$ID[k], "_variants_CN.csv", sep=""))) # Read in CCF values

for (j in 1:100){
  iteration <- iterations[which(iterations[,(j+5)]==1),] # Restrict to one iteration
  peptides_subset <- peptides[which(peptides$V5 %in% iteration$ID),] # Match peptides to that iteration
  peptides_subset <- peptides_subset[!duplicated(peptides_subset$V6),] # Remove duplicated peptides
  
  CCF_scrambled <- sample_n(CCF, length(peptides_subset$V1), replace=TRUE) # Scramble CCF values
  peptides_subset$CCF <- CCF_scrambled$VAF # Assign CCF values
  
  peptides_clonal <- peptides_subset[which(peptides_subset$CCF>.75),] # Assign as clonal
  peptides_subclonal <- peptides_subset[which(peptides_subset$CCF<0.75),] # Assign as subclonal
 
  iteration_results[j,1] <- length(peptides_clonal$V1) # Assign total number clonal
  iteration_results[j,2] <- length(peptides_subclonal$V1) # Assign total number subclonal
  iteration_results[j,3] <- length(peptides_clonal[which(peptides_clonal$min_binding<500),1]) # Assign binding clonal
  iteration_results[j,4] <- length(peptides_subclonal[which(peptides_subclonal$min_binding<500),1]) # Assign binding subclonal
}
write.csv(iteration_results, paste("All_binding_ratio_results", sample, ".txt", sep="")) # write results
} else {print("Skipping, either file does not exist or results have already been generated") }
