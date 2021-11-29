#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
rm *.tmp
echo "***STARTING LOOP***"
for x in *.csv
do
	SAMPLE_NAME=$(echo "${x##*/}")	

	#Detected Species
	WC_ORGANISM=$(tail -n+2 "$x" | wc -l)
	printf "$WC_ORGANISM" > wc.tmp

	#Species count
	SPECIESNAME=$(tail -n+2 "$x" | cut -f 9 -d","| cut -f2-3 -d " "|cut -d "_" -f3-4| sort | uniq -c)
	printf "$SPECIESNAME\n" > species.tmp
	WC_SPECIES=$(cat species.tmp|wc -l)
	
	#Genus count
	GENUSCOUNT=$(tail -n+2 "$x"| cut -f 9 -d ","| cut -f2-3 -d " "| cut -d "_" -f3-4 | cut -f 1 -d " "| sort | uniq -c)
	printf "$GENUSCOUNT\n" > genus.tmp
	WC_GENUS=$(cat genus.tmp |wc -l)
	
	#Evaluate by Interseq
	INTERSEQ_NR=$(tail -n+2 "$x" | cut -f 1 -d ","| sort -h )
	printf "$INTERSEQ_NR\n" > interseq.tmp
	INTERSEQ_THRESHOLD=$(cat interseq.tmp | awk '$1 <= 20000 { print $0}' Interseq.tmp| wc -l)
	SPECIES_COUNT=$((WC_ORGANISM-INTERSEQ_THRESHOLD))
		
	#Summary
	echo "___________________"
	echo -e "**SUMMARY FOR SAMPLE:**\n \e[31m$SAMPLE_NAME\e[0m"
	echo "Detected Organismns: $WC_ORGANISM"
	echo "Different Species: $WC_SPECIES" 
	echo "Different Genuses: $WC_GENUS"
	echo "Organismns under interseq-threshold (20.000): $INTERSEQ_THRESHOLD"
	echo "Organismns over interseq-threshold: $SPECIES_COUNT"
	echo "___________________"
	echo "**Species:**"
	cat species.tmp
	echo "___________________"
	echo "**Genus:**"
	cat genus.tmp
	echo "___________________"
	echo "**Interseq summary:**"
	cat interseq.tmp
	echo "___________________"


	#Samples which can be used
	if (("$WC_ORGANISM" == "1")) 
	then
		echo "$SAMPLE_NAME" >> samples.tmp
	fi
	
	if (("$WC_GENUS" == "1")) 
	then
		echo "$SAMPLE_NAME" >> samples.tmp
	fi
	
	if (("$SPECIES_COUNT" == "1")) 
	then
		echo "$SAMPLE_NAME" >> samples.tmp
	fi

	RESULT=$(cat samples.tmp| cut -f 2 -d "_"|cut -f1-4 -d "." |sort -h| uniq)
	printf "$RESULT\n" > result.tmp
	SAMPLE_NUMBER=$(cat result.tmp|wc -l)
	SAMPLE_COMPOSITION=$(cat result.tmp| cut -f 4 -d "."| sort | uniq -c)

done

printf "%b" "\e[31m$SAMPLE_NUMBER Samples can be used for sequencing:\n$SAMPLE_COMPOSITION\nSample Names are saved in result.tmp\n\e[0m"
