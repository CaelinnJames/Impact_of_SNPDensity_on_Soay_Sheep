#!/bin/sh
#$ -cwd
#$ -l h_rt=3:00:00
#$ -pe sharedmem 1
#$ -l h_vmem=100G
#$ -M s1944058@sms.ed.ac.uk
#$ -m baes 
. /etc/profile.d/modules.sh

module load igmm/apps/dissect/1.15.2c
module load igmm/apps/plink/1.90b4

mpirun -np 8 dissect.mpich --reml --reml-maxit 100 --bfile HD/Conditional_HD_Geno --pheno AdultForeLegPhenotypes.txt --pheno-col 2 --blue --covar Assoc_HD.txt --qcovar QAssoc_HD.txt --random-effects AdultForeLegRandom.txt --random-effects-cols 1 2 --out HD/AdultForeLeg_HD_Conditional_H2

if [[ -f HD/AdultForeLeg_HD_Conditional_H2.badsnps ]]
then
plink --bfile HD/Conditional_HD_Geno --sheep --exclude HD/AdultForeLeg_HD_Conditional_H2.badsnps --make-bed --out HD/AdultForeLeg_HD_Conditional_H2

mpirun -np 8 dissect.mpich --reml --reml-maxit 100 --bfile HD/AdultForeLeg_HD_Conditional_H2 --pheno AdultForeLegPhenotypes.txt --pheno-col 2 --blue --covar Assoc_HD.txt --qcovar QAssoc_HD.txt --random-effects AdultForeLegRandom.txt --random-effects-cols 1 2 --out HD/AdultForeLeg_HD_Conditional_H2
fi

  
