user=libvirt
host=hot-desktop.lan.hot.griffinht.com

scp -r libvirtd.conf "$user@$host:/home/$user/.config/libvirt/libvirtd.conf"
