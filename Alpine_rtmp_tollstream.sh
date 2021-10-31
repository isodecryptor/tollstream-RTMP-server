#!/bin/bash
#git pull test
#changes change test
#Author:Donald Bilton
# purpose to run a tiny os,alpine, to host
#an rtmp server using nginx for use with tollstream.com
#this install has been tested on android. Size for ll
#is 100MB after install. This is 1/6th the size of the install
#size for ubuntu and seems perfect for lightweight applications
#such as cell phones. This will also run on older androids
#Would like to run this inside of busy box for outdated androids

#startup script here
if [ -f "/home/tollstream-RTMP-server/Tollstreamstartup.sh" ]; then
   pkill ngrok
   screen -wipe
   reset
   echo "               🌍☄️ Welcome Back!☄️🌏"
   echo "               Press any key to continue"
   read
else
   touch /home/tollstream-RTMP-server/Tollstreamstartup.sh
   chmod +x /home/tollstream-RTMP-server/Tollstreamstartup.sh
   ( echo "#!/bin/bash"
    echo   "   cd /home/tollstream-RTMP-server"
    echo   "   reset"
    echo   "   echo ' Would you to check for updates for tollstream.coms server scripts and auto install?. Warning. If modifying ' "
    echo   "   echo ' files like nginx.conf or Alpine_rtmp_tollstream.sh, manually, you ' "
    echo   "   echo ' are advised to back up these custom configurations, as you will likely loose them. ' "
    echo   "   echo ' Manual remerging of personal configurations are required after updating, if ' "
    echo   "   echo ' these files have been, manually, modified. ' "
    echo   "   echo ' Otherwise, updating is recommended and new features will be listed as they are added. ' "
    echo   "   echo ' Please enter y for yes, update, or n for no, skip update check. ' "
    echo   "   read update "
    echo   '   while [[ "$update" != [yYnN] ]]; do '
    echo   "   echo ' Please answer y for yes or n for no. ' "
    echo   "   read update "
    echo   "   done "
    echo   '   if [ "$update" = "y" ] || [ "$update" = "Y" ]; then '
    echo   "      git config --global core.fileMode false; git stash; git pull "
    echo   "      chmod +x Alpine_rtmp_tollstream.sh "
    echo   "      ./Alpine_rtmp_tollstream.sh "
    echo   "   else "
    echo   "      cd /home/tollstream-RTMP-server "
    echo   "      ./Alpine_rtmp_tollstream.sh "
    echo   "   fi "
    echo   "exit" ) > /home/tollstream-RTMP-server/Tollstreamstartup.sh
    #Find the correct directory for prestart so no recursive loop starts inside bash.bashrc. Must call external bash shell script in bash.bashrc, otherwise,
    #infinite recursive loop will occur because of it continously calling bash or the author of termux is being a, secretive , douche and hiding some game. 
    touch /data/data/com.termux/files/home/prestart.sh
    chmod +x /data/data/com.termux/files/home/prestart.sh
    ( echo "#!/bin/bash"
    echo "pkill screen"
    echo "screen -d -m -S startup"
    echo 'screen -S startup -p 0 -X stuff "proot-distro login alpine^M" '  
    echo 'screen -S startup -p 0 -X stuff "cd /home/tollstream-RTMP-server^M" ' 
    echo 'screen -S startup -p 0 -X stuff "./Tollstreamstartup.sh^M" ' 
    echo "screen -r startup"
    echo "exit"
    ) > /data/data/com.termux/files/home/prestart.sh
    (
    echo "/data/data/com.termux/files/home/prestart.sh"
    echo "exit"
    ) >> /data/data/com.termux/files/usr/etc/profile
fi
#define variables here
streamKey=$(openssl rand -base64 36 | tr -d "=+/" | cut -c1-25)
name=$streamKey
#Define functions here
echo $name > /home/tollstream-RTMP-server/streamKey.save
#Main
apk add nginx nginx-mod-rtmp jq bash openssl curl
if [[ -f "/run/nginx" ]]; then
   echo "/run/nginx was created,already"
else
   mkdir /run/nginx
fi
cp nginx.conf /etc/nginx/nginx.conf
reset
chmod +x /home/tollstream-RTMP-server/Tollstream_animated_banner/tollstream_animated.banner
/home/tollstream-RTMP-server/Tollstream_animated_banner/tollstream_animated.banner
nginx
nginx -t
echo "Your rtmp server is set up. Please answer the questions"
echo "about your streaming software."
echo "RTMP Servers require that port florwarding is enabled"
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
   if [[ -f "ngrok" ]];
   then
      echo "This file exists on your filesystem."
   else
      reset
      wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
      tar -xvf /home/tollstream-RTMP-server/ngrok-stable-linux-amd64.zip
   fi
   str=$(cat /root/.ngrok2/ngrok.yml)
      if [ $( echo $str | wc -c ) -lt 63 ] && [ $( echo $str | wc -c ) -gt 58 ]; then
         echo "You have already saved your authkey"
      else
      reset
      echo "Please now register at https://www.ngrok.com.free version will work. Upgrade if interested"
      echo "Tollstream.com is not affiliated with ngrok.com, only gives you the ability to use ngrok.com's"
      echo "nat bypass solutions with our automated install scripts."
      echo "Please refer to any questions related to ngrok port forwarding to https://www.ngrok.com and inquiries"
      echo "about plans and licensing details."
      echo "Please enter your authkey located at "
      echo "https://dashboard.ngrok.com/auth/your-authtoken"
      echo "into the terminal for usage with tollstreams e-commerce services."
      read ngrokAuthkey
      num=$(echo -n "$ngrokAuthkey" | wc -c)
      while [ $num -gt 50 ] || [ $num -lt 45];
      do
         reset
         echo "Please double check that your are entering the"
         echo "Authkey for ngrok located at top of"
         echo "https://dashboard.ngrok.com/auth/your-authtoken"
         echo "page"
         read ngrokAuthkey
         num=$(echo -n "$ngrokAuthkey" | wc -c)
      done
      echo $num
      ./ngrok authtoken $ngrokAuthkey
      fi
else
   echo "Skipping local tunnel nat bypass install"
fi
reset
echo "Please enter your username associated with Tollstream.com." 
touch userServerInfo.txt
if [[ -f "userNameSave" ]]; then
   echo "Your screen for tollstream is:"$(cat userNameSave)
   echo Press enter
   read
else
   read userName
   touch userNameSave
   echo -n $userName > userNameSave
fi
#purpose:to send ngroks url to tollstream
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
#modify this to send commands between screens using the
#how to send commands between screens in main fork.
   screen -d -m -S ngrok
   screen -S ngrok -p 0 -X stuff "exec ./ngrok tcp 1935^M"
   sleep 4 
   (
   echo 
   cat userNameSave; echo -n ":  rtmp://" 
   echo -n $(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p')
   echo  "/larix/$streamKey" ) > userServerInfo.txt
else
   reset
   echo "Your public ip address is: "
   echo -n
   wget -qO- http://ipecho.net/plain
   echo
   echo "your localhost rtmp address is "
   echo
   echo -n "rtmp://127.0.0.1:1935/larix/name_publish"
   echo
   echo -n "Your private rtmp address is : " 
   echo
   echo -n "rtmp://"$(ip route get 1.2.3.4 | awk '{print $7}');
   echo ":1935/larix/name_publish"
   echo
   echo -n "Your public rtmp address should be:"
   echo 
   echo  -n "rtmp://"$(wget -qO- http://ipecho.net/plain)
   echo ":1935/larix/$streamKey"

(cat userNameSave ; echo -n rtmp://$(wget -qO- http://ipecho.net/plain)
echo :1935/larix/$streamKey) > userServerInfo.txt
fi
openssl rsautl -encrypt -inkey public-key.pem -pubin -in userServerInfo.txt -out userServerInfoCipher.dat
nc 52.86.45.108 2001 < userServerInfoCipher.dat
if [ "$answ1" = "n" ] || [ "$answ1" = "N" ]; then
   reset
   echo "Your public rtmp server address:"
   echo
   echo -n "rtmp://"
   echo -n $(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p')
   echo   "/larix/$streamKey "
   echo
   echo
   echo "Your localhost rtmp server address:"
   echo
   echo -n "rtmp://127.0.0.1:1935/larix/name_publish"
   echo
   echo
   echo "Your private rtmp server address is :"
   echo
   echo -n "rtmp://"$(ip route get 1.2.3.4 | awk '{print $7}'); echo ":1935/larix/name_publish"
   echo
   echo "Please make note of the rtmp ur4ls that will be used in your system"
   echo "configuration"
   echo "A explanation of when to use which url will he explained in the "
   echo "how to host rtmp servers forum at Tollstream.com"
   echo "Please press enter when finished making note of the urls"
   read
   screen -r ngrok
   pkill screen
   pkill ngrok
   screen -wipe

fi
exit

