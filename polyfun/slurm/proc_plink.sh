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

## 1       2245570 SKI     1245570 3245570
#bash finemap_test.bash 1 1245570 3245570
## 

sno=$SLURM_ARRAY_TASK_ID

/well/PROCARDIS/cgrace/pLOF_500K/plink2 \
    --bfile LD/ukb_v3_maf_imp_${sno}_eur \
    --rm-dup force-first \
    --make-bed --out LD_new/ukb_v3_maf_imp_${sno}_eur_rmdup

./plink \
    --bfile LD_new/ukb_v3_maf_imp_${sno}_eur_rmdup \
    --cm-map example_annotation/1000GP_Phase3/genetic_map_chr${sno}_combined_b37.txt ${sno} \
    --make-bed --out LD_new/ukb_v3_maf_imp_${sno}_eur_wcm

#    --extract gen_annot/SKI.tmp \

date
