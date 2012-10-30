#!/bin/sh
#
# Require admin password to turn on wifi
# Inspiration from:
#	https://github.com/rtrouton/rtrouton_scripts/blob/master/rtrouton_scripts/setting_preferred_wireless_networks/setting_preferred_wireless_network.sh
#	http://pastie.org/4698068

# Determines which OS the script is running on
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# On 10.7 and higher, the Wi-Fi interface needs to be identified.
# On 10.5 and 10.6, the Wi-Fi interface should be named as "AirPort"

if [[ ${osvers} -ge 7 ]]; then
    wifiDevice=`/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi/,/^Ethernet Address/' | head -2 | tail -1 | cut -c 9-`
else
    wifiDevice=`/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: AirPort/,/^Ethernet Address/' | head -2 | tail -1 | cut -c 9-`
fi

# Exit if there are no wifi devices
if [ $wifiDevice = "" ]; then
  exit 0;
fi

#Set wifi device to AirPort for Leopard
if [[ ${osvers} -lt 7 ]]; then
    wifiDevice="AirPort"
fi

/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport ${wifiDevice} prefs RequireAdminPowerToggle=YES
