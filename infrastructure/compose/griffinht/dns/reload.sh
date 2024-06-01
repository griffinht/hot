#!/bin/sh

docker compose exec knot knotc -c /knot.conf reload
