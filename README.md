## OpenWrt Hostpot/Logging/Qos Management Bash Service

With the OpenWrt Management Service, you can collect the data on the device and send it to the endpoint that you specified.

- Hotspot management
- Speed limitation with Qos Control
- Who visited which websites with URL logging
- Download/Upload information (both device and user) (Watching Bandwidth)
- Device uptime information (heartbeat)
- SSID information
- Dhcp log information (you can sign it there if you wish).
- Signing DHCP log files will be in the next version

**Working logic :**
All main files are located at /usr/montefi folder.
Every endpoint has a variable named `endpoint_url`
You can change the endpoint values as your desire. Foe example : 
If you can check /usr/montefi/alive.sh, you will see the line as this : 

    endpoint_url="$API_BASE_URI/device/$DEVICE_ID/status"
  
The variable `API_BASE_URI` comes from `/usr/montefi/config.sh`
`device/$DEVICE_ID/status` is the endpoint part of it. You can change it if you want.

Since OpenWrt/Lede devices run on Linux, it creates many related package logs. You can provide these logs with third party tools.
Since the packages used in this project produce logs in the same way, the service parses them and make sense of these log files and send them to the endpoint that you mentioned. Cronjob service is used to do that.

You can ***change*** the `**API_BASE_URI**` information at`/ur/montefi/config.sh`
You can ***change*** the splash screen at`/etc/banner`

## Installation

**1-** First of all, change your `API_BASE_URI` value at`/ur/montefi/config.sh` then copy all the files to the OpenWrt device's root directory (/)

`$ scp -r / local / setup-files root@10.10.0.2: /`

(In Windows / Linux / Mac you can use Ftp client also)

**2-** Connect to the device via ssh

    $ ssh root@10.10.0.2
    $ sh /tmp/montefi/setup.sh

**3-** When the installation is finished, check your cron items. You will see the tasks that OpenWrt is going to handle

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
