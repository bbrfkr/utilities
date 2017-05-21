#!/bin/sh

# output usage
if [ "$1" = "" ] || [ "$1" = "-h" ] ; then
  echo "usage: wait_for_port.sh TARGET_HOST TARGET_PORT SEARCH_REGEXP RETRY_TIMES"
  exit 1
fi

# validation arguments and define values
TARGET_HOST=$1
if [ "$2" != "" ] ; then
  TARGET_PORT=$2
else
  echo "ERROR: please specify TARGET_PORT"
  exit 1
fi

if [ "$3" != "" ] ; then
  SEARCH_REGEXP=$3
else
  echo "ERROR: please specify SEARCH_REGEXP"
  exit 1
fi

if [ "$4" != "" ] ; then
  RETRY_TIMES=$4
else
  RETRY_TIMES="INFINITY"
fi
RESPONSED=0

# main process
if [ $RETRY_TIMES = "INFINITY" ] ; then
  while [ $RESPONSED -ne 1 ]
  do
    echo -ne "\n" | nc $TARGET_HOST $TARGET_PORT | grep -e "$SEARCH_REGEXP" > /dev/null
    if [ $? -eq 0 ] ; then
      RESPONSED=1
    else
      sleep 1
    fi
  done
else
  while [ $RESPONSED -ne 1 ] && [ $RETRY_TIMES -gt 0 ]
  do
    echo -ne "\n" | nc $TARGET_HOST $TARGET_PORT | grep -e "$SEARCH_REGEXP" > /dev/null
    if [ $? -eq 0 ] ; then
      RESPONSED=1
    else
      RETRY_TIMES=$(($RETRY_TIMES - 1))
      sleep 1
    fi
  done
fi

if [ $RESPONSED -eq 1 ] ; then
  echo "$TARGET_HOST:$TARGET_PORT is opened!"
  exit 0
else
  echo "$TARGET_HOST:$TARGET_PORT is closed..."
  exit 1
fi

