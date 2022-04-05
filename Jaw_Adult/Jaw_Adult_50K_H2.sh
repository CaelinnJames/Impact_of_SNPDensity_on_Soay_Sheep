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

mpirun -np 8 dissect.mpich --reml --bfile ../InputData/Plates_1to87_QC3 --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar JawLength_AdultAssoc.txt --qcovar JawLength_AdultQAssoc.txt --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_H2

if [[ -f 50K/JawLength_Adult_50K_H2.badsnps ]]
then
plink --bfile ../InputData/Plates_1to87_QC3 --sheep -- exclude 50K/JawLength_Adult_50K_H2.badsnps --make-bed 50K/JawLength_Adult_50K_H2

mpirun -np 8 dissect.mpich --reml --bfile 50K/JawLength_Adult_50K_H2 --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar JawLength_AdultAssoc.txt --qcovar JawLength_AdultQAssoc.txt --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_H2
fi

mpirun -np 8 dissect.mpich --reml --bfile ../InputData/Plates_1to87_QC3 --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_TotalPhenotypeVariance

if [[ -f 50K/JawLength_Adult_50K_TotalPhenotypeVariance.badsnps ]]
then
plink --bfile ../InputData/Plates_1to87_QC3 --sheep -- exclude 50K/JawLength_Adult_50K_TotalPhenotypeVariance.badsnps --make-bed 50K/JawLength_Adult_50K_TotalPhenotypeVariance

mpirun -np 8 dissect.mpich --reml --bfile 50K/JawLength_Adult_50K_TotalPhenotypeVariance --pheno JawLength_AdultPhenotypes.txt --pheno-col 1 --blue --random-effects JawLength_AdultRandom.txt --random-effects-cols 1 --out 50K/JawLength_Adult_50K_TotalPhenotypeVariance
fi
