vm_pattern=$1
#for ip in `nmap -sn '192.168.0.*' | grep 'Nmap scan' | awk '{print$5}'`
#do
#    ping -t 1 -i 0.25 -c 2 $ip || true
#done

for vmname in `virsh list | grep $vm_pattern | awk '{printf "%s\n", $2}'`
do
   #vmmac=`virsh domiflist ${vmname} | grep vnet | head -n 1 | awk '{printf "%s", $5}'` 
   vmmac=`virsh dumpxml $vmname | grep "mac address" | cut -d"'" -f2`
   disk=`virsh dumpxml $vmname | grep "source file" | cut -d"'" -f2`
   #vmip=`arp -e| grep $vmmac | awk '{printf "%s", $1}'`
   vmip=`virsh qemu-agent-command $vmname '{"execute":"guest-network-get-interfaces"}' | jq ."return"[1].\"ip-addresses\"[0].\"ip-address\" | cut -d'"' -f2`
   echo $vmname, $vmmac, $disk, $vmip
done


echo
echo

for vmname in `virsh list | grep $vm_pattern | awk '{printf "%s\n", $2}'`
do
   #vmmac=`virsh domiflist ${vmname} | grep vnet | head -n 1 | awk '{printf "%s", $5}'`
   vmmac=`virsh dumpxml $vmname | grep "mac address" | cut -d"'" -f2`
   disk=`virsh dumpxml $vmname | grep "source file" | cut -d"'" -f2`
   #vmip=`arp -e| grep $vmmac | awk '{printf "%s", $1}'`
   vmip=`virsh qemu-agent-command $vmname '{"execute":"guest-network-get-interfaces"}' | jq ."return"[1].\"ip-addresses\"[0].\"ip-address\" | cut -d'"' -f2`
   echo $vmip $vmname
done

