#!/bin/bash 
 
#SBATCH -p short
#SBATCH -o gen_annot_%A.%a.out
#SBATCH -e gen_annot_%A.%a.err

echo "------------------------------------------------" 
echo "Run on host: "`hostname` 
echo "Operating system: "`uname -s` 
echo "Username: "`whoami` 
echo "Started at: "`date` 
echo "------------------------------------------------" 
 
date

FIRST=$SLURM_ARRAY_TASK_ID

LAST=$(($FIRST + $SLURM_ARRAY_TASK_STEP - 1))

for (( MY_TASK=$FIRST; MY_TASK<=$LAST; MY_TASK++ )) 
do
    chr=`grep -w ^$MY_TASK carma_loci.txt | cut -f 2`
    perl gen_annot_for_loci.pl $chr $MY_TASK
done
date
