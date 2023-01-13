#!/bin/bash
#!/usr/bin/env bash

# run inside medaka Docker: docker run --rm -it -v $PWD:/input  nanozoo/medaka:1.7.2--aa54076

# Example: 
# bash script.sh fastq_dir/ ont_reference.fasta 
# $1 $2 $3 

#____________INPUTS____________#
# $1 fastq/fastq.gz fastq_dir/ (-i)
    FASTQ=$1
    #FASTQ_NAME=$(basename ${FASTQ})
# $2 reference (-ref)
    REFERENCE=$2
    REFERENCE_NAME=$(basename -s ".fasta" ${REFERENCE})
# $3 guppy model (-m)
    #MODEL=$3

################################################
    echo "############"
    echo -e "\033[1m#  MEDAKA #\033[22m"
    echo "############"   

for FASTQ_FILE in ${FASTQ}*.fastq.gz
do
    echo $FASTQ_FILE
    FASTQ_NAME=$(basename -s ".fastq.gz" ${FASTQ_FILE})
    echo $FASTQ_NAME
    echo $REFERENCE
    medaka_haploid_variant -i ${FASTQ_FILE} -r ${REFERENCE} -m r104_e81_sup_variant_g610 -o medaka_${FASTQ_NAME}_vs_${REFERENCE_NAME} -t2
done
