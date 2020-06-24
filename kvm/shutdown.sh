vm_pattern=$1
#for ip in `nmap -sn '192.168.0.*' | grep 'Nmap scan' | awk '{print$5}'`
#do
#    ping -t 1 -i 0.25 -c 2 $ip || true
#done

for i in 1 2 3 4 5 6 7 8
do
   virsh shutdown knode${i}
done
