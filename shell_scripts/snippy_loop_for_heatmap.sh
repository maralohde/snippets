#!/bin/bash

# run snippy for all files in 2 dirs 
# output: .csv with ref;ctgs;SNPS

for X in reference/*.fasta
do
        echo "__________Ref: $X"
        for Y in ctgs/*.fasta
        do
        snippy --cpus 20 --outdir ${X%.fasta}_vs_${Y%.fasta} --ref $X --ctgs $Y
        VALUE=$(grep "Variant-SNP" ${X%.fasta}_vs_${Y%.fasta}/snps.txt | cut -f2)
        echo "reference;ctgs;SNPS" >> SNP_results_1.csv
        echo "$X;$Y;$VALUE" >> SNP_results_1.csv
        done
done 
