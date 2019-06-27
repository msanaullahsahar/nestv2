#!/bin/bash
sudo mkdir /home/pi/motion
sudo chmod 755 /home/pi/motion
sudo wget “http://download.installPiCam.sh”
sudo chmod 7555 installPiCam.sh
sudo ./ installpicam.sh
sudo wget “https://download.countPics.py”
sudo wget “https://download.countPics.sh”
sudo wget “https://download.clearPics.py”
sudo wget “https://download.cam.sh”
sudo chmod 755 countPics.py clearPics.py countPics.sh cam.sh 

echo '*/5 * * * * sudo python /root/clearPics.py' >> /var/spool/cron/crontabs/root
echo '@reboot ( sleep 2 ;sh /root/countPics.sh )' >> /var/spool/cron/crontabs/root
echo '@reboot ( sleep 10 ;sh /root/cam.sh )' >> /var/spool/cron/crontabs/root
