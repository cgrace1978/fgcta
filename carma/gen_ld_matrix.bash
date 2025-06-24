#!/bin/bash

chr=$1
query=$2
prefix=$3

perl gen_query.pl $query ${chr} ${prefix}

## extract the SNPs of interest from the BIM files.
plink --bfile plink_ukbb/snptestid/ukb_v3_maf_imp_${chr}_eur \
    --extract ${prefix}_ids.txt \
    --make-bed --out ${prefix}

## generate LD matrix
plink --bfile ${prefix} \
    --a1-allele ${prefix}_in.bim 2 1 '#' --r \
    --matrix --out ${prefix}_ld

gzip ${prefix}_ld.ld
