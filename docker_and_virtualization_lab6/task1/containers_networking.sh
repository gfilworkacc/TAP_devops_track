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
			echo -e "\n===============================================================" >> "$0"_output
			echo -e "Ignoring ping request from alpine$c to alpine$d - same container." >> "$0"_output
			echo
			continue
		else
			if docker exec alpine"$c" ping -c 1 alpine"$d" &>/dev/null
			then
				echo -e "\n==================================================" >> "$0"_output
				echo -e "Container alpine$d is accessable from alpine$c. POC:\n" >> "$0"_output
				docker exec alpine"$c" ping -c 1 alpine"$d" 1>> "$0"_output
			else
				echo -e "\n======================================================" >> "$0"_output
				echo -e "Container alpine$d is NOT accessable from alpine$c. POC:\n" >> "$0"_output
				docker exec alpine"$c" ping -c 1 alpine"$d" 2>> "$0"_output
			fi
		fi
	done
done
