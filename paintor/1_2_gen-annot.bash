#!/bin/bash

chr=$2
loci=$1
iter=$3

# loci=`grep -w ^$i loci.iter${iter}.txt | cut -f 6`
# chr=`grep -w ^$i loci.iter${iter}.txt | cut -f 2`

echo $loci $chr

#cp ../simData/$loci\_snptest.txt .
cp ../cad.annot/extendedmodel_150219.chr$chr.bed .
perl munge-snps.pl $loci $iter
perl build_fgwas.pl $loci $chr
cut -f 5- ${loci}_annot.txt | sed 's/\t/ /g' > ${loci}.maf005.iter${iter}.processed.annotations
