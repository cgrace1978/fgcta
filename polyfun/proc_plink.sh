#!/bin/bash 

#SBATCH -p short
#SBATCH -o proc_plink_%A.%a.out
#SBATCH -e proc_plink_%A.%a.err

#SBATCH -c 4

echo "------------------------------------------------" 
echo "Run on host: "`hostname` 
echo "Operating system: "`uname -s` 
echo "Username: "`whoami` 
echo "Started at: "`date` 
echo "------------------------------------------------" 
 
date

sno=$SLURM_ARRAY_TASK_ID

## remove duplicates from UKB genotype file
/well/PROCARDIS/cgrace/pLOF_500K/plink2 \
    --bfile LD/ukb_v3_maf_imp_${sno}_eur \
    --rm-dup force-first \
    --make-bed --out LD_new/ukb_v3_maf_imp_${sno}_eur_rmdup

## Add centiMorgan data to the UKB file (needed to generate ldscores
./plink \
    --bfile LD_new/ukb_v3_maf_imp_${sno}_eur_rmdup \
    --cm-map example_annotation/1000GP_Phase3/genetic_map_chr${sno}_combined_b37.txt ${sno} \
    --make-bed --out LD_new/ukb_v3_maf_imp_${sno}_eur_wcm

date
