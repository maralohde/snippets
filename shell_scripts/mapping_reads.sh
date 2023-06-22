#!/bin/bash
# Loop to map read from one sample to the related assembly
bash mapping_read.sh fasta/ fastq/

CPUS="20"
DIR="BAMS"
mkdir -p "${DIR}"
fasta_dir=$1
fastq_dir=$2

# Loop over Files in fasta dir
for fasta in "$fasta_dir"/*.fasta; do
    # extract basename
    fasta_name=$(basename "$fasta")
    fasta_name="${fasta_name%.fasta}"  # remove file ending

    # Loop over Files in fastq dir
    for fastq in "$fastq_dir"/*.fastq.gz; do
        # extract basename
        fastq_name=$(basename "$fastq")
        fastq_name="${fastq_name%.fastq.gz}"  # remove file ending

        # Compare basenames of fasta and fastq files
        if [ "$fasta_name" = "$fastq_name" ]; then
            echo "Mapping $fastq reads on $fasta"
            minimap2 -ax map-ont ${fasta} ${fastq} | samtools view -bS - | samtools sort -@ ${CPUS} - > ${DIR}/${fasta_name}.bam
          	chmod 666 ${DIR}/${fasta_name}.bam
        fi
    done
done
