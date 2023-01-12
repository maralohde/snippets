#!/bin/bash
#!/usr/bin/env bash

# SNP calling from Illumina paired reads
# run inside snippy Docker: docker run --rm -it -v $PWD:/input nanozoo/snippy:4.4.1--9debffd

# Example: 
# bash script.sh hybrid_genome.fasta illumina_genome_fastq/ 
# $1 $2 

# $1 REFERENCE
REF=$1
FASTQ_DIR=$2
CPUS="20"

for FASTQ in $(ls $FASTQ_DIR/*R1.fastq.gz)
do
  snippy --outdir $(basename -s .fastq.gz $FASTQ)_vs_$(basename -s .fasta ${REF}) \
  --R1 ${FASTQ} --R2 ${FASTQ%R1.fastq.gz}R2.fastq.gz --ref ${REF} --CPU 20
done
