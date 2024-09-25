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
                    "min_kd", "min_stab", "min_WT_kd", "CCF", "EC", ))]

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

## Normalize data
data_raw <- data
data$expression <- scale(log(data$expression+0.01,10), center = TRUE)
data$TAP <- scale(data$TAP, center=TRUE)
data$Cle <- scale(data$Cle, center=TRUE)
data$min_kd <- scale(log(data$min_kd+0.01,10), center=TRUE)
data$min_stab <- scale(log(data$min_stab+0.01,10), center=TRUE)
data$DAI <- scale(log(data$DAI+0.01,10), center=TRUE)
data$EC <- scale(data$EC, center=TRUE)

## Visualize heatmap

data_plot <- t(data[,c(4:8,10:11)])

set.seed(123)
# Elbow plot
#data_kmeans <- t(data_plot)
#wcss <- matrix(NA, nrow=10, ncol=1)
#for (i in 1:10){
#  print(i)
#  kmeans_result <- kmeans(data_kmeans, centers=i, nstart=10)
#  wcss[i] <- sum(kmeans_result$tot.withinss)
#}
#elbow_data <- data.frame(Clusters=1:10, WCSS=wcss)

#pdf("elbow_plot.pdf")
#ggplot(elbow_data, aes(x = Clusters, y = WCSS)) +
#  geom_line() +
#  geom_point() +
#  ggtitle("Elbow Method") +
#  xlab("Number of Clusters") +
#  ylab("WCSS")
#dev.off()

## Gap statistic
data_clust <- t(data_plot)
data_clust <- as.matrix(data_clust)
print(which(is.na(data_clust)))
class(data_clust)
is.numeric(data_clust)

# Compute the gap statistic
gap_stat <- clusGap(data_clust, FUN = kmeans, nstart = 25, K.max = 10, B = 50)


#nb<-NbClust(data_clust, diss=NULL, distance="euclidean", method="average")

pdf("gap_statistic.pdf")
plot(gap_stat, main = "Gap Statistic for Optimal Number of Clusters")
#fviz_nbclust(nb)
dev.off()
