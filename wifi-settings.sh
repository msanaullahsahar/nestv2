#!/bin/bash
sudo apt-get update -y
sudo apt-get install whiptail -y
sudo apt-get install wget -y
echo -ne '\007'
# Ask permission to set wifi
whiptail --title "Permission" --yesno "WiFi-Settings Script. Do you want to continue (yes/no)?" 10 60
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit 1 || return 1
fi
echo -e "\e[31;43m***** WiFi-Settings begins *****\e[0m"
# Enter SSID
while [[ -z "$SSID" ]]
do
  SSID=$(whiptail --inputbox "What is your WiFi name?" 8 78 --title "WiFi SSID" 3>&1 1>&2 2>&3)
  exitstatus=$?
	if [ $exitstatus = 1 ];then
	exit 1 || return 1
	fi
done
# Enter Password
while [[ -z "$PSWD" ]]
do
  PSWD=$(whiptail --inputbox "What is your WiFi name?" 8 78 --title "WiFi Password" 3>&1 1>&2 2>&3)
  exitstatus=$?
	if [ $exitstatus = 1 ];then
	exit 1 || return 1
	fi
done
# Download WiFi Config file
sudo rm -rf /etc/wpa_supplicant/wpa_supplicant.conf
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/wpa_supplicant.conf
sudo mv wpa_supplicant.conf /etc/wpa_supplicant/
sudo sed -i -e 's/mySSID/$SSID/g' /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i -e 's/myPassword/$PSWD/g' /etc/wpa_supplicant/wpa_supplicant.conf
# Reboot System
if (whiptail --title "Reboot Permission" --yesno "Do you want to reboot now (y/n)?" 10 60) then
sudo reboot now
else
echo "Please reboot manually ...."
fi
