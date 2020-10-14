#Author:Donald Bilton
#
#Date: 10/07/2020
#PURPOSE: To install an nginx rtmp server
#for use with tollstream.com
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install libnginx-mod-rtmp nginx-full -y
sudo apt-get autoremove -y
sudo mv nginx.conf /etc/nginx/nginx.conf
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx start
sudo nginx -t
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
  sudo apt install npm
  sudo npm install -g localtunnel
else
   echo "Skipping local tunnel nat bypass install"
fi
exit
