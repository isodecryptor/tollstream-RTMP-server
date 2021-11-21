#!/bin/bash

# Attempt to install an alpine chroot for a central kernel for tollstream.com. 
# The objective is to make a script that works with most if not all linux distributions
# This should work with any os that has a bash shell and builtins such as chroot. 


virtual_machine() {


apt update && apt install wget, qemu

wget https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.2-x86_64.iso

tar -xvf alpine-minirootfs-*.tar

echo 'Please enter the memory you would like to dedicate to the streaming server \n'

echo 'Gernerally, it is safe to allocate half your memory to a multi purpose computer such as a desktop or other multi task computer'

echo 'Your currently free and used memory in MB is \n'

free -m

echo "Enter the amount of memory dedicated to the server os?"

read memory_allocate

qemu-img create -f qcow2 alpine.qcow2 1G

qemu-system-x86_64 -m $memory_allocate -nic user -boot d -cdrom alpine-virt-3.14.2-x86_64.iso


}


tollstream_chroot() {

  cd /home

  chrootDir='Tollstream'

  mkdir Tollstream

 

  architecture=$(arch)

  if [ $architecture == 'armv7l' ];

        then

        architecture='armv7'

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

  mount --make-rprivate sys

  mount -v --rbind /dev Tollstream/dev

  mount --make-rprivate dev

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

  chroot Tollstream /bin/ash -l







}

echo 'Tollstream has two options for installing its open source server \n'

echo 'Virtual machines are sometimes the only option you may have. It is also a more private option.Ex. your computers mac address will not be the same\n '

echo "as the virtual machine's\n"

echo "A virtual machine will install tollstream's RTMP server in a totoally isolated environment. Nothing that is installed on the virual machine effects\n"

echo "the installation of the parent os\n"

echo "A virtual machine is a great option for more privacy and security, however it does take more system resources to run than a chroot install\n"

echo " The other option is a chroot install of tollstream's packages. It is isolated from your parent os as well but does use the same drivers as your parent os\n"

echo "If you are running linux and not concerned with the greater privacy benefits of using a virtual machine, the chroot install option is better on system resources\n"

echo "Tollstream uses the tiny Alpine linux distribution to be cross compatible with all operating systems(tollstream runs in a tiny, isolated os)\n"

echo "Please choose one of two options\n"

echo " 1) Virtual machine\n"

echo " 2) Chroot\n"

read choice

if [ $choice = 1 ]; then
   virtual_machine
else 

    tollstream_chroot
fi

exit
