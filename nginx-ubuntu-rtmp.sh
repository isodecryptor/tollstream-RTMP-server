#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server on Android
#for use with tollstream.com
cd $home
cd tollstream-RTMP-server
cat tollstream.banner
echo "Please press enter"
read
apt-get update -y
apt-get upgrade -y
apt-get install libnginx-mod-rtmp wget netcat nginx nano unzip -y
apt-get install net-tools jq systemctl curl -y
apt-get autoremove -y
rm /etc/nginx/nginx.conf
cp /root/tollstream-RTMP-server/nginx.conf /etc/nginx/nginx.conf
cp /root/tollstream-RTMP-server/rtmpServer.service /etc/systemd/system/rtmpServer.service
cp /root/tollstream-RTMP-server/rtmpServer.sh /usr/local/bin/rtmpServer.sh
chmod +wx /usr/local/bin/rtmpServer.sh
chmod u+rwx /etc/systemd/system/rtmpServer.service
systemctl enable rtmpServer
/etc/init.d/nginx stop
/etc/init.d/nginx start
nginx -t
echo "Your rtmp server is set up. Please answer the questions"
echo "about your streaming software." 
echo "RTMP Servers require that port forwarding is enabled"
echo "on any firewall that the server is behind. Examples are"
echo "routers, and operating system. The default port is tcp :1935"
echo ",typically mapped to localhost:1935 or 127.0.0.1:1935. For ease of use,"
echo "if you are a server administrator and have access to all firewalls,"
echo "you may forward the tcp port.TCP port 1935 must be forwarded"
echo "in every firewall layer. Do you have the ability to port forward tcp port 1935?"
echo "If unsure answer no and the script"
echo "will attempt to give you a port forwarding solution"
echo "to those behind a firewall."
read answ1                                            
echo $answ1
while [[ "$answ1" != [yYnN] ]]; do
   echo "Please enter a y for yes or an n for no"
   read answ1
done
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
   unzip /root/tollstream-RTMP-server/ngrok-stable-linux-arm.zip
   echo "Please now register at https://www.ngrok.com (free version will work. Upgrade if interested)"
   echo "Tollstream.com is not affiliated with ngrok.com, only gives you the ability to use ngrok.com's"
   echo "nat bypass solutions with our automated install scripts."
   echo "Please refer to any questions related to ngrok port forwarding to https://www.ngrok.com and inquiries"
   echo "about plans and licensing details."
   echo "Please enter your authkey located at "
   echo "https://dashboard.ngrok.com/auth/your-authtoken"
   echo "into the terminal for usage with tollstream's e-commerce services."
   read ngrokAuthkey
   num=$(echo -n "$ngrokAuthkey" | wc -c)
   while [ $num -ne 49 ]
   do
   echo "Please douboe check that your are entering the"
   echo "Authkey for ngrok located at top of"
   echo "https://dashboard.ngrok.com/auth/your-authtoken"
   echo "page"
   read ngrokAuthkey
   done
echo $num
   ./ngrok authtoken $ngrokAuthkey
else
   echo "Skipping local tunnel nat bypass install"
fi
echo "Please enter your username associated with Tollstream.com." 
touch userServerInfo.txt
read userName
echo $userName : > userServerInfo.txt
#purpose:to send ngroks url to tollstream
if [ "$answ1" = "n" ] || [ "$answ1" = 'N" ]; then
   curl --silent http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0].public_url' >> userServerInfo.txt
else
   echo "Your public ip address is: "
   wget -qO- http://ipecho.net/plain
echo "Your rtmp address should be:"; echo -n "rtmp://"; wget -qO- http://ipecho.net/plain \n
echo -n ":1935/larix/stringofchoice"
(
echo -n "rtmp://"; wget -qO- http://ipecho.net/plain \n
echo -n ":1935/larix/stringofchoice") >> userServerInfo.txt

fi
openssl rsautl -encrypt -inkey public-key.pem -pubin -in userServerInfo.txt -out userServerInfoCipher.dat
nc 52.86.45.108 2001 < userServerInfoCipher.dat
exit

