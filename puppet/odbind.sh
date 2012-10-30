#!/bin/sh

#Bound to the directory based on machine name

#OD master is the building network, machines are named with the first two letters being the building
# .kcs is our local TLD

OD=`hostname | cut -c 1-2 |awk '{print tolower($0)}'`".kcs"

CURRENTOD=`/usr/bin/dscl localhost -list /LDAPv3`

if [ "${CURRENTOD}" != "${OD}" ]; then
	if [ "${CURRENTOD}" != "" ]; then
		echo "Remove ${CURRENTOD}"
		/usr/bin/dscl -q localhost -delete /Search CSPSearchPath /LDAPv3/${CURRENTOD}
		/usr/sbin/dsconfigldap -r ${CURRENTOD}
	fi
	echo "Add ${OD}"
	/usr/sbin/dsconfigldap -a ${OD}
	/usr/bin/dscl -q localhost -create /Search SearchPolicy dsAttrTypeStandard:CSPSearchPath
	/usr/bin/dscl -q localhost -merge /Search CSPSearchPath /LDAPv3/${OD}
#	/usr/bin/killall DirectoryService
fi

