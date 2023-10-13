rm(list=ls())
library(ggplot2)
library(dplyr)


maf=read.table('tmp/geno.frq',h=T)




summary(maf$MAF)
jpeg(file='output/maf.jpg',width = 2160,height = 2160,res=300,quality = 100)

h=hist(maf$MAF,breaks = seq(0,.5,.05),include.lowest = F,col ='darkblue', axes = F)
h$density=h$counts/sum(h$counts)*100
plot(h,freq=FALSE,col='darkblue',xaxt='n',ylab='(%)',xlab='MAF',main='')
axis(1,seq(0,.5,.05))
dev.off()
