#!/bin/bash
#Author:Donald Bolton
# purpose to run a tiny os,alpine, to host
#an rtmp server using nginx for use with tollstream.com
#this install has been tested on android. Size for install
#is 100MB after install. This is 1/6th the size of the install
#size for ubuntu and seems perfect for lightweight applications
#such as cell phones. This will also run on older androids
#Would like to run this inside of busy box for outdated androids
cd $home
apk add git nginx nginx-mod-rtmp jq screen
mkdir /run/nginx
git clone tollstream-RTMP-server
cd tollstream-RTMP-server
cp nginx.conf /etc/nginx/nginx.conf
nginx
cat Tollstream.banner


