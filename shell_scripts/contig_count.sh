#!/bin/bash

# Print number of contig of each sample

rm *.tmp
echo "***STARTING LOOP***"
for x in *_polished.fasta
do

        SAMPLE_NAME=$(echo "${x##*/}")

        #Contigs
        CONTIGS_COUNT=$(cat "$x" | grep ">"| wc -l)
        printf "$CONTIGS_COUNT" > contigs_count.tmp

        echo "___________________"
        echo -e "**SUMMARY FOR SAMPLE:**\n \e[31m$SAMPLE_NAME\e[0m"
        echo "Detected Contigs: $CONTIGS_COUNT"
done
