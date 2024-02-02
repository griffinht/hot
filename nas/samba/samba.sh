#!/bin/sh

set -xe

mkdir -p /var/lib/samba
mkdir -p /var/lib/samba/private
mkdir -p /var/run/samba
mkdir -p /var/log/samba
#mkdir -p samba
#mkdir -p samba/private

config='smb.conf'

/bin/sh
exit 1

cat > "$config" << EOF
[global]
default service = share
lock directory = /var/lib/samba/lock
guest account = "$USER"
#smb ports = 4445 1399

[share]
path = /bruh
#browseable = yes
guest ok = yes
#writable = yes
read only = no
#valid users = griffin
EOF

exec smbd --foreground --debug-stdout --configfile="$config" "$@"
