#!/bin/bash
mkdir longest_contig
for X in *q20*.fasta
do
        SAMPLE_NAME=$(ls $X |  cut -f 1-2 -d "_")
        samtools faidx $X
        cat *.fai |sort -h -k2| tail -1 > "$SAMPLE_NAME"_longest_contig.txt
        rm *.fai
        CONTIG=$(cut -f1 "$SAMPLE_NAME"_longest_contig.txt)
        samtools faidx $X "$CONTIG" > "$SAMPLE_NAME"_longest_contig.fasta
        mv "$SAMPLE_NAME"_longest_contig.fasta longest_contig
done
