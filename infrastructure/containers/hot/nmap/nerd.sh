#!/bin/bash

set -e
set -o pipefail

# last grep should fail
nmap -p- nerd-vps.griffinht.com cat output | tee /dev/stderr | grep 'open' | (! grep -vE '(22|80|443)/tcp') | printf 'open ports:\n%s\n' "$(cat)"
