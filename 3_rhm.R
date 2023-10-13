rm(list=ls())
library(sommer)
library(dplyr)
base::load('tmp/grm.Rdata')

phe=readr::read_tsv('tmp/pheno.txt')
colnames(phe)[1]='id'
covariates=readr::read_tsv('tmp/covar.txt')


phe2=phe %>% inner_join(covariates) %>% mutate(id2=id)

traits=colnames(phe)[-1]
VC=NULL
for(tr in traits){
    phe3=phe2
    colnames(phe3)[colnames(phe3)==tr]='y'

    
    for(wind in 1:length(GRMlist)){
    
          fit0=mmer(fixed = y~covar1+covar2,random=~vsr(id,Gu=GRMlistRemain[[wind]]),data=phe3,nIters = 50)
          vc00=summary(fit0)$varcomp[c('u:id.y-y','units.y-y'),'VarComp']
          names(vc00)=c('vc_gen_main_model','vc_error_main_model')
      
          fiti=mmer(fixed = y~covar1+covar2,random=~vsr(id2,Gu=GRMlist[[wind]])+
                      vsr(id,Gu=GRMlistRemain[[wind]]),data=phe3,nIters = 50)
          
          logL0=summary(fit0)$log[1,1]
          logL1=summary(fiti)$log[1,1]
          
          chisq=-2*(logL0-logL1)
          
          pval=pchisq(q=chisq,df = 1,lower.tail = F)/2
          
          
          
          vc0=summary(fiti)$varcomp[c('u:id2.y-y','u:id.y-y','units.y-y'),'VarComp']
          names(vc0)=c('vc_region_target','vc_region2','vc_error')
          vc=data.frame(t(vc00),t(vc0),
                     trait=tr,region=wind,
                     windown_rhm[wind,],
                     congergence1=fiti$convergence,
                     congergence0=fit0$convergence,
                     chisq=chisq,pval=pval)
          VC=rbind(vc,VC)
          
    }
}


readr::write_csv(VC %>% mutate(minuslog10pvalue=-log10(pval)),'output/rhm.csv')
