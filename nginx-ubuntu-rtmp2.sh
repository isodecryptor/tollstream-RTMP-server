#$BASH

#Author:Donald Bilton
#
#Date: 10/07/2020

#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com
apt-get update 

apt-get upgrade

apt-get install nginx

apt-get install libnginx-mod-rtmp ufw

apt-get install sudo

sudo apt-get autoremove

echo "Please choose a user name to use with sudo"
echo "Root user will be removed for security reasons"

# Purpose - Script to add a user to Linux system including passsword
# Author - Vivek Gite  under GPL v2.0+
# ------------------------------------------------------------------
# Am i Root user?
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
		usermod -aG sudo $username
                echo "$username has been added to sudoers file"
                echo "$username now has sudo priveleges"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi
exit



