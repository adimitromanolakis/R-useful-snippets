

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


