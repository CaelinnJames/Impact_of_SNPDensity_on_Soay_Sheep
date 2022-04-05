Assoc1 = read.table("Assoc1.txt")
Assoc2 = read.table("Assoc2.txt")
Assoc3 = merge(Assoc1,Assoc2,by=c("V1","V2")) 
write.table(Assoc3, "Assoc3.txt",row.names=FALSE,col.names=FALSE,quote=FALSE) 
