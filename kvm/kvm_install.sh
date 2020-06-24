#!/bin/bash

# create bridged network (see script in projects/misc)

#packages needed to be installed
apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y
apt-get install xtightvncviewer
use -X option when ssh to load server from ashvin-dev (eg. ssh -X root@192.168.0.31)

# make user/group work as root
vi /etc/libvirt/qemu.conf 
uncomment "user=root" and "group=root" and start/restart libvirtd service (below)

# if you do not want above step, copy iso to /var/lib/libvirt/images and use it from there

# Enabled and start libvirtd service (virtual machine services)
systemctl enable --now libvirtd

# create virtual disk
qemu-img create -f /mnt/vmimages1/qcow2 knode1.qcow2 64g

# switch from netplan to old way of configuring 
# create network bridge using virsh command or using /etc/network/interfaces file
# enable dhcp on bridge not on interface

# create vm
virt-install --name=kube-node1 \
	--vcpus=4 \
	--memory=6144 \
	--disk /mnt/vmimages1/knode1.qcow2,cache=none \
	--os-variant=ubuntu18.04 \
	--os-type=linux \
	--network bridge=kube-br0 \
	--graphics none \
	--console pty,target_type=serial \
	--location http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/ \
	--extra-args='console=tty0 console=ttyS0,115200n8 serial'

# other option to create
virt-install --name=knode_template \
    --vcpus=4 \
    --memory=6144 \
    --disk path=/mnt/vmimages1/knode_template.qcow2,cache=none,size=64 \
    --os-variant=ubuntu18.04 \
    --os-type=linux \
    --network bridge=kube-br0 \
    --graphics vnc \
    --cdrom /root/kvm/ubuntu-18.04.4-live-server-amd64.iso \
    --noautoconsole
# do above install by following below steps
virsh dumpxml 1 | grep vnc
vncviewer 127.0.0.1:5900
# ---- complete install in this vnc session

# After install is complete, poweroff the guest do below steps to support
# qemu guest agent (host to guest communication to get guest information)
virsh edit <name> and add below lines after last "controller"
    <!-- support qemu guest agent -->
    <controller type='virtio-serial' index='0'>
      <alias name='virtio-serial0'/>
    </controller>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0'/>
    </channel>
power on guest

inside guest....
apt-get install lsscsi
root@kubenode:~# apt-get install qemu-guest-agent -y
systemctl enable --now qemu-guest-agent
systemctl status qemu-guest-agent (should show running)

Now "virsh domifaddr <name>" should show ip address of guest

# above command will create VM and start installation

# virsh domdisplay
# virsh dominfo 3
# virsh domiflist 3
# virsh domblklist 3
# virsh reboot 3
# virsh start knode1
# virsh shutdown 3
# virsh edit 1 or virsh edit kube-node1
# virsh undefine kube-node1

virt-clone --original knode_template --name knode1 --file /mnt/vmimages1/knode1.qcow2
virt-clone --original knode_template --name knode2 --file /mnt/vmimages1/knode2.qcow2
virt-clone --original knode_template --name knode3 --file /mnt/vmimages1/knode3.qcow2
virt-clone --original knode_template --name knode4 --file /mnt/vmimages1/knode4.qcow2
virt-clone --original knode_template --name knode5 --file /mnt/vmimages2/knode5.qcow2
virt-clone --original knode_template --name knode6 --file /mnt/vmimages2/knode6.qcow2
virt-clone --original knode_template --name knode7 --file /mnt/vmimages2/knode7.qcow2
virt-clone --original knode_template --name knode8 --file /mnt/vmimages2/knode8.qcow2

