library(cluster)
library(ggplot2)
#library(factoextra)
library(NbClust)
library(pheatmap)

clinical_data <- as.data.frame(read.csv("Metadata_annotations_all_Mayo_samples_immune_binary.csv"))

#data <- matrix(NA, nrow=1, ncol=13)
#colnames(data) <- c("ID","CCF","gene","expression","min_binding","MT_9mer","Cle","TAP","max_stability","EC","DAI", "Patient", "Immunosuppression")
data <- matrix(NA, nrow=1, ncol=14)
colnames(data) <- c("ID","CCF","gene","expression","min_binding","MT_9mer","max_stability","Cle", "TAP", "netMHC_II_binding","EC","DAI", "Patient", "Immunosuppression")


for (i in 1:length(clinical_data$Tumor_Sample_Barcode)){
  tumor_id <- clinical_data$Tumor_Sample_Barcode[i]
  patient_id <- clinical_data$ID[i]
  #print(paste("/xdisk/khasting/knodele/Mayo_data/Characteristics_tables/", patient_id, "_all_characteristics_add_EC.csv", sep=""))
  data_temp <- as.data.frame(read.table(paste("/xdisk/khasting/knodele/Mayo_data/Characteristics_tables/", patient_id, "_all_characteristics_add_EC.csv", sep=""),sep=",", header=TRUE))
  #print(head(data_temp))
  data_temp <- data_temp[which(!duplicated(data_temp$MT_9mer)),]
  data_temp <- data_temp[, which(colnames(data_temp) %in% c("MT_9mer", "V5", "gene", "expression", "TAP", "Cle",
                    "min_binding", "max_stability", "WT_binding", "CCF", "EC", "netMHC_II_binding"))]
  #print(head(data_temp))
  test <- data_temp[which(is.na(data_temp$TAP)),]
  #print(length(test$MT_9mer))
  if (length(test$MT_9mer)>0){
    data_temp <- data_temp[-which(is.na(data_temp$TAP)),]
  }
  test <- data_temp[which(is.na(data_temp$expression)),]
  data_temp$DAI <- data_temp$WT_binding/data_temp$min_binding
    
  data_temp <- data_temp[, which(colnames(data_temp) %in% c("MT_9mer", "V5", "gene", "expression", "TAP", "Cle",
                    "min_binding", "max_stability", "DAI", "CCF","EC", "DAI", "netMHC_II_binding"))]
  #print(colnames(data_temp))
  colnames(data_temp) <- c("ID","CCF","gene","expression","min_binding","MT_9mer","max_stability","Cle","TAP","netMHC_II_binding", "EC","DAI")
  #colnames(data_temp) <- c("ID","CCF","gene","expression","min_binding","MT_9mer","max_stability","EC","DAI")
  #print(head(data_temp))
  #print(colnames(data_temp))
  data_temp$Patient <- patient_id
  data_temp$Immunosuppression <- clinical_data$Immunosuppression[i]
  data <- rbind(data, data_temp)
  
}

data <- data[-1,]
print("Data compiled successfully!")
#head(data)

#print(data[which(is.na(data$prime)),])

## Normalize data
data <- data[-which(is.na(data$expression)),]
print(data[which(data$EC ==0),])
data <- data[-which(data$EC ==0),]
data_raw <- data
data$expression <- scale(log(data$expression+0.01,10), center = TRUE)
data$TAP <- scale(data$TAP, center=TRUE)
data$Cle <- scale(data$Cle, center=TRUE)
data$min_binding <- scale(log(data$min_binding,10), center=TRUE)
#data$min_binding <- scale(data$min_binding, center=TRUE)
data$max_stability <- scale(log(as.numeric(data$max_stability),10), center=TRUE)
#data$max_stability <- scale(log(as.numeric(data$max_stability),10), center=TRUE)
data$DAI <- scale(log(data$DAI,10), center=TRUE)
#data$DAI <- scale(log(data$DAI,10), center=TRUE)
data$EC <- scale(data$EC, center=TRUE)
data$netMHC_II_binding <- scale(log(as.numeric(data$netMHC_II_binding),10), center=TRUE)
#head(data)

data_raw$expression <- log(data_raw$expression+0.01,10)
data_raw$min_binding <- log(data_raw$min_binding,10)
data_raw$max_stability <- log(data_raw$max_stability,10)
data_raw$DAI <- log(data_raw$DAI,10)

print(sum(is.nan(data$netMHC_II_binding)))
print(sum(is.nan(data$TAP)))
print(sum(is.nan(data$Cle)))
print(sum(is.nan(data$min_binding)))
print(sum(is.nan(data$max_stability)))
print(sum(is.nan(data$DAI)))
print(sum(is.nan(data$EC)))

## Setup
set.seed(123)
data_plot <- t(data[,c(4:5,7:9, 12)])
#data_plot <- t(data[,c(4:5,7:9)])
#data_plot <- t(data[,c(5,7:9)])
colors <- colorRampPalette(RColorBrewer::brewer.pal(11,"BrBG"))(256)

#print(length(data$TAP))
## Performs k-means clustering
data_clust <- t(data_plot)
head(data_clust)
kmeans <- kmeans(data_clust, 6)
print(length(kmeans$cluster))
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
  geom_violin() + theme_minimal()
dev.off()

#C6 <- data_raw[which(data_raw$clusters==6),]
#C7 <- data_raw[which(data_raw$clusters==7),]
#range(C6$min_binding)
#range(C7$min_binding)
#range(C6$max_stability)
#range(C7$max_stability)
#range(C6$expression)
#range(C7$expression)
#t.test(C6$max_stability, C7$max_stability)
#t.test(C6$min_binding, C7$min_binding)
#t.test(C6$expression, C7$expression)

pdf("Tap_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -TAP), y=TAP)) + 
  geom_violin() + theme_minimal()
dev.off()

pdf("Cle_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -Cle), y=Cle)) + 
  geom_violin() + theme_minimal()
dev.off()

pdf("Kd_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), min_binding), y=min_binding)) + 
  geom_violin() + theme_minimal()
dev.off()

pdf("Stab_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -max_stability), y=max_stability)) + 
  geom_violin() + theme_minimal()
dev.off()

pdf("DAI_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -DAI), y=DAI)) + 
  geom_violin() + theme_minimal()
dev.off()

pdf("EC_v_clusters.pdf")
ggplot(data_raw, aes(x=reorder(as.factor(clusters), -EC), y=EC)) + 
  geom_violin() + theme_minimal()
dev.off()

patients <- unique(data$Patient)
summary <- matrix(NA, nrow=length(unique(data$Patient)), ncol=21)
print(length(unique(data$Patient)))

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
#print(head(summary))
#print(length(summary$Patient))
summary_plot <- reshape::melt(summary, id.vars=c("Patient"))
summary_plot$Clonal <- NA
#print(length(summary$Clonal))
summary_plot[1:590,4] <- "Clonal"
summary_plot[491:1180,4] <- "Sub-clonal"
#print(sum(is.na(summary_plot$Clonal)))
#print(summary_plot)
summary_plot$variable <- gsub("\\..*", "", summary_plot$variable)
clinical_data_temp <- clinical_data[match(summary_plot$Patient, clinical_data$ID),]
print(identical(summary_plot$Patient, clinical_data_temp$ID))
summary_plot$Immunosuppression <- clinical_data_temp$Immunosuppression
summary_plot$Immune_binary <- clinical_data_temp$immune_binary
summary_plot$Dataset <- clinical_data_temp$Dataset
#summary_plot$immune_clonal <- paste(summary_plot$Immunosuppression, summary_plot$Clonal, sep="_")
summary_plot$immune_clonal <- paste(summary_plot$Immune_binary, summary_plot$Clonal, sep="_")
print(table(summary_plot$immune_clonal))

C <- summary_plot[which(summary_plot$variable=="C1"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C1 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C1_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C2"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C2 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C2_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C3"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C3 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C3_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C4"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C4 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C4_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C5"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C5 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C5_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C6"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C6 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C6_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()


C <- summary_plot[which(summary_plot$variable=="C7"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C7 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C7_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal()
dev.off()

C <- summary_plot[which(summary_plot$variable=="C8"),]
C_ich_c <- C[which(C$immune_clonal=="high_Clonal"),]
C_ich_sc <- C[which(C$immune_clonal=="high_Sub-clonal"),]
C_icl_c <- C[which(C$immune_clonal=="low_Clonal"),]
C_icl_sc <- C[which(C$immune_clonal=="low_Sub-clonal"),]
C_is_c <- C[which(C$immune_clonal=="Suppressed_Clonal"),]
C_is_sc <- C[which(C$immune_clonal=="Suppressed_Sub-clonal"),]
print("C8 cluster stats")
wilcox.test(as.numeric(C_ich_c$value), as.numeric(C_ich_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_icl_c$value), as.numeric(C_icl_sc$value), paired=TRUE)
wilcox.test(as.numeric(C_is_c$value), as.numeric(C_is_sc$value), paired=TRUE)

pdf("C8_boxplot.pdf")
ggplot(C, aes(x=immune_clonal, y=as.numeric(value))) + geom_boxplot(outlier.shape = NA) + geom_jitter(width=0.05) + theme_minimal() + geom_line(aes(group=Patient))+ theme(axis.text.x = element_text(angle = 30, hjust = 1))
dev.off()
