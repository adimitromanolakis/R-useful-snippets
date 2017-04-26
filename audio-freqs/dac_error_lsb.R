
square = function(f) {
    
    l1 = sin(2*pi *  f  *  time)
    
    l1 = l1 > 0
    l1 = 2*l1 - 1
    
}

tone = function(f, phase) {
    sin(2*pi*f*time + phase) 
}


library(signal)
library(fftw)


plotSpectrum = function(l2, f1 = NA, lim = -100) {
    
    l2 = l2*blackman(length(l2))
    
    ft = abs(FFT(c(l2 ) ) )
    #ft = ft/max(ft)
    
    n = length(ft)
    freq= seq(0,fs, l=n)
    ft = ft[1:(n/2)]
    freq = freq[1:(n/2)]
    
    ft = 20*log10( abs(ft) )
    ft[ft< lim] = lim
    plot(freq,ft,t="l",log="x",xlim=c(30,fs/2),ylim=c(lim-3,40))
    grid()
    lines(freq,ft,t="l")
    if(!is.na(f1)) abline(v=(1:10)*f1,lty=2,col=rgb(0,0,1,0.2))
}


resbits = 16
maxcode = 2**resbits - 1
#maxcode





codes = lapply(1:resbits, function(i) {
    
s = seq(0,maxcode)
y = 2**i

0 + ( s %% y  >= (y/2) )

})


bits = do.call(cbind,codes)


if(0) {
bit0 = seq(0,maxcode) %% 2
bit1 = 0 + ( seq(0,maxcode) %% 4 >= 2 )
bit2 = 0 + ( seq(0,maxcode) %% 8 >= 4 )
bit3 = 0 + ( seq(0,maxcode) %% 16 >= 8 )
bit4 = 0 + ( seq(0,maxcode) %% 32 >= 16 )

bits = as.matrix( cbind(bit0,bit1,bit2,bit3,bit4))

}



#bits



vref_ideal = rev ( 1 / 2**(seq(1,resbits)) )





vref = vref_ideal
vref_ideal * 1024




lsb1 = 2**(- resbits)

#vref = vref * runif(resbits, 0.99, 1.01) 

vref = vref  +  runif( resbits , -lsb1,lsb1)*1



#vref[1] = vref[1]*1.2
#vref[2] = vref[2]*0.95

out = ( bits %*% vref ) [,1]

out_ideal = ( bits %*% vref_ideal ) [,1]


out_code = ( bits %*% 2**seq(0,resbits-1) ) [,1] 
#plot(diff(out_code),t="l")

range(diff(2**resbits*out_ideal) )
range(diff(2**resbits*out) )
range(out-out_ideal) / min(vref_ideal)



error_lsb = (out-out_ideal) / min(vref_ideal)
if(1) {
plot(diff(error_lsb),t="l", lwd=0.2)
#plot(error_lsb,t="l",lwd=0.2)
}

####
####




fs=28e3
dt=1/fs

maxtime=9.4
maxtime=1
time = seq(0,maxtime,by=dt)



square = function(f) {
    
    l1 = sin(2*pi *  f  *  time)
    
    l1 = l1 > 0
    l1 = 2*l1 - 1
    
}

tone = function(f, phase) {
    sin(2*pi*f*time + phase) 
}



f1 = 80



x = 0.001*tone(f1,0) #+ tone(503,0)
x = 0.001*tone(f1,0) + 0.001*tone(221.5,0)

x = (1+x)/2
orig = x

range(x)


x = 1 + 4096*x




x = floor(x)
range(x)
x[1:200]

x2 = out[x]
x3 = out_ideal[x]


scale = 4096 / maxcode
n = length(orig)




range(x3)
range(x2)
range(x4)

#plot(unique(x4-x2))

plotSpectrum(0.1*x3,f1,-140)

plotSpectrum(0.1*x2,f1,-140)



NOISE = runif(length(x), 0,0.1)*4

NOISE = filter(butter(7,0.55,"high"),NOISE)
NOISE = filter(butter(7,0.55,"high"),NOISE)

plotSpectrum(NOISE)

#NOISE = rnorm(length(x), 0, 0.1)*1
range(round( x + 450 + NOISE*4 ))
x3n = out_ideal[round( x + 450 + NOISE*0.4 )] 
#plotSpectrum(x3n)



B = (orig+1e-2+NOISE/555) * scale 
range(B)

err = 0;

x4=0*B

library(compiler)
enableJIT(3)

f = function() {
    err=0
    x4 = 0*B;
    for(i in 1:n) {
        target = B[i] #- err
        ind = which.min(abs(target-out))
        
        
        #ind = ind + round(runif(1,-1,1))
        #if(ind<1) ind = 1
        
        err = out[ind] - target
      # err = 1.2*err;
        x4[i] = out[ind]
        
    }
    x4
}

x4 = f()
    

if(0) x4 = sapply(1:n, function(i) {
    
    target = B[i] 
    ind = which.min(abs(target-out))
    
    
    #ind = ind + round(runif(1,-1,1))
    #if(ind<1) ind = 1

    
    out[ind]
})

plotSpectrum(0.1*x4,f1,-140)






library(signal)
library(fftw)


plotSpectrum = function(l2, f1 = NA) {
            
        l2 = l2*blackman(length(l2))
        
        ft = abs(FFT(c(l2 ) ) )
        #ft = ft/max(ft)
        
        n = length(ft)
        freq= seq(0,fs, l=n)
        ft = ft[1:(n/2)]
        freq = freq[1:(n/2)]
        
        ft = 20*log10( abs(ft) )
        ft[ft< -100] = -100
        plot(freq,ft,t="l",log="x",xlim=c(30,fs/2),ylim=c(-104,40))
        grid()
        lines(freq,ft,t="l")
        if(!is.na(f1)) abline(v=(1:10)*f1,lty=2,col=rgb(0,0,1,0.2))
}



m = x2 - mean(x2)
m2 = x4 - mean(x4)
mean(m^2)/mean(m2^2)
thdn  = max(abs(m-m2)) / max(m)
cat("Dist = ", thdn, "\n")


m = x2 - mean(x2)
m2 = x3 - mean(x3)
mean(m^2)/mean(m2^2)
thdn  = max(abs(m-m2)) / max(m)
cat("Dist = ", thdn, "\n")
