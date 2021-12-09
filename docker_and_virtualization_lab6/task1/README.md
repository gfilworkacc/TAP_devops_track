# Docker and virtualization lab6 - task1

## Run script containers_networking.sh to generate all steps:

```bash
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
```

## Output:

```bash
2a012bda9425c86c0bcc074ea8177a79edc2cc5811aa3d36a5a8339b16f9ea19
32853ceaa8e0401e626322345d54285eedfb6e1366fd80c671b0337fe93609ca
f772a6359f6cbd7702868345b705221053a0c274ed78883a86bb348ba5226115
deeceb9de5de07690862daebcfb139ebea4bac03053887f41a43d33b5e6ea87f
501f4b8ab4104fc2d61a13429c883c96772f9b7d8194be414e1fb7e3b71e0cc2

Container alpine1 has the following IP addresses:
172.17.0.2
172.22.0.2

Container alpine2 has the following IP addresses:
172.17.0.3
172.22.0.3
172.23.0.2

Container alpine3 has the following IP addresses:
172.17.0.4
172.23.0.3
```
