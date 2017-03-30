
genofile <- snpgdsOpen("../exome/test.gds")
 

colorPal = function(pal = "RdYlBu", n=300) {
  
  library(RColorBrewer)
  
  #  c1 = colorRampPalette(brewer.pal(300,"Blues"))
   #  c1 = colorRampPalette(brewer.pal(300,"YlOrRd"))
  c1 = colorRampPalette(brewer.pal(n,pal))
  
  c1(n)

}




IBSstatistics = function() {
    
    maf_all = snpgdsSNPRateFreq(genofile)
    str(maf_all)
    s = which(maf_all$AlleleFreq > 0.05)
    
    length(s)
    ibs = snpgdsIBS(genofile, snp.id = s)
    
    
    
    pdf(w=26,h=26)
    library(gplots)
    
    m = ibs$ibs
    rownames(m) = pop[ ibs$sample.id]
    
    sel = which(rownames(m) == "CHS")
    m = m[ sel,sel]
    
    median(m)
    n=dim(m)[1]
    m[cbind(1:n,1:n)] = median(m)
    m[1:3,1:3]
    hist(m,n=200)
    
    heatmap.2(m,trace="none", col=colorPal(n=300))
    heatmap.2(m,trace="none", col=colorPal(n=300) , 
              breaks = seq(quantile(m,p=0.2) , quantile(m,p=0.8) , l =301)
              
              )
    
    
    #heatmap.2(m,trace="none",breaks=seq(0.905,0.93,l=100) , col=heat.colors(99) )
    m2 = cor(m)
   # m2[cbind(1:n,1:n)] = median(m2)
    hist(m2,n=200)
    
    q1 = quantile(m2,p=0.1)
    q2 = quantile(m2,p=0.9)
    
    heatmap.2(m2 ,trace="none", col=( colorPal(n=1500) ) )# , breaks=seq(-0.5,0.5,l=1501))
    heatmap.2(m2 ,trace="none", col=( colorPal(n=1500) ) , breaks=seq(q1,q2,l=1501))
    q1 = quantile(m2,p=0.3)
    heatmap.2(m2 ,trace="none", col=rev( colorPal("Oranges",n=1500) ) , breaks=seq(min(m2),q1,l=1501))
    q2 = quantile(m2,p=0.7)
    heatmap.2(m2 ,trace="none", col=( colorPal("Oranges",n=1500) ) , breaks=seq(q2,max(m2),l=1501))
    
    dev.off();
    
    
    ibd=snpgdsIBDMoM(genofile,snp.id=sample(1:50000,20000))
    str(ibd)
    
    
    heatmap.2(cor(ibd$k0),trace="n", col=heat.colors(200))
    image(ibd$k1)
    
}

