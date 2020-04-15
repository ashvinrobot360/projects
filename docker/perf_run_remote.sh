#!/bin/bash
#INPUT: operation, read percentage, write percentage

if [ $# -ne 6 ]
then
	echo "Usage: $0 <remote_ip> <device_file> <type> <oper> <rd_perc> <wr_perc>"
	echo "    Example: $0 192.168.0.23 /dev/sdb block read 90 10"
	echo "    Example: $0 192.168.0.23 /dev/sdc ext4 read 90 10"
    exit 1
fi

set -e

create_fio_config()
{
FIO_CONFIG_FILE=$1
FNAME=$2
OPERATION=$3
bs=$4
RDP=$5
WRP=$6
# create fio configuration dynamically for this run
cat <<EOT > ${FIO_CONFIG_FILE}
[global]
direct=1
iodepth=22
ioengine=libaio
runtime=10
time_based=1
ramp_time=5
size=256m
numjobs=1
rw=${OPERATION}
bs=${bs}
rwmixread=${RDP}
rwmixwrite=${WRP}

[${OPERATION}_bw_test]
name=${OPERATION}_bw_test
filename=${FNAME}
EOT
}

# set -x

REMOTE_IP=$1
REMOTE_DEV=$2
FS=$3
OPERATION=$4
RDP=$5
WRP=$6
REMOTE_USER="root"
# assume password less login will work

# Find model of device on remote machine
# MODEL='model of REMOTE_DEV without space'
MODEL=`ssh $REMOTE_USER@$REMOTE_IP -n "hdparm -I $REMOTE_DEV" | grep "Model Number:.*" | cut -d ":" -f2 | sed 's/ *//' |sed 's/ /_/g' | sed 's/___*//g'`
RESULT_DIR="$HOME/fio_results"
mkdir -p ${RESULT_DIR}

# umount remote device forcefully (if required), ignore if device not mounted and it fails
# it is just a best effort
remote_mnt_dir=`ssh $REMOTE_USER@$REMOTE_IP -n mount | grep ${REMOTE_DEV} | cut -d' ' -f3` || true
ssh $REMOTE_USER@$REMOTE_IP -n "umount -lf $remote_mnt_dir" || true

# create filesystem and mount if it is not at block level
FNAME=$REMOTE_DEV
if [ "${FS}" != "block" ]; then
    REMOTE_MOUNT_POINT="/mnt/${MODEL}_${FS}"
    echo "Making filesystem $FS on ${REMOTE_DEV}..."
    if [ "${FS}" == "ext4" ]; then
        OPT="-F"
    else
        OPT="-f"
    fi
    ssh $REMOTE_USER@$REMOTE_IP -n "mkfs.${FS} $OPT ${REMOTE_DEV}"
    echo "Mounting $REMOTE_DEV to $REMOTE_MOUNT_POINT"
    ssh $REMOTE_USER@$REMOTE_IP -n "mkdir -p ${REMOTE_MOUNT_POINT}"
    ssh $REMOTE_USER@$REMOTE_IP -n "mount ${REMOTE_DEV} ${REMOTE_MOUNT_POINT}"
    FNAME="${REMOTE_MOUNT_POINT}/test.dat"
fi

BW_CSV_FILE="$RESULT_DIR/${MODEL}_${FS}_${OPERATION}_BW.csv"
LAT_CSV_FILE="$RESULT_DIR/${MODEL}_${FS}_${OPERATION}_LAT.csv"

for bs in 4k 8k 16k 32k 64k 128k 256k 512k 1024k
do
    echo "========BEGIN $MODEL, $FS, ${OPERATION}, ${bs} =========="

    # Prepare local files/folders
    LOCAL_RESULT_JSON="${RESULT_DIR}/${MODEL}_${FS}_${OPERATION}_${bs}.json"

    # create fio configuration dynamically for this run
    LOCAL_FIO_CONFIG="${RESULT_DIR}/${MODEL}_${FS}_${OPERATION}_${bs}.fio"
    create_fio_config ${LOCAL_FIO_CONFIG} $FNAME $OPERATION $bs $RDP $WRP

    # Start remote fio server
	# ssh $REMOTE_USER@$REMOTE_IP -n "pkill -9 -f fio -u $REMOTE_USER" || true
	ssh $REMOTE_USER@$REMOTE_IP -n "fio --server --daemonize=/tmp/fio.pid" || true

    # Execute fio on local to remote
    ret=0
	fio --client=$REMOTE_IP $LOCAL_FIO_CONFIG --output-format=json --output=$LOCAL_RESULT_JSON || ret=$?
    if [ $ret -ne 0 ]; then
        # some error in fio run
        head -n 10 $LOCAL_RESULT_JSON
        exit 1
    fi
    sed -i 's/^<.*//g' $LOCAL_RESULT_JSON

    # Parse the results and update to summary csv files
    # create csv files if not found
    if [ ! -f $BW_CSV_FILE ]; then
        echo "bs,read,write" > $BW_CSV_FILE
        echo "bs,read,write" > $LAT_CSV_FILE
    fi

    # Get b/w and latency from result json and update corresponding csv files
    if [ $OPERATION == "read" ]; then
        BANDWIDTH=`jq '.client_stats[0].read.bw' $LOCAL_RESULT_JSON`
        BANDWIDTH=`expr ${BANDWIDTH/\.*} / 1024`
        echo "${bs},${BANDWIDTH}," >> $BW_CSV_FILE
        UNROUNDEDLAT=`jq '.client_stats[0].read.lat_ns.mean' $LOCAL_RESULT_JSON`
    	LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
  		echo "${bs},$LAT," >> $LAT_CSV_FILE
    elif [ $OPERATION == "write" ]; then
        BANDWIDTH=`jq '.client_stats[0].write.bw' $LOCAL_RESULT_JSON`
        echo "${bs},,${BANDWIDTH}" >> $BW_CSV_FILE
        BANDWIDTH=`expr ${BANDWIDTH/\.*} / 1024`
        UNROUNDEDLAT=`jq '.client_stats[0].write.lat_ns.mean' $LOCAL_RESULT_JSON`
        LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
        echo "${bs},,$LAT" >> $LAT_CSV_FILE
    else
        # r/w operation
        WRITELATUNR=`jq '.client_stats[0].write.lat_ns.mean' $LOCAL_RESULT_JSON`
        WRITELAT=`expr ${WRITELATUNR/\.*} / 1000`
        READLATUNR=`jq '.client_stats[0].read.lat_ns.mean' $LOCAL_RESULT_JSON`
        READLAT=`expr ${READLATUNR/\.*} / 1000`
        WBANDWIDTH=`jq '.client_stats[0].write.bw' $LOCAL_RESULT_JSON`
        RBANDWIDTH=`jq '.client_stats[0].read.bw' $LOCAL_RESULT_JSON`
        WBANDWIDTH=`expr ${WBANDWIDTH/\.*} / 1024`
        RBANDWIDTH=`expr ${RBANDWIDTH/\.*} / 1024`
        echo "${bs},$READLAT,$WRITELAT" >> $LAT_CSV_FILE
        echo "${bs},$RBANDWIDTH,$WBANDWIDTH" >> $BW_CSV_FILE
    fi

    echo "========END $MODEL, $FS, ${OPERATION}, ${bs} =========="
done
