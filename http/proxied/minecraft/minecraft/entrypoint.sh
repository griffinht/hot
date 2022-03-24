#!/bin/sh

web() {
    if [ -z "$WEB_BASE_PATH" ]; then WEB_BASE_PATH='/'; fi
    if [ -z "$WEB_PORT" ]; then WEB_PORT='80'; fi
    
    echo "starting ttyd in background on WEB_PORT=$WEB_PORT with WEB_BASE_PATH=$WEB_BASE_PATH"

    # run ttyd in background with bash (because it has command history and stuff)
    ttyd --base-path "$WEB_BASE_PATH" --port "$WEB_PORT" rcon-cli &
}

if [ -z "$WEB" ]; then web; fi

# minecraft servers will not shutdown gracefully with unix signals, so we need to gracefully shutdown ourselves by sending the minecraft stop command via rcon

stop() {
    echo "$(date) shutting down gracefully..." >> docker_log
    echo 'gracefully shutting down minecraft server'
    
    echo 'running stop command via rcon'
    # this returns immediately after the command is run
    rcon-cli stop
    echo "$(date) waiting on minecraft server to shutdown with PID=$1" >> docker_log
    
    # we still need to wait for the server to gracefully shutdown
    echo "waiting on minecraft server to shutdown with PID=$1"
    wait "$1"
    
    echo "done"
    echo "$(date) shut down gracefully" >> docker_log
}

# run server in background - it won't handle SIGTERM properly so we handle it below
java \
-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
 -jar /usr/local/bin/server.jar nogui &
 
# docker will send a SIGTERM to PID=1 when it is time to stop
trap "stop $!" SIGTERM

echo "$(date) server started, script waiting" >> docker_log

# stay busy while waiting for signal
# https://stackoverflow.com/a/21882119/11975214
# https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86#.6b04xvnr8
tail -f /dev/null & wait

echo "$(date) script stopped, server should have shut down gracefully" >> docker_log
