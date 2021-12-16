# Linux lab 4: 
# Find all non-binary files in /etc which contain the string http, which are not exlusively of type ASCII text.<br/>
# Show the contents of the file with biggest size by replacing the 13th line with the string "linux is cool" on the stdout.<br/>
# * Note openssl and pgp-tools must be installed on the fedora container <br/>

## Script content:

```bash
#!/usr/bin/env bash
grep -irw http /etc 2>/dev/null | cut -d: -f1 | xargs file | sort -u | grep -E ", ASCII text" | cut -d: -f1 | xargs du -h | sort -k1h | tail -1 | awk '{print $2}' | xargs sed -e '13s/^\s*$/linux is cool/' | sed -n '13p'
```
