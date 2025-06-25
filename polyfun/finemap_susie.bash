#!/bin/bash

chr=$1
st=$2
en=$3
prefix=$4

python finemapper.py \
       --geno ../LD/ukb_v3_maf_imp_${chr}_eur \
       --sumstats ../CHD_munge/chr${chr}.summstat.txt \
       --n 1165720 \
       --chr ${chr} \
       --start ${st} \
       --end ${en} \
       --method susie \
       --max-num-causal 5 \
       --cache-dir LD_cache \
       --non-funct \
       --allow-missing \
       --out ../susie_out2/${prefix}_susie.${chr}.${st}.${en}.gz


##  
