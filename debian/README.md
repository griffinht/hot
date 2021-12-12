#debian

## Provide preseed file via network
### Start http server with preseed file
Run these commands from this current working directory
```
sed -i 's/HOST/192.168.0.123/g' html/preseed
docker run -v "$(pwd)"/html:/usr/share/nginx/html/ -p 8080:80 nginx
```
## Install debian
### Prepare USB drive with installation
```
curl https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso
sudo cp debian.iso /dev/sdx (check lsblk for devices)
```
Plug in to the new computer, and boot to the USB drive

From installer menu:
- Advanced options > Automated install
- (wait for network configuration)
- enter location of preseed when prompted (`http://192.168.0.123/preseed` assuming you are running the http server)