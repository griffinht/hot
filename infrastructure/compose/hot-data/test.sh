#!/bin/sh

# guix shell samba -- test.sh
echo 'this was generated by a test script to test if file create permissions are working - griffin did this' > 'test'

# --password='' 
smbclient \
    -N \
    //hot-data.lan.hot.griffinht.com/anything -c "put test test"
