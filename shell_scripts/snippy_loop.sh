#!/bin/bash
for X in *.fasta
do
	SAMPLE_NAME=$(echo "$X" ls | cut -f 1-2 -d "_") #with technology
	SAMPLE=$(echo "$X" ls | cut -f 1 -d "_") #without_technology
	snippy --cpus 8 --outdir "$SAMPLE_NAME" --ref "$SAMPLE"_ill_*.fasta --ctgs  "$SAMPLE_NAME"*.fasta
	echo "Sample: "$SAMPLE_NAME"" >> "$SAMPLE_NAME"_variants.txt
	echo "Reference: "$SAMPLE"_ill" >> "$SAMPLE_NAME"_variants.txt
	cat "$SAMPLE_NAME"/*.txt| grep "Variant" >> "$SAMPLE_NAME"_variants.txt
	mkdir snippy_variants | mv "$SAMPLE_NAME"_variants.txt snippy_variants/
done
