#!/usr/bin/env bash
find /var/log -type f -name '*log.[1-9].gz' -exec rm '{}' \; 2>> /var/log/src.log

