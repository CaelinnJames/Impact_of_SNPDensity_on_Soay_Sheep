#!/bin/sh  
#$ -cwd  
#$ -l h_rt=2:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=200G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c  

dissect.mpich  --gwas --bfile ../../InputData/Plates_1to87_QC3 --pheno AdultHindLegResiduals.txt --out Hindleg/Adult_Hindleg_TwoStep_GWAS    
