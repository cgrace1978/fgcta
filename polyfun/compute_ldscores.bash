#!/bin/bash

# python compute_ldscores_from_ld.py \
#   --ukb \
#   --out output/test_weight.parquet

#  --annot example_data/annotations.1.annot.parquet \

## 
chr=$1

python compute_ldscores.py \
       --bfile ../LD_new/ukb_v3_maf_imp_${chr}_eur_wcm  \
       --out output/ukb_chr${chr}.parquet

#--annot ../SKI_annot_tmp1 \


