rm(list=ls())
library(snpStats)
library(sommer)
library(dplyr)
w<-.99


gp=read.plink('tmp/geno')
windown_rhm<-readr::read_csv('tmp/window.csv')
map0=gp$map %>% arrange(chromosome,position)

map<-data.frame(chr=map0$chr, snpID=rownames(map0),cM=0, pos=map0$pos)

snp<-as(gp$geno,'numeric')-1
snp=snp[,map$snpID]
GRM<-w*A.mat(snp)+diag(nrow(snp))*(1-w)



##############
#GRM regional#
##############
GRMlist<-list()
for(i in 1:nrow(windown_rhm)){
  windi<-windown_rhm[i,]
  
  snp0_order<-which(colnames(snp)==as.character(windi[1,1]))
  snp1_order<-which(colnames(snp)==as.character(windi[1,2]))
  
  snpr<-as(gp$geno[,snp0_order:snp1_order],'numeric')-1
  if(ncol(snpr)!=windi[1,6]) stop('erro 123')
  Gr<-w*A.mat(snpr)+diag(nrow(snpr))*(1-w)
  GRMlist[[length(GRMlist)+1]]<-Gr
}
save(GRM,GRMlist,windown_rhm,file='tmp/grm.Rdata')
