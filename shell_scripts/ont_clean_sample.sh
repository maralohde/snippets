#!/bin/bash
# extracting chromosom (longest contig)
# check if chromosom is closed first

for X in all_contigs/*.fasta;
do
samtools faidx "$X"
cat "$X".fai| column -t |sort -rk2 -n | awk 'FNR <= 1'| awk '{$2=$2};1'| cut -f1 -d " " > ${X%.fasta}_list.txt 
xargs samtools faidx "$X" <"${X%.fasta}_list.txt"> ${X%.fasta}_cleaned.fasta
rm "$X".fai
rm ${X%.fasta}_list.txt 
done

