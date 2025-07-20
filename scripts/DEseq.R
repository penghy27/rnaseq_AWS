# tx2gene.R

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("txdbmaker")

library(GenomicFeatures)
library(tximport)
library(readr)
library(dplyr)
library(DESeq2)

# Built tx2gene file
gtf_file <- "~/bulk_rnaseq/reference/Mus_musculus.GRCm38.102.gtf"
txdb <- makeTxDbFromGFF(gtf_file, format="gtf")
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, keys = k, keytype = "TXNAME", columns = "GENEID")
#write.csv(tx2gene, file="reference/tx2gene.csv", row.names = FALSE)

# Retrieve counts & TPM matrix 
samples <- list.dirs("~/bulk_rnaseq/results/salmon_out/", full.names = FALSE, recursive = FALSE)
files <- file.path("~/bulk_rnaseq/results/salmon_out", samples, "quant.sf")
names(files) <- samples
files


# 用 tximport 匯入
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE)
#write.csv(txi$abundance, file = "~/bulk_rnaseq/results/tpm_matrix.csv")
#write.csv(txi$counts, file = "~/bulk_rnaseq/results/count_matrix.csv")

# Create samples table
samples <- data.frame(Sample= c("SRR1552450", "SRR1552451", "SRR1552452", "SRR1552453"),
                      condition= c("virgin", "virgin", "pregnant", "pregnant"))

dds <- DESeqDataSetFromTximport(txi, colData = samples, design = ~ condition)
dds$condition <- relevel(dds$condition, ref="virgin")
keep <- rowSums(counts(dds)) >=10
dds <- dds[keep, ]
dds <- DESeq(dds)

padj <- 0.05
log2FoldChange <- 0.05
dfAll <- data.frame()

dds$Menthol <- relevel(dds$Menthol, ref = "Control")
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
dds <- DESeq(dds)

padj <- .05
minLog2FoldChange <- .5
dfAll <- data.frame()
# Get all DE results except Intercept, and "flatten" into a single file.
for (result in resultsNames(dds)){
  if(result != 'Intercept') {
    res <- results(dds, alpha = 0.05, name=result)
    dfRes <- as.data.frame(res)
    dfRes <- subset(subset(dfRes, select=c(log2FoldChange, padj)))
    dfRes$Factor <- result
    dfRes <-subset(dfRes, padj < 0.05)
    dfAll <- rbind(dfAll, dfRes)
  }
}
head(dfAll)
