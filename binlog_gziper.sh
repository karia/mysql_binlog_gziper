#!/bin/bash
#
# mysql_binlog_gziper by karia ( karia@side2.net )

if [ ${EUID:-${UID}} -ne 0 ]; then
  echo "You are not root user!!!"
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "usage: $0 /path/to/mysql_binlog_dir"
  exit 0
fi

DIR_BINLOG=$1
FILELIST=/tmp/binlog_filelist

/usr/bin/find $DIR_BINLOG -type f -regex ".*mysql-bin\.[0-9]+" -print | sort > $FILELIST

while read TMPFILE
do
  /sbin/fuser $TMPFILE
  if [ $? -eq 1 ] ; then
    nice -5 gzip $TMPFILE
    echo "gzip finished: " $TMPFILE
  else
    echo "gzip skipped: " $TMPFILE
  fi
  
done < $FILELIST

exit 0
