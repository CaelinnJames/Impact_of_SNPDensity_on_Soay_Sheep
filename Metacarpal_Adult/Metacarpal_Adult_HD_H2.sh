#!/bin/sh
#$ -cwd
#$ -l h_rt=3:00:00
#$ -pe sharedmem 1
#$ -l h_vmem=150G
#$ -M s1944058@sms.ed.ac.uk
#$ -m baes 
. /etc/profile.d/modules.sh

module load igmm/apps/dissect/1.15.2c
module load igmm/apps/plink/1.90b4

mpirun -np 8 dissect.mpich --reml --bfile ../InputData/HD_QC --pheno MetacarpalLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar MetacarpalLength_AdultAssoc.txt --qcovar MetacarpalLength_AdultQAssoc.txt --random-effects MetacarpalLength_AdultRandom.txt --random-effects-cols 1 --out HD/MetacarpalLength_Adult_HD_H2

if [[ -f HD/MetacarpalLength_Adult_HD_H2.badsnps ]]
then
plink --bfile ../InputData/HD_QC --sheep --exclude HD/MetacarpalLength_Adult_HD_H2.badsnps --make-bed --out HD/MetacarpalLength_Adult_HD_H2

mpirun -np 8 dissect.mpich --reml --bfile HD/MetacarpalLength_Adult_HD_H2 --pheno MetacarpalLength_AdultPhenotypes.txt --pheno-col 1 --blue --covar MetacarpalLength_AdultAssoc.txt --qcovar MetacarpalLength_AdultQAssoc.txt --random-effects MetacarpalLength_AdultRandom.txt --random-effects-cols 1 --out HD/MetacarpalLength_Adult_HD_H2
fi
#mpirun -np 8 dissect.mpich --reml --bfile ../InputData/HD_QC --pheno MetacarpalLength_AdultPhenotypes.txt --pheno-col 1 --blue --random-effects MetacarpalLength_AdultRandom.txt --random-effects-cols 1 --out HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance

#if [[ -f HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance.badsnps ]]
#then
#plink --bfile ../InputData/HD_QC --sheep --exclude HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance.badsnps --make-bed --out HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance

#mpirun -np 8 dissect.mpich --reml --bfile HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance --pheno MetacarpalLength_AdultPhenotypes.txt --pheno-col 1 --blue --random-effects MetacarpalLength_AdultRandom.txt --random-effects-cols 1 --out HD/MetacarpalLength_Adult_HD_TotalPhenotypeVariance
#fi
