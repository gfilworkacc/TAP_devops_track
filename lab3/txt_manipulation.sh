#!/usr/bin/env bash

/bin/grep -i "#*debug" /etc/services | /bin/grep udp | /bin/awk '{print $2" "$1}' | /bin/tr -d '/udp' > /root/udp.debug

/bin/sort -rn udp.debug | /bin/head -2 > /root/udp.high

/bin/cat /root/udp.high
