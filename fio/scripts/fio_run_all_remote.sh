#!/bin/bash

dev="/dev/sdb"
for fs in block ext4 xfs
do
   for op in read write rw
   do
      ./fio_run_remote.sh 192.168.0.17 $dev ${fs} ${op} 90 10
    done
done
