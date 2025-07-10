#!/bin/bash

if pgrep -x "gammastep" >/dev/null; then
    echo '{"text":"🌕","tooltip":"Night Light ON (3500K)","class":"enabled"}'
else
    echo '{"text":"🌑","tooltip":"Night Light OFF","class":"disabled"}'
fi
