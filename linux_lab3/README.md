# Linux lab 3:
# Extract all udp-type services from /etc/services which contain in some form the word "debug" in their comments.<br/>
# Create a new file from such services with format \<svc-port> \<svc-name> with the name udp.debug. <br/>
# Put the two services with the highest port number in a new file called udp.high.<br/>

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
