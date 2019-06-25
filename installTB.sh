#!/bin/bash
START=$(date +%s)
bold=$(tput bold)
normal=$(tput sgr0)
whiptail --title "Permission" --yesno "This script will install ThingsBoard IOT platform on Raspberry-Pi B+. Do you want to continue (yes/no)?" 10 60
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit 1 || return 1
fi
echo -e "\e[31;43m***** Welcome. Automatic Installation Begins *****\e[0m"
echo -e "\e[31;43m*** Current Date and Time : $now ***\e[0m"
sudo apt-get update -y
sudo apt-get install whiptail -y
sudo apt-get install dialog -y
sudo apt-get install wget -y
sudo apt-get install unzip -y
sudo apt-get install curl -y
sudo apt-get install oracle-java8-jdk -y
echo -ne '\007'
now=$(date)
echo -e "\e[31;43m*** Downloading Latest ThingsBoard Package ***\e[0m"
URL=$(curl -s https://api.github.com/repos/thingsboard/thingsboard/releases/latest | grep browser_download_url.*deb | cut -d '"' -f 4)
sleep 10
wget "$URL" 2>&1 |\
stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
dialog --gauge "Downloading Thingsboard Platform" 10 100
echo -ne '\007'
thingsboard="$(find . -name "*.deb")"
echo -e "\e[31;43m*** Installing ThingsBoard as a service ***\e[0m"
sudo dpkg -i $thingsboard
sudo /usr/share/thingsboard/bin/install/install.sh --loadDemo
echo -e "\e[31;43m*** Restrict ThingsBoard to 256MB of memory usage ***\e[0m"
echo 'export JAVA_OPTS="$JAVA_OPTS -Dplatform=rpi -Xms256M -Xmx256M"' >> /etc/thingsboard/conf/thingsboard.conf
echo -e "\e[31;43m***** Starting Thingsboard as a Service *****\e[0m"
sudo service thingsboard start
echo -e "\e[31;43m*** Finding IP address of the Thingsboard IOT Platform ***\e[0m"
ipv4=$(curl ifconfig.co)
ipv41=$(hostname -I)
echo -e "\e[31;43m***** How to access dashboard? *****\e[0m"
echo "ThingsBoard platform can be accessed using the following links, try them to see which one works. Please note down these links as you will need them later on."
echo -e "\e[4mhttp://$ipv4:8080/login\e[0m"
echo -e "\e[4mhttp://$ipv41:8080/login\e[0m"
echo -e "\e[31;43m***** All Done! *****\e[0m"
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to complete this installation process."
if (whiptail --title "Reboot Permission" --yesno "Do you want to reboot now (y/n)?" 10 60) then
sudo reboot now
else
echo "Please reboot otherwise Thingsboard platform will not start ...."
fi
