#!/bin/sh

# curl -d 'asdasdfasdfasdfafd' localhost:9199/alert
curl -H 'Content-Type: application/json' \
    -d '[{"labels":{"alertname":"test-alert"}}]' \
    -i \
    http://localhost:9093/api/v2/alerts
