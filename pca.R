rm(list=ls())
library(snpStats)
library(dplyr)
w<-.99


gp=read.plink('tmp/geno')
xxmat <- xxt(gp$genotypes, correct.for.missing=FALSE)


evv <- eigen(xxmat, symmetric=TRUE)
pcs <- evv$vectors[,1:2]
varexp <-round(100*(evv$values**2/sum(evv$values**2))[1:2],2)


df=data.frame(PCA1=pcs[,1],PCA2=pcs[,2])

jpeg(file='output/pca.jpg',width = 2160,height = 2160,res=300,quality = 100)

plot(PCA2~PCA1,data=df,xlab=paste0(varexp[1],'(%)'),ylab=paste0(varexp[2],'(%)'),pch=19,col='darkblue')
dev.off()


pca=data.frame(id=colnames(xxmat),covar1=pcs[,1],covar2=pcs[,2])
readr::write_tsv(pca,'tmp/covar.txt')

