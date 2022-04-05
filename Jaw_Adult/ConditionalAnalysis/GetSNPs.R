files = intersect(list.files(pattern="JawLength_Adult_HD_GWAS_Chr",recursive=TRUE),list.files(pattern=".gwas.snps",recursive=TRUE))
SNPresults = do.call(rbind, lapply(files, function(x) read.table(x,header=T)))

bimFile <- read.table("/exports/igmm/eddie/haley-soay/InputData/HD_QC.bim",header=F)
GWASHDResults <- merge(bimFile,SNPresults[,c("SNP","PV","BETA"),],by.x="V2",by.y="SNP",all.x=FALSE,all.y=TRUE)
colnames(GWASHDResults) <- c("SNP","Chr","V3","Pos","Ref","Minor","PV","BETA")

SNPs <- GWASHDResults[which(GWASHDResults$PV < (0.05/48635) ),]

SNPs <- SNPs[SNPs$Chr %in% names(which(table(SNPs$Chr)>1)),]

SNPs <- SNPs[order(SNPs$PV),]

SNPs <- SNPs[!duplicated(SNPs[,"Chr"]),]

write.table(SNPs[,c("SNP")],"SNPs_HD.txt",row.names=FALSE,col.names=FALSE,quote=FALSE)



files = intersect(list.files(pattern="JawLength_Adult_50K_GWAS_Chr",recursive=TRUE),list.files(pattern=".gwas.snps",recursive=TRUE))
SNPresults = do.call(rbind, lapply(files, function(x) read.table(x,header=T)))

bimFile <- read.table("/exports/igmm/eddie/haley-soay/InputData/Plates_1to87_QC3.bim",header=F)
GWASHDResults <- merge(bimFile,SNPresults[,c("SNP","PV","BETA"),],by.x="V2",by.y="SNP",all.x=FALSE,all.y=TRUE)
colnames(GWASHDResults) <- c("SNP","Chr","V3","Pos","Ref","Minor","PV","BETA")

SNPs <- GWASHDResults[which(GWASHDResults$PV < (0.05/20082) ),]

SNPs <- SNPs[SNPs$Chr %in% names(which(table(SNPs$Chr)>1)),]

SNPs <- SNPs[order(SNPs$PV),]

SNPs <- SNPs[!duplicated(SNPs[,"Chr"]),]


write.table(SNPs[,c("SNP")],"SNPs_50K.txt",row.names=FALSE,col.names=FALSE,quote=FALSE)

