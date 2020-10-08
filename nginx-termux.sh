#$BASH

#Author:Donald Bilton
#
#Date: 10/07/2020

#PURPOSE: To install an nginx rtmp server 
#for use with tollstream.com

termux-wake-lock

termux-setup-storage

pkg update -y 

pkg upgrade -y

apt-get autoremove

pkg install proot-distro

proot-distro install ubuntu

proot-distro login ubuntu


exit



