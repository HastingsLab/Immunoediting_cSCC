## Load in libraries:
library(ggplot2)
library(dplyr)
#library(rsconnect)
library(data.table)
#library(grid)
#library(gridExtra)
#library(LaplacesDemon)
library(plyr)
library(abc)

bin_edges <- c(0,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.2,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.3,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.4,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.5,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.6,0.61,0.62,0.63,0.64,0.65,0.66,0.67,0.68,0.69,0.7,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.8,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.9,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,1.0)

#' Define a function for predicting VAF distribution based on known inputs
#' @param unif_cov Coverage
#' @param n Number of sequenced cells
#' @param mu Total number of mutations
#' @param ratio_fix_pol Ratio of fixed to polymorphic mutations
#' @param a SFS dexay 1/x^a
#' @param singletons exclude mutations with read support equal or smaller than this value
#' @param pur tumor purity
plot_VAF <- function(cov, n, mu, ratio_fix_pol, a, singletons, pur){
  set.seed(1)
  
  df <- as.data.frame(cov)
    
  prob_vector = (1/seq(n)^a) / sum(1/seq(n)^a)
  prob_vector[n] = prob_vector[n] + ratio_fix_pol
  #plot(prob_vector)
  min_mutations = 100000*ceiling(1/min(prob_vector))
  all_mutations = sort(sample(1:n,mu,replace=TRUE,prob=round(min_mutations*prob_vector)))
  #hist(all_mutations, breaks = 100)
  #mu = 50
    
  coverage_dist_emp = sample_n(df, mu, replace = T) #the original sample function behaved bad.
  coverage_dist_emp = c(coverage_dist_emp$cov)
  alt_reads_dist = rbinom(n = length(all_mutations), size = coverage_dist_emp, prob = pur * (all_mutations/(2*n)))
    
  VAF = data.frame(cbind(coverage_dist_emp, alt_reads_dist, all_mutations))
  VAF_expected = data.frame(cbind(n, all_mutations, all_mutations))
  colnames(VAF) <- c("coverage", "alt_reads", "real_alt_reads")
  colnames(VAF_expected) <- c("coverage", "alt_reads", "real_alt_reads")
  VAF$Freq = VAF$alt_reads / VAF$coverage
  VAF_expected$Freq = pur * (VAF_expected$alt_reads / (2*VAF_expected$coverage))
      
  VAF = subset(VAF, alt_reads > singletons)
  
  freq   = hist(VAF$Freq, breaks=bin_edges, include.lowest=TRUE, plot=FALSE)
  
  return(list(VAF=VAF, freq=freq))
}


## Read in variants
maf_file = "Mayo_data_combined_variants.maf"
maf <- data.table::fread(maf_file)
maf$VAF <- maf$t_alt_count/(maf$t_alt_count+maf$t_ref_count)

## Read in metadata
clinical_data <- as.data.frame(read.csv("Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

## Read in purities and match to metadata
purities <- as.data.frame(read.table("Output_purities_puree_formatted.tsv"))
purities <- purities[match(paste(clinical_data$RNA_ID, "_RNA_count", sep=""), purities$V1),]
identical(paste(clinical_data$RNA_ID, "_RNA_count", sep=""), purities$V1)
clinical_data$sample_purity <- purities$V2

## Define parameters to iterate over
growth <- seq(0.01, 2, by = 0.01)
ratio <- seq(0.01, 1, by = 0.01)
params <- expand.grid(growth = growth, ratio = ratio)

## Define loop to calculate growth rate and ratio for all patients
for (i in 1:length(clinical_data$ID)){
    print(i)
    # Calculate true distribution for comparison
    variants <- maf[which(maf$Tumor_Sample_Barcode == clinical_data$Tumor_Sample_Barcode[i]),]
    true_distribution   = hist(variants$VAF, breaks=bin_edges, include.lowest=TRUE, plot=FALSE)
    true_distribution$counts <- true_distribution$counts/sum(true_distribution$counts)*100
    true_distribution$coverage <- true_distribution$t_alt_count + true_distribution$t_ref_count
    if (length(true_distribution[which(is.na(true_distribution$coverage)),1]>0)){
        true_distribution <- true_distribution[-which(is.na(true_distribution$coverage)),]
    }
    # Simulate results
    results <- matrix(NA, nrow = 100, ncol = length(params$growth))
    for (j in 1:nrow(params)){
      result <- plot_VAF(true_distribution$coverage, 166667, length(variants[,1]), params$ratio[j], params$growth[j], 2, clinical_data$sample_purity[i])
      test <- result$freq
      test$counts <- test$counts/sum(test$counts)*100
      results[,j] <- test$counts
    }    
    results <- t(results)
    param <- as.matrix(params)
    res <- abc(target=true_distribution$counts, param=params, sumstat=results, tol=0.01, method="rejection")
    summary <- summary(res)
    summary <- as.data.frame(summary)
    
    ## Save results
    clinical_data$growth[i] <- summary[which(summary$Var1=="Mean:" & summary$Var2=="growth"),3]
    clinical_data$raio[i] <- summary[which(summary$Var1=="Mean:" & summary$Var2=="ratio"),3]
}

write.csv(clinical_data, "Metadata_growth_ratio_added.csv")

