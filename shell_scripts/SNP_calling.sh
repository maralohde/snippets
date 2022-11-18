#!/bin/bash
#!/usr/bin/env bash

# run inside snippy Docker: docker run --rm -it -v $PWD:/input nanozoo/snippy:4.4.1--9debffd
# Example: 
# bash script.sh illumina_genome_fasta/ illumina_chromosome_fasta/ ont_genome_fasta/ ont_chromosome_fasta/ hybrid_genome.fasta hybrid_chromosome.fasta illumina_chromosome_ref.fasta ont_ref.fasta
# $1 $2 $3 $4 $5 $6 $7 $8 $9 $10

#_________INSTALLATION_________#

apt update
apt-get install -y bc bsdmainutils 

################################################

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

# CPUS

CPUS="20"

################################################
    echo "############"
    echo -e "\033[1m#  SNIPPY  #\033[22m"
    echo "############"

# 1. SNIPPY
## 1.1 snippy gg ref hybrid genome
    echo -e "\033[0;31m1.1 snippy gg ref hybrid genome\033[0m"
### 1.1.1 ILLUMINA
    OUTDIR1="results/snippy_${HYBRID_GENOME_REF_NAME}_ref_vs_Ill_genome"
    OUTDIR1_NAME=$(basename ${OUTDIR1})
    mkdir -p ${OUTDIR1}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${HYBRID_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR1}/${OUTDIR1_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR1}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR1}/${OUTDIR1_NAME}.csv > ${OUTDIR1}/SNP_resume_${OUTDIR1_NAME}_modified.csv 

    #summary
    for SNIPPY_1 in ${OUTDIR1}/*_modified.csv
        do

            SUM_1=$(cat ${SNIPPY_1} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_1=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_1})
            MEDIAN_1=$(cat ${SNIPPY_1}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

### 1.1.2 ONT
    OUTDIR2="results/snippy_${HYBRID_GENOME_REF_NAME}_ref_vs_ONT_genome"
    OUTDIR2_NAME=$(basename ${OUTDIR2})
    mkdir -p ${OUTDIR2}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${HYBRID_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR2}/${OUTDIR2_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR2}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR2}/${OUTDIR2_NAME}.csv > ${OUTDIR2}/SNP_resume_${OUTDIR2_NAME}_modified.csv 
    
    #summary
    for SNIPPY_2 in ${OUTDIR2}/*_modified.csv
        do

            SUM_2=$(cat ${SNIPPY_2} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_2=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_2})
            MEDIAN_2=$(cat ${SNIPPY_2}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

## 1.2. snippy gg ref hybrid chromosome
    echo -e "results/1.2 snippy gg ref hybrid chromosome"
### 1.2.1 ILLUMINA
    OUTDIR3="results/snippy_${HYBRID_CHROMOSOME_REF_NAME}_ref_vs_Ill_chromosome"
    OUTDIR3_NAME=$(basename ${OUTDIR3})
    mkdir -p ${OUTDIR3}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${HYBRID_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR3}/${OUTDIR3_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR3}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR3}/${OUTDIR3_NAME}.csv > ${OUTDIR3}/SNP_resume_${OUTDIR3_NAME}_modified.csv 

    #summary
    for SNIPPY_3 in ${OUTDIR3}/*_modified.csv
        do

            SUM_3=$(cat ${SNIPPY_3} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_3=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_3})
            MEDIAN_3=$(cat ${SNIPPY_3}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done
### 1.2.2 ONT
    OUTDIR4="results/snippy_${HYBRID_CHROMOSOME_REF_NAME}_ref_vs_ONT_chromosome"
    OUTDIR4_NAME=$(basename ${OUTDIR4})
    mkdir -p ${OUTDIR4}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${HYBRID_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${HYBRID_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR4}/${OUTDIR4_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR4}
        done

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR4}/${OUTDIR4_NAME}.csv > ${OUTDIR4}/SNP_resume_${OUTDIR4_NAME}_modified.csv 

    #summary
    for SNIPPY_4 in ${OUTDIR4}/*_modified.csv
        do

            SUM_4=$(cat ${SNIPPY_4} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_4=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_4})
            MEDIAN_4=$(cat ${SNIPPY_4}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

## 1.3 Ill Genome ref
    echo -e "\033[0;31m1.3 snippy gg ref Ill genome\033[0m"
### 1.3.1 gg Ill Genome
    OUTDIR5="results/snippy_${ILL_GENOME_REF_NAME}_ref_vs_Ill_genome"
    OUTDIR5_NAME=$(basename ${OUTDIR5})
    mkdir -p ${OUTDIR5}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ILL_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR5}/${OUTDIR5_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR5}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR5}/${ILL_GENOME_REF_NAME}
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR5}/${OUTDIR5_NAME}.csv > ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_GENOME_REF_NAME};${ILL_GENOME_REF_NAME}/d" ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}.csv > ${OUTDIR5}/SNP_resume_${OUTDIR5_NAME}_modified.csv 

    #summary
    for SNIPPY_5 in ${OUTDIR5}/*_modified.csv
        do

            SUM_5=$(cat ${SNIPPY_5} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_5=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_5})
            MEDIAN_5=$(cat ${SNIPPY_5}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done
### 1.3.2 gg ONT Genome
    OUTDIR6="results/snippy_${ILL_GENOME_REF_NAME}_ref_vs_ONT_genome"
    OUTDIR6_NAME=$(basename ${OUTDIR6})
    mkdir -p ${OUTDIR6}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ILL_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR6}/${OUTDIR6_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR6}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR6}/${ONT_GENOME_REF_NAME}    

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR6}/${OUTDIR6_NAME}.csv > ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_GENOME_REF_NAME};${ONT_GENOME_REF_NAME};/d" ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}.csv > ${OUTDIR6}/SNP_resume_${OUTDIR6_NAME}_modified.csv 

    #summary
    for SNIPPY_6 in ${OUTDIR6}/*_modified.csv
        do

            SUM_6=$(cat ${SNIPPY_6} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_6=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_6})
            MEDIAN_6=$(cat ${SNIPPY_6}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

## 1.4 ONT Genome ref
    echo -e "\033[0;31m1.4 snippy gg ref ONT genome\033[0m"
### 1.4.1 gg ref Ill Genome
    OUTDIR7="results/snippy_${ONT_GENOME_REF_NAME}_ref_vs_Ill_genome"
    OUTDIR7_NAME=$(basename ${OUTDIR7})
    mkdir -p ${OUTDIR7}

        for FASTA in ${ILL_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ONT_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR7}/${OUTDIR7_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR7}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR7}/${ILL_GENOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR7}/${OUTDIR7_NAME}.csv > ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_GENOME_REF_NAME};${ILL_GENOME_REF_NAME}/d" ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}.csv > ${OUTDIR7}/SNP_resume_${OUTDIR7_NAME}_modified.csv 

    #summary
    for SNIPPY_7 in ${OUTDIR7}/*_modified.csv
        do

            SUM_7=$(cat ${SNIPPY_7} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_7=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_7})
            MEDIAN_7=$(cat ${SNIPPY_7}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

### 1.4.2 gg ref ONT Genome
    OUTDIR8="results/snippy_${ONT_GENOME_REF_NAME}_ref_vs_ONT_genome"
    OUTDIR8_NAME=$(basename ${OUTDIR8})
    mkdir -p ${OUTDIR8}

        for FASTA in ${ONT_GENOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ONT_GENOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_GENOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR8}/${OUTDIR8_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR8}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR8}/${ONT_GENOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR8}/${OUTDIR8_NAME}.csv > ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_GENOME_REF_NAME};${ONT_GENOME_REF_NAME};/d" ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}.csv > ${OUTDIR8}/SNP_resume_${OUTDIR8_NAME}_modified.csv 

    #summary
    for SNIPPY_8 in ${OUTDIR8}/*_modified.csv
        do

            SUM_8=$(cat ${SNIPPY_8} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_8=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_8})
            MEDIAN_8=$(cat ${SNIPPY_8}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

## 1.5 gg ref Ill Chromosome
    echo -e "\033[0;31m1.5 snippy gg ref Ill chromosome\033[0m"
### 1.5.1 gg Ill Chromosome
    OUTDIR9="results/snippy_${ILL_CHROMOSOME_REF_NAME}_ref_vs_Ill_chromosome"
    OUTDIR9_NAME=$(basename ${OUTDIR9})
    mkdir -p ${OUTDIR9}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ILL_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR9}/${OUTDIR9_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR9}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR9}/${ILL_CHROMOSOME_REF_NAME}
        
    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR9}/${OUTDIR9_NAME}.csv > ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_CHROMOSOME_REF_NAME};${ILL_CHROMOSOME_REF_NAME};/d" ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}.csv > ${OUTDIR9}/SNP_resume_${OUTDIR9_NAME}_modified.csv 

    #summary
    for SNIPPY_9 in ${OUTDIR9}/*_modified.csv
        do

            SUM_9=$(cat ${SNIPPY_9} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_9=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_9})
            MEDIAN_9=$(cat ${SNIPPY_9}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

### 1.5.2 gg ONT Chromosome
    OUTDIR10="results/snippy_${ILL_CHROMOSOME_REF_NAME}_ref_vs_ONT_chromosome"
    OUTDIR10_NAME=$(basename ${OUTDIR10})
    mkdir -p ${OUTDIR10}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ILL_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ILL_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR10}/${OUTDIR10_NAME}.csv
            mv ${FASTA_NAME} ${OUTDIR10}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR6}/${ONT_CHROMOSOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR10}/${OUTDIR10_NAME}.csv > ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ILL_CHROMOSOME_REF_NAME};${ONT_CHROMOSOME_REF_NAME};/d" ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}.csv > ${OUTDIR10}/SNP_resume_${OUTDIR10_NAME}_modified.csv 

    #summary
    for SNIPPY_10 in ${OUTDIR10}/*_modified.csv
        do

            SUM_10=$(cat ${SNIPPY_10} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_10=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_10})
            MEDIAN_10=$(cat ${SNIPPY_10}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

## 1.6 ONT Chromosome
    echo -e "\033[0;31m1.6 snippy gg ref ONT chromosome\033[0m"
### 1.6.1 gg Ill Chromosome
    OUTDIR11="results/snippy_${ONT_CHROMOSOME_REF_NAME}_ref_vs_Ill_chromosome"
    OUTDIR11_NAME=$(basename ${OUTDIR11})
    mkdir -p ${OUTDIR11}

        for FASTA in ${ILL_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ONT_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR11}/${OUTDIR11_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR11}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR11}/${ILL_CHROMOSOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR11}/${OUTDIR11_NAME}.csv > ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_CHROMOSOME_REF_NAME};${ILL_CHROMOSOME_REF_NAME};/d" ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}.csv > ${OUTDIR11}/SNP_resume_${OUTDIR11_NAME}_modified.csv 

    #summary
    for SNIPPY_11 in ${OUTDIR11}/*_modified.csv
        do

            SUM_11=$(cat ${SNIPPY_11} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_11=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_11})
            MEDIAN_11=$(cat ${SNIPPY_11}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

### 1.6.2 gg ONT Chromosome
    OUTDIR12="results/snippy_${ONT_CHROMOSOME_REF_NAME}_ref_vs_ONT_chromosome"
    OUTDIR12_NAME=$(basename ${OUTDIR12})
    mkdir -p ${OUTDIR12}

        for FASTA in ${ONT_CHROMOSOME_FASTA_DIR}/*.fasta
        do
            FASTA_NAME=$(basename -s .fasta ${FASTA})
            snippy --cpus ${CPUS} --outdir ${FASTA_NAME} --ref ${ONT_CHROMOSOME_REF} --ctgs ${FASTA}
            VALUE=$(grep "Variant-SNP" ${FASTA_NAME}/snps.txt | cut -f2)
            echo "${ONT_CHROMOSOME_REF_NAME};${FASTA_NAME};$VALUE" >> ${OUTDIR12}/${OUTDIR12_NAME}.csv
            mv ${FASTA_NAME}/ ${OUTDIR12}
        done

    #removing ref vs ref dir for snippy_core
        rm -rf ${OUTDIR12}/${ONT_CHROMOSOME_REF_NAME}

    #replacing all blanks with 0
        sed -E 's/(^|;)(;|$)/\10\2/g; s/(^|;)(;|$)/\10\2/g' ${OUTDIR12}/${OUTDIR12_NAME}.csv > ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}.csv
        
    #removing ref vs ref from summary
        sed "/${ONT_CHROMOSOME_REF_NAME};${ONT_CHROMOSOME_REF_NAME};/d" ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}.csv > ${OUTDIR12}/SNP_resume_${OUTDIR12_NAME}_modified.csv 

    #summary
    for SNIPPY_12 in ${OUTDIR12}/*_modified.csv
        do

            SUM_12=$(cat ${SNIPPY_12} | cut -d ";" -f3 | paste -s -d+ |bc)
            AVERAGE_12=$(awk -F';' 'BEGIN{s=0;}{s=s+$3;}END{print s/NR;}' < ${SNIPPY_12})
            MEDIAN_12=$(cat ${SNIPPY_12}| cut -f3 -d ";" | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
            
        done

################################################

    echo "############"
    echo -e "\033[1m#  SNIPPY CORE  #\033[22m"
    echo "############"

# 2. SNIPPY-CORE
    echo "SNIPPY CORE"
## 2.1 Hybrid Genome Ref
    echo -e "\033[0;31m1.1 snippy-core: ref hybrid genome\033[0m"
### 2.1.1 Hybrid Genome Ref gg Ill Genomes
    OUTDIR13="results/snippy-core_${HYBRID_GENOME_REF_NAME}_ref_vs_Ill_genomes"
    OUTDIR13_NAME=$(basename ${OUTDIR13})
    mkdir -p ${OUTDIR13}

    snippy-core ${OUTDIR1}/*/ --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR13_NAME}

    mv core_${OUTDIR13_NAME}* ${OUTDIR13}

    #summary
    for CORE_13 in ${OUTDIR13}/*.txt
        do

            SUM_13=$(cat ${CORE_13} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_13=$(cat ${CORE_13} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_13=$(cat ${CORE_13} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

### 2.1.2 Hybrid Genome Ref gg ONT Genomes
    OUTDIR14="results/snippy-core_${HYBRID_GENOME_REF_NAME}_ref_vs_ONT_genomes"
    OUTDIR14_NAME=$(basename ${OUTDIR14})
    mkdir -p ${OUTDIR14}

    snippy-core ${OUTDIR2}/*/ --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR14_NAME}

    mv core_${OUTDIR14_NAME}* ${OUTDIR14}

    #summary
    for CORE_14 in ${OUTDIR14}/*.txt
        do

            SUM_14=$(cat ${CORE_14} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_14=$(cat ${CORE_14} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_14=$(cat ${CORE_14} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

### 2.1.3 Hybrid Genome Ref gg combined Genomes
    OUTDIR15="results/snippy-core_${HYBRID_GENOME_REF_NAME}_ref_vs_combined_genomes"
    OUTDIR15_NAME=$(basename ${OUTDIR15})
    mkdir -p ${OUTDIR15}

    mkdir tmp
    cp -r ${OUTDIR1}/*/ tmp/
    cp -r ${OUTDIR2}/*/ tmp/

    snippy-core tmp/* --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR15_NAME}

    rm -rf tmp/

    mv core_${OUTDIR15_NAME}* ${OUTDIR15}

    # separate Ill and ONT results

    cat ${OUTDIR15}/*.txt | grep "sup" >> ${OUTDIR15}/core_${OUTDIR15_NAME}_ONT_only.txt
    cat ${OUTDIR15}/*.txt | grep "ill" >> ${OUTDIR15}/core_${OUTDIR15_NAME}_ILL_only.txt

    #summary ILL
    for CORE_15_ILL in ${OUTDIR15}/core_${OUTDIR15_NAME}_ILL_only.txt
        do

            SUM_15_ILL=$(cat ${CORE_15_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_15_ILL=$(cat ${CORE_15_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_15_ILL=$(cat ${CORE_15_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_15_ONT in ${OUTDIR15}/core_${OUTDIR15_NAME}_ONT_only.txt
        do

            SUM_15_ONT=$(cat ${CORE_15_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_15_ONT=$(cat ${CORE_15_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_15_ONT=$(cat ${CORE_15_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

## 2.2 Hybrid Chromosome Ref
    echo -e "\033[0;31m1.1 snippy-core: ref hybrid genome\033[0m"
### 2.2.1 Hybrid Chromosome Ref gg Ill Chromosomes
    OUTDIR16="results/snippy-core_${HYBRID_CHROMOSOME_REF_NAME}_ref_vs_Ill_chromosomes"
    OUTDIR16_NAME=$(basename ${OUTDIR16})
    mkdir -p ${OUTDIR16}

    snippy-core ${OUTDIR3}/*/ --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR16_NAME}

    mv core_${OUTDIR16_NAME}* ${OUTDIR16}

    #summary
    for CORE_16 in ${OUTDIR16}/*.txt
        do

            SUM_16=$(cat ${CORE_16} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_16=$(cat ${CORE_16} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_16=$(cat ${CORE_16} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

### 2.2.2 Hybrid Chromosome Ref gg ONT Chromosomes
    OUTDIR17="results/snippy-core_index_${HYBRID_CHROMOSOME_REF_NAME}_vs_ONT_chromosomes"
    OUTDIR17_NAME=$(basename ${OUTDIR17})
    mkdir -p ${OUTDIR17}

    snippy-core ${OUTDIR4}/*/ --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR17_NAME}

    mv core_${OUTDIR17_NAME}* ${OUTDIR17}

    #summary
    for CORE_17 in ${OUTDIR17}/*.txt
        do

            SUM_17=$(cat ${CORE_17} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_17=$(cat ${CORE_17} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_17=$(cat ${CORE_17} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

### 2.2.3 Hybrid Chromosome Ref gg combined Chromosomes
    OUTDIR18="results/snippy-core_${HYBRID_CHROMOSOME_REF_NAME}_ref_vs_combined_chromosomes"
    OUTDIR18_NAME=$(basename ${OUTDIR18})
    mkdir -p ${OUTDIR18}

    mkdir tmp
    cp -r ${OUTDIR3}/*/ tmp/
    cp -r ${OUTDIR4}/*/ tmp/

    snippy-core tmp/* --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR18_NAME}

    rm -rf tmp/

    mv core_${OUTDIR18_NAME}* ${OUTDIR18}

    # separate Ill and ONT results

    cat ${OUTDIR18}/*.txt | grep "sup" >> ${OUTDIR18}/core_${OUTDIR18_NAME}_ONT_only.txt
    cat ${OUTDIR18}/*.txt | grep "ill" >> ${OUTDIR18}/core_${OUTDIR18_NAME}_ILL_only.txt

    #summary ILL
    for CORE_18_ILL in ${OUTDIR18}/core_${OUTDIR18_NAME}_ILL_only.txt
        do

            SUM_18_ILL=$(cat ${CORE_18_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_18_ILL=$(cat ${CORE_18_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_18_ILL=$(cat ${CORE_18_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_18_ONT in ${OUTDIR18}/core_${OUTDIR18_NAME}_ONT_only.txt
        do

            SUM_18_ONT=$(cat ${CORE_18_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_18_ONT=$(cat ${CORE_18_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_18_ONT=$(cat ${CORE_18_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
   
## 2.3 Ill Genome Ref
### 2.3.1 Ill Genome gg Ill Genomes
    OUTDIR19="results/snippy-core_${ILL_GENOME_REF_NAME}_ref_vs_Ill_genomes"
    OUTDIR19_NAME=$(basename ${OUTDIR19})
    mkdir -p ${OUTDIR19}

    snippy-core ${OUTDIR5}/*/ --ref ${ILL_GENOME_REF} --prefix core_${OUTDIR19_NAME}

    mv core_${OUTDIR19_NAME}* ${OUTDIR19}

    #summary
    for CORE_19 in ${OUTDIR19}/*.txt
        do

            SUM_19=$(cat ${CORE_19} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_19=$(cat ${CORE_19} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_19=$(cat ${CORE_19} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done    


### 2.3.2 Ill Genome gg combined Genomes
    OUTDIR20="results/snippy-core_${ILL_GENOME_REF_NAME}_ref_vs_combined_genomes"
    OUTDIR20_NAME=$(basename ${OUTDIR20})
    mkdir -p ${OUTDIR20}

    mkdir tmp
    cp -r ${OUTDIR5}/*/ tmp/
    cp -r ${OUTDIR6}/*/ tmp/

    snippy-core tmp/* --ref ${ILL_GENOME_REF} --prefix core_${OUTDIR20_NAME}

    rm -rf tmp/

    mv core_${OUTDIR20_NAME}* ${OUTDIR20}

    # separate Ill and ONT results

    cat ${OUTDIR20}/*.txt | grep "sup" >> ${OUTDIR20}/core_${OUTDIR20_NAME}_ONT_only.txt
    cat ${OUTDIR20}/*.txt | grep "ill" >> ${OUTDIR20}/core_${OUTDIR20_NAME}_ILL_only.txt

    #summary ILL
    for CORE_20_ILL in ${OUTDIR20}/core_${OUTDIR20_NAME}_ILL_only.txt
        do

            SUM_20_ILL=$(cat ${CORE_20_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_20_ILL=$(cat ${CORE_20_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_20_ILL=$(cat ${CORE_20_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_20_ONT in ${OUTDIR20}/core_${OUTDIR20_NAME}_ONT_only.txt
        do

            SUM_20_ONT=$(cat ${CORE_20_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_20_ONT=$(cat ${CORE_20_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_20_ONT=$(cat ${CORE_20_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

    #summary
    for CORE_20 in ${OUTDIR20}/*.txt
        do

            SUM_20=$(cat ${CORE_20} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_20=$(cat ${CORE_20} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_20=$(cat ${CORE_20} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done   

## 2.4 Ill Chromosome Ref
### 2.4.1 Ill Chromosome Ref gg Ill Chromosomes
    OUTDIR21="results/snippy-core_${ILL_CHROMOSOME_REF_NAME}_ref_vs_Ill_chromosomes"
    OUTDIR21_NAME=$(basename ${OUTDIR21})
    mkdir -p ${OUTDIR21}

    snippy-core ${OUTDIR9}/*/ --ref ${ILL_CHROMOSOME_REF} --prefix core_${OUTDIR21_NAME}

    mv core_${OUTDIR21_NAME}* ${OUTDIR21}

    #summary
    for CORE_21 in ${OUTDIR21}/*.txt
        do

            SUM_21=$(cat ${CORE_21} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_21=$(cat ${CORE_21} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_21=$(cat ${CORE_21} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done  

### 2.4.2 Ill Chromosome Ref gg combined Chromosomes
    OUTDIR22="results/snippy-core_${ILL_CHROMOSOME_REF_NAME}_ref_vs_combined_genomes"
    OUTDIR22_NAME=$(basename ${OUTDIR22})
    mkdir -p ${OUTDIR22}

    mkdir tmp
    cp -r ${OUTDIR9}/*/ tmp/
    cp -r ${OUTDIR10}/*/ tmp/

    snippy-core tmp/* --ref ${ILL_CHROMOSOME_REF} --prefix core_${OUTDIR22_NAME}

    rm -rf tmp/

    mv core_${OUTDIR22_NAME}* ${OUTDIR22}

    # separate Ill and ONT results

    cat ${OUTDIR22}/*.txt | grep "sup" >> ${OUTDIR22}/core_${OUTDIR22_NAME}_ONT_only.txt
    cat ${OUTDIR22}/*.txt | grep "ill" >> ${OUTDIR22}/core_${OUTDIR22_NAME}_ILL_only.txt

    #summary ILL
    for CORE_22_ILL in ${OUTDIR22}/core_${OUTDIR22_NAME}_ILL_only.txt
        do

            SUM_22_ILL=$(cat ${CORE_22_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_22_ILL=$(cat ${CORE_22_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_22_ILL=$(cat ${CORE_22_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_22_ONT in ${OUTDIR22}/core_${OUTDIR22_NAME}_ONT_only.txt
        do

            SUM_22_ONT=$(cat ${CORE_22_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_22_ONT=$(cat ${CORE_22_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_22_ONT=$(cat ${CORE_22_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

## 2.5 ONT Genome Ref
### 2.5.1 ONT Genome gg ONT Genomes
    OUTDIR23="results/snippy-core_${ONT_GENOME_REF_NAME}_ref_vs_ONT_genomes"
    OUTDIR23_NAME=$(basename ${OUTDIR23})
    mkdir -p ${OUTDIR23}

    snippy-core ${OUTDIR8}/*/ --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR23_NAME}

    mv core_${OUTDIR23_NAME}* ${OUTDIR23}

    #summary
    for CORE_23 in ${OUTDIR23}/*.txt
        do

            SUM_23=$(cat ${CORE_23} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_23=$(cat ${CORE_23} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_23=$(cat ${CORE_23} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done 

### 2.5.2 ONT Genome gg combined Genomes
    OUTDIR24="results/snippy-core_${ONT_GENOME_REF_NAME}_ref_vs_combined_genomes"
    OUTDIR24_NAME=$(basename ${OUTDIR24})
    mkdir -p ${OUTDIR24}

    mkdir tmp
    cp -r ${OUTDIR7}/*/ tmp/
    cp -r ${OUTDIR8}/*/ tmp/

    snippy-core tmp/* --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR24_NAME}
    
    rm -rf tmp/

    mv core_${OUTDIR24_NAME}* ${OUTDIR24}

    # separate Ill and ONT results

    cat ${OUTDIR24}/*.txt | grep "sup" >> ${OUTDIR24}/core_${OUTDIR24_NAME}_ONT_only.txt
    cat ${OUTDIR24}/*.txt | grep "ill" >> ${OUTDIR24}/core_${OUTDIR24_NAME}_ILL_only.txt    

    #summary ILL
    for CORE_24_ILL in ${OUTDIR24}/core_${OUTDIR24_NAME}_ILL_only.txt
        do

            SUM_24_ILL=$(cat ${CORE_24_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_24_ILL=$(cat ${CORE_24_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_24_ILL=$(cat ${CORE_24_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_24_ONT in ${OUTDIR24}/core_${OUTDIR24_NAME}_ONT_only.txt
        do

            SUM_24_ONT=$(cat ${CORE_24_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_24_ONT=$(cat ${CORE_24_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_24_ONT=$(cat ${CORE_24_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done 

## 2.6 ONT Chromosome Ref
### 2.6.1 ONT Chromosome Ref gg ONT Chromosomes
    OUTDIR25="results/snippy-core_${ONT_CHROMOSOME_REF_NAME}_ref_vs_ONT_chromosomes"
    OUTDIR25_NAME=$(basename ${OUTDIR25})
    mkdir -p ${OUTDIR25}

    snippy-core ${OUTDIR12}/*/ --ref ${ONT_CHROMOSOME_REF} --prefix core_${OUTDIR25_NAME}

    mv core_${OUTDIR25_NAME}* ${OUTDIR25}

    #summary
    for CORE_25 in ${OUTDIR25}/*.txt
        do

            SUM_25=$(cat ${CORE_25} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_25=$(cat ${CORE_25} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_25=$(cat ${CORE_25} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done 

### 2.6.2 ONT Chromosome Ref gg combined Chromosomes
    OUTDIR26="results/snippy-core_${ONT_CHROMOSOME_REF_NAME}_ref_vs_combined_chromosomes"
    OUTDIR26_NAME=$(basename ${OUTDIR26})
    mkdir -p ${OUTDIR26}

    mkdir tmp
    cp -r ${OUTDIR11}/*/ tmp/
    cp -r ${OUTDIR12}/*/ tmp/

    snippy-core tmp/* --ref ${ONT_CHROMOSOME_REF} --prefix core_${OUTDIR26_NAME}

    rm -rf tmp/

    mv core_${OUTDIR26_NAME}* ${OUTDIR26}

    # separate Ill and ONT results

    cat ${OUTDIR26}/*.txt | grep "sup" >> ${OUTDIR26}/core_${OUTDIR26_NAME}_ONT_only.txt
    cat ${OUTDIR26}/*.txt | grep "ill" >> ${OUTDIR26}/core_${OUTDIR26_NAME}_ILL_only.txt

    #summary ILL
    for CORE_26_ILL in ${OUTDIR26}/core_${OUTDIR26_NAME}_ILL_only.txt
        do

            SUM_26_ILL=$(cat ${CORE_26_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_26_ILL=$(cat ${CORE_26_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_26_ILL=$(cat ${CORE_26_ILL} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done
        
    # summary ONT
    for CORE_26_ONT in ${OUTDIR26}/core_${OUTDIR26_NAME}_ONT_only.txt
        do

            SUM_26_ONT=$(cat ${CORE_26_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | paste -s -d+ |bc)
            AVERAGE_26_ONT=$(cat ${CORE_26_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | awk -F';' 'BEGIN{s=0;}{s=s+$1;}END{print s/NR;}')
            MEDIAN_26_ONT=$(cat ${CORE_26_ONT} | column -t| tr  -s '[:blank:]' | sed 's/ /;/g'| cut -d ";" -f 5| tail -n +2 | sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')

        done

################################################
    echo "############"
    echo -e "\033[1m#  SUMMARY  #\033[22m"
    echo "############"

# 3. SUMMARY SNIPPY

mkdir results/summary_snippy/

## 3.1 Snippy SUM summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "INDEX_HYBRID;ILL;${SUM_1};${SUM_3}" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "INDEX_HYBRID;ONT;${SUM_2};${SUM_4}" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "ILL;ILL;${SUM_5};${SUM_9}" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "ILL;ONT;${SUM_6};${SUM_10}" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "ONT;ILL;${SUM_7};${SUM_11}" >> results/summary_snippy/snippy_summary_SUM.csv
    echo "ONT;ONT;${SUM_8};${SUM_12}" >> results/summary_snippy/snippy_summary_SUM.csv

## 3.2 Snippy AVERAGE summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "INDEX_HYBRID;ILL;${AVERAGE_1};${AVERAGE_3}" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "INDEX_HYBRID;ONT;${AVERAGE_2};${AVERAGE_4}" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "ILL;ILL;${AVERAGE_5};${AVERAGE_9}" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "ILL;ONT;${AVERAGE_6};${AVERAGE_10}" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "ONT;ILL;${AVERAGE_7};${AVERAGE_11}" >> results/summary_snippy/snippy_summary_AVERAGE.csv
    echo "ONT;ONT;${AVERAGE_8};${AVERAGE_12}" >> results/summary_snippy/snippy_summary_AVERAGE.csv

## 3.3 Snippy MEDIAN summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "INDEX_HYBRID;ILL;${MEDIAN_1};${MEDIAN_3}" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "INDEX_HYBRID;ONT;${MEDIAN_2};${MEDIAN_4}" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "ILL;ILL;${MEDIAN_5};${MEDIAN_9}" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "ILL;ONT;${MEDIAN_6};${MEDIAN_10}" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "ONT;ILL;${MEDIAN_7};${MEDIAN_11}" >> results/summary_snippy/snippy_summary_MEDIAN.csv
    echo "ONT;ONT;${MEDIAN_8};${MEDIAN_12}" >> results/summary_snippy/snippy_summary_MEDIAN.csv

# 4. SUMMARY SNIPPY-CORE

mkdir results/summary_snippy-core

## 4.1 Snippy-core SUM summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "INDEX_HYBRID;ILL;${SUM_13};${SUM_16}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "INDEX_HYBRID;ONT;${SUM_14};${SUM_17}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ILL;${SUM_15_ILL};${SUM_18_ILL}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ONT;${SUM_15_ONT};${SUM_18_ONT}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ILL;ILL;${SUM_19};${SUM_21}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ILL;COMBINED_ONLY_ILL;${SUM_20_ILL};${SUM_22_ILL}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ILL;COMBINED_ONLY_ONT;${SUM_20_ONT};${SUM_22_ONT}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ONT;ONT;${SUM_23};${SUM_25}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ONT;COMBINED_ONLY_ILL;${SUM_24_ILL};${SUM_26_ILL}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv
    echo "ONT;COMBINED_ONLY_ONT;${SUM_24_ONT};${SUM_26_ONT}" >> results/summary_snippy-core/snippy-core_summary_SUM.csv


## 4.2 Snippy-core AVERAGE summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "INDEX_HYBRID;ILL;${AVERAGE_13};${AVERAGE_16}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "INDEX_HYBRID;ONT;${AVERAGE_14};${AVERAGE_17}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ILL;${AVERAGE_15_ILL};${AVERAGE_18_ILL}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ONT;${AVERAGE_15_ONT};${AVERAGE_18_ONT}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ILL;ILL;${AVERAGE_19};${AVERAGE_21}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ILL;COMBINED_ONLY_ILL;${AVERAGE_20_ILL};${AVERAGE_22_ILL}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ILL;COMBINED_ONLY_ONT;${AVERAGE_20_ONT};${AVERAGE_22_ONT}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ONT;ONT;${AVERAGE_23};${AVERAGE_25}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ONT;COMBINED_ONLY_ILL;${AVERAGE_24_ILL};${AVERAGE_26_ILL}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv
    echo "ONT;COMBINED_ONLY_ONT;${AVERAGE_24_ONT};${AVERAGE_26_ONT}" >> results/summary_snippy-core/snippy-core_summary_AVERAGE.csv

## 4.3 Snippy-core MEDIAN summary

    echo "REFERENCE;SNIPPY;SNPS_GENOME;SNPS_CHROMOSOME" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "INDEX_HYBRID;ILL;${MEDIAN_13};${MEDIAN_16}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "INDEX_HYBRID;ONT;${MEDIAN_14};${MEDIAN_17}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ILL;${MEDIAN_15_ILL};${MEDIAN_18_ILL}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "INDEX_HYBRID;COMBINED_ONLY_ONT;${MEDIAN_15_ILL};${MEDIAN_18_ONT}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ILL;ILL;${MEDIAN_19};${MEDIAN_21}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ILL;COMBINED_ONLY_ILL;${MEDIAN_20_ILL};${MEDIAN_22_ILL}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ILL;COMBINED_ONLY_ONT;${MEDIAN_20_ONT};${MEDIAN_22_ONT}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ONT;ONT;${MEDIAN_23};${MEDIAN_25}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ONT;COMBINED_ONLY_ILL;${MEDIAN_24_ILL};${MEDIAN_26_ILL}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv
    echo "ONT;COMBINED_ONLY_ONT;${MEDIAN_24_ONT};${MEDIAN_26_ONT}" >> results/summary_snippy-core/snippy-core_summary_MEDIAN.csv

################################################
    chmod -R 777 results/
################################################
    echo "############"
    echo -e "\033[1m#  DONE  #\033[22m"
    echo "############"
