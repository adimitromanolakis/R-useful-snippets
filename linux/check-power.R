

cat("Brightness : ",
readLines("/sys/devices/pci0000:00/0000:00:08.1/0000:04:00.0/backlight/amdgpu_bl0/actual_brightness")
,"\n")


f = "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/PNP0C0A:00/power_supply/BAT1/power_now"

f = system("find /sys/devices 2>/dev/null|grep power_now ", intern=TRUE)
print(f)



while(1) {
x = readLines(f)
x = as.numeric(x)/1e6

ns = round(10*x)
ns = paste(rep("*",ns),collapse="")

cat(sprintf("%8.2f %s\n", x,ns))

Sys.sleep(4)

}
