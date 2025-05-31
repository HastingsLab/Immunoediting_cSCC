
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
data_plot <- t(data[,c(4:5,7:9, 11:12)])
#data_plot <- t(data[,c(4:5,7:9)])
#data_plot <- t(data[,c(5,7:9)])
colors <- colorRampPalette(RColorBrewer::brewer.pal(11,"BrBG"))(256)

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
