#!/bin/bash

check_lock_file(){
  if [ ! -e .twlock ];then
    echo ".twlock file not exist"
    return 0
  else
    echo ".twlock file exist"
    return 1
  fi
}

create_lock_file(){
  touch .twlock
  echo "created .twlock file"
}

remove_lock_file(){
  rm .twlock
  echo "removed .twlock file"
}

start_twrb_process(){
  twpid=`ps x | grep -v grep | grep "tw.rb" | awk '{print $1}'`
  if [ ! "$twpid" = "" ];then
    echo "tw ruby process running"
  else
    echo "tw ruby process starting..."
    nohup ruby ./tw.rb > /dev/null 2>&1 &
    sleep 3
    twpid=`ps x | grep -v grep | grep "tw.rb" | awk '{print $1}'`
    if [ "$twpid" = "" ];then
      echo "Don't start tw.rb!!"
      return 9
    else
      echo "tw ruby process running"
      return 0
    fi
  fi
}

stop_twrb_process(){
  twpid=`ps x | grep -v grep | grep "tw.rb" | awk '{print $1}'`
  if [ ! "$twpid" = "" ];then
    echo "tw ruby process running"
    kill -9 $twpid
    sleep 3
    twpid=`ps x | grep -v grep | grep "tw.rb" | awk '{print $1}'`
    if [ ! "$twpid" = "" ];then
      echo "Don't stop tw.rb!!"
      return 9
    else
      echo "tw ruby process stopped"
      return 0
    fi
  else
    echo "tw ruby process not running"
  fi
}

stop_restarter(){
  restarterpid=`ps x | grep -v grep | grep "twrestarter.sh" | awk '{print $1}'`
  if [ ! "$restarterpid" = "" ];then
    echo "restarter running"
    echo "stopping restarter process"
    kill -9 $restarterpid
    sleep 3
    restarterpid=`ps x | grep -v grep | grep "twrestarter.sh" | awk '{print $1}'`
    if [ ! "$restarterpid" = "" ];then
      echo "Don't stop restarter process"
      return 9
    else
      echo "stopped restarter process"
      return 0
    fi
 fi
}

fsize_check(){
  fsize1=`ls -l tw.csv | awk '{print $5}'`
  sleep 5
  fsize2=`ls -l tw.csv | awk '{print $5}'`

  if [ "$fsize1" = "$fsize2" ];then
    echo "tw.rb stopped!!"
    return 1
  else
    echo "tw.rb running!"
    return 0
  fi
}

