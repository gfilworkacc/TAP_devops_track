# Linux lab03 - extracting all upd services with debug string from /etc/services, formating them and output them to two files.

## Script content:

```bash
#!/usr/bin/env bash
grep -i "udp.*#.*debug"  /etc/services | awk '{print $2" "$1}' | tr -d /udp  > udp.debug && tail -n 2 udp.debug > udp.high
```

## udp.debug file content:

```bash
410 eclaebg
2159 gbremote
2293 nbgmngr
2576 tclroebgger
3563 watcomebg
3593 bm
4026 as-ebg
4867 nify-ebg
4869 hrelaybg
5364 knet
7606 mii-ebg
44553 rbr-ebg
```

## udp.high content:

```bash
7606 mii-ebg
44553 rbr-ebg
```
