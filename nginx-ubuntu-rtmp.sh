#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com
apt-get update -y
apt-get upgrade -y
apt-get install libnginx-mod-rtmp nginx -y
apt-get autoremove -y
rm /etc/nginx/nginx.conf
mv /root/tollstream-RTMP-server/nginx.conf /etc/nginx/nginx.conf
echo nginx -t
exit



