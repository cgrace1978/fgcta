#!/bin/bash

## generates baseline ld scores from UKB genotype data

chr=$1

python compute_ldscores.py \
       --bfile ../LD_new/ukb_v3_maf_imp_${chr}_eur_wcm  \
       --out output/ukb_chr${chr}.parquet



