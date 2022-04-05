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

mpirun -np 8 dissect.mpich --reml --bfile 50K/Conditional_50K_Geno --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar Assoc_50K.txt --qcovar QAssoc_50K.txt --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_Conditional_H2

if [[ -f 50K/JawLength_Adult_50K_Conditional_H2.badsnps ]]
then
plink --bfile 50K/Conditional_50K_Geno --sheep -- exclude 50K/JawLength_Adult_50K_Conditional_H2.badsnps --make-bed 50K/JawLength_Adult_50K_Conditional_H2

mpirun -np 8 dissect.mpich --reml --bfile 50K/JawLength_Adult_50K_Conditional_H2 --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar Assoc_50K.txt --qcovar QAssoc_50K.txt --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_Conditional_H2
fi

  
