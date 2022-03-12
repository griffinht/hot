#!/bin/sh

$(curl https://am.i.mullvad.net/json | jq .mullvad_exit_ip)

