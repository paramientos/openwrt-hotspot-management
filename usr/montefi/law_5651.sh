#!/bin/sh

. /usr/montefi/config.sh
. /usr/montefi/device_id.sh

api="$API_BASE_URI/device/$DEVICE_ID/law5651"

leases=`cat /var/dhcp.leases`
curl --request POST --data "device_id=$device_id&leases=$leases" -D- $api