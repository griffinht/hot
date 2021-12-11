#!/bin/bash
set -e

curl https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso -C - -Lo debian.iso

sudo apt-get -y install xorriso

if [ -d isofiles ]; then
  chmod +w -R isofiles
  rm -r isofiles
fi

xorriso -osirrox on -indev debian.iso  -extract / isofiles/
exit 1
#
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz

cpio -H newc -o -A -F isofiles/install.amd/initrd < preseed

gzip isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/
#
chmod a+w isofiles/isolinux/isolinux.bin
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o debian-10-unattended.iso isofiles