#!/bin/bash

set -e
set -o pipefail

cleanup() {
    exitcode="$?"
    if [ "$exitcode" -eq 0 ]; then
        message='hooray! job success!'
    else
        message="looks like your program exited with a $exitcode"
        cow_flag='-d'
    fi
    printf '%s' \
        "$message" \
        | cowsay "$cow_flag" | lolcat --24bit --force-color
    echo -e "Click here for more information: \e]8;;https://www.example.com\ahttps://www.example.com\e]8;;\a"
}
trap cleanup EXIT

for i in {1..10}; do
    echo stdout $i
    echo stderr $i > /dev/stderr
    sleep .5
done

exit 0
# last grep should fail
nmap -p- nerd-vps.griffinht.com cat output | tee /dev/stderr | grep 'open' | (! grep -vE '(22|80|443)/tcp') | printf 'open ports:\n%s\n' "$(cat)"
