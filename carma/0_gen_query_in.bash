#!/bin/bash

i=$1

chr=`grep -w ^$i carma_loci.txt | cut -f 2`
st=`grep -w ^$i carma_loci.txt | cut -f 3`
en=`grep -w ^$i carma_loci.txt | cut -f 4`

echo $chr $st $en

zcat CHD_meta_SAIGE_complete_filtered_30.1.19_formatted.out.gz \
    | sed '1d' \
    | awk -v chr=$chr -v st=$st -v en=$en '{if($2 == chr && $3 >= st && $3 <= en){print $0}}' - \
    | cut -f 1 > queries/loci_${i}.txt



