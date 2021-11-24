#!/bin/bash

# working Attempt to install an alpine chroot for a central kernel for tollstream.com. 
# The objective is to make a script that works with most if not all linux distributions
# This should work with any os that has a bash shell and builtins such as chroot. 

RED="\e[31m"
LIGHTBLUE="\e[96m"
PURPLE="\e[95m"
ENDCOLOR="\e[0m"

ENDCOLOR="\e[0m"

virtual_machine() {


apt update && apt install wget, qemu

wget https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.2-x86_64.iso

tar -xvf alpine-minirootfs-*.tar

clear

echo 'Please enter the memory you would like to dedicate to the streaming server'

echo 'Gernerally, it is safe to allocate half your memory to a multi purpose computer'

echo 'such as a desktop or other multi task computer'

echo 'Your currently free and used memory in MB is'

free -m

echo "Enter the amount of memory dedicated to the server os?"

read memory_allocate

qemu-img create -f qcow2 alpine.qcow2 1G

qemu-system-x86_64 -m $memory_allocate -nic user -boot d -cdrom alpine-virt-3.14.2-x86_64.iso

clear

}


tollstream_chroot() {

  cd /home

  chrootDir='Tollstream'

  mkdir Tollstream

  architecture=$(uname -m)

  if [ $architecture == 'unknown' ]; then

     architecture=$(arch)

  fi

  if [ $(echo $architecture | grep armv7) =='' ]; then

     architecture=$architecture

     echo $architecture

  else

     architecture='armv7'

     echo $architecture

  fi

  if [ $architecture == 'i686' ];

     then

     architecture='x86'

  fi

  if [ $architecture == 'i386' ];

      then

     architecture='x86'

  fi

  curl -LO http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/$architecture/apk-tools-static-2.12.7-r0.apk

  tar -xzf apk-tools-static-*.apk

  ./sbin/apk.static -X  https://dl-cdn.alpinelinux.org/alpine/latest-stable/main -U --allow-untrusted -p Tollstream  --initdb add alpine-base

  mount -v -t proc none Tollstream/proc

  mount -v --rbind /sys Tollstream/sys

  mount --make-rprivate Tollstream/sys

  mount -v --rbind /dev Tollstream/dev

  mount --make-rprivate Tollstream/dev

  if [ -L /dev/shm ] && [ -d /run/shm ]; then

        mkdir -p run/shm

        mount -v --bind /run/shm run/shm

        mount --make-private run/shm
  fi

  cp -L /etc/resolv.conf Tollstream/etc/

  mkdir -p Tollstream/etc/apk

  echo "https://mirror.clarkson.edu/alpine/v3.14/main" > Tollstream/etc/apk/repositories

  chroot Tollstream rm /etc/mtab 2> /dev/null

  chroot Tollstream ln -s /proc/mounts /etc/mtab

#  cd /home/Tollstream




echo $(printf "if [[ ! -f '/home/Tollstream/exist' ]];\n"

printf "then\n"

printf "touch /home/Tollstream/exist;\n"

printf "apk update; apk upgrade;\n"

printf "apk add git bash openssl screen;\n"

printf "cd /home;\n"

printf "git clone --depth=1 -b test-ubuntu2 \\n"

printf " --single-branch \\n"

printf "https://github.com/isodecryptor/tollstream-RTMP-server.git;\n"

printf "cd tollstream-RTMP-server;\n"

printf "chmod +x Alpine_rtmp_tollstream.sh;\n"

printf "./Alpine_rtmp_tollstream.sh;\n"

printf "fi\n") >> /home/Tollstream/etc/profile



  chroot Tollstream /bin/ash -l







}

clear

echo -e "${LIGHTBLUE}Tollstream has two options for installing its open source server"

echo 'Virtual machines are sometimes the only option you may have.'

echo  'It is also a more private option.Ex. your computers mac address'

echo  "will not be the same as the virtual machine's"

echo  "A virtual machine will install Tollstream's RTMP server in a totoally isolated environment."

echo  "Nothing that is installed on the virual machine effects" 

echo "the installation of the parent os"

echo "A virtual machine is a great option for more privacy and security,"

echo "however it does take more system resources to run than a chroot install"

echo " The other option is a chroot install of tollstream's packages."

echo "It is isolated from your parent os as well but does use the same drivers as your parent os"

echo "If you are running linux and not concerned with the greater privacy benefits of using a virtual machine,"

echo " the chroot install option is better on system resources"

echo "Tollstream uses the tiny Alpine linux distribution to be cross compatible with all operating systems"

echo "(tollstream runs in a tiny, isolated os)"

echo -e "Please choose one of two options${ENDCOLOR}"

echo -e "${RED} 1) Virtual machine"

echo -e " 2) Chroot${ENDCOLOR}"

read choice

if [ $choice = 1 ]; then
   virtual_machine
else

    tollstream_chroot
fi

exit
