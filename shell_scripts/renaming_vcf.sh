#!/bin/bash

# add directory name to snps.vcf files

for f in */snps.vcf
    do fp=$(dirname "$f")
    fl=$(basename "$f")
    mv "$fp/$fl" "$fp/$fp"_"$fl"; 
done
