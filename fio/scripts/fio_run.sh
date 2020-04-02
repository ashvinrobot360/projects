#!/bin/bash
#INPUT: operation, read percentage, write percentage

if [ $# -ne 4 ]
then
	echo "Usage: $0 <oper> <rd_perc> <wr_perc> <fs>"
    exit 1
fi

OPERATION=${1}
RDP=${2}
WRP=${3}
FILE_SYSTEM=${4}

RES_FOLDER=$HOME/fio/results
rm -rf $HOME/fio/results/$OPERATION/$FILE_SYSTEM
mkdir -p $HOME/fio/results/${OPERATION}/${FILE_SYSTEM}

JSON_PREFIX="./fio_result_"
FIO_FILE="/home/ashvin/fio/config/generic.fio"

sed -i "s/rw=.*/rw=${OPERATION}/" /home/ashvin/fio/config/generic.fio
sed -i "s/rwmixread=.*/rwmixread=${RDP}/" /home/ashvin/fio/config/generic.fio
sed -i "s/rwmixwrite=.*/rwmixwrite=${WRP}/" /home/ashvin/fio/config/generic.fio

FNAME="/mnt/${FILE_SYSTEM}/testdir/testfio"
set -e
sed -i "s,filename=.*,filename=${FNAME}," ${FIO_FILE}
# for bs in 4k 8k 16k 32k 64k 128k 256k 512k 1024k
for bs in 1024k
do
		echo "========ENTERED FOR LOOP ~ ${bs} =========="
    # 1. Execute fio
		sed -i "s/^bs=.*/bs=${bs}/" $FIO_FILE
    JSON_FILE="$HOME/fio/results/${OPERATION}/${FILE_SYSTEM}/${FILE_SYSTEM}_${OPERATION}_${bs}.json"
		fio $FIO_FILE --output-format=json --output=$JSON_FILE

    # 2. Parse result and update csv
    BW_CSV_FILE="$HOME/fio/results/${OPERATION}/${FILE_SYSTEM}/${FILE_SYSTEM}_bw_${OPERATION}.csv"
    LAT_CSV_FILE="$HOME/fio/results/${OPERATION}/${FILE_SYSTEM}/${FILE_SYSTEM}_lat_${OPERATION}.csv"

		# create csv files if not found
		if [ ! -f $BW_CSV_FILE ]; then
			echo "bs,read,write" > $BW_CSV_FILE
		fi

		if [ ! -f $LAT_CSV_FILE ]; then
			echo "bs,read,write" > $LAT_CSV_FILE
		fi
		cat $BW_CSV_FILE
		if [ $OPERATION == "read" ]; then
			BANDWIDTH=`jq '.jobs[0].read.bw' $JSON_FILE`
			echo "${bs},${BANDWIDTH}," >> $BW_CSV_FILE
		elif [ $OPERATION == "write" ]; then
			BANDWIDTH=`jq '.jobs[0].write.bw' $JSON_FILE`
		 	echo "${bs},,${BANDWIDTH}" >> $BW_CSV_FILE

		fi

		if [ $OPERATION == "read" ]; then
			UNROUNDEDLAT=`jq '.jobs[0].read.lat_ns.mean' $JSON_FILE`
    	LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
  		echo "${bs},$LAT," >> $LAT_CSV_FILE
		elif [ $OPERATION == "write" ]; then
			UNROUNDEDLAT=`jq '.jobs[0].write.lat_ns.mean' $JSON_FILE`
			LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
			echo "${bs},,$LAT" >> $LAT_CSV_FILE

		fi

		if [ $OPERATION == "rw" ]; then
			WRITELATUNR=`jq '.jobs[0].write.lat_ns.mean' $JSON_FILE`
			WRITELAT=`expr ${WRITELATUNR/\.*} / 1000`
			READLATUNR=`jq '.jobs[0].read.lat_ns.mean' $JSON_FILE`
			READLAT=`expr ${READLATUNR/\.*} / 1000`
			WBANDWIDTH=`jq '.jobs[0].write.bw' $JSON_FILE`
			RBANDWIDTH=`jq '.jobs[0].read.bw' $JSON_FILE`

			# echo "${bs},$READLAT,$WRITELAT,$LAT_CSV_FILE"
			# echo "${bs},$RBANDWIDTH,$WBANDWIDTH,$BW_CSV_FILE"

			echo "${bs},$READLAT,$WRITELAT" >> $LAT_CSV_FILE
			echo "${bs},$RBANDWIDTH,$WBANDWIDTH" >> $BW_CSV_FILE

		fi
done

cat $FIO_FILE
