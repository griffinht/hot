#!/bin/sh

LIBVIRT_LOG_OUTPUTS='1:syslog:my_libvirt' libvirtd --daemon
