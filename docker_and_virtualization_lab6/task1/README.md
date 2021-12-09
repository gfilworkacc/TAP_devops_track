# Docker and virtualization lab6 - task1

## Run script containers_networking.sh to generate all steps:
```bash
#!/usr/bin/env bash

#Create bridge networks

for n in 1 2
do
	docker network create net"$n"
done

#Create 3 containers based on alpine

for c in 1 2 3
do
	docker run --name alpine"$c" -dit alpine:latest 
done

#Connect containers to the networks

for c in 1 2
do
	docker network connect net1 alpine"$c" 
done

for c in 2 3
do
	docker network connect net2 alpine"$c" 
done

#Check connectivity between containers and output to file

for c in 1 2 3
do
	for d in 1 2 3
	do
		if [[ "$c" -eq "$d" ]]
		then
			echo "Ignoring ping request from alpine$c to alpine$d - same container." >> "$0"_output
			echo
			continue
		else
			if docker exec alpine"$c" ping -c 1 alpine"$d" &>/dev/null
			then
				echo -e "\nContainer alpine$d is accessable from alpine$c. POC:\n" >> "$0"_output
				docker exec alpine"$c" ping -c 1 alpine"$d" 1>> "$0"_output
			else
				echo -e "\nContainer alpine$d is NOT accessable from alpine$c. POC:\n" >> "$0"_output
				docker exec alpine"$c" ping -c 1 alpine"$d" 2>> "$0"_output
			fi
		fi
	done
done
```

## Output:

```bash
===============================================================
Ignoring ping request from alpine1 to alpine1 - same container.

==================================================
Container alpine2 is accessable from alpine1. POC:

PING alpine2 (192.168.80.3): 56 data bytes
64 bytes from 192.168.80.3: seq=0 ttl=64 time=0.084 ms

--- alpine2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.084/0.084/0.084 ms

======================================================
Container alpine3 is NOT accessable from alpine1. POC:

ping: bad address 'alpine3'

==================================================
Container alpine1 is accessable from alpine2. POC:

PING alpine1 (192.168.80.2): 56 data bytes
64 bytes from 192.168.80.2: seq=0 ttl=64 time=0.080 ms

--- alpine1 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.080/0.080/0.080 ms

===============================================================
Ignoring ping request from alpine2 to alpine2 - same container.

==================================================
Container alpine3 is accessable from alpine2. POC:

PING alpine3 (192.168.96.3): 56 data bytes
64 bytes from 192.168.96.3: seq=0 ttl=64 time=0.085 ms

--- alpine3 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.085/0.085/0.085 ms

======================================================
Container alpine1 is NOT accessable from alpine3. POC:

ping: bad address 'alpine1'

==================================================
Container alpine2 is accessable from alpine3. POC:

PING alpine2 (192.168.96.2): 56 data bytes
64 bytes from 192.168.96.2: seq=0 ttl=64 time=0.071 ms

--- alpine2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.071/0.071/0.071 ms

===============================================================
Ignoring ping request from alpine3 to alpine3 - same container.
```
