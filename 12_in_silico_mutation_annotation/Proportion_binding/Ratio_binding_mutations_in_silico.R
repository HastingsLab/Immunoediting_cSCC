## Libraries
library(stringr)
library(ggplot2)
library(stringi)
library(dplyr)

## Define variable for this iteration
args <- commandArgs(trailingOnly = TRUE)
k <- as.numeric(args[1])
print(args[1])
print(paste("Starting analysis:", k,sep=""))

## Read in clinical data
clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(is.na(clinical_data$RNA_ID)),]
clinical_data <- clinical_data[which(clinical_data$Include_in_study=="Yes"),]

## Read in peptides
sample=clinical_data$ID[k]

if (file.exists(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", sample, "_netmhc_fake_mutations_00.xsl", sep="")) && !file.exists(paste("All_binding_ratio_results", sample, ".txt", sep=""))){
peptides <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/", sample, "_fake_mutations_vep_19.peptides", sep=""), header=FALSE)) # Read in peptide list
length(unique(peptides$V5)) 
ID <- str_split_fixed(peptides$V5, ":", 4) # Create appropriate ID for matching to netMHC file
peptides$ID_lim <- paste(ID[,1], ID[,2], sep=":")
  
print("Read in peptides")

## Read in and process all netMHC files
wt_all <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", sample, "_fake_mutations_vep_WT_all_9mer.peptides", sep=""), header=FALSE))

### Read in binding and remove WT
binding_example <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", sample, "_netmhc_fake_mutations_00.xsl", sep=""), skip=1, header=TRUE))
#print(ncol(binding_example))
binding <- matrix(NA, nrow=1, ncol=ncol(binding_example))
colnames(binding) <- colnames(binding_example)
for (i in c("00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18",
"19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39",
"40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",
"61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81",
"82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99")){
        binding_part <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", sample, "_netmhc_fake_mutations_", i, ".xsl", sep=""), skip=1, header=TRUE))
        binding_part <- binding_part[-1,]
        #print(ncol(binding_part))
        binding <- rbind(binding, binding_part)
}

print("Done reading in binding")

wt_binding <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/", sample, "_fake_mutations_vep_WT_all_9mer.peptides", sep=""), header=FALSE))
colnames(wt_binding) <- "Peptide"
binding <- binding[-which(binding$Peptide %in% wt_binding$Peptide),]
binding <- unique(binding)

IDs <- stringr::str_split_fixed(binding$ID, "_", 4)
binding$ID <- paste(IDs[,1], IDs[,2], sep=":")

netMHC <- binding

#print(head(binding))
# Find min binding
for (i in 1:length(peptides$V1)){ 
  netMHC_subset <- netMHC[which(netMHC$ID==peptides$ID_lim[i]),]
  peptides$min_binding[i] <- min(netMHC_subset$nM, netMHC_subset$nM.1, netMHC_subset$nM.2, netMHC_subset$nM.3, netMHC_subset$nM.4, netMHC_subset$nM.5)
}
#print(head(peptides))
print("done matching binding")

iterations <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/In_silico_muts/", sample, "_fake_mutations.txt", sep=""), header=FALSE)) # Read in data frame assigning each mutation to an iteration
iterations$ID <- paste("chr", iterations$V1, sep="") # Create appropriate ID for matching
iterations$ID <- paste(iterations$ID, iterations$V2-1, iterations$V3, iterations$V4, sep=":")
  
iteration_results <- matrix(nrow=100, ncol=2) # Create an output file
colnames(iteration_results) <- c("count", "binding_clonal")

for (j in 1:100){
  iteration <- iterations[which(iterations[,(j+5)]==1),] # Restrict to one iteration
  peptides_subset <- peptides[which(peptides$V5 %in% iteration$ID),] # Match peptides to that iteration
  peptides_subset <- peptides_subset[!duplicated(peptides_subset$V6),] # Remove duplicated peptides
  
  iteration_results[j,1] <- length(peptides_subset$V1) # Assign total number clonal
  iteration_results[j,2] <- length(peptides_subset[which(peptides_subset$min_binding<500),1]) # Assign binding clonal
}
write.csv(iteration_results, paste("All_binding_ratio_results", sample, ".txt", sep="")) # write results
print(paste("Successfully completed", sample, k))
} else {print("Skipping, either file does not exist or results have already been generated") }
