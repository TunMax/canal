#!/bin/bash

nohup /usr/bin/warp-svc > /app/warp.log &

sleep 5

warp-cli --accept-tos registration new
warp-cli --accept-tos mode proxy
warp-cli --accept-tos connect

if [ -n "$SOCKS5_MODE" ]; then
    /app/gost -L tcp://:1080/127.0.0.1:40000 -L udp://:1080/127.0.0.1:40000
else
    /app/gost -L http://:1080 -F socks5://127.0.0.1:40000
fi