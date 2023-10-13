rm(list=ls())
library(dplyr)
library(stringr)
library(ggplot2)
pval=readr::read_csv('output/rhm.csv') %>% mutate(Chr=str_pad(chr,pad='0',2),Chr=paste0('Chr',Chr)) %>%
  mutate(pos=((pos0+pos1)/2)/1000000) %>% filter(congergence1 & congergence0)


g=ggplot(data=pval,mapping = aes(x=pos,y=minuslog10pvalue))+
  facet_grid(trait~Chr,scales = 'free')+geom_point(color='darkblue')+ylab('-log10(p-value)')+xlab('Position (Mb)')+
  geom_hline(yintercept = 5,linetype=2,color='red')+theme_bw()
jpeg('output/manhattam_plot.jpeg',width = 4250,height = 2000,res=300,quality = 100)
g
dev.off()
