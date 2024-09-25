library(stringr)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
print(input)
output <- args[2]

data <- as.data.frame(read.table(input, skip=1, header=TRUE))
head(data)
length(data$Peptide)
data <- data[which(str_length(data$Peptide)==9),]
length(data$Peptide)
data <- data$Peptide
data <- unique(data)
data <- data[-1]

write.table(data, output, row.names=FALSE, quote=FALSE, col.names=FALSE)
