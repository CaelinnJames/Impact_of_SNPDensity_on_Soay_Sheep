#!/bin/sh  
#$ -cwd  
#$ -l h_rt=1:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=100G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  



module load igmm/apps/dissect/1.15.2c  

mpirun -np 8 dissect.mpich  --reml --bfile ../InputData/Plates_1to87_QC3 --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --covar BirthWtAssoc.txt --qcovar BirthWtQAssoc.txt --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out 50K/BirthWt_50K_H2

#mpirun -np 8 dissect.mpich  --reml --bfile ../InputData/Plates_1to87_QC3 --pheno BirthWtPhenotypes.txt --pheno-col 1 --blue --random-effects BirthWtRandom.txt --random-effects-cols 1 2 --out 50K/BirthWt_50K_TotalPhenotypeVariance


