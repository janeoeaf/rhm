rm(list=ls())
library(snpStats)
library(dplyr)


windows=20 #tamanho da janela
overlap=10 #sobreposição
overlapmin=20 #numero minimo de SNP na janela



geno=read.plink('tmp/geno')
map0=geno$map %>% arrange(chromosome,position)

map<-data.frame(chr=map0$chr, snpID=rownames(map0),cM=0, pos=map0$pos)
Windows<-NULL
for(chr in 1:max(map[,1])){
  mapchr<-map[map[,1]==chr,]
  
  endsnp0<-which(!1:nrow(mapchr)%%windows)
  indsnp<-(1:nrow(mapchr))[which(1:nrow(mapchr)%%overlap==1)]
  end_snp<-indsnp+windows-1
  
  end0<-end_snp[end_snp<=nrow(mapchr)]
  ind0<-indsnp[end_snp<=nrow(mapchr)]
  
  if(nrow(mapchr)-(max(ind0)+overlap+1)>=overlapmin){
    ind0<-c(ind0,max(ind0)+overlap)
    end0<-c(end0,nrow(mapchr))
  } else end0[length(end0)]<-nrow(mapchr)
  
  wind<-data.frame(t(rbind(ind0,end0)),snp0=mapchr[ind0,2],snp1=mapchr[end0,2],chr=chr,pos0=mapchr[ind0,4],pos1=mapchr[end0,4])
  wind<-transform(wind,numberSNP=end0-ind0+1)
  Windows<-rbind(Windows,wind)
}

readr::write_csv(Windows[,-c(1:2)],'tmp/window.csv')
