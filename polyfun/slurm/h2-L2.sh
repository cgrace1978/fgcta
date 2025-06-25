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

## 1       2245570 SKI     1245570 3245570
#bash finemap_test.bash 1 1245570 3245570

mkdir -p output2

python polyfun.py \
    --compute-h2-L2 \
    --no-partitions \
    --output-prefix output2/testrun \
    --sumstats example_data/sumstats.parquet \
    --ref-ld-chr example_data/annotations. \
    --w-ld-chr example_data/weights.

date
