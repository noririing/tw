#!/bin/bash

. twcom.sh

while :
do
  sleep 7
  fsize_check
  if [ $? -eq 1 ];then
    echo "file size not changing"
    check_lock_file
    if [ $? -eq 1 ];then
       echo "restart tw ruby process"
       stop_twrb_process
       sleep 3
       start_twrb_process
    fi
  fi
done