rm(list=ls())
library(dplyr)
library(stringr)
library(ggplot2)
pval=readr::read_csv('output/rhm.csv') %>% mutate(Chr=str_pad(chr,pad='0',2)) %>%
  mutate(logL=-log(pval),pos=((pos0+pos1)/2)/1000000) %>% filter(congergence)


g=ggplot(data=pval,mapping = aes(x=pos,y=logL,color=Chr))+
  facet_grid(trait~Chr,scales = 'free')+geom_point()+ylab('-log10(p-value)')+xlab('Pos (Mb)')+
  geom_hline(yintercept = 5,linetype=2)+theme_bw()
jpeg('output/plot.jpeg',width = 4250,height = 2000,res=300,quality = 100)
g
dev.off()
