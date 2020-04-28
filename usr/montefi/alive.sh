#!/bin/bash

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh
mac_address=`cat /sys/class/net/br-lan/address | xargs`
real_ip=`wget -qO- http://bot.whatismyipaddress.com/`
hostname=`uci get system.@system[0].hostname`
disk_usage_percentage=`df / | awk 'END{ print $(NF-1) }' |  sed 's/.$//'`
memory_usage_percentage=`free | grep Mem | awk '{print $3/$2 * 100.0}'`
uptime=`awk '{print int($1/3600)":"int(($1%3600)/60)":"int($1%60)}' /proc/uptime`

endpoint_url="$API_BASE_URI/device/$DEVICE_ID/status"


generate_post_data() 
{
  cat <<EOF
{
	"real_ip": "$real_ip",
	"mac_address": "$mac_address",
	"hostname" : "$hostname",
	"disk_usage_percentage":"$disk_usage_percentage",
	"memory_usage_percentage":"$memory_usage_percentage",
	"uptime":"$uptime"
}
EOF
}

curl --header "Content-Type: application/json" --request POST --data "$(generate_post_data)" $endpoint_url