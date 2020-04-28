#!/bin/bash

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

api="$API_BASE_URI/device/$DEVICE_ID/bw"

download=`cat /sys/class/net/br-lan/statistics/tx_bytes`
upload=`cat /sys/class/net/br-lan/statistics/rx_bytes`
until_to=`date +"%T"`

curl --request POST --data "device_id=$DEVICE_ID&download=$download&upload=$upload&until_to=$until_to" -D- $api