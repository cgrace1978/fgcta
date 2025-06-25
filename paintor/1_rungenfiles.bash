#!/bin/bash

i=$1
iter=$2

gene=`grep -w ^$i loci.iter${iter}.txt | cut -f 6`
chr=`grep -w ^$i loci.iter${iter}.txt | cut -f 2`
st=`grep -w ^$i loci.iter${iter}.txt | cut -f 3`
en=`grep -w ^$i loci.iter${iter}.txt | cut -f 4`
echo $gene $chr $st $en
perl genzscores.pl $gene $chr $st $en $iter
python ../bin/PAINTOR_Utilities/CalcLD_1KG_VCF.py \
    --locus ${gene}.maf005.iter${iter} \
    --reference ../1000G_phase3_vcf_v2/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz \
    --map ../integrated_call_samples_v3.20130502.ALL.panel \
    --effect_allele a1 \
    --alt_allele a2 \
    --population EUR \
    --Zhead Zscore \
    --out_name ${gene}.maf005.iter${iter} \
    --position pos \
    > ${gene}.maf005.iter${iter}.LD.log \
    2> ${gene}.maf005.iter${iter}.LD.err

bash gen-annot.bash $gene $chr $iter
cp ${gene}.maf005.iter${iter}.ld ${gene}.maf005.iter${iter}.processed.ld
