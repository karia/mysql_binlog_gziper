#!/bin/bash
#
# mysql_binlog_gziper by karia ( karia@side2.net )

if [ ${EUID:-${UID}} -ne 0 ]; then
  echo "You are not root user!!!"
  exit 1
fi

FILELIST=/tmp/log_filelist
/usr/bin/find /var/log/mysql -type f -regex ".*mysql-bin\.[0-9]+" -print | sort > $FILELIST

while read TMPFILE
do
  fuser $TMPFILE > /dev/null 2>&1
  if [ $? -eq 1 ] ; then
    nice -5 gzip $TMPFILE
    echo "gzip finished: " $TMPFILE
  else
    echo "gzip skipped: " $TMPFILE
  fi
  
done < $FILELIST

exit 0

