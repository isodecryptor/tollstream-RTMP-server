#$BASH

#Author:Donald Bilton
#
#Date: 10/07/2020

#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com

termux-wake-lock

termux-setup-storage

pkg update -y 

pkg upgrade -y

apt-get autoremove

pkg install proot-distro

proot-distro install ubuntu

proot-distro login ubuntu

cd /data/data/com.termux/files/home/tollstream-RTMP-server

chmod +rwx nginx-ubuntu-rtmp2.sh

cp nginx-ubuntu-rtmp2.sh /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root
/nginx-ubuntu-rtmp2.sh
exit
