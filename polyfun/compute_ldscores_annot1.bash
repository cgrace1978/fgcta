#!/bin/bash

chr=$1

python compute_ldscores.py \
       --bfile ../LD_new/ukb_v3_maf_imp_${chr}_eur_wcm  \
       --annot ukb_ldscore/ukb_annotations.random.${chr}.txt \
       --out ukb_ldscore/ukb_annotations.${chr}.l2.ldscore.parquet \
       --allow-missing




