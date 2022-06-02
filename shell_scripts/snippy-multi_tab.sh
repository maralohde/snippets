#!/bin/bash

# execute in directory were all *.fastas are located for snippy analysis

for X in *.fasta
do 
	NAME=$(ls "$X"|cut -d "." -f 1)
	WEG=$(pwd $X)
	echo "$NAME	$WEG" >> snippy.tab
done
