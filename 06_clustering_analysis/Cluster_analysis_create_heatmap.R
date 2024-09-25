library(cluster)
library(ggplot2)
library(factoextra)
library(NbClust)
library(pheatmap)

clinical_data <- as.data.frame(read.csv("Simple_metadata_immune_annotations.csv"))
clinical_data <- clinical_data[-which(is.na(clinical_data$Tumor_Sample_Barcode)),]
clinical_data <- clinical_data[-which(clinical_data$Tumor_Sample_Barcode=="s_CSCC-302_-_T2a_B4_DNA"),]

data <- matrix(NA, nrow=1, ncol=13)
colnames(data) <- c("Peptide", "ID", "gene_id", "expression", "TAP", "Cle",
                    "min_kd", "min_stab", "CCF", "EC", "DAI", "Patient", "Immunosuppression")



for (i in 1:length(clinical_data$Tumor_Sample_Barcode)){
  tumor_id <- clinical_data$Tumor_Sample_Barcode[i]
  patient_id <- clinical_data$ID[i]
  if (!file.exists(paste("Characteristic_tables/", patient_id, "_all_characteristics.csv", sep=""))){
    cat("File not ready yet! \n")
  } else {
    data_temp <- as.data.frame(read.csv(paste("Characteristic_tables/", patient_id, "_all_characteristics_add_EC_add_PRIME.csv", sep=""), row.names=1))
  
    data_temp <- data_temp[, which(colnames(data_temp) %in% c("Peptide", "ID", "gene_id", "expression", "TAP", "Cle",
                    "min_kd", "min_stab", "min_WT_kd", "CCF", "EC"))]
    
    test <- data_temp[which(is.na(data_temp$TAP)),]
    print(length(test$Peptide))
    if (length(test$Peptide)>0){
      data_temp <- data_temp[-which(is.na(data_temp$TAP)),]
    }
    
    data_temp$DAI <- data_temp$min_WT_kd/data_temp$min_kd
    
    data_temp <- data_temp[, which(colnames(data_temp) %in% c("Peptide", "ID", "gene_id", "expression", "TAP", "Cle",
                    "min_kd", "min_stab", "DAI", "CCF","EC", "DAI"))]
    data_temp$Patient <- patient_id
    data_temp$Immunosuppression <- clinical_data$Immunosuppression[i]
    data <- rbind(data, data_temp)
  
  }
}
data <- data[-1,]
print("Data compiled successfully!")
head(data)

print(data[which(is.na(data$prime)),])

## Normalize data
data_raw <- data
data$expression <- scale(log(data$expression+0.01,10), center = TRUE)
data$TAP <- scale(data$TAP, center=TRUE)
data$Cle <- scale(data$Cle, center=TRUE)
data$min_kd <- scale(log(data$min_kd+0.01,10), center=TRUE)
data$min_stab <- scale(log(data$min_stab+0.01,10), center=TRUE)
data$DAI <- scale(log(data$DAI+0.01,10), center=TRUE)
data$EC <- scale(data$EC, center=TRUE)
#data$prime <- scale(log(data$prime,10), center=TRUE)

data_raw$expression <- log(data_raw$expression+0.01,10)
data_raw$min_kd <- log(data_raw$min_kd,10)
data_raw$min_stab <- log(data_raw$min_stab,10)
data_raw$DAI <- log(data_raw$DAI,10)

## Setup
set.seed(123)
data_plot <- t(data[,c(4:8,10:11)])
#head(data_plot)
colors <- colorRampPalette(RColorBrewer::brewer.pal(11,"BrBG"))(256)

## Performs k-means clustering
data_clust <- t(data_plot)
kmeans <- kmeans(data_clust, 7)
data$clusters <- kmeans$cluster
data_raw$clusters <- kmeans$cluster

# Reorder data_plot based on clusters
ordered_indices <- order(data$clusters)
data_plot_ordered <- data_plot[, ordered_indices]

# Prepare annotations based on reordered clusters
col_cluster_annotations <- data$clusters[ordered_indices]
col_cluster_annotations <- as.data.frame(col_cluster_annotations)
row.names(col_cluster_annotations) <- colnames(data_plot_ordered)
col_cluster_annotations$col_cluster_annotations <- as.factor(col_cluster_annotations$col_cluster_annotations)

cluster_colors <- c("1" = "#CC6677", "2" = "#661100", "3" = "#999933", "4" = "#DDCC77", "5" = "#117733", "6" = "#88CCEE", "7" = "#332288", "8" = "black")

pheatmap(data_plot_ordered, cluster_rows=FALSE, cluster_cols=FALSE, show_colnames=FALSE, color = colors, annotation_col = col_cluster_annotations, annotation_colors = list(col_cluster_annotations = cluster_colors))


## Plot characteristic boxplots between the clusters

pdf("Expression_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -expression), y=expression)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C2 <- data_raw[which(data_raw$clusters==2),]
C7 <- data_raw[which(data_raw$clusters==7),]
range(C2$min_kd)
range(C7$min_kd)
range(C2$min_stab)
range(C7$min_stab)
t.test(C2$min_stab, C7$min_stab)
t.test(C2$min_kd, C7$min_kd)

pdf("Tap_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -TAP), y=TAP)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

pdf("Cle_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -Cle), y=Cle)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

pdf("Kd_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), min_kd), y=min_kd)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

pdf("Stab_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -min_stab), y=min_stab)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

pdf("DAI_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -DAI), y=DAI)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

pdf("EC_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -EC), y=EC)) + 
  geom_boxplot(outlier.shape=NULL) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

patients <- unique(data$Patient)
summary <- matrix(NA, nrow=length(unique(data$Patient)), ncol=21)

## Quantify clusters
for (i in 1:length(patients)){
  patient = patients[i]
  summary[i,2] <- length(data[which(data$Patient==patient & data$clusters==1 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,3] <- length(data[which(data$Patient==patient & data$clusters==2 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,4] <- length(data[which(data$Patient==patient & data$clusters==3 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,5] <- length(data[which(data$Patient==patient & data$clusters==4 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,6] <- length(data[which(data$Patient==patient & data$clusters==5 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,7] <- length(data[which(data$Patient==patient & data$clusters==6 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,8] <- length(data[which(data$Patient==patient & data$clusters==7 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,9] <- length(data[which(data$Patient==patient & data$clusters==8 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,10] <- length(data[which(data$Patient==patient & data$clusters==9 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,11] <- length(data[which(data$Patient==patient & data$clusters==10 & data$CCF > 0.75),1])/length(data[which(data$Patient==patient & data$CCF > 0.75),1])
  summary[i,12] <- length(data[which(data$Patient==patient & data$clusters==1 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,13] <- length(data[which(data$Patient==patient & data$clusters==2 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,14] <- length(data[which(data$Patient==patient & data$clusters==3 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,15] <- length(data[which(data$Patient==patient & data$clusters==4 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,16] <- length(data[which(data$Patient==patient & data$clusters==5 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,17] <- length(data[which(data$Patient==patient & data$clusters==6 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,18] <- length(data[which(data$Patient==patient & data$clusters==7 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,19] <- length(data[which(data$Patient==patient & data$clusters==8 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,20] <- length(data[which(data$Patient==patient & data$clusters==9 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
  summary[i,21] <- length(data[which(data$Patient==patient & data$clusters==10 & data$CCF < 0.75),1])/length(data[which(data$Patient==patient & data$CCF < 0.75),1])
}

summary[,1] <- patients
summary <- as.data.frame(summary)
summary[(summary=="NaN")] <- 0
#print(summary) 
#print(sums)
colnames(summary) <- c("Patient", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C1.1", "C2.1", "C3.1", "C4.1", "C5.1", "C6.1", "C7.1", "C8.1", "C9.1", "C10.1")
summary_plot <- reshape::melt(summary, id.vars=c("Patient"))
summary_plot$Clonal <- NA
summary_plot[1:420,4] <- "Clonal"
summary_plot[421:840,4] <- "Sub-clonal"
#print(summary_plot)
summary_plot$variable <- gsub("\\..*", "", summary_plot$variable)
clinical_data_temp <- clinical_data[match(summary_plot$Patient, clinical_data$ID),]
summary_plot$Immunosuppression <- clinical_data_temp$Immunosuppression
summary_plot$immune_clonal <- paste(summary_plot$Immunosuppression, summary_plot$Clonal, sep="_")


C <- summary_plot[which(summary_plot$variable=="C1"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C1 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C1_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C2"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C2 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_ic_sc$value), as.numeric(C_is_sc$value))
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_is_c$value))

pdf("C2_v4_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C3"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C3 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value))

pdf("C3_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C4"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C4 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C4_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C5"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C5 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C5_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C6"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C6 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C6_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()


C <- summary_plot[which(summary_plot$variable=="C7"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C7 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C7_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C8"),]
C_ic_c <- C[which(C$immune_clonal=="No_Clonal"),]
C_ic_sc <- C[which(C$immune_clonal=="No_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Yes_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Yes_Sub-clonal"),]
print("C8 cluster stats")
wilcox.test(as.numeric(C_ic_c$value), as.numeric(C_ic_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C8_v3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()
