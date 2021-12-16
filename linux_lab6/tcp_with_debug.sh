#!/usr/bin/env bash
grep "^[a-z-]*debug[a-z]*" /etc/services | grep -i "# .*debug" | grep tcp > /root/tcp.debug
