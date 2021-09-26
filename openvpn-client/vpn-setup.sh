#!/bin/bash

# $1 = .conf or .ovpn file path
# $2 = username
# $3 = password

if [ -d vpn ]; then
  echo "directory vpn already exists"
  exit 1
fi

if [ -f vpn ]; then
  echo "file vpn already exists (should be a directory, will be created by this script)";
  exit 1
fi

mkdir vpn
mv "$1" vpn/vpn.conf
sed -i /auth-user-pass/d vpn/vpn.conf
printf "auth-user-pass auth" >> vpn/vpn.conf
printf "$2\n$3\n" > vpn/auth
