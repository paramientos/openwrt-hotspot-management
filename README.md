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

(In Turkish => **OpenWrt**, modemimizin beceri ve yeteneklerini geliştirmek için mükemmel bir seçimdir. Bu yüzden bash tabanlı bir hizmet geliştirdim, **Wi-Fi Hotspot**, **indirme/yükleme limitleme**, **5651 log yönetimi** gibi tüm ihtiyaçlarınızı yönetmek için OpenWrt cihazınıza entegre edebilirsiniz)

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


|Parameters (alive.sh)|   |
|---|---|
| real_ip   | Real IP/Public IP   |
| mac_address  |  Mac address of the device (wan port) |
| hostname  | Hostname of the device  |
| disk_usage_percentage  | Disk usage of the device  |
| memory_usage_percentage | Memory usage of the device  |
| uptime  |   |


|Parameters (bw.sh)|   |
|---|---|
| download   | Download info of the device as Kb   |
| upload  |  Upload info of the device as Kb |
| until_to  | The date that data was received  |

|Parameters (dhcp_leases.sh)|   |
|---|---|
| leases   | The Dhcp leases of the device   |

|Parameters (law_5651.sh)|   |
|---|---|
| leases   | The Dhcp leases of the device   |

|Parameters (ssid.sh)|   |
|---|---|
| ssid_name   | Wi-Fi name   |
| ssid_key  |  Wi-Fi password |

|Parameters (url_logger.sh)|   |
|---|---|
| gateway_ip   | The gateway ip of the device   |
| urls  |  The url addresses that the users visited |

|Parameters (user_bw_usage.sh)|   |
|---|---|
| usage   | The user data usage information. For more further information about the parameters of the Wrtbwmon package, you can check : https://github.com/Kiougar/luci-wrtbwmon |


The packages : 
- Curl (https://openwrt.org/packages/pkgdata/curl)
- wrtbwmon_0.36_all (https://github.com/Kiougar/luci-wrtbwmon)
- luci-wrtbwmon_v0.8.3_all (https://github.com/Kiougar/luci-wrtbwmon)
- nodogsplash (https://nodogsplashdocs.readthedocs.io/en/stable)
- bash (https://openwrt.org/packages/pkgdata/bash)
- uuidgen (https://openwrt.org/packages/pkgdata_lede17_1/uuidgen)
- qos-scripts (https://openwrt.org/docs/guide-user/network/traffic-shaping/traffic_shaping)
- luci-app-qos (https://openwrt.org/packages/pkgdata/luci-app-qos)

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
