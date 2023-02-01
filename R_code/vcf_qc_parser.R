library (dplyr)

args <- commandArgs(trailingOnly = TRUE) 
inputfile <- args[1]
outputfile <- args[2]

df <- read.table(inputfile, sep="\t", header=FALSE)
df$DP <- gsub(".*DP=([0-9]+).*", "\\1", df$V8)
colnames(df) <- c("contig","position","col3","default","changes","quality","col7","col8","col9","col10","DP")
df <- df[df$quality >= 20,]
df <- df[df$DP >= 30,]

keeps <- c("contig","position","col3","default","changes","quality","col7","col8","col9","col10")
df_save <- df[keeps]

write.table(df_save, outputfile, row.names=FALSE, quote=FALSE, col.names=FALSE, sep='\t') 
