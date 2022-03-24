#!/bin/sh

function web {
    if [ -z "$WEB_BASE_PATH" ]; then WEB_BASE_PATH='/'; fi
    if [ -z "$WEB_PORT" ]; then WEB_PORT='80'; fi
    
    echo "starting ttyd in background on WEB_PORT=$WEB_PORT with WEB_BASE_PATH=$WEB_BASE_PATH"

    # run ttyd in background
    ttyd --base-path "$WEB_BASE_PATH" --port "$WEB_PORT" rcon-cli &
}

if [ -z "$WEB" ]; then web; fi

# run server
java \
-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
 -jar /usr/local/bin/server.jar nogui
