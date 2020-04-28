#!/bin/sh

file="/var/log/dnsmasq.log"
minimum_size=3000
actual_size=$(du -k "$file" | cut -f 1)
if [ $actual_size -ge $minimum_size ]; then
   #echo "" > $file
   sh /usr/montefi/url_logger.sh
fi