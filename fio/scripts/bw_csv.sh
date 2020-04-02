#!/bin/bash
FIRST="$HOME/fio/fio_result_"
SECOND="_seq_rd_"

HEADER="bs,ext4,xfs"
echo $HEADER > bw_ext4_xfs.csv
for bs in 4k 8k 16k 32k 64k 128k 512k 1024k 2048k
do
    CUR_LINE="${bs}"
	for fs in ext4 xfs
	do
	    BW=`grep -w bw ${FIRST}${fs}${SECOND}${bs}.json | grep -v ": 0" | cut -d' ' -f11 | cut -d',' -f1`
        CUR_LINE=${CUR_LINE},${BW}
	done
    echo $CUR_LINE >> bw_ext4_xfs.csv
done

