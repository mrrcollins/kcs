#!/bin/sh
#
# Add KCS wireless networks to machines
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

#Networks
wifi[1]="net1"
wifi[2]="net2"
wifi[3]="net3"
wifi[4]="net4"
wifi[5]="net5"
wifi[6]="net6"

#Defaults
INDEX=0
SECURITY="NONE"
PASSWORD=""

#N capable? Our n networks are the regular SSID with an n at the end
if [[ `/usr/sbin/system_profiler SPAirPortDataType| grep "Supported PHY Modes: 802.11 a/b/g/n"` ]]; then 
	N=true
fi

for SSID in "${wifi[@]}"
do
	if [[ !(`/usr/sbin/networksetup -listpreferredwirelessnetworks ${wifiDevice} | grep -P "^\t${SSID}$"`) ]]; then
		echo "Adding $SSID"
	    /usr/sbin/networksetup -addpreferredwirelessnetworkatindex $wifiDevice $SSID $INDEX $SECURITY $PASSWORD
	fi
	if [[ !(`/usr/sbin/networksetup -listpreferredwirelessnetworks ${wifiDevice} | grep -P "^\t${SSID}n$"`) && $N ]]; then
		echo "Adding $SSIDn"
    	/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $wifiDevice ${SSID}n $INDEX $SECURITY $PASSWORD			
	fi
done

SSID="admin"
SECURITY="WPA2"
PASSWORD="nomoresecrets"

if [[ !(`/usr/sbin/networksetup -listpreferredwirelessnetworks ${wifiDevice} | grep -P "^\t${SSID}$"`) ]]; then
	echo "Adding $SSID"
    sudo /usr/sbin/networksetup -addpreferredwirelessnetworkatindex $wifiDevice $SSID $INDEX $SECURITY $PASSWORD
fi
