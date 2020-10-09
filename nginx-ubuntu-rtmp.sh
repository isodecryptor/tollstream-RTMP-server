#$BASH

#Author:Donald Bilton
#
#Date: 10/07/2020

#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com

apt-get update 

apt-get upgrade

apt-get install nginx

apt-get install libnginx-mod-rtmp ufw git

apt-get install sudo

sudo apt-get autoremove

cd $home

git clone https://github.com/isodecryptor/tollstream-RTMP-server

sudo rm /etc/nginx

mv /root/tollstream-RTMP-server/nginx.conf /etc/nginx/nginx.conf



exit



