#!/bin/bash

for fs in ext4 xfs
do
    for op in read write rw
    do
      echo "======RUNNING $fs, $op========="
      ./fio_run.sh ${op} 90 10 ${fs}
    done
done
