#!/bin/bash
FIRST="$HOME/fio/fio_result_"
SECOND="_seq_rd_"

HEADER="lat,ext4,xfs"
echo $HEADER > lat_ext4_xfs.csv
for bs in 4k 8k 16k 32k 64k 128k 512k 1024k 2048k
do
    CUR_LINE="${bs}"
	for fs in ext4 xfs
	do
	    UNROUNDEDLAT=`jq '.jobs[0].read.lat_ns.mean' ${FIRST}${fs}${SECOND}${bs}.json`
		LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
        CUR_LINE=${CUR_LINE},${LAT}
	done
    echo $CUR_LINE >> lat_ext4_xfs.csv
done

