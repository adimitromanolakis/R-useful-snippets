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


















geneticMap = list()

for(i in 1:22) {
  fn = sprintf("/tmp/plink.chr%s.GRCh37.map",i)
  a = read.table(fn,as=T)
  a = a[,-2]
  print(i)
  geneticMap[[i]] = a
  
}

save(geneticMap,file="/tmp/geneticMap-grch37.rdata")


str(geneticMap)


load("~/MEGAsync/work/prest-ibs/truffle/data/geneticMap-grch37.rdata")






















seg$cm1 = NA
seg$cm2 = NA
seg$cmlen = NA


for(ch in 1:22) {

	print(ch)
	s = which(seg$CHROM == ch)

	m = geneticMap[[ch]]
	#m[1:100,]

	cm1 = approx(m$V4,m$V3,seg$POS[s]*1e6)$y
	cm2 = approx(m$V4,m$V3,(seg$POS[s]+seg$LEN[s])*1e6)$y
	cm2-cm1
	seg$cmlen[s] = cm2 - cm1
	seg$cm1[s] = cm1
	seg$cm2[s] = cm2

}













