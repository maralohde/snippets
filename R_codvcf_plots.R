#!/usr/bin/env Rscript
install.packages("ggrepel")
library(ggrepel) 
library(ggplot2)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
# path to the sampledir
dirin <- "/cloud/project/vcf/"

filelist <- list.files(path=dirin, pattern="*.vcf")
dataframelist <- lapply(paste0(dirin,filelist), function(x) read.delim(x, header=FALSE, comment.char="#"))

filelist

df_merged=data.frame()

for (i in 1:length(dataframelist)) {
  data <- dataframelist[[i]]
  data$filename <- filelist[i]
  #assign( paste0("data_",filelist[i]), data)
  df_merged <- rbind(df_merged, data)
}

df_merged$DP <- gsub(".*DP=([0-9]+).*", "\\1", df_merged$V8)
colnames(df_merged) <- c("contig","position","col3","default","changes","col6","col7","col8","col9","col10","filename","DP")
df_merged$DP <- as.numeric(df_merged$DP)

# plots
plot <- ggplot(df_merged, aes(y = DP, x = contig, color = contig, label = position)) +
  geom_jitter(shape=16, position=position_jitter(seed = 1, 0.2)) +
  #geom_text(position = position_jitter(seed = 1, 0.2)) +
  geom_text_repel(aes()) +
  facet_grid(cols = NULL, rows = vars(filename),scales = "fixed", space = "fixed",) +
  xlab("") + 
  ylab("Read depth of each variation call") +
  theme(legend.position = "none")

resize_h <- (2 * length(filelist))

pdf("read_depth_of_variant_calls.pdf",height = resize_h, width = 10) 
plot
dev.off()


plot2 <- ggplot(df_merged, stat= "scaled", aes(x=position)) +
  geom_histogram(aes(fill=factor(contig)), color="#FFFFFF")+
  facet_grid(rows = vars(filename), cols = vars(contig),scales = "free_x", space = "fixed",) +
  #theme_classic() +
  xlab("contigs iłn bp") + 
  ylab("Number of SNPs") +
  ggtitle("SNP Distribution across the contig") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  xlab("Contig length")

pdf("SNP_distro_per_contig.pdf",height = resize_h, width = 10) 
plot2
dev.off()
