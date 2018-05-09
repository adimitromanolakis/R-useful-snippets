library(RSQLite)
library(RMySQL)
library(RPostgreSQL)


uid = function(id1,id2) {
  id = paste(id1,id2,sep=" ")
  s = which(id1<id2)
  id[s] =  paste(id2,id1,sep=" ")[s]
  id
}



con <- dbConnect(RSQLite::SQLite(), "/media/apo/2TB//garbase.sqlite")
data.frame(dbListTables(con))
#dbDisconnect(con)

ped = dbReadTable(con,"ped")



population_of = function(id) {
  
  ped$Population[ base::match( sub(".*_","",id)  ,  ped$Individual.ID ) ]
  
}


ibd = dbReadTable(con,"ibd")
#ibd_bk = ibd
#ibd = ibd_bk

ibd$ID1 = sub(".*_","",ibd$ID1)
ibd$ID2 = sub(".*_","",ibd$ID2)
ibd$uid = uid(ibd$ID1  ,   ibd$ID2  )
ibd[1,]



ibd$pop1 =   population_of(ibd$ID1)
ibd$pop2 =   population_of(ibd$ID2)






proportionSharing = function(seg, chrom = 6, cc = c("CEU"), type = "IBD1", minLength = 1 , doPlot = 1 ) {
  
  seg = seg[   seg$CHROM  == chrom   ,]
  minpos = min(seg$POS)-0.5
  maxpos = max(seg$POS+seg$LENGTH)+0.5
  
  
  seg = seg[seg[,1]==  type ,]
  seg = seg [ seg$LENGTH > minLength,]

  seg$n = runif(nrow(seg),0,1)

  seg = seg[seg$pop1 %in% cc,]
  seg = seg[seg$pop2 %in% cc,]
  
  
  ibd2 = ibd[ 
    ibd$pop1 %in% cc & (ibd$pop2 %in% cc )
    ,]
  #table(ibd2$pop1,ibd2$pop2)
  
  ntot = nrow(ibd2)
  print(ntot)
  
  
  seg2 = seg
  
  POS = seg2$POS
  LEN = seg2$LENGTH
  
 
  f = function(l1) {
    #v = POS > l1 & POS < l1 + 3
    
    v = l1 > POS & l1 < POS+LEN 
    100*sum(v)/ntot
    
  }
  
  
  
  
  spos = seq(0,max(POS+LEN),by=0.1)
  
  spos = seq(minpos,maxpos,  by=0.1)
  
  y = sapply(spos,f)
  #str(y)
  if(doPlot) plot(spos,y,t="l")
  
  d = data.frame(chrom=chrom,pos=spos,prop=y)
  d
  
}



seg2 = dbReadTable(con,"seg")


proportionSharing(seg2,3,cc=c("JPT"),type="IBD1",minLength = 5)








