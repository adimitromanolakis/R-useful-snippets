
genofile <- snpgdsOpen("../exome/test.gds")
 

colorPal = function(pal = "RdYlBu", n=300) {
  
  library(RColorBrewer)
  
  #  c1 = colorRampPalette(brewer.pal(300,"Blues"))
   #  c1 = colorRampPalette(brewer.pal(300,"YlOrRd"))
  c1 = colorRampPalette(brewer.pal(n,pal))
  
  c1(n)

}







makeClusterMatrix = function(a, values, diagonal = 0) {
    
    
    a$IID1 = as.character(a$IID1)
    a$IID2 = as.character(a$IID2)

    n = unique(c(a$IID1,a$IID2))
    m = matrix(1,nrow=length(n),ncol=length(n))

    colnames(m) = n
    rownames(m) = n
    
    m[ cbind(a$IID1,a$IID2) ] = values
    m[ cbind(a$IID2,a$IID1) ] = values
    
    m[ cbind(n,n) ] =   diagonal
    
    
    m
}


library(gplots)
library(RColorBrewer)
library(cluster)


niceClusterPlot = function(m , q1 = NA ,  pal = NA,  reverse = 0,  sep = NA, plotTitle = "") {
    
    if(is.na(q1)) q1 = quantile(m,p=c(0.05,0.995))
    
    br1 = seq(q1[1],q1[2],l=601)
    
    #c1  = rev ( heat.colors(300) ) 
    
    
    
    
    if(is.na(pal)) pal = "RdBu"
    
    
    if(length(pal) == 1) {
            pal = brewer.pal(1300, pal)
           # pal = pal[ 1:( length(pal)-1) ]
           # pal = pal[ (1+1):length(pal) ]
            c1 = colorRampPalette(pal)
            
            c1 = c1(600)
    } else {
            c1 = pal
    }
    
    if(reverse) c1 = rev(c1)
    
    #c1 = (heat.colors(300))
    
    
   # t=dist(m)
    #str(t)
    
    
    
    heatmap.2(m,trace="n",
              main=plotTitle,
              col = c1,breaks=br1,
              colsep=sep,
              rowsep=sep,
              sepwidth=c(0.02,0.02),
              sepcolor=rgb(0.8,0.8,0.8),
              #hclustfun=agnes,
              distfun=function(x) (dist(x,method="manh") )
                                            
    )
              
    
    
    
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

