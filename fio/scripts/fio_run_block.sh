#!/bin/bash
#INPUT: operation, read percentage, write percentage

if [ $# -ne 4 ]
then
	echo "Usage: $0 <oper> <rd_perc> <wr_perc> <device_file>"
    exit 1
fi

# set -x

OPERATION=${1}
RDP=${2}
WRP=${3}
DEV=${4}

REMOTE_IP="192.168.0.23"
REMOTE_USER="root"
# assume password less login will work

#1. find model of device
# MODEL='model of DEV without space'
MODEL=`ssh $REMOTE_USER@$REMOTE_IP -n "hdparm -I /dev/$DEV" | grep "Model Number:.*" | cut -d ":" -f2 | sed 's/ *//' |sed 's/ /_/g' | sed 's/___*//g'`

SCRIPT_PATH=`dirname $0`
FULL_SCRIPT_PATH=`realpath $SCRIPT_PATH`

FULL_CONFIG_PATH=`sed "s/scripts/config/g" <<< $FULL_SCRIPT_PATH`
FULL_RESULT_PATH=`sed "s/scripts/results/g" <<< $FULL_SCRIPT_PATH`
LOCAL_JSON_FOLDER="$FULL_RESULT_PATH/${MODEL}/${OPERATION}"
BW_CSV_FILE="$FULL_RESULT_PATH/${OPERATION}/${MODEL}/${MODEL}_bw_${OPERATION}.csv"
LAT_CSV_FILE="$FULL_RESULT_PATH/${OPERATION}/${MODEL}/${MODEL}_lat_${OPERATION}.csv"
REMOTE_JSON_FILE="/tmp/tmp.json"

echo $SCRIPT_PATH
echo $FULL_SCRIPT_PATH
echo $FULL_CONFIG_PATH
echo $FULL_RESULT_PATH
echo $LOCAL_JSON_FOLDER
echo $MODEL

rm -rf $LOCAL_JSON_FOLDER
mkdir -p $LOCAL_JSON_FOLDER

JSON_PREFIX="./fio_result_"
FIO_FILE="$FULL_CONFIG_PATH/generic.fio"
REMOTE_FIO_FILE="/tmp/`basename $FIO_FILE`"
echo $REMOTE_FIO_FILE

sed -i "s/rw=.*/rw=${OPERATION}/" $FULL_CONFIG_PATH/generic.fio
sed -i "s/rwmixread=.*/rwmixread=${RDP}/" $FULL_CONFIG_PATH/generic.fio
sed -i "s/rwmixwrite=.*/rwmixwrite=${WRP}/" $FULL_CONFIG_PATH/generic.fio

FNAME="/dev/${DEV}"

set -e
sed -i "s,filename=.*,filename=${FNAME}," ${FIO_FILE}

for bs in 4k 8k 16k 32k 64k 128k 256k 512k 1024k
do
    echo "========BEGIN ~ ${OPERATION},${bs} =========="

    # Prepare local files/folders
    LOCAL_JSON_FILE="${LOCAL_JSON_FOLDER}/${MODEL}_${OPERATION}_${bs}.json"

    # Prepare local fio config file
    sed -i "s/^bs=.*/bs=${bs}/" $FIO_FILE

    # Copy local fio config file to remote
    scp $FIO_FILE $REMOTE_USER@$REMOTE_IP:$REMOTE_FIO_FILE

    # Execute fio on remote
	ssh $REMOTE_USER@$REMOTE_IP -n "fio $REMOTE_FIO_FILE --output-format=json --output=$REMOTE_JSON_FILE"

    # Copy remote fio result json to local folder
	scp $REMOTE_USER@$REMOTE_IP:$REMOTE_JSON_FILE $LOCAL_JSON_FILE

    # Parse the results and update to summary csv files
    # create csv files if not found
    if [ ! -f $BW_CSV_FILE ]; then
        echo "bs,read,write" > $BW_CSV_FILE
    fi

		if [ ! -f $LAT_CSV_FILE ]; then
			echo "bs,read,write" > $LAT_CSV_FILE
		fi

		# cat $BW_CSV_FILE
		if [ $OPERATION == "read" ]; then
			BANDWIDTH=`jq '.jobs[0].read.bw' $LOCAL_JSON_FILE`
            BANDWIDTH=`expr ${BANDWIDTH/\.*} / 1024`
			echo "${bs},${BANDWIDTH}," >> $BW_CSV_FILE
		elif [ $OPERATION == "write" ]; then
			BANDWIDTH=`jq '.jobs[0].write.bw' $LOCAL_JSON_FILE`
		 	echo "${bs},,${BANDWIDTH}" >> $BW_CSV_FILE
            BANDWIDTH=`expr ${BANDWIDTH/\.*} / 1024`
		fi

		if [ $OPERATION == "read" ]; then
			UNROUNDEDLAT=`jq '.jobs[0].read.lat_ns.mean' $LOCAL_JSON_FILE`
    	LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
  		echo "${bs},$LAT," >> $LAT_CSV_FILE
		elif [ $OPERATION == "write" ]; then
			UNROUNDEDLAT=`jq '.jobs[0].write.lat_ns.mean' $LOCAL_JSON_FILE`
			LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
			echo "${bs},,$LAT" >> $LAT_CSV_FILE

		fi

		if [ $OPERATION == "rw" ]; then
			WRITELATUNR=`jq '.jobs[0].write.lat_ns.mean' $LOCAL_JSON_FILE`
			WRITELAT=`expr ${WRITELATUNR/\.*} / 1000`
			READLATUNR=`jq '.jobs[0].read.lat_ns.mean' $LOCAL_JSON_FILE`
			READLAT=`expr ${READLATUNR/\.*} / 1000`
			WBANDWIDTH=`jq '.jobs[0].write.bw' $LOCAL_JSON_FILE`
			RBANDWIDTH=`jq '.jobs[0].read.bw' $LOCAL_JSON_FILE`
            WBANDWIDTH=`expr ${WBANDWIDTH/\.*} / 1024`
            RBANDWIDTH=`expr ${RBANDWIDTH/\.*} / 1024`


			# echo "${bs},$READLAT,$WRITELAT,$LAT_CSV_FILE"
			# echo "${bs},$RBANDWIDTH,$WBANDWIDTH,$BW_CSV_FILE"

			echo "${bs},$READLAT,$WRITELAT" >> $LAT_CSV_FILE
			echo "${bs},$RBANDWIDTH,$WBANDWIDTH" >> $BW_CSV_FILE

		fi
    echo "========END ~ ${OPERATION},${bs} =========="
done

cat $FIO_FILE
