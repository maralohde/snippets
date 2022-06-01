#!/bin/bash

# excecute in environment of snippy directorys
# add directory name to snps.vcf files

for f in */snps.*
    do fp=$(dirname "$f")
    fl=$(basename "$f")
    mv "$fp/$fl" "$fp/$fp"_"$fl"; 
done
