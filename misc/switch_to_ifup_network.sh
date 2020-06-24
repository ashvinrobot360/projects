#!/bin/bash

# update your /etc/network/interfaces
echo Update /etc/network/interfaces files and press enter key
read x

# installed old network service
apt-get update
apt-get install ifupdown

# make configuration effective, no reboot required
ifdown --force lo enp2s0f0 enp2s0f1 && ifup -a
systemctl unmask networking
systemctl enable networking
systemctl restart networking

# remove unwanted services
systemctl stop systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
systemctl disable systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
systemctl mask systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
apt-get --assume-yes purge nplan netplan.io
