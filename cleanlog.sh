#!/bin/bash
#cleanlog.sh
#author wuyang
# clearn /var/log/

ROOT_UID=0
LOG_DIR=/var/log
LINES=50
E_XCD=86
E_NOTROOT=87
E_WRONGARGS=85

[ $UID -ne "$ROOT_UID" ] && {
 echo "Must run this script as root"
 exit $E_NOTROOT
}

[ -n "$1" ] && lines=$1 || lines=$LINES
#Better Way to check args of number
#case "$1" in
#	""	) lines=50;;
#	*[!0-9]*) echo "Usage:`basename $0` lines-to-cleanup";
#		  exit $E_WRONGARGS;;
#	*	) lines=$1;;
#esac
echo $lines
cd $LOG_DIR

[ "$PWD" != "$LOG_DIR" ] && { 
echo "Can't change to $LOG_DIR"
exit $E_XCD
}


