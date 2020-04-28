## OpenWrt Hostpot/Logging/Qos Management Bash Service

With OpenWrt management bash service, you can direct the data you collect on the device to the relevant endpoints. With the data collection mechanism built into the device, you will be able to perform the following operations without any hassle:

- Hotspot management
- Speed limitation with Qos Control
- Who entered which sites with URL logging
- Download / Upload information (on both device and user basis) (Watching Bandwith)
- Device uptime information (heartbeat)
- SSID information
- It takes the Dhcp log information and sends the relevant endpointe data (you can sign it there if you wish).
- Signing with SSL will be activated in the next version.

**Working logic :**
All main files are located at /usr/montefi folder.
Every endpoint has a variable named `endpoint_url`
You can change the endpoint values as your desire. Foe example : 
If you can check /usr/montefi/alive.sh, you will see the line as this : 

    endpoint_url="$API_BASE_URI/device/$DEVICE_ID/status"
  
The variable `API_BASE_URI` comes from `/usr/montefi/config.sh`
`device/$DEVICE_ID/status` is the endpoint part of it. You can change it if you want.

When OpenWrt/Lede devices run on Linux, it creates many related package logs. You can provide these logs with third party tools.
Since the packages used in this project produce logs in the same way, we break down, make sense of these log files and direct them to the specified endpoint. For this, cronjob service is used.

While device setup, a device id information is compiled. This is sent in the body when sending data to endpoints in the future.

You can ***change*** the `**API_BASE_URI**` information at`/ur/montefi/config.sh`
You can ***change*** the splash screen at`/etc/banner`

## Installation

**1-** First, we copy all the files to the OpenWrt device and copy them to root.

`$ scp -r / local / setup-files root@10.10.0.2: /`
(In Windows / Linux / Mac you can use Ftp client also)

**2-** We connect to the device with Ssh

    $ ssh root@10.10.0.2
    $ sh /tmp/montefi/setup.sh
	
	Then follow the instructions

**3-** When setup is finished, check your crons. You will see the tasks that OpenWrt is going to handle

    $ crontab -e

**4-** Enjoy your new Wi-Fi friend :)

Supported versions :
 - [x] OpenWrt 19.07.1
 - [x] OpenWrt 19.07.0
 - [x] OpenWrt 18.06.7
 - [x] OpenWrt 18.06.6
 - [x] OpenWrt 18.06.5
 - [x] LEDE 17.01.6
 - [x] LEDE 17.01.5
 - [x] LEDE 17.01.4
 - [x] LEDE 17.01.3
 - [x] LEDE 17.01.2

**RoadMap :** 
 - [ ] Sign dhcp log files with SSL at device
