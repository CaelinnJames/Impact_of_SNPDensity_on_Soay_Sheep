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
  
plink --bfile HD/Conditional_HD_Geno --sheep --not-chr ${i},X --keep MetacarpalLength_LambPhenotypes.txt --make-bed --out HD/Conditional_NoChr${i}  
  
dissect.mpich  --make-grm --bfile HD/Conditional_NoChr${i} --out HD/Conditional_NoChr${i}_GRM  
  
echo "HD/Conditional_Chr${i} HD/Conditional_NoChr${i}_GRM" > HD/Conditional_GWAS_GRM${i}.txt  
  
plink --bfile HD/Conditional_HD_Geno --sheep --chr ${i} --keep MetacarpalLength_LambPhenotypes.txt --make-bed --out HD/Conditional_Chr${i}  
  
if [[ -f HD/Conditional_NoChr${i}_GRM.badsnps ]]  
then  
plink --bfile HD/Conditional_NoChr${i} --sheep --exclude HD/Conditional_NoChr${i}_GRM.badsnps  --make-bed --out HD/Conditional_NoChr${i}_2  
  
dissect.mpich  --make-grm --bfile HD/Conditional_NoChr${i}_2 --out HD/Conditional_NoChr${i}_GRM
  
fi  
  
dissect.mpich  --gwas --bfile-grm-list HD/Conditional_GWAS_GRM${i}.txt --pheno MetacarpalLength_LambPhenotypes.txt --covar Assoc_HD.txt --qcovar QAssoc_HD.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2  --out HD/Conditional_MetacarpalLength_Lamb_HD_GWAS_Conditional_Chr${i}  
  
if [[ -f HD/Conditional_MetacarpalLength_Lamb_HD_GWAS_Conditional_Chr${i}.badsnps ]]  
then  
plink --bfile HD/Conditional_Chr${i} --sheep --exclude HD/Conditional_MetacarpalLength_Lamb_HD_GWAS_Conditional_Chr${i}.badsnps --make-bed --out HD/Conditional_Chr${i}_2  
  
echo "HD/Conditional_Chr${i}_2 HD/Conditional_NoChr${i}_GRM" > HD/Conditional_GWAS_GRM${i}.txt  
  
dissect.mpich  --gwas --bfile-grm-list HD/Conditional_GWAS_GRM${i}.txt --pheno MetacarpalLength_LambPhenotypes.txt --covar Assoc_HD.txt --qcovar QAssoc_HD.txt --random-effects MetacarpalLength_LambRandom.txt --random-effects-cols 1 2 --out HD/Conditional_MetacarpalLength_Lamb_HD_GWAS_Conditional_Chr${i}    
fi 

