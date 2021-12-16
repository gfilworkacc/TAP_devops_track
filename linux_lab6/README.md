# Linux lab 6:
# Extract all tcp-based services from /etc/services which contain debug both in the service name and in the comment and put them in a file called tcp.debug.<br/>

## Script content:

```bash
#!/usr/bin/env bash
grep -i ^[a-z-]*debug.*/tcp.*#.*debug /etc/services > tcp.debug
```

## Result:

```bash
decladebug      410/tcp                 # DECLadebug Remote Debug Protocol
tclprodebugger  2576/tcp                # TCL Pro Debugger
watcomdebug     3563/tcp                # Watcom Debug
as-debug        4026/tcp                # Graphical Debug Server
unify-debug     4867/tcp                # Unify Debugger
mipi-debug      7606/tcp                # MIPI Alliance Debug
rbr-debug       44553/tcp               # REALbasic Remote Debug
```
