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

    
          fit0=mmer(fixed = y~1,data=phe3,nIters = 50)
          fit1=mmer(fixed = y~1,random=~vsr(id,Gu=GRM),data=phe3,nIters = 50)
          vc=summary(fit1)$varcomp[c('u:id.y-y','units.y-y'),'VarComp']
          names(vc)=c('vc_gen','vc_error')
      
        
          
          logL0=summary(fit0)$log[1,1]
          logL1=summary(fit1)$log[1,1]
          
          chisq=-2*(logL0-logL1)
          
          pval=pchisq(q=chisq,df = 1,lower.tail = F)/2
          
          
          
          vc=data.frame(t(vc),
                     trait=tr,
                     congergence=fit1$convergence,chisq=chisq,pval=pval)
          VC=rbind(vc,VC)
          
    }


VC=VC%>% mutate(h2=vc_gen/(vc_gen+vc_error))
readr::write_csv(VC,'output/h2.csv')
