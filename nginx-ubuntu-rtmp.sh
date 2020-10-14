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
nginx -t
echo "Your rtmp server is set up. Please answer the questions
about your streaming software. \n"
echo "RTMP Servers require that port forwarding is enabled
on any firewall that the server is behind. Examples are \n
routers, and operating system. The default port is tcp :1935
,typically mapped to localhost:1935 or 127.0.0.1:1935. For ease of use,
if you are a server administrator and have access to all firewalls, 
you may forward the tcp port :1934(tcp port 1935 must be forwarded
in every firewall layer. Do you have the ability to port forward tcp port 1935?
If unsure answer no and the script will attempt to give you a port forwarding solution
to those behind a firewall."
read answ1                                            
echo $answ1
while [[ "$answ1" != [yYnN] ]]; do
   echo "Please enter a y for yes or an n for no"
   read answ1
done
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
  sudo apt install npm
  sudo npm install -g localtunnel
else
   echo "Skipping local tunnel nat bypass install"
fi
exit

