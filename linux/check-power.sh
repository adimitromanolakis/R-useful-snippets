
echo brightness:
cat /sys/devices/pci0000:00/0000:00:08.1/0000:04:00.0/backlight/amdgpu_bl0/brightness
grep "" /sys/devices/pci0000:00/0000:00:08.1/0000:04:00.0/drm/card1/card1-eDP-1/amdgpu_bl1/brigh*



echo
echo

F=`find /sys -name power_now`

while true; do cat $F; sleep 1.5; done

