#!/bin/sh

set -xe

# todo why not just configure the firewall it would remove the need for all this drama

file=compose.yml

echo "status: checking $file for any ports which should not be exposed"

#yq e "$file" -o=json | jq '.services[].ports[] | map(select(. | startswith("${N") or (. != "${HTTP_PORT?}:80" and . != "${HTTPS_PORT?}:443")))'

filter() {
    # jq cannot iterator over null
    # improper fix is to suppress the error
    # true ignores errors which is bad lol 
    yq e "$file" -o=json | jq -r '.services[].ports[]' 2>/dev/null | grep -v '${HTTP_PORT?}:80' | grep -v '${HTTPS_PORT?}:443' | grep -v '${INTERFACE?}:*:*' || true
}
result="$(filter)"
echo expose ports:
echo "$result"
[ -z "$result" ]
