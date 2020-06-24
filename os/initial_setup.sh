#!/bin/bash

# Things to do after intial Ubuntu install on physical host
# or bare metal server

USER=`whoami`
if [ "$USER" != "root" ]; then
    echo ERROR: Run this script using sudo
    exit 1
fi

# allow root level ssh login
echo Chaning root password
passwd root
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl restart sshd

# install disk level packages
apt install lsscsi nmap jq mssh
# 

