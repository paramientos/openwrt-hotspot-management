#!/bin/sh

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

check_api="$API_BASE_URI/device/$DEVICE_ID/urls"

gateway_ip=`ip route | grep default | awk '{ print $3 }'`


lease_file="/var/log/dnsmasq.log"
clean_lease_file="/var/log/urls.log"

touch $clean_lease_file

awk '{print $1 " " $2 " " $3 " "  $6 " " $7 " " $8}' $lease_file > $clean_lease_file

urls=`cat $clean_lease_file`

curl --request POST --data "device_id=$device_id&gateway_ip=$gateway_ip&urls=$urls" -D- $api


echo "" > $clean_lease_file
echo "" > $lease_file