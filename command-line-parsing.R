
library(stringr)

parseCommandArgs = function(args) {
  
    q = strsplit(args," +")[[1]]
    l = lapply(q, function(x) strsplit(x,"=")[[1]])
    
    opts = list()
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
 
  n = length(l2)
  
  for(i in names(defaultArgs) ) {
    
    if(is.null(l1[[i]])) l1[[i]] = defaultArgs[[i]]
    
  }
  
  l1
}




# Example 

z=parseCommandArgs("t=5,4x,5 nibd=10x ngenes")
z=mergeArgs(z,list(ncpus=3))

print(z)

