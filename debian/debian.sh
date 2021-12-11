#!/bin/bash
set -e
#https://wiki.debian.org/DebianInstaller/Preseed/EditIso
curl https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso -C - -Lo debian.iso

sudo apt-get -y install xorriso genisoimage isolinux

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
chmod +w md5sum.txt
find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
chmod -w md5sum.txt
)
#
xorriso -as mkisofs -o debian-unattended.iso -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table isofiles
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