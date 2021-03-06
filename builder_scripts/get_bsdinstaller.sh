#!/bin/sh

#set -e

if [ ! -d "/usr/ports" ]; then
	echo -n ">>> Checking out fresh ports tree (this will take a bit)..."
	(portsnap fetch) 2>&1 | egrep -B3 -A3 -wi '(error)'
	(portsnap extract) 2>&1 | egrep -B3 -A3 -wi '(error)'
	echo "Done!"
fi

CURRENTDIR=`pwd`
[ -r "${CURRENTDIR}/pfsense_local.sh" ] && . ${CURRENTDIR}/pfsense_local.sh

if [ -d $BASE_DIR/installer/CVS ]; then
	rm -rf $BASE_DIR/installer
fi

# Update BSDInstaller
echo -n ">>> Updating BSDInstaller collection..."
if [ -d $BASE_DIR/installer ]; then
	cd $BASE_DIR/installer && git reset --hard ; git fetch ; git rebase origin 
else
	cd $BASE_DIR && git clone https://github.com/pfsense/bsdinstaller.git installer
fi

ln -s ${BUILDER_TOOLS}/builder_scripts/installer ${BASE_DIR}/installer/ 2>/dev/null

# Build BSDInstaller
mkdir -p /usr/ports/packages/All

