#!/bin/sh

set -e

cleanup() {
    echo exit code $?
}
trap cleanup EXIT

host="${CI_HOST:-localhost:8000}"
url="$host/cgi-bin"

run() {
    curl \
        -s \
        -X POST \
        --data-binary @- \
        "$url/run"
}

#job="$(run < bruh)"

job="$(run << EOF
#!/bin/sh

set -xe

/ci/nerd.sh
EOF
)"

abort() {
    echo "$job" | curl \
        -X POST \
        -d @- \
        -s -N \
        "$url/abort"
    # todo is this correct?
    wait
    #exit "$?"
}
# todo make sure this triggers on laminar abort
trap abort INT
#trap abort HUP
#trap abort EXIT

log() {
    stream="$1"
    echo "$job" | curl \
        -X POST \
        -d @- \
        -s -N \
        "$url/log?$stream"
}

log "stdout" &
pid="$!"
log "stderr" > /dev/stderr
wait "$pid"

finish() {
    echo "$job" | curl \
        -s \
        -X POST \
        -d @- \
        "$url/finish"
}
exit "$(finish)"
