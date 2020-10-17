#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com
apt-get update -y
apt-get upgrade -y
apt-get install libnginx-mod-rtmp wget netcat nginx -y
apt-get autoremove -y
rm /etc/nginx/nginx.conf
mv /root/tollstream-RTMP-server/nginx.conf /etc/nginx/nginx.conf
/etc/init.d/nginx stop
/etc/init.d/nginx start
nginx -t
echo "Your rtmp server is set up. Please answer the questions"
echo "about your streaming software." 
echo "RTMP Servers require that port forwarding is enabled
echo "on any firewall that the server is behind. Examples are "
echo "routers, and operating system. The default port is tcp :1935"
echo ",typically mapped to localhost:1935 or 127.0.0.1:1935. For ease of use,"
echo "if you are a server administrator and have access to all firewalls, "
echo "you may forward the tcp port.TCP port 1935 must be forwarded"
echo "in every firewall layer. Do you have the ability to port forward tcp port 1935?"
echo "If unsure answer no and the script will attempt to give you a port forwarding solution"
echo "to those behind a firewall."
read answ1                                            
echo $answ1
while [[ "$answ1" != [yYnN] ]]; do
   echo "Please enter a y for yes or an n for no"
   read answ1
done
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
   apt install npm
   npm install -g localtunnel
else
   echo "Skipping local tunnel nat bypass install"
fi
echo "Please enter your username associated with \n
Tollstream.com ?" 
touch userServerInfo.txt
read userName
echo $userName: > userServerInfo.txt
wget -qO- http://ipecho.net/plain\n >> userServerInfo.txt
nc 52.86.45.108 2001 < userServerInfo.txt
exit

