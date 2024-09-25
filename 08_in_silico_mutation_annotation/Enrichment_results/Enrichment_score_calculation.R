## Libraries
library(ggplot2)
library(stringr)
library(DGEobj.utils)

## Define variable for this iteration
args <- commandArgs(trailingOnly = TRUE)
a <- as.numeric(args[1])
print(a)

## Read in clinical data
clinical_data <- as.data.frame(read.csv("/home/u1/knodele/Immunoediting_Human_cSCC/13_growth_rate_simulations/Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

# Read in master Expression spreadsheet
expression <- as.data.frame(read.table("merged_gene_count_53_Tumor Samples_ASU.txt", header=TRUE))
genes <- expression$GeneId
gene_length <- expression$Length
expression <- expression[,-c(1:7)]
expression <- as.matrix(expression)

expression <- convertCounts(expression, "TPM", gene_length)

patient <- clinical_data$ID[a]
print(patient)
if (file.exists(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", patient, "_netmhc_fake_mutations_WT.xsl", sep="")) && !file.exists(paste(patient,"_enrichment_results.csv",sep=""))){
  print(a)
  ### Define IDs
  sample <- clinical_data$Tumor_Sample_Barcode[a]
  patient <- clinical_data$ID[a]
  rna <- paste(clinical_data$RNA_ID[a], "_RNA_count", sep="")

  ### Subset MAF file
  MAF_subset <- data.table::fread(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", patient, "_fake_mutations_vep.maf", sep=""))
  MAF_subset <- MAF_subset[which(MAF_subset$Variant_Classification=="Missense_Mutation"),]
  MAF_subset <- as.data.frame(MAF_subset)
  MAF_subset <- MAF_subset[, which(colnames(MAF_subset) %in% c("Chromosome", "Start_Position", "Gene", "Reference_Allele",
                                                            "Tumor_Seq_Allele2","t_ref_count", "t_alt_count"))]

  ### Create Mutation ID
  MAF_subset$ID <- paste(MAF_subset$Chromosome, MAF_subset$Start_Position-1, MAF_subset$Reference_Allele, MAF_subset$Tumor_Seq_Allele2, sep=":")
  MAF_subset$ID_lim <- paste(MAF_subset$Chromosome, MAF_subset$Start_Position-1, sep=":")

  ### Match Expression
  expression_subset <- as.data.frame(expression[,which(colnames(expression)== rna)])
  expression_subset$genes <- genes
  colnames(expression_subset) <- c("TPM","Gene")
  
  expression_subset <- expression_subset[match(MAF_subset$Gene, expression_subset$Gene),]
  identical(MAF_subset$Gene[100], expression_subset$Gene[100])
  
  MAF_subset$Expression <- expression_subset$TPM
  
  ### Match Peptides
  peptides <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", patient, "_fake_mutations_vep_17.peptides", sep=""), header=FALSE))
  MAF_subset <- MAF_subset[which(MAF_subset$ID %in% peptides$V5),]
  peptides <- peptides[match(MAF_subset$ID, peptides$V5),]
  identical(MAF_subset$ID, peptides$V5)
  MAF_subset$Peptide <- peptides$V6

  ### Limit MAF columns
  MAF_subset <- MAF_subset[,-c(1:6)]
  
  ### Read in binding and remove WT
  binding <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", patient, "_netmhc_fake_mutations.xsl", sep=""), skip=1, header=TRUE))
  
  wt_binding <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/", patient, "_netmhc_fake_mutations_WT.xsl", sep=""), skip=1, header=TRUE))
  binding <- binding[-which(binding$Peptide %in% wt_binding$Peptide),]
  binding <- unique(binding)

  IDs <- stringr::str_split_fixed(binding$ID, "_", 4)
  binding$ID <- paste(IDs[,1], IDs[,2], sep=":")

  if (length(MAF_subset[-which(is.na(MAF_subset$Expression)),1]>0)){
   MAF_subset <- MAF_subset[-which(is.na(MAF_subset$Expression)),] 
  }
  
  MAF_subset$weak_neo <- "not+neo"
  
  ### Match min binding
  for (i in 1:length(MAF_subset$ID)){
    #print(i)
    binding_subset <- binding[which(binding$ID==MAF_subset$ID_lim[i]),]
    MAF_subset$binding[i] <- min(binding_subset$nM, binding_subset$nM.1, binding_subset$nM.2, binding_subset$nM.3, binding_subset$nM.4, binding_subset$nM.5)
    if (MAF_subset$binding[i] <500){
      MAF_subset$weak_neo[i] <- "neo"
    }
  }

  MAF_subset$Sample <- sample
  
  iterations <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/", patient, "_fake_mutations.txt", sep=""), header=FALSE)) # Read in data frame assigning each mutation to an iteration
  iterations$ID <- paste("chr", iterations$V1, sep="") # Create appropriate ID for matching
  iterations$ID <- paste(iterations$ID, iterations$V2-1, iterations$V3, iterations$V4, sep=":")

  iteration_results <- matrix(nrow=100, ncol=2) # Create an output file
  colnames(iteration_results) <- c("iteration", "result")
  
  for (j in 1:100){
    iteration <- iterations[which(iterations[,(j+5)]==1),] # Restrict to one iteration
    MAF_subset_iteration <- MAF_subset[which(MAF_subset$ID %in% iteration$ID),]
    MAF_subset_rank_order <- MAF_subset_iteration[order(MAF_subset_iteration$Expression),]
    MAF_subset_rank_order$rank <- dplyr::dense_rank(MAF_subset_rank_order$Expression)
    ## True binders
    not_neo <- MAF_subset_rank_order[which(MAF_subset_rank_order$weak_neo=="not+neo"),]
    not_neo_sum <- sum(not_neo$rank)/length(not_neo$Gene)
    neo <- MAF_subset_rank_order[which(MAF_subset_rank_order$weak_neo=="neo"),]
    neo_sum <- sum(neo$rank)/length(neo$Gene)
    iteration_results[j,1] <- j
    iteration_results[j,2] <- not_neo_sum - neo_sum
  }
write.csv(iteration_results, paste(patient,"_enrichment_results.csv",sep=""))
} else {print("File not available or already ran")}
