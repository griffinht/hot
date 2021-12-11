#!/bin/bash
set -e

curl https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso -C - -Lo debian.iso

sudo apt-get -y install xorriso genisoimage

xorriso -osirrox on -indev debian.iso  -extract / isofiles/
#rm debian.iso
#
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz

#echo "preseed" | cpio -H newc -o -A -F isofiles/install.amd/initrd

gzip isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/

#md5
(
cd isofiles/
chmod a+w md5sum.txt
md5sum `find -follow -type f` > md5sum.txt
chmod a-w md5sum.txt
)
#
chmod a+w isofiles/isolinux/isolinux.bin
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o debian-unattended.iso isofiles
# clean
chmod +w -R isofiles
rm -r isofiles

lsblk
read -rp "Plug in device, then press enter"
lsblk
read -rp "Which device? (/dev/???): " DEVICE
sudo cp debian-unattended.iso "$DEVICE"
echo "blocking until finished..."
sync
echo "copy complete!"
rm debian-unattended.iso