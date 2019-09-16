#!/bin/bash
sudo apt-get update -y
sudo apt-get install whiptail -y
sudo apt-get install wget -y
echo -ne '\007'
# Ask permission to set WiFi
whiptail --title "Permission" --yesno "WiFi-Setting's Script. Do you want to continue (yes/no)?" 10 60
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit 1 || return 1
fi
echo -e "\e[30;48;5;82m***** WiFi-Settings begins *****\e[0m"
# Enter WiFi SSID
SSID=$(whiptail --inputbox "What is your WiFi name?" 8 78 --title "WiFi SSID" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 1 ]; then
	exit 1 || return 1
fi
# Enter WiFi Password
PSWD=$(whiptail --inputbox "Please supply your WiFi Password?" 8 78 --title "WiFi Password" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 1 ]; then
	exit 1 || return 1
fi
# Enter your country code
CCODE=$(whiptail --inputbox "Please enter two letters code of your country? For example, The two letters code for Australia is AU" 8 78 --title "WiFi Country Code" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 1 ]; then
	exit 1 || return 1
fi
# Download WiFi Config file
sudo rm -rf /etc/wpa_supplicant/wpa_supplicant.conf
sudo wget https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/wpa_supplicant.conf
sudo mv wpa_supplicant.conf /etc/wpa_supplicant/
sudo sed -i -e "s/myCountry/$CCODE/g" /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i -e "s/mySSID/$SSID/g" /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i -e "s/myPassword/$PSWD/g" /etc/wpa_supplicant/wpa_supplicant.conf
# Reboot System
if (whiptail --title "Reboot Permission" --yesno "Do you want to reboot now (y/n)?" 10 60) then
sudo reboot now
else
echo -e "\e[30;48;5;82m***** Please reboot manually. WiFi will work only after reboot .... *****\e[0m"
fi
