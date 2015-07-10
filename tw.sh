#!/bin/bash

. twcom.sh

case "$1" in
"start" ) 

  echo "start TWwatcher"
  check_lock_file
  if [ $? -eq 0 ];then
    create_lock_file
    start_twrb_process
  fi
  nohup ./twrestarter.sh > /dev/null 2>&1 &

;;
"stop"  ) 

  echo "stop TWwatcher"
  check_lock_file
  if [ $? -eq 1 ];then
    remove_lock_file
    stop_twrb_process
  fi
  stop_restarter

;;
"check")
  fsize_check
  check_lock_file

;;
"kill" ) 

echo "kill TWwatcher"

;;

* ) 

echo "usage ./tw.sh start | stop | check | kill"

;;
esac