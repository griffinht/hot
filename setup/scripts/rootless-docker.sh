#!/bin/bash


apt-get install -y uidmap

if dpkg -l slirp4netns; then
  echo warning: manually installing optional package slirp4netns because it was not already installed
  apt-get install -y slirp4netns
fi

if dpkg -l dbus-user-session; then
  echo error: dbus-user-session not installed
  echo this should be installed manually, and might require a restart
  exit 1;
fi