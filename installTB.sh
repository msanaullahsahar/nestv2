#!/bin/bash
START=$(date +%s)
clear
whiptail --title "Permission" --yesno "This script will install ThingsBoard IoT platform on Raspberry-Pi. Do you want to continue (yes/no)?" 10 60
exitstatus=$?
if [ $exitstatus = 1 ]; then
exit 1 || return 1
fi
echo -e "\e[30;48;5;82m***** Welcome. Automatic Installation Begins *****\e[0m"
sudo apt-get update -y
sudo apt-get install whiptail -y
sudo apt-get install dialog -y
sudo apt-get install wget -y
sudo apt-get install unzip -y
sudo apt-get install curl -y
sudo apt-get install default-jdk -y
echo -ne '\007'
clear
echo -e "\e[31;43m*** Downloading Latest ThingsBoard Package ***\e[0m"
URL=$(curl -s https://api.github.com/repos/thingsboard/thingsboard/releases/latest | grep browser_download_url.*deb | cut -d '"' -f 4)
sleep 5
wget "$URL" 2>&1 |\
stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
dialog --gauge "Downloading Thingsboard Platform. The downloading process may take some minutes depending on the speed of your internet." 10 100
thingsboard="$(find . -name "*.deb")"
echo -ne '\007'
echo -e "\e[30;48;5;82m*** Making ThingsBoard Platform Ready for Installation***\e[0m"
sudo dpkg -i $thingsboard
echo -e "\e[30;48;5;82m*** Installing PostgreSQL ***\e[0m"
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo service postgresql start
su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password 'post24984';\""
sudo -u postgres psql -c 'create database thingsboard;'
echo -e "\e[30;48;5;82m*** Changing Port ***\e[0m"
sudo sed -i -e 's/${HTTP_BIND_PORT:8080}/${HTTP_BIND_PORT:8070}/g' /etc/thingsboard/conf/thingsboard.yml
echo -e "\e[30;48;5;82m*** Restrict ThingsBoard to 512MB of memory usage ***\e[0m"
echo 'export JAVA_OPTS="$JAVA_OPTS -Dplatform=rpi -Xms512M -Xmx512M"' >> /etc/thingsboard/conf/thingsboard.conf
echo -e "\e[30;48;5;82m*** Configuring database for Thingsboard ***\e[0m"
echo '# DB Configuration' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export DATABASE_ENTITIES_TYPE=sql' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export DATABASE_TS_TYPE=sql' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.PostgreSQLDialect' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export SPRING_DRIVER_CLASS_NAME=org.postgresql.Driver' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/thingsboard' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export SPRING_DATASOURCE_USERNAME=postgres' >> /etc/thingsboard/conf/thingsboard.conf
echo 'export SPRING_DATASOURCE_PASSWORD=post24984' >> /etc/thingsboard/conf/thingsboard.conf
echo -e "\e[30;48;5;82m*** Installing ThingsBoard Platform ***\e[0m"
sudo /usr/share/thingsboard/bin/install/install.sh --loadDemo
echo -e "\e[30;48;5;82m***** Starting Thingsboard as a Service *****\e[0m"
sudo systemctl enable thingsboard
sudo systemctl start thingsboard
#sudo service thingsboard start
#echo -e "\e[30;48;5;82m*** Finding IP address of the Thingsboard IOT Platform ***\e[0m"
#ipv4=$(curl ifconfig.co)
#ipv41=$(hostname -I)
echo
echo -e "\e[30;48;5;82m Installing Proxy Server\e[0m"
sudo apt install nginx -y
wget "https://raw.githubusercontent.com/msanaullahsahar/nestv2/master/thingsboard.conf"
sudo mv thingsboard.conf /etc/nginx/conf.d/thingsboard.conf
sudo systemctl restart nginx
echo
clear
echo -e "\e[30;48;5;82m ***** How to access dashboard? *****\e[0m"
echo -e "\e[30;48;5;82m ThingsBoard platform can be accessed by using the following link.\e[0m"
#echo -e "\e[30;48;5;82m http://$ipv4:8080/login\e[0m"
#echo -e "\e[30;48;5;82m http://$ipv41:8080/login\e[0m"
echo -e "\e[30;48;5;82m http://raspberrypi/login\e[0m"
echo -e "\e[30;48;5;82m***** All Done! *****\e[0m"t
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to complete this installaion process."
if (whiptail --title "Reboot Permission" --yesno "Do you want to reboot now (y/n)?" 10 60) then
sudo reboot now
else
echo "Please reboot manually otherwise Thingsboard IoT platform may not start properly ...."
fi