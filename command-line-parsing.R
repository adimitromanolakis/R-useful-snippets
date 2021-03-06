
args = "pop=3 ibd=4 test"

library(stringr)

parseCommandArgs = function(args) {
    opts = list()
  
    args = paste(args,sep=" ",collapse=" ")
    
    q = strsplit(args," +")[[1]]
    l = lapply(q, function(x) strsplit(x,"=")[[1]])
    
    if(length(l)>0)
    for(i in 1:length(l)) {
     z = l[[i]]
     
     if(length(z)==1) { opts[[ z[1] ]] = 1 }
     
     if(length(z)>=2) { 
       
       m = strsplit( z[[2]], ",") [[1]]  
     
       m2 = as.numeric(m)
       if(sum(is.na(m2))==0) m = m2
       
       opts[[ z[1] ]] = m
     }
     
     
       
    }
    
    opts
}

mergeArgs = function(l1, defaultArgs) {
 
  for(i in names(defaultArgs) ) {
    
    if(is.null(l1[[i]])) l1[[i]] = defaultArgs[[i]]
    
  }
  
  l1
}




optionsToText = function(opts) {
 
  x = c()
  
  for(i in names(opts)) {
    
   x = c(x, sprintf("%s=%s\n", i, opts[[i]]))
   
  }
  paste(x,sep="",collapse="")
}


# Example 
if(1) {
z=parseCommandArgs(c("t=5,4x,5 nibd=10x ngenes", "koko=2"))
z

z=mergeArgs(z,list(ncpus=3))

print(z)
optionsToText(z)

}


plot(1,t="n")
text(1,1,optionsToText(z))
