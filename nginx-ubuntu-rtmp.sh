#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com
apt-get update 
apt-get upgrade
apt-get install libnginx-mod-rtmp ufw git nginx
sudo apt-get autoremove
sudo rm /etc/nginx/nginx.conf
mv /root/tollstream-RTMP-server/nginx.conf /etc/nginx/nginx.conf
exit



