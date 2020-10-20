#!/bin/bash
#Author: Donald Bilton
#Date: 10/20/2020
#
#Purpose: To make a system servie that starts every time the operating system starts. This will reload the modules that are required for streaming on a private
#RTMP Server, associated with Tollstream.com. This server is powered by nginx

service nginx stop 
service nginx start
