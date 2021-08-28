#!/bin/bash

mkdir vpn
mv "$1" vpn/vpn.conf
sed -i /auth-user-pass/d vpn/vpn.conf
printf "auth-user-pass auth" >> vpn/vpn.conf
printf "$2\n$3\n" > vpn/auth
