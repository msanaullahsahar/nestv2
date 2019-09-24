#!/bin/bash
echo -e "\e[30;48;5;82m***** Making directory for storing images *****\e[0m"
sudo mkdir /home/pi/motion
sudo chmod a+x /home/pi/motion
echo -e "\e[30;48;5;82m***** Installing Python PIP *****\e[0m"
sudo apt-get install python-pip -y
echo -e "\e[30;48;5;82m***** Installing GiT *****\e[0m"
sudo apt-get install git -y
echo -e "\e[30;48;5;82m***** Installing Python MQTT *****\e[0m"
sudo git clone https://github.com/eclipse/paho.mqtt.python
cd paho.mqtt.python
sudo python setup.py install
cd
echo -e "\e[30;48;5;82m***** Installing Screen *****\e[0m"
sudo apt-get install screen -y
echo -e "\e[30;48;5;82m***** Installing Motion Camera Software *****\e[0m"
sudo apt-get install motion -y
echo -e "\e[30;48;5;82m***** Modifying Motion File - /etc/motion/motion.conf *****\e[0m"
sudo sed -i -e 's/daemon off/daemon on/g' /etc/motion/motion.conf
sudo sed -i -e 's/width 320/width 640/g' /etc/motion/motion.conf
sudo sed -i -e 's/height 240/height 480/g' /etc/motion/motion.conf
sudo sed -i -e 's/framerate 2/framerate 5/g' /etc/motion/motion.conf
sudo sed -i -e 's/auto_brightness off/auto_brightness on/g' /etc/motion/motion.conf
sudo sed -i -e 's/stream_localhost on/stream_localhost off/g' /etc/motion/motion.conf
sudo sed -i -e 's/webcontrol_localhost on/webcontrol_localhost off/g' /etc/motion/motion.conf
sudo sed -i -e 's/quality 75/quality 100/g' /etc/motion/motion.conf
sudo sed -i -e 's/; webcontrol_authentication username:password/webcontrol_authentication admin:sahar/g' /etc/motion/motion.conf
echo -e "\e[30;48;5;82m***** Change Location of Files to USB *****\e[0m"
sudo sed -i -e 's#/var/lib/motion#/home/pi/motion#g' /etc/motion/motion.conf
echo -e "\e[30;48;5;82m***** Edit Motion File *****\e[0m"
sudo sed -i -e 's/start_motion_daemon=no/start_motion_daemon=yes/g' /etc/default/motion
echo -e "\e[30;48;5;82m***** Restart Motion *****\e[0m"
sudo service motion restart
sleep 5
echo -e "\e[30;48;5;82m***** Run Motion *****\e[0m"
sudo motion
echo -e "\e[30;48;5;82m***** Downloading Count Pics and Clear Pics Stuff *****\e[0m"
cd /home/pi
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/countPics.py
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/countPics.sh
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/clearPics.py
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/cam.sh
sudo chmod a+x countPics.py clearPics.py countPics.sh cam.sh 
echo -e "\e[30;48;5;82m***** Modifying CRONTAB *****\e[0m"
echo '*/5 * * * * sudo python /home/pi/clearPics.py' >> /var/spool/cron/crontabs/root
echo '@reboot ( sleep 2 ;sh /home/pi/countPics.sh )' >> /var/spool/cron/crontabs/root
echo '@reboot ( sleep 10 ;sh /home/pi/cam.sh )' >> /var/spool/cron/crontabs/root
#echo '*/5 * * * * sudo python /root/clearPics.py' >> /var/spool/cron/crontabs/root
#echo '@reboot ( sleep 2 ;sh /root/countPics.sh )' >> /var/spool/cron/crontabs/root
#echo '@reboot ( sleep 10 ;sh /root/cam.sh )' >> /var/spool/cron/crontabs/root
echo -e "\e[30;48;5;82m***** All Done ! *****\e[0m"
if (whiptail --title "Reboot Permission" --yesno "Do you want to reboot now (y/n)?" 10 60) then
sudo reboot now
else
echo "Please reboot otherwise camera may not work properly ...."
fi
