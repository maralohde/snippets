#!/bin/bash

CPUS="20"
DIR="BAMS"
mkdir -p "${DIR}"

for ONT in ont/*.fasta; do 
	for ILL in ill/*fasta; do
		ILLNAME=$(basename ${ILL%.fasta})
		ONTNAME=$(basename ${ONT%.fasta})
		echo "## Mapping $ILLNAME contigs on $ONTNAME"
		
		minimap2 -ax map-ont ${ONT} ${ILL} | samtools view -bS - | samtools sort -@ ${CPUS} - > ${DIR}/ont-${ONTNAME}-to-ill-${ILLNAME}.bam
		chmod 666 ${DIR}/ont-${ONTNAME}-to-ill-${ILLNAME}.bam
	done
done
