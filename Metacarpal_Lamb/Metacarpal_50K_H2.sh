#!/bin/sh
#$ -cwd
#$ -l h_rt=1:00:00
#$ -pe sharedmem 1
#$ -l h_vmem=100G
#$ -M s1944058@sms.ed.ac.uk
#$ -m baes 
. /etc/profile.d/modules.sh

module load igmm/apps/dissect/1.15.2c
module load igmm/apps/plink/1.90b4

mpirun -np 8 dissect.mpich --reml --bfile ../../InputData/Plates_1to87_QC3 --pheno MetacarpalLength_LambPhenotypes.txt --pheno-col 1 --blue --covar MetacarpalLength_LambAssoc.txt --qcovar MetacarpalLength_LambQAssoc.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2 --out 50K/MetacarpalLength_Lamb_50K_H2

if [[ -f 50K/MetacarpalLength_Lamb_50K_H2.badsnps ]]
then
plink --bfile ../../InputData/Plates_1to87_QC3 --sheep -- exclude 50K/MetacarpalLength_Lamb_50K_H2.badsnps --make-bed 50K/MetacarpalLength_Lamb_50K_H2

mpirun -np 8 dissect.mpich --reml --bfile 50K/MetacarpalLength_Lamb_50K_H2 --pheno MetacarpalLength_LambPhenotypes.txt --pheno-col 1 --blue --covar MetacarpalLength_LambAssoc.txt --qcovar MetacarpalLength_LambQAssoc.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2 --out 50K/MetacarpalLength_Lamb_50K_H2
fi

