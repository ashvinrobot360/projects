#!/bin/bash

for dev in sdb sdc
do
   for op in read write rw
   do
      echo "======RUNNING $dev, $op========="
      ./fio_run_block.sh ${op} 90 10 ${dev}
    done
done
