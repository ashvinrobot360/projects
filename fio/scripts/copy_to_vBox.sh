#!/bin/bash

for fname in `find /home/ashvin/fio/results -name *.csv`
do
  set -x
	sudo cp $fname /media/sf_virtualbox_share/fio_results
  set +x
done
