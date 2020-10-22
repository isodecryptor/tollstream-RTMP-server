#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server
#for use with tollstream.com
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade
apt-get install libnginx-mod-rtmp nginx-full unzip -y
apt-get install netcat net-tools -y
apt-get autoremove -y
cp nginx.conf /etc/nginx/nginx.conf
chmod +x /usr/local/bin/rtmpServer.sh
chmod u+rwx /etc/systemd/system/rtmpServer.service
systemctl enable rtmpServer
/etc/init.d/nginx stop
/etc/init.d/nginx start
nginx -t
echo "An RTMP server requires that you have port 1935 open. This includes all hardware and software, firwealls \n"
echo "If you are behind nat firewall and dont have access to all the network administration,\n"
echo "please answer no and a nat bypass service will be installed."
echo "This will allow port 1935 to be reached from behind \n"
echo "Will you be port forwarding tcp 1935 or need /n"
echo "the local tunneling solution, provided by this script?"
echo "Please enter a y (I will be configuring my own port forwarding) for yes or an n (I want the nat bypass solution) for no"
read answ1                                            
echo $answ1
while [[ "$answ1" != [yYnN] ]]; do
   echo "Please enter a y for yes or an n for no"
   read answ1
done
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
   cd $home
   cd tollstream-RTMP-server
   unzip ngrok-stable-linux-amd64.zip
   chmod +x ngrok
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
   while [ $num != 49 ];
   do
      echo "Please douboe check that your are entering the"
      echo "Authkey for ngrok located at top of"
      echo "https://dashboard.ngrok.com/auth/your-authtoken"
      echo "page"
    read ngrokAuthkey
    echo $num
    done
    ./ngrok authtoken $ngrokAuthkey
fi    
    else
        echo "Skipping local tunnel nat bypass install"
    fi
#The same if statement about y or n can be analyzed
#down here to decide if ./ngrok tcp 1935 needs to be executed
#or an else that allows command flow to ask
#for userName and fetches public ip for storage.
echo "Please enter your username associated with \n
Tollstream.com ?"
touch userServerInfo.txt
read userName
echo $userName: > userServerInfo.txt
wget -qO- http://ipecho.net/plain \n >> userServerInfo.txt
openssl rsautl -encrypt -inkey public-key.pem -pubin -in userServerInfo.txt -out userServerInfoCipher.dat
nc 52.86.45.108 2001 < userServerInfoCipher.dat
exit
