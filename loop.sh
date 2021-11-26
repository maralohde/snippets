#!/bin/bash
rm *.tmp
echo "starting loop"
for x in 210921140822329_S.139.21.Ec.fasta_composition.csv
do
	#Detected Species
	WC_NUMBER=$(tail -n+2 "$x" | wc -l)
	SPECIESNAME=$(head -2 $x | tail -1 | cut -f9 -d","| cut -f2-3 -d " ")
	printf "$WC_NUMBER" >> wc.tmp

	#species count
	WC_NUMBER=$(tail -n+2 "$x" | wc -l)
	SPECIESNAME=$(tail -n+2 "$x" | cut -f 9 -d","| cut -f2-3 -d " "|cut -d "_" -f3-4| sort | uniq -c)
 	printf "$SPECIESNAME\n" >> species.tmp
	
	#genus count
	GENUSCOUNT=$(tail -n+2 "$x"| cut -f 9 -d ","| cut -f2-3 -d " "| cut -d "_" -f3-4 | cut -f 1 -d " "| sort | uniq -c)
	printf "$GENUSCOUNT\n" >> genus.tmp

	# evaluate by Interseq
	INTERSEQ_NR=$(tail -n+2 "$x" | cut -f 1 -d ","| sort -h )
	printf "$INTERSEQ_NR\n" >> Interseq.tmp
done

echo "Detected Species: $WC_NUMBER" 
echo "_________"
echo "Species summary:"
cat species.tmp
echo "_________"
echo "Genus summary:"
cat genus.tmp
echo "_________"
echo "Interseq summary:"
cat Interseq.tmp
	
 #| grep ";1$"| sort | uniq -c
