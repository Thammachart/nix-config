#!/bin/sh
while true
do
    date_and_time="$(date +'%Y-%m-%d %I:%M:%S')"
    printf "%s\n" "$date_and_time"
    sleep 30
done