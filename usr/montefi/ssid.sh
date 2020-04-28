#!/bin/bash
. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

ssid_name=`uci get wireless.wifinet0.ssid`
ssid_key=`uci get wireless.wifinet0.key`

endpoint_url="$API_BASE_URI/device/$DEVICE_ID/wireless"


generate_post_data() 
{
  cat <<EOF
{
	"ssid_name":"$ssid_name",
	"ssid_key":"$ssid_key"
}
EOF
}

curl --header "Content-Type: application/json" --request POST --data "$(generate_post_data)" $endpoint_url