                                         
#!/bin/bash
cd /home/ubuntu/test_netcat
touch userServerInfoCipher.dat  
nc_listen(){
#add authentication layer to check if username and server upload key matches the database on tollstream.com

nc 2001 -w 1 -l  >  userServerInfoCipher.dat
openssl rsautl -decrypt -in userServerInfoCipher.dat -out netcatfile.txt -inkey /home/ubuntu/private-key->
#must use code that checks the variables for non command style input. The input can only be treated as a string
#regardless of what its contents are and then checked for validation or simply thrown out as garbage
source netcatfile.txt
serverUploadKey=$(wp user meta get $userName upload_Key --path=/var/www/tollstream.com/)
if [[ "$serverUploadKey" = "$uploadKey" ]]; then
   sudo cat netcatfile.txt >> netcatfile_append.txt
   sed -i 's/"tcp/rtmp/g' netcatfile_append.txt
   sed -i 's/"/g' netcatfile_append.txt
fi
#recursively call itself so this service keeps listening for the next server information, continously
nc_listen
}
nc_listen
exit


