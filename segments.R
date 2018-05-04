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

