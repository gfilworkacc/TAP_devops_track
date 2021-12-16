#!/usr/bin/env bash
grep -i ^[a-z-]*debug.*/tcp.*#.*debug /etc/services > tcp.debug
