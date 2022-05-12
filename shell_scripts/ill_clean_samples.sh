#!/bin/bash
# extracting mapped contigs

reference=${1}
#ctgs=${2}  # dir/*.fasta

for X in all_contigs/*.fasta;
do
    NAME=$(ls ${X} |cut -d "/" -f 2| cut -d "." -f 1)

    # Mapping
    minimap2 -ax map-ont ${reference} "$X" | samtools view -bS - | samtools sort - > "$NAME".bam

    # Converting from .bam to .sam
    samtools view -bh "$NAME".bam > "$NAME"_contigs.bam

    #Extract only mapped contigs
    samtools view -F4 "$NAME"_contigs.bam > "$NAME"_mapped_contigs.sam

    # Make a list with mapped contigs for samtool
    cut -f1 "$NAME"_mapped_contigs.sam | sort | uniq > "$NAME"_mapped.list

    # Extract mapped contigs from .fasta file
    xargs samtools faidx "$X" < "$NAME"_mapped.list> "$NAME"_cleaned.fasta

    # sorting files into dir
    mkdir -p "$NAME"_clean/
    mkdir -p ill_fasta_clean/
    mv "$NAME".bam "$NAME"_clean/
    mv "$NAME"_contigs.bam "$NAME"_clean/
    mv "$NAME"_mapped_contigs.sam "$NAME"_clean/
    mv "$NAME"_mapped.list "$NAME"_clean/
    mv "$NAME"_cleaned.fasta ill_fasta_clean/

done
