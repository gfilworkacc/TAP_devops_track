#!/usr/bin/env bash
grep -i "udp.*#.*debug"  /etc/services | awk '{print $2" "$1}' | tr -d /udp  > udp.debug && tail -n 2 udp.debug > udp.high
