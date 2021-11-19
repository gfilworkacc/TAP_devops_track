#!/usr/bin/env bash
grep -irw http /etc 2>/dev/null | cut -d: -f1 | xargs file | sort -u | grep -E ", ASCII text" | cut -d: -f1 | xargs du -h | sort -k1h | tail -1 | awk '{print $2}' | xargs sed -e '13s/^\s*$/linux is cool/' | sed -n '13p'
