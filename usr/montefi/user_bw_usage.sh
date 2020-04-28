#!/bin/sh

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

check_api="$API_BASE_URI/device/$DEVICE_ID/consumer/bw"

usage=""

if [ -f /etc/config/usage.db ]; then
    usage=`cat /etc/config/usage.db`
fi

curl --request POST --data "device_id=$device_id&usage=$usage" -D- $api