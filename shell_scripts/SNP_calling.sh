#!/bin/bash
#!/usr/bin/env bash

# run inside snippy Docker
# Example: 
# bash script.sh illumina_genome_fasta/ illumina_chromosome_fasta/ ont_genome_fasta/ ont_chromosome_fasta/ hybrid_genome.fasta hybrid_chromosome.fasta illumina_chromosome_ref.fasta ont_ref.fasta
# $1 $2 $3 $4 $5 $6 $7 $8 $9 $10

#____________INPUTS____________#
# $1 illumina_genome_fasta_dir/
    ILL_GENOME_FASTA_DIR=$1
    ILL_GENOME_FASTA_DIR_NAME=$(basename ${ILL_GENOME_FASTA_DIR})
# $2 illumina_chromosome_fasta_dir/
    ILL_CHROMOSOME_FASTA_DIR=$2
    ILL_CHROMOSOME_FASTA_DIR_NAME=$(basename ${ILL_CHROMOSOME_FASTA_DIR})
# $3 ont_genome_fasta_dir/
    ONT_GENOME_FASTA_DIR=$3
    ONT_GENOME_FASTA_DIR_NAME=$(basename ${ONT_GENOME_FASTA_DIR})
# $4 ont_chromosome_fasta_dir/
    ONT_CHROMOSOME_FASTA_DIR=$4
    ONT_CHROMOSOME_FASTA_DIR_NAME=$(basename ${ONT_CHROMOSOME_FASTA_DIR})
# $5 hybrid_genome_ref.fasta
    HYBRID_GENOME_REF=$5
    HYBRID_GENOME_REF_NAME=$(basename -s .fasta ${HYBRID_GENOME_REF})
# $6 hybrid_chromosome_ref.fasta
    HYBRID_CHROMOSOME_REF=$6
    HYBRID_CHROMOSOME_REF_NAME=$(basename -s .fasta ${HYBRID_CHROMOSOME_REF})
# $7 Ill_genome_ref.fasta
    ILL_GENOME_REF=$7
    ILL_GENOME_REF_NAME=$(basename -s .fasta ${ILL_GENOME_REF})
# $8 Ill_chromosome_ref.fasta
    ILL_CHROMOSOME_REF=$8
    ILL_CHROMOSOME_REF_NAME=$(basename -s .fasta ${ILL_CHROMOSOME_REF})
# $9 ONT_genome_ref.fasta
    ONT_GENOME_REF=$9
    ONT_GENOME_REF_NAME=$(basename -s .fasta ${ONT_GENOME_REF})
# $10 ONT_chromosome_ref.fasta
    ONT_CHROMOSOME_REF=${10}
    ONT_CHROMOSOME_REF_NAME=$(basename -s .fasta ${ONT_CHROMOSOME_REF})

################################################

################################################
    echo "############"
    echo -e "\033[1m#  SNIPPY  #\033[22m"
    echo "############"
# 1. SNIPPY
## 1.1 snippy gg ref hybrid genome
    echo -e "\033[0;31m1.1 snippy gg ref hybrid genome\033[0m"
### 1.1.1 ILLUMINA
    OUTDIR1="results/snippy_hybrid_ref_vs_Ill_genome"
    OUTDIR1_NAME=$(basename ${OUTDIR1})
    mkdir -p ${OUTDIR1}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${HYBRID_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR1}/${OUTDIR1_NAME}.csv
            mv ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR1}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR1}/${OUTDIR1_NAME}.csv > ${OUTDIR1}/SNP_resume_${OUTDIR1_NAME}.csv

### 1.1.2 ONT
    OUTDIR2="results/snippy_hybrid_ref_vs_ONT_genome"
    OUTDIR2_NAME=$(basename ${OUTDIR2})
    mkdir -p ${OUTDIR2}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${HYBRID_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR2}/${OUTDIR2_NAME}.csv
            mv ${HYBRID_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR2}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR2}/${OUTDIR2_NAME}.csv > ${OUTDIR2}/SNP_resume_${OUTDIR2_NAME}.csv

## 1.2. snippy gg ref hybrid chromosome
    echo -e "results/1.2 snippy gg ref hybrid chromosome"
### 1.2.1 ILLUMINA
    OUTDIR3="results/snippy_hybrid_ref_vs_Ill_chromosome"
    OUTDIR3_NAME=$(basename ${OUTDIR3})
    mkdir -p ${OUTDIR3}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${HYBRID_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR3}/${OUTDIR3_NAME}.csv
            mv ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR3}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR3}/${OUTDIR3_NAME}.csv > ${OUTDIR3}/SNP_resume_${OUTDIR3_NAME}.csv


### 1.2.2 ONT
    OUTDIR4="results/snippy_hybrid_ref_vs_ONT_chromosome"
    OUTDIR4_NAME=$(basename ${OUTDIR4})
    mkdir -p ${OUTDIR4}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${HYBRID_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR4}/${OUTDIR4_NAME}.csv
            mv ${HYBRID_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR4}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR4}/${OUTDIR4_NAME}.csv > ${OUTDIR4}/SNP_resume_${OUTDIR4_NAME}.csv

## 1.3 Ill Genome ref
    echo -e "\033[0;31m1.3 snippy gg ref Ill genome\033[0m"
### 1.3.1 gg Ill Genome
    OUTDIR5="results/snippy_Ill_genome_ref_vs_Ill_genome"
    OUTDIR5_NAME=$(basename ${OUTDIR5})
    mkdir -p ${OUTDIR5}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ILL_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR5}/${OUTDIR5_NAME}.csv
            mv ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR5}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR5}/${ILL_GENOME_REF_NAME}_vs_${ILL_GENOME_REF_NAME}
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR5}/${OUTDIR5_NAME}.csv > ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_GENOME_REF_NAME};${ILL_GENOME_REF_NAME}/d" ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}.csv > ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}_modified.csv 

### 1.3.2 gg ONT Genome
    OUTDIR6="results/snippy_Ill_genome_ref_vs_ONT_genome"
    OUTDIR6_NAME=$(basename ${OUTDIR6})
    mkdir -p ${OUTDIR6}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ILL_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR6}/${OUTDIR6_NAME}.csv
            mv ${ILL_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR6}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR6}/${OUTDIR6_NAME}.csv > ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_GENOME_REF_NAME};${ILL_GENOME_REF_NAME};/d" ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}.csv > ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}_modified.csv 

## 1.4 ONT Genome ref
    echo -e "\033[0;31m1.4 snippy gg ref ONT genome\033[0m"
### 1.4.1 gg ref Ill Genome
    OUTDIR7="results/snippy_ONT_genome_ref_vs_Ill_genome"
    OUTDIR7_NAME=$(basename ${OUTDIR7})
    mkdir -p ${OUTDIR7}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ONT_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR7}/${OUTDIR7_NAME}.csv
            mv ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR7}
        done
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR7}/${OUTDIR7_NAME}.csv > ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_GENOME_REF_NAME};${ONT_GENOME_REF_NAME}/d" ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}.csv > ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}_modified.csv 


### 1.4.2 gg ref ONT Genome
    OUTDIR8="results/snippy_ONT_genome_ref_vs_ONT_genome"
    OUTDIR8_NAME=$(basename ${OUTDIR8})
    mkdir -p ${OUTDIR8}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ONT_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR8}/${OUTDIR8_NAME}.csv
            mv ${ONT_GENOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR8}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR8}/${ONT_GENOME_REF_NAME}_vs_${ONT_GENOME_REF_NAME}
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR8}/${OUTDIR8_NAME}.csv > ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_GENOME_REF_NAME};${ONT_GENOME_REF_NAME};/d" ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}.csv > ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}_modified.csv 

## 1.5 gg ref Ill Chromosome
    echo -e "\033[0;31m1.5 snippy gg ref Ill chromosome\033[0m"
### 1.5.1 gg Ill Chromosome
    OUTDIR9="results/snippy_Ill_chromosome_ref_vs_Ill_chromosome"
    OUTDIR9_NAME=$(basename ${OUTDIR9})
    mkdir -p ${OUTDIR9}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ILL_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR9}/${OUTDIR9_NAME}.csv
            mv ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR9}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR9}/${ILL_CHROMOSOME_REF_NAME}_vs_${ILL_CHROMOSOME_REF_NAME}
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR9}/${OUTDIR9_NAME}.csv > ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_CHROMOSOME_REF_NAME};${ILL_CHROMOSOME_REF_NAME};/d" ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}.csv > ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}_modified.csv 

### 1.5.2 gg ONT Chromosome
    OUTDIR10="results/snippy_Ill_chromosome_ref_vs_ONT_chromosome"
    OUTDIR10_NAME=$(basename ${OUTDIR10})
    mkdir -p ${OUTDIR10}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ILL_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR10}/${OUTDIR10_NAME}.csv
            mv ${ILL_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR10}
        done
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR10}/${OUTDIR10_NAME}.csv > ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_CHROMOSOME_REF_NAME};${ILL_CHROMOSOME_REF_NAME};/d" ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}.csv > ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}_modified.csv 


## 1.6 ONT Chromosome
    echo -e "\033[0;31m1.6 snippy gg ref ONT chromosome\033[0m"
### 1.6.1 gg Ill Chromosome
    OUTDIR11="results/snippy_ONT_chromosome_ref_vs_Ill_chromosome"
    OUTDIR11_NAME=$(basename ${OUTDIR11})
    mkdir -p ${OUTDIR11}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ONT_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR11}/${OUTDIR11_NAME}.csv
            mv ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR11}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR11}/${OUTDIR11_NAME}.csv > ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_CHROMOSOME_REF_NAME};${ONT_CHROMOSOME_REF_NAME};/d" ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}.csv > ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}_modified.csv 


### 1.6.2 gg ONT Chromosome
    OUTDIR12="results/snippy_ONT_chromosome_ref_vs_ONT_chromosome"
    OUTDIR12_NAME=$(basename ${OUTDIR12})
    mkdir -p ${OUTDIR12}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus 20 --outdir ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} --ref ${ONT_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR12}/${OUTDIR12_NAME}.csv
            mv ${ONT_CHROMOSOME_REF_NAME}_vs_${FASTA_NAME} ${OUTDIR12}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR12}/${ONT_CHROMOSOME_REF_NAME}_vs_${ONT_CHROMOSOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR12}/${OUTDIR12_NAME}.csv > ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_CHROMOSOME_REF_NAME};${ONT_CHROMOSOME_REF_NAME};/d" ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}.csv > ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}_modified.csv 
################################################

#SNIPPY_CORE
