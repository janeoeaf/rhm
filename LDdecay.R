rm(list=ls())
library(ggplot2)
library(dplyr)
library(stringr)



nchr<-11
model=1
N<-225


LD<-NULL
for(chr in 1:nchr){
  ldfile<-sprintf('tmp/geno_chr%i.ld',chr)
  LDchri<-read.table(ldfile,h=T)
  LD<-rbind(LD,LDchri)
}
LD<-transform(LD,distance=abs(BP_A-BP_B)/1000) %>% mutate(chr=paste0('chr',str_pad(CHR_A, 2, pad = "0")))




if(model%in%c(1,3)){
  n<-N*2
  inivalues<-c(beta=.01)
  fit<-nls(R2~((10+beta*distance)/((2+beta*distance)*(11+beta*distance)))*(1+((3+beta*distance)*(12+12*beta*distance+(beta*distance)^2))/(n*(2+beta*distance)*(11+beta*distance))),start=inivalues,
           control=nls.control(maxiter=100),data=LD)
  fpoints1<-predict(fit)
  df1 <- data.frame(distance=LD$distance,fpoints=fpoints1)
  maxld1 <- max(fpoints1) 
 # h.decay1 <- maxld1/2
  h.decay1 <- .2
  
  half.decay.distance1 <- df1$distance[which.min(abs(df1$fpoints-h.decay1))]
  s1<-summary(fit)
  LD$yhat_model1=fpoints1
  model1out<-data.frame(model=1,beta=s1$coefficients[1],pvalue=s1$coefficients[4],R2=1-deviance(lm(R2~1,data=LD))/deviance(fit),maxld_hat=maxld1,half_decay_dist= half.decay.distance1)
}

if(model%in%c(2,3)){
  
  fit2=nls(R2 ~ (1/(1+4*beta*distance) ), data=LD, start=list(beta=0.001), trace=F)
  fpoints2<-predict(fit2)
  df2 <- data.frame(distance=LD$distance,fpoints=fpoints2)
  maxld2 <- max(fpoints2) 
  h.decay2 <- maxld2/2
  half.decay.distance2 <- df2$distance[which.min(abs(df2$fpoints-h.decay2))]
  s2<-summary(fit2)
  model2out<-data.frame(model=2,beta=s2$coefficients[1],pvalue=s2$coefficients[4],R2=1-deviance(lm(R2~1,data=LD))/deviance(fit2),maxld_hat=maxld2,half_decay_dist= half.decay.distance2)
  LD$yhat_model2=fpoints2
  
}

if(model==1) modelout<-model1out
if(model==2) modelout<-model2out
if(model==3) modelout<-rbind(model1out,model2out)


make_line_model1_l1=data.frame(R2=c(h.decay1,h.decay1),distance=c(-Inf,half.decay.distance1))
make_line_model1_l2=data.frame(R2=c(-Inf,h.decay1),distance=c(half.decay.distance1,half.decay.distance1))



g=ggplot(data=LD,mapping = aes(x=distance,y=R2))+#facet_wrap(~chr,scale='free')+
  # geom_hex(bins = 500) +
  geom_point(size=.25,color='gray',alpha=.5)+
  ylab(expression(r^2))+xlab('Distance(Kb)')+
  # scale_fill_continuous(type = "viridis") +
  geom_line(data=make_line_model1_l1,linetype=2)+
  geom_line(data=make_line_model1_l2,linetype=2)+
  scale_y_continuous(breaks = seq(0,1,.2))+
  scale_x_continuous(breaks = sort(round(c(half.decay.distance1,seq(0,6e4,2e4))))
                       )+

  
  geom_line(mapping = aes(y=yhat_model1),color='red')+
  theme_bw()+
  theme(axis.text=element_text(size=12.5))+
  theme(axis.title =element_text(size=12.5))


jpeg(file='output/LDdecay.jpeg',width = 2160,height = 2160,res=300,quality = 100)
print(g)
dev.off()




