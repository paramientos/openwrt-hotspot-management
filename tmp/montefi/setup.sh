#!/bin/sh 


#Wrtbwmon plugin and Luci UI
#https://github.com/Kiougar/luci-wrtbwmon

#Create automatic crons
#https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

#https://wiki.openwrt.org/doc/howto/cron

#the order is important

. /usr/montefi/config.sh

clrscr() {
	clear
}



register() {
	. /usr/montefi/config.sh
	
	api_reg="$API_BASE_URI/register"
	echo "Enter customer name ?"
	read corp_name
	
	. /usr/montefi/device_id.sh
	
	echo "Reseller ID ? : "
	read reseller_id
	
	curl --request POST --data "device_id=$device_id&corp_name=$corp_name&reseller_id=$reseller_id" -D- $api_reg
}

test_connection() {
	echo "Checking internet connection..."
	sleep 2
	if ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 
	then
		echo ""
	else 
		echo "######## No Internet Connection ######"
		exit 1
	fi
}


test_connection


echo "Install Hotspot  ?  (y/n)"
read bool_hotspot

if [ $bool_hotspot = "y" ]; then 	
	echo "Hotspot will be installed :)"
else
	echo "Hotspot will not be installed :("
fi


echo "Install Url Logging  ?  (y/n)"
read bool_url_log

if [ $bool_url_log = "y" ]; then 	
	echo "URL Logging will be installed :)"
else
	echo "URL Logging will not be installed :("
fi



echo "Install Qos Control  ?  (y/n)"
read bool_qos

if [ $bool_qos = "y" ]; then 	
	echo "Qos Control will be installed :)"
else
	echo "Qos Control will not be installed :("
fi


echo "Here we go .................."
sleep 2

clrscr


echo "Update pkg..."
opkg update

clrscr

echo "Installing Bash..."
opkg install bash
set +o verbose # verbose off

clrscr

echo "Write the device id to the file ...."
opkg install uuidgen

#device_id=`cat /sys/class/net/eth0.2/address`
device_id=$(uuidgen)
echo "var DEVICE_ID='$device_id';" > /tmp/montefi/nds/etc/nodogsplash/htdocs/images/device_id.js
echo "var DEVICE_ID='$device_id';" > /etc/nodogsplash/htdocs/images/device_id.js
echo "DEVICE_ID='$device_id';" > /usr/montefi/device_id.sh 

clrscr

echo "Installing pakages..."

echo "Installing Curl..."
opkg install curl

clrscr


if [ $bool_qos = "y" ]; then 	
	echo "Installing Qos Control..."
	opkg install qos-scripts

	echo "Installing Qos UI ..."
	opkg install luci-app-qos
fi

clrscr




echo "Installing Wrtbwmon..."
opkg install /tmp/montefi/wrtbwmon_0.36_all.ipk


echo "Starting Wrtbwmon..."
/etc/init.d/wrtbwmon start

echo "Adding Wrtbwmon service to startup..."
/etc/init.d/wrtbwmon enable


clrscr




echo "Installing Wrtbwmon UI..."
opkg install /tmp/montefi/luci-wrtbwmon_v0.8.3_all.ipk

clrscr



if [ $bool_hotspot = "y" ]; then 	
	echo "Installing Hotspot..."
	opkg install nodogsplash

	echo "Starting Hotspot ..."
	/etc/init.d/nodogsplash start

	echo "Adding Hotspot service to startup..."
	/etc/init.d/nodogsplash enable

	echo "Copying Hotspot files...."
	cp -rf /tmp/montefi/nds/etc/ /

	clrscr
fi



echo "Setting Timezone as UTC+3 (you can change it later at /etc/TZ file"
echo "<+03>-3" > /etc/TZ

clrscr

echo "Adding Cronjob to startup..."
/etc/init.d/cron enable
echo "Starting Cronjob ..."
/etc/init.d/cron start


clrscr
	
echo "Adding Cronjob tasks..."
crontab -l | { cat; echo "* * * * * sh /usr/montefi/alive.sh"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * sh /usr/montefi/ssid.sh"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * sh /usr/montefi/bw.sh"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * sh /usr/montefi/dhcp_leases.sh"; } | crontab -
crontab -l | { cat; echo "0 */6 * * * sh /usr/montefi/law_5651.sh"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * sh /usr/montefi/user_bw_usage.sh"; } | crontab -
crontab -l | { cat; echo "* * * * * /usr/sbin/wrtbwmon update /etc/config/usage.db"; } | crontab -
#crontab -l | { cat; echo "* * * * * /usr/sbin/wrtbwmon publish /var/usage.db /var/usage.html"; } | crontab -
crontab -l | { cat; echo "0 0 1 * * /usr/sbin/wrtbwmon update /etc/config/usage.db && rm /etc/config/usage.db"; } | crontab -
crontab -l | { cat; echo "* * * * * sh /usr/montefi/tz.sh"; } | crontab -
#crontab -l | { cat; echo "0 3 * * * sh /usr/montefi/restart.sh"; } | crontab -

clrscr

if [ $bool_url_log = "y" ]; then 
	echo "log-queries\nlog-facility=/var/log/dnsmasq.log\n#address=/facebook.com/127.0.0.1" >> "/etc/dnsmasq.conf" 

	echo "Restarting Dnsmasq service..."
	/etc/init.d/dnsmasq restart
	
	echo "Writing Url crons"
	crontab -l | { cat; echo "* * * * * sh /usr/montefi/check_url_log_size.sh"; } | crontab -
	crontab -l | { cat; echo "*/10 * * * * sh /usr/montefi/url_logger.sh"; } | crontab -
fi



echo "Restarting Cronjob ..."
/etc/init.d/cron restart

clrscr

echo "Send DHCP list as the first time..."
sh /usr/montefi/dhcp_leases.sh

clrscr

echo "Restart Time server..."
/etc/init.d/sysfixtime restart

clrscr


echo "Adding Firewall rules..."
uci add firewall 'redirect'
uci set firewall.@rule[-1].name='luci-remote'
uci set firewall.@rule[-1].src='wan'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].src_dport='8989'
uci set firewall.@rule[-1].dest_port='8989'
uci set firewall.@rule[-1].target='DNAT'
uci set firewall.@rule[-1].dest='lan'
uci commit firewall
/etc/init.d/firewall restart


clrscr

echo "Write Hostname..."

uci set system.@system[0].hostname="$DEVİCE_HOST_NAME"
uci commit system
/etc/init.d/system reload

clrscr

echo "Setting Environment Variables"
echo "DEVICE_ID=$device_id" > $HOME/.profile
source $HOME/.profile
export DEVICE_ID=$device_id


clrscr

echo "Registering device..."
register


clrscr

echo "Clean installing files..."
rm -rf /tmp/montefi/

clrscr



echo "Clean Luci cache if exists..."
[ -e /tmp/luci-indexcache ] && rm /tmp/luci-indexcache
	

clrscr

echo "************************************************************"
echo "Device ID : $device_id"	
echo "************************************************************"
sleep 2

	
echo "Restart the device (y/n)"
read rst


if [ $rst = "y" ]; then 	
	echo "Restarting...."
	reboot
fi







