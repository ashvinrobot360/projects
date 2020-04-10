#!/bin/bash

# Abort script on first error (ie. do not continue)
set -e

# below will print all commands, used debugging. Once script is working, comment out
# set -x

RES_PATH="$HOME/projects/fio/results/VBOX_HARDDISK"
MODEL="VBOX_HARDDISK"
for op in read write rw
do
   CSV_FILE="${RES_PATH}/compare_${MODEL}_${op}.csv"
   rm -f $CSV_FILE
   for bs in 4k 8k 16k 32k 64k 128k 256k 512k 1024k
   do
       CUR_BW_LINE="${bs}"
       CUR_LAT_LINE=""
       for fs in block ext4 xfs
       do
            JSON_FILE="${RES_PATH}/${MODEL}_${fs}_${op}_${bs}.json"
            echo "Processing file ${JSON_FILE}..."
            if [ ! -f $CSV_FILE ]; then
                # write heading line
                if [ "${op}" == "read" ]; then
                    echo "Block size,${MODEL}_block_bw_rd,${MODEL}_ext4_bw_rd,${MODEL}_xfs_bw_rd,${MODEL}_block_lat_rd,${MODEL}_ext4_lat_rd,${MODEL}_xfs_lat_rd" > $CSV_FILE
                fi
                if [ "${op}" == "write" ]; then
                    echo "Block size,${MODEL}_block_bw_wr,${MODEL}_ext4_bw_wr,${MODEL}_xfs_bw_wr,${MODEL}_block_lat_wr,${MODEL}_ext4_lat_wr,${MODEL}_xfs_lat_wr" > $CSV_FILE
                fi
                if [ "${op}" == "rw" ]; then
                    echo "Block size,${MODEL}_block_bw_rd,${MODEL}_block_bw_wr,${MODEL}_ext4_bw_rd,${MODEL}_ext4_bw_wr,${MODEL}_xfs_bw_rd,${MODEL}_xfs_bw_wr,${MODEL}_block_lat_rd,${MODEL}_block_lat_wr,${MODEL}_ext4_lat_rd,${MODEL}_ext4_lat_wr,${MODEL}_xfs_lat_rd,${MODEL}_xfs_lat_wr" > $CSV_FILE
                fi
            fi

            # Get b/w and latency from result json and update corresponding csv files
            if [ "${op}" == "read" ]; then
                BW=`jq '.client_stats[0].read.bw' $JSON_FILE`
                BW=`expr ${BW/\.*} / 1024`
                CUR_BW_LINE="${CUR_BW_LINE},${BW}"
                UNROUNDEDLAT=`jq '.client_stats[0].read.lat_ns.mean' $JSON_FILE`
                LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
                CUR_LAT_LINE="${CUR_LAT_LINE},${LAT}"
            elif [ "${op}" == "write" ]; then
                BW=`jq '.client_stats[0].write.bw' $JSON_FILE`
                BW=`expr ${BW/\.*} / 1024`
                CUR_BW_LINE="${CUR_BW_LINE},${BW}"
                UNROUNDEDLAT=`jq '.client_stats[0].write.lat_ns.mean' $JSON_FILE`
                LAT=`expr ${UNROUNDEDLAT/\.*} / 1000`
                CUR_LAT_LINE="${CUR_LAT_LINE},${LAT}"
            else
                # r/w operation
                WRITELATUNR=`jq '.client_stats[0].write.lat_ns.mean' $JSON_FILE`
                WRITELAT=`expr ${WRITELATUNR/\.*} / 1000`
                READLATUNR=`jq '.client_stats[0].read.lat_ns.mean' $JSON_FILE`
                READLAT=`expr ${READLATUNR/\.*} / 1000`
                CUR_LAT_LINE="${CUR_LAT_LINE},${READLAT},${WRITELAT}"
                WBW=`jq '.client_stats[0].write.bw' $JSON_FILE`
                RBW=`jq '.client_stats[0].read.bw' $JSON_FILE`
                WBW=`expr ${WBW/\.*} / 1024`
                RBW=`expr ${RBW/\.*} / 1024`
                CUR_BW_LINE="${CUR_BW_LINE},${RBW},${WBW}"
            fi
       done
       echo ${CUR_BW_LINE}${CUR_LAT_LINE} >> $CSV_FILE
   done
done
