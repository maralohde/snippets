#!/bin/bash
#!/usr/bin/env bash

# SNP calling from Illumina paired reads
# run inside snippy Docker: docker run --rm -it -v $PWD:/input nanozoo/snippy:4.4.1--9debffd

# Example: 
# bash script.sh hybrid_genome.fasta illumina_genome_fastq/ 
# $1 $2 

#_________INSTALLATION_________#
apt update
apt-get install -y bc bsdmainutils 

# $1 REFERENCE
REF=$1
FASTQ_DIR=$2
CPUS="20"

REF_NAME=$(basename -s .fasta $REF)

for FASTQ in $(ls $FASTQ_DIR/*R1.fastq.gz)
do
  FASTQ_NAME=$(basename -s .fastq.gz $FASTQ)
  
  snippy --outdir "$FASTQ_NAME"_vs_"$REF_NAME" --R1 ${FASTQ} --R2 ${FASTQ%R1.fastq.gz}R2.fastq.gz --ref ${REF} --CPU 20

  # summary from snps.filt.vcf (summary.csv: reference;sample;total_variants)
  VARIANTS=$(cat  "$FASTQ_NAME"_vs_"$REF_NAME"/snps.filt.vcf |grep -v "#" | wc -l) 
  echo "${REF_NAME};${FASTQ_NAME};${VARIANTS}" >> summary.csv

done


## SUMMARY
SUM=$(cat summary.csv | cut -d ";" -f3 | paste -s -d+ |bc)
MEDIAN=$(cat summary.csv| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
AVERAGE=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < summary.csv)
MIN=$(cat summary.csv | cut -d ";" -f3 | head -n3| sort| head -n 1)
MAX=$(cat summary.csv | cut -d ";" -f3 | head -n3| sort| tail -n 1)

echo "SUM = $SUM" >> summary.csv
echo "MEDIAN = $MEDIAN" >> summary.csv
echo "AVERAGE = $AVERAGE" >> summary.csv
echo "MIN = $MIN" >> summary.csv
echo "MAX = $MAX" >> summary.csv
