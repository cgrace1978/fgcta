#!/bin/bash
#$ -cwd -V -N PAINTOR.E065
#$ -o qsubfiles/E065/
#$ -e qsubfiles/E065/
#$ -q long.qc
#$ -pe shmem 1
#$ -S /bin/bash

date

let sno=$SGE_TASK_ID

echo $sno
gene=`grep -w ^$sno loci.trim.E065.txt | cut -f 6`
iter=`grep -w ^$sno loci.trim.E065.txt | cut -f 7`
annot=`grep -w ^$sno loci.trim.E065.txt | cut -f 8`

for i in {5..10}; do 
    echo $i;
    bash run_PAINTOR_mcmc_maxsamples.bash $gene $iter $i $annot
done

date
