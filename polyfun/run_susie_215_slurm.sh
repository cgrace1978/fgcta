#!/bin/bash 

#SBATCH -p short
#SBATCH -o finemap_%A.%a.out
#SBATCH -e finemap_%A.%a.err

#SBATCH -c 4

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
    chr=`grep -w ^${MY_TASK} ../215_regions.txt | cut -f 2`
    st=`grep -w ^${MY_TASK} ../215_regions.txt | cut -f 5`
    en=`grep -w ^${MY_TASK} ../215_regions.txt | cut -f 6`
    gene=`grep -w ^${MY_TASK} ../215_regions.txt | cut -f 4`
    bash finemap_susie.bash $chr $st $en ${MY_TASK}.${gene}
done

## 1       2245570 SKI     1245570 3245570


date
