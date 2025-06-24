#!/bin/bash

loci=$1
iter=$2
id=$3
annot=$4

echo $loci

echo ${loci}.maf005.iter${iter}.processed > input.${loci}.iter${iter} 

mkdir output.${loci}.baseline.iter${iter}.mcmc.ID${id}

../bin/PAINTOR \
    -input input.${loci}.iter${iter} \
    -Zhead Zscore \
    -LDname ld \
    -in . \
    -out output.${loci}.baseline.iter${iter}.mcmc.ID${id} \
    -mcmc \
    -max_samples 10000 \
    -num_chains 5 \
    -burn_in 50000 > output.${loci}.baseline.iter${iter}.mcmc.ID${id}/${loci}.log 

echo $annot
mkdir output.${loci}.${annot}.iter${iter}.mcmc.ID${id}
../bin/PAINTOR \
    -input input.${loci}.iter${iter} \
    -Zhead Zscore \
    -LDname ld \
    -in . \
    -out output.${loci}.${annot}.iter${iter}.mcmc.ID${id} \
    -annotations $annot \
    -mcmc \
    -max_samples 10000 \
    -num_chains 5 \
    -burn_in 50000 > output.${loci}.${annot}.iter${iter}.mcmc.ID${id}/${loci}.log 
   

