#!/bin/sh

set -e

# todo metrics like how many runs, how many failed, how many succeeded, avg runtime? idk!

command='laminarc queue adfasdf'
log="mylog"

while true; do
    start="$(date +%s)"

    exitcode=0
    $command || exitcode="$?"

    end="$(date +%s)"
    #echo $start $end $((end - start))

    time="$start"
    #todo report start or end time?
    #time="$end"

    # todo always log itself as having run
    # todo isn't this better off as grafana loki data???
    # these are literal job logs
    # not really metrics they do not change over time! they just happen!
    # a metric would be last run time for x job
    # https://cribl.io/blog/logs-events-metrics-and-traces-oh-my/
    # https://www.reddit.com/r/linuxadmin/comments/gh591f/comment/fq7rz44/?context=3
    cat << EOF >> "$log"
# seconds
cron_run{command="$command", exitcode="$exitcode", start="$start", end="$end"} "$time"
EOF

    sleep 1
done
