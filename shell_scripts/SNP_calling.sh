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

    echo "############"
    echo -e "\033[1m#  SNIPPY CORE  #\033[22m"
    echo "############"
snippy-core {snippy output directories} --ref ../reference/VA13414_index_chromosom.fasta --prefix core

# 2. SNIPPY-CORE
    echo "SNIPPY CORE"
## 2.1 Hybrid Genome Ref
    echo -e "\033[0;31m1.1 snippy-core: ref hybrid genome\033[0m"
### 2.1.1 Hybrid Genome Ref gg Ill Genomes
    OUTDIR13="results/snippy-core_index_hybrid_ref_vs_Ill_genomes"
    OUTDIR13_NAME=$(basename ${OUTDIR13})
    mkdir -p ${OUTDIR13}

    snippy-core ${OUTDIR1}/*/ --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR13_NAME}

    mv core_${OUTDIR13_NAME}* ${OUTDIR13}

### 2.1.2 Hybrid Genome Ref gg ONT Genomes
    OUTDIR14="results/snippy-core_index_hybrid_ref_vs_ONT_genomes"
    OUTDIR14_NAME=$(basename ${OUTDIR14})
    mkdir -p ${OUTDIR14}

    snippy-core ${OUTDIR2}/*/ --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR14_NAME}

    mv core_${OUTDIR14_NAME}* ${OUTDIR14}

### 2.1.3 Hybrid Genome Ref gg combined Genomes
    OUTDIR15="results/snippy-core_index_hybrid_ref_vs_combined_genomes"
    OUTDIR15_NAME=$(basename ${OUTDIR15})
    mkdir -p ${OUTDIR15}

    mkdir tmp
    mv ${OUTDIR1}/*/ tmp/
    mv ${OUTDIR2}/*/ tmp/

    snippy-core tmp/* --ref ${HYBRID_GENOME_REF} --prefix core_${OUTDIR15_NAME}

    rm -rf tmp/
    mv core_${OUTDIR15_NAME}* ${OUTDIR15}

## 2.2 Hybrid Chromosome Ref
echo -e "\033[0;31m1.1 snippy-core: ref hybrid genome\033[0m"
### 2.2.1 Hybrid Chromosome Ref gg Ill Chromosomes
    OUTDIR16="results/snippy-core_index_hybrid_ref_vs_Ill_chromosomes"
    OUTDIR16_NAME=$(basename ${OUTDIR16})
    mkdir -p ${OUTDIR16}

    snippy-core ${OUTDIR3}/*/ --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR16_NAME}

    mv core_${OUTDIR16_NAME}* ${OUTDIR16}

### 2.2.2 Hybrid Genome Ref gg ONT Chromosomes
    OUTDIR17="results/snippy-core_index_hybrid_ref_vs_ONT_chromosomes"
    OUTDIR17_NAME=$(basename ${OUTDIR17})
    mkdir -p ${OUTDIR17}

    snippy-core ${OUTDIR4}/*/ --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR17_NAME}

    mv core_${OUTDIR17_NAME}* ${OUTDIR17}

### 2.2.3 Hybrid Genome Ref gg combined Chromosomes
    OUTDIR18="results/snippy-core_index_hybrid_ref_vs_combined_chromosomes"
    OUTDIR18_NAME=$(basename ${OUTDIR18})
    mkdir -p ${OUTDIR18}

    mkdir tmp
    mv ${OUTDIR3}/*/ tmp/
    mv ${OUTDIR4}/*/ tmp/

    snippy-core tmp/* --ref ${HYBRID_CHROMOSOME_REF} --prefix core_${OUTDIR18_NAME}

    rm -rf tmp/

    mv core_${OUTDIR18_NAME}* ${OUTDIR18}

## 2.3 Ill Genome Ref
### 2.3.1 Ill Genome gg Ill Genomes
    OUTDIR19="results/snippy-core_Ill_genome_ref_vs_Ill_genomes"
    OUTDIR19_NAME=$(basename ${OUTDIR19})
    mkdir -p ${OUTDIR19}

    snippy-core ${OUTDIR5}/*/ --ref ${ILL_GENOME_REF} --prefix core_${OUTDIR19_NAME}

    mv core_${OUTDIR19_NAME}* ${OUTDIR19}


### 2.3.2 Ill Genome gg combined Genomes
    OUTDIR20="results/snippy-core_Ill_genome_ref_vs_combined_genomes"
    OUTDIR20_NAME=$(basename ${OUTDIR20})
    mkdir -p ${OUTDIR20}

    mkdir tmp
    mv ${OUTDIR5}/*/ tmp/
    mv ${OUTDIR6}/*/ tmp/

    snippy-core tmp/* --ref ${ILL_GENOME_REF} --prefix core_${OUTDIR20_NAME}

    rm -rf tmp/

    mv core_${OUTDIR20_NAME}* ${OUTDIR20}

## 2.4 Ill Chromosome Ref
### 2.4.1 Ill Chromosome Ref gg Ill Chromosomes
    OUTDIR21="results/snippy-core_Ill_chromosome_ref_vs_Ill_chromosomes"
    OUTDIR21_NAME=$(basename ${OUTDIR21})
    mkdir -p ${OUTDIR21}

    snippy-core ${OUTDIR9}/*/ --ref ${ILL_CHROMOSOME_REF} --prefix core_${OUTDIR21_NAME}

    mv core_${OUTDIR21_NAME}* ${OUTDIR21}

### 2.4.2 Ill Chromosome Ref gg combined Chromosomes
    OUTDIR22="results/snippy-core_Ill_chromosomes_ref_vs_combined_genomes"
    OUTDIR22_NAME=$(basename ${OUTDIR22})
    mkdir -p ${OUTDIR22}

    mkdir tmp
    mv ${OUTDIR9}/*/ tmp/
    mv ${OUTDIR10}/*/ tmp/

    snippy-core tmp/* --ref ${ILL_CHROMOSOME_REF} --prefix core_${OUTDIR22_NAME}

    rm -rf tmp/

    mv core_${OUTDIR22_NAME}* ${OUTDIR22}


## 2.5 ONT Genome Ref
### 2.5.1 ONT Genome gg ONT Genomes
    OUTDIR23="results/snippy-core_ONT_genome_ref_vs_ONT_genomes"
    OUTDIR23_NAME=$(basename ${OUTDIR23})
    mkdir -p ${OUTDIR23}

    snippy-core ${OUTDIR8}/*/ --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR23_NAME}

    mv core_${OUTDIR23_NAME}* ${OUTDIR23}

### 2.5.2 ONT Genome gg combined Genomes
    OUTDIR24="results/snippy-core_ONT_genome_ref_vs_combined_genomes"
    OUTDIR24_NAME=$(basename ${OUTDIR24})
    mkdir -p ${OUTDIR24}

    mkdir tmp
    mv ${OUTDIR7}/*/ tmp/
    mv ${OUTDIR8}/*/ tmp/

    snippy-core tmp/* --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR24_NAME}
    
    rm -rf tmp/

    mv core_${OUTDIR24_NAME}* ${OUTDIR24}

## 2.6 ONT Chromosome Ref
### 2.6.1 ONT Chromosome Ref gg ONT Chromosomes
    OUTDIR25="results/snippy-core_ONT_chromosome_ref_vs_ONT_chromosomes"
    OUTDIR25_NAME=$(basename ${OUTDIR25})
    mkdir -p ${OUTDIR25}

    snippy-core ${OUTDIR12}/*/ --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR25_NAME}

    mv core_${OUTDIR25_NAME}* ${OUTDIR25}

### 2.6.2 ONT Chromosome Ref gg combined Chromosomes
    OUTDIR26="results/snippy-core_ONT_chromosome_ref_vs_combined_chromosomes"
    OUTDIR26_NAME=$(basename ${OUTDIR26})
    mkdir -p ${OUTDIR26}

    mkdir tmp
    mv ${OUTDIR11}/*/ tmp/
    mv ${OUTDIR12}/*/ tmp/

    snippy-core tmp/* --ref ${ONT_GENOME_REF} --prefix core_${OUTDIR26_NAME}

    mv core_${OUTDIR26_NAME}* ${OUTDIR26}

################################################