# Code Snippeds for Tools
## [Samtools](https://github.com/samtools/samtools)
*Extracting contigs from multi contig fasta*
```bash=
samtools faidx S.101.21.Kp_nano_polished.fasta contig_1 > S.101.21.Kp_nano_contig1.fasta
```
*Extracting coverage info*
```bash=
samtools depth  *bam  |  awk '{sum+=$3} END { print sum/NR}'
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
snippy-clean_full_aln core.full.aln > clean.full.aln
run_gubbins.py -p gubbins clean.full.aln
snp-sites -c gubbins.filtered_polymorphic_sites.fasta > clean.core.aln
FastTree -gtr -nt clean.core.aln > clean.core.tree
```
## Guppy
*Basecalling*
```bash=
guppy_basecaller -c dna_r10.4_e8.1_modbases_5hmc_5mc_cg_sup.cfg -r -i nano-server/GRIDION_DISK/20220407_klebsiella_outbreak_ukl_batch04/20220407_klebsiella_outbreak_ukl_batch04/20220407_1344_X2_FAR28270_3cd30ca5/fast5_pass/ -s basecalled_demulti_data --device auto  --barcode_kits "SQK-NBD112-24" --gpu_runners_per_device 20
```
## [Assembly-stats](https://github.com/sanger-pathogens/assembly-stats#installation)
Statistics for Assemblys
```bash=
docker run --rm -it -v $PWD:/input sangerpathogens/assembly-stats:version-1.0.1-docker1 bash
```
