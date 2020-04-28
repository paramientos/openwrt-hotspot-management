#!/bin/bash



#JSON lib from OpenWRT . Thanks to OpenWRT
. /usr/share/libubox/jshn.sh

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

check_api="$API_BASE_URI/device/$DEVICE_ID/sandbox/check"
set_queue_as_run_api="$API_BASE_URI/device/$DEVICE_ID/sandbox/set"

function set_qos() {
	
	device_id=$1
	queue_id=$2
	download=$3
	upload=$4
	uci set qos.wan.download=$download
	uci set qos.wan.upload=$upload
	uci set qos.wan.enabled=1
	uci commit qos
	/etc/init.d/qos enabled
	/etc/init.d/qos restart
	curl --request POST --data "device_id=$device_id&queue_id=$queue_id" $set_queue_as_run_api

}

data=$(curl --request POST --silent --data "device_id=$device_id"  $check_api)

#echo $data

json_load "$data"
json_select result

json_get_var var_queue_id queue_id
json_get_var var_module module
json_get_var var_command command


if [ $var_module = "onoff" ]; then
	curl --request POST --data "device_id=$device_id&queue_id=$queue_id" $set_queue_as_run_api
	sleep 10
	$var_command
fi


if [ $var_module = "qos" ]; then
	download=$(echo $var_command | sed -e 's/[{}]/''/g' | sed s/\"//g | awk -v RS=',' -F: '$1=="download"{print $2}' | xargs)
	upload=$(echo $var_command | sed -e 's/[{}]/''/g' | sed s/\"//g | awk -v RS=',' -F: '$1=="upload"{print $2}' | xargs)
	set_qos $device_id $var_queue_id $download $upload
fi















