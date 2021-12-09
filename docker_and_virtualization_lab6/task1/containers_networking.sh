#!/usr/bin/env bash

#Arrays
containers=(alpine1 alpine2 alpine3)
networks=(net1 net2)

#Create bridge networks
for net in "${networks[@]}"
do
	docker network create "$net"
done

#Create 3 containers based on alpine
for name in ${containers[@]}
do
	docker run --name "$name" -dit alpine:latest 
done

#Connect containers to the networks
for name in ${containers[@]:0:2}
do
	docker network connect ${networks[0]} "$name"
done

for name in ${containers[@]:1:2}
do
	docker network connect ${networks[1]} "$name"
done

#IP addresses
echo
for id in 1 2 3 
	do
		echo "Container alpine"$id" has the following IP addresses:" 
		docker container inspect alpine"$id" | jq ' .[].NetworkSettings.Networks | .bridge.IPAddress, .net1.IPAddress, .net2.IPAddress' | sed -e 's/"//g' -e 's/null//g' -e' /^$/d'
		echo
	done
