## Libraries
library(ggplot2)
library(stringr)
library(DGEobj.utils)

## Define variable for this iteration
args <- commandArgs(trailingOnly = TRUE)
a <- as.numeric(args[1])

## Read in clinical data
clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[which(clinical_data$Include_in_study=="Yes"),]

# Read in master Expression spreadsheet
expression <- as.data.frame(read.csv("all_samples_tpm.counts.txt", header=TRUE))
colnames(expression) <- gsub("NPT\\.", "NPT-", colnames(expression))
colnames(expression) <- gsub("\\.1", "-1", colnames(expression))
colnames(expression) <- gsub("\\.2", "-2", colnames(expression))
genes <- expression$Gene
#head(genes)

patient <- clinical_data$ID[a]
if (!file.exists(paste(patient,"_enrichment_results.csv",sep=""))){
  ### Define IDs
  sample <- clinical_data$Tumor_Sample_Barcode[a]
  patient <- clinical_data$ID[a]
  rna <- clinical_data$RNA_ID[a]

  ### Subset MAF file
  MAF_subset <- data.table::fread(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/", patient, "_fake_mutations_vep.maf", sep=""))
  print(paste("MAF successfully read for", patient, "with", length(MAF_subset$Hugo_Symbol), "lines", sep=" "))

  MAF_subset <- MAF_subset[which(MAF_subset$Variant_Classification=="Missense_Mutation"),]
  MAF_subset <- as.data.frame(MAF_subset)
  MAF_subset <- MAF_subset[, which(colnames(MAF_subset) %in% c("Chromosome", "Start_Position", "Hugo_Symbol", "Reference_Allele",
                                                            "Tumor_Seq_Allele2","t_ref_count", "t_alt_count"))]

  ### Create Mutation ID
  MAF_subset$ID <- paste(MAF_subset$Chromosome, MAF_subset$Start_Position-1, MAF_subset$Reference_Allele, MAF_subset$Tumor_Seq_Allele2, sep=":")
  MAF_subset$ID_lim <- paste(MAF_subset$Chromosome, MAF_subset$Start_Position-1, sep=":")

  ### Match Expression
  expression_subset <- as.data.frame(expression[,which(colnames(expression)== rna)])
  expression_subset$genes <- genes
  colnames(expression_subset) <- c("TPM","Gene")

  expression_subset <- expression_subset[match(MAF_subset$Hugo_Symbol, expression_subset$Gene),]
  print(paste("Match of gene id for expression is:", identical(MAF_subset$Hugo_Symbol[10], expression_subset$Gene[10]), sep = " "))
  
  MAF_subset$Expression <- expression_subset$TPM

  ### Match Peptides
  peptides <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/", patient, "_fake_mutations_vep_19.peptides", sep=""), header=FALSE))
  MAF_subset <- MAF_subset[which(MAF_subset$ID %in% peptides$V5),]
  peptides <- peptides[match(MAF_subset$ID, peptides$V5),]
  identical(MAF_subset$ID, peptides$V5)
  MAF_subset$Peptide <- peptides$V6

  ### Limit MAF columns
  MAF_subset <- MAF_subset[,-c(1:6)]
  
  ### Read in binding and remove WT
  binding_example <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", patient, "_netmhc_fake_mutations_00.xsl", sep=""), skip=1, header=TRUE))
  binding <- matrix(NA, nrow=1, ncol=ncol(binding_example))
  colnames(binding) <- colnames(binding_example)
  for (i in c("00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18",
"19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39",
"40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",
"61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81",
"82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99")){
	binding_part <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", patient, "_netmhc_fake_mutations_", i, ".xsl", sep=""), skip=1, header=TRUE))
	binding_part <- binding_part[-1,]
	binding <- rbind(binding, binding_part)
   }  

  wt_binding <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", patient, "_fake_mutations_vep_WT_all_9mer.peptides", sep=""), header=FALSE))
  colnames(wt_binding) <- "Peptide"
  binding <- binding[-which(binding$Peptide %in% wt_binding$Peptide),]
  binding <- unique(binding)

  IDs <- stringr::str_split_fixed(binding$ID, "_", 4)
  binding$ID <- paste(IDs[,1], IDs[,2], sep=":")

  if (length(MAF_subset[-which(is.na(MAF_subset$Expression)),1]>0)){
   MAF_subset <- MAF_subset[-which(is.na(MAF_subset$Expression)),] 
  }
  
write.csv(MAF_subset, paste("/xdisk/khasting/knodele/Mayo_data/", patient,"_intermediate_results_MAF.csv",sep=""))
write.csv(binding, paste("/xdisk/khasting/knodele/Mayo_data/", patient,"_intermediate_results_binding.csv",sep=""))
} else {print("File not available or already ran")}
