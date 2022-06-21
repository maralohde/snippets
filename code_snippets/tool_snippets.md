# Code Snippeds for Tools
## [Samtools](https://github.com/samtools/samtools)
*Extracting contigs from multi contig fasta*
```bash=
samtools faidx S.101.21.Kp_nano_polished.fasta contig_1 > S.101.21.Kp_nano_contig1.fasta
```

## Spades
*Assembly for Illumina*
```bash=
spades.py -1 illumina_R1.fastq.gz -2 illumina_R2.fastq.gz --careful --cov-cutoff auto -o spades_assembly_all_illumina
```
## [Unicycler](https://github.com/rrwick/Unicycler)
*Hybrid Assembly*
```bash=
unicycler -1 <fwd>_R1.fastq.gz -2 <rev>_R2.fastq.gz -l nanopore_reads.fastq -o outputfolder
```
## [Snippy](https://github.com/tseemann/snippy)
*Contig Comparison*
```bash=
snippy --cpus 8 --outdir raw --ref S.101.21.Kp_ill_contigs.fasta --ctgs S.101.21.Kp_raw_contig1.fasta
```

## [RepeatMasker](https://github.com/rmhubley/RepeatMasker)
*Masking repetitiv areas*
```bash=
RepeatMasker *.fasta
```
## [Gubbins](https://github.com/nickjcroucher/gubbins)
*Masking recombinant areas*
```bash=
% snippy-clean_full_aln core.full.aln > clean.full.aln
% run_gubbins.py -p gubbins clean.full.aln
% snp-sites -c gubbins.filtered_polymorphic_sites.fasta > clean.core.aln
% FastTree -gtr -nt clean.core.aln > clean.core.tree
```
