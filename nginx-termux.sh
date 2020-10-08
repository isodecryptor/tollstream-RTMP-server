#$BASH

#Author:Donald Bilton
#
#Date: 10/07/2020

#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com

termux-wake-lock

termux-setup-storage

cd /data/data/com.termux/files/home

pkg update -y && pkg install curl proot tar -y && curl https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Installer/Ubuntu/ubuntu.sh | bash

pkg upgrade

apt-get install man git wget -y

echo 'command+=" -b /data/data/com.termux/files/home:/root"' | tee -a start-ubuntu.sh

echo 'command+=" -b /sdcard"' | tee -a  start-ubuntu.sh

apt-get autoremove

chmod +wrx nginx-ubuntu-rtmp2.sh

cp nginx-ubuntu-rtmp2.sh /data/data/com.termux/files/home/ubuntu-fs/home

./start-ubuntu.sh

exit



