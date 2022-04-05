#!/bin/sh  
#$ -cwd  
#$ -l h_rt=2:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=200G  
#$ -t 1-26  
#$ -tc 10  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c  
module load igmm/apps/plink/1.90b4  
  
i=$SGE_TASK_ID  
  
plink --bfile ../../InputData/Plates_1to87_QC3 --sheep --not-chr ${i},X --keep MetacarpalLength_LambPhenotypes.txt --make-bed --out 50K/NoChr${i}  
  
dissect.mpich  --make-grm --bfile 50K/NoChr${i} --out 50K/NoChr${i}_GRM  
  
echo "50K/Chr${i} 50K/NoChr${i}_GRM" > 50K/GWAS_GRM${i}.txt  
  
plink --bfile ../../InputData/Plates_1to87_QC3 --sheep --chr ${i} --keep MetacarpalLength_LambPhenotypes.txt --make-bed --out 50K/Chr${i}  
  
if [[ -f 50K/NoChr${i}_GRM.badsnps ]]  
then  
plink --bfile 50K/NoChr${i} --sheep --exclude 50K/NoChr${i}_GRM.badsnps  --make-bed --out 50K/NoChr${i}_2  
  
dissect.mpich  --make-grm --bfile 50K/NoChr${i}_2 --out 50K/NoChr${i}_GRM
  
fi  
  
dissect.mpich  --gwas --bfile-grm-list 50K/GWAS_GRM${i}.txt --pheno MetacarpalLength_LambPhenotypes.txt --covar MetacarpalLength_LambAssoc.txt --qcovar MetacarpalLength_LambQAssoc.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2  --out 50K/MetacarpalLength_Lamb_50K_GWAS_Chr${i}  
  
if [[ -f 50K/MetacarpalLength_Lamb_50K_GWAS_Chr${i}.badsnps ]]  
then  
plink --bfile 50K/Chr${i} --sheep --exclude 50K/MetacarpalLength_Lamb_50K_GWAS_Chr${i}.badsnps --make-bed --out 50K/Chr${i}_2  
  
echo "50K/Chr${i}_2 50K/NoChr${i}_GRM" > 50K/GWAS_GRM${i}.txt  
  
dissect.mpich  --gwas --bfile-grm-list 50K/GWAS_GRM${i}.txt --pheno MetacarpalLength_LambPhenotypes.txt --covar MetacarpalLength_LambAssoc.txt --qcovar MetacarpalLength_LambQAssoc.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2 --out 50K/MetacarpalLength_Lamb_50K_GWAS_Chr${i}    
fi 

