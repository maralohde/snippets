# Code Snippeds for Tools
## Samtools
### Extracting contigs from multi contig fasta
```bash=
samtools faidx S.101.21.Kp_nano_polished.fasta contig_1 > S.101.21.Kp_nano_contig1.fasta
```

## Spades
### Assembly for Illumina
```bash=
spades.py -1 illumina_R1.fastq.gz -2 illumina_R2.fastq.gz --careful --cov-cutoff auto -o spades_assembly_all_illumina
```
## Unicycler
### Hybrid Assembly
```bash=
unicycler -1 <fwd>_R1.fastq.gz -2 <rev>_R2.fastq.gz -l nanopore_reads.fastq -o outputfolder
```
## Snippy
### Contig Comparison

```bash=
snippy --cpus 8 --outdir raw --ref S.101.21.Kp_ill_contigs.fasta --ctgs S.101.21.Kp_raw_contig1.fasta
```
