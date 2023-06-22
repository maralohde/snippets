#!/bin/bash
# calculate meandepth with samtools
# print average and median depth and depth of chromosome contig in a summary file

touch coverage_summary.csv
echo "name,average_depth,median_depth,chr_depth" >> coverage_summary.csv

for bam in *.bam ; do
bam_name="${bam%.bam}"

samtools coverage $bam > ${bam_name}_coverage.txt

DEPTH_AVERAGE="$(cat ${bam_name}_coverage.txt| tr -t "[:blank:]" ";"| cut -d ";" -f 7 | tail -n +2|awk '{ total += $1 } END { print total/NR }')" >> ${bam_name}_coverage.txt
DEPTH_MEDIAN="$(cat ${bam_name}_coverage.txt | tr -t "[:blank:]" ";"| cut -d ";" -f 7 | tail -n +2| sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')" >> ${bam_name}_coverage.txt
CHR_CONTIG_DEPTH="$(cat ${bam_name}_coverage.txt| grep -v "#"| sort -n -k 3 | tail -n 1 | tr -t "[:blank:]" ";"| cut -d ";" -f7)"

echo "$bam_name,$DEPTH_AVERAGE,$DEPTH_MEDIAN,$CHR_CONTIG_DEPTH" >> coverage_summary.csv

done
