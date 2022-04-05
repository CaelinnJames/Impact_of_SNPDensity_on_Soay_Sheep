#!/bin/sh  
#$ -cwd  
#$ -l h_rt=6:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=100G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  



module load igmm/apps/dissect/1.15.2c  
module load igmm/apps/plink/1.90b4

mpirun -np 8 dissect.mpich  --reml --bfile ../InputData/HD_QC --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --covar BirthWtAssoc.txt --qcovar BirthWtQAssoc.txt --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out HD/BirthWt_HD_H2

if [[ -f HD/BirthWt_HD_H2.badsnps ]]
then
plink --bfile ../InputData/HD_QC --sheep --exclude HD/BirthWt_HD_H2.badsnps --make-bed --out HD/BirthWt_HD_H2

mpirun -np 8 dissect.mpich  --reml --bfile HD/BirthWt_HD_H2 --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --covar BirthWtAssoc.txt --qcovar BirthWtQAssoc.txt --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out HD/BirthWt_HD_H2

fi

#mpirun -np 8 dissect.mpich  --reml --bfile ../InputData/HD_QC --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out HD/BirthWt_HD_TotalPhenotypeVariance


#if [[ -f HD/BirthWt_HD_TotalPhenotypeVariance.badsnps ]]
#then
#plink --bfile ../InputData/HD_QC --sheep --exclude HD/BirthWt_HD_TotalPhenotypeVariance.badsnps --make-bed --out HD/BirthWt_HD_TotalPhenotypeVariance

#mpirun -np 8 dissect.mpich  --reml --bfile HD/BirthWt_HD_TotalPhenotypeVariance --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out HD/BirthWt_HD_TotalPhenotypeVariance

#fi
