# K8s task 15:<br/>
# 1. Create a bash script that sleeps for 5 seconds in a loop but between every new cycle it pings 5 times the environment variable MY_HOST.<br/>
# 2. Create a Docker image from bash<br/>
# 3. Copy the bash script in the Dockerfile and execute it on runtime<br/>
# 4. Push the image to docker hub<br/>
# 5. Create a configmap that stores the MY_HOST variable and the value is: google.com<br/>
# 6. Create a pod.yaml that runs the image from docker hub<br/>
# 7/a. First scenario: Use configmap values as envirionment variable on the pod<br/>
# 7/b. Second scenario: Mount the configmap inside the pod<br/>
# 8. Run the pod and monitor the logs, do you see pinging google every 5 seconds?<br/>
# 9. Edit the file pod.yaml to run the command printenv to display the value of environment variable MY_HOST using command field<br/>
# 10. Run the pod again and monitor the logs, do you see the pod pinging google every 5 seconds or printing environment variable MY_HOST value? Why?"<br/>

## Step 1 - script content:

```bash
#!/usr/bin/env bash
while true
do
	sleep 5
	ping -c 5 "$MY_HOST"
done
```

## Steps 2 and 3 - Dockerfile content:

```bash
FROM bash

WORKDIR /script

COPY loop-script.sh /script

RUN chmod a+x /script/loop-script.sh

CMD ["bash", "/script/loop-script.sh"]
```

## Step 4 - tag and push the image to the repository:

```bash
docker tag task-15:latest agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
docker push agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
```

## Steps from 5 to 7a - yaml file content: 

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: task-15
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: task-15
  namespace: task-15
data:
  MY_HOST: "google.com"
---
apiVersion: v1
kind: Pod
metadata:
  name: task-15a
  namespace: task-15
spec:
  containers:
    - name: task-15
      image: agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
      env:
        - name: MY_HOST
          valueFrom:
            configMapKeyRef:
              name: task-15
              key: MY_HOST
      command: ["bash", "-c"]
      args: ["export MY_HOST=$MY_HOST && /script/loop-script.sh"]
```

## Results from step 8:

```bash
PING google.com (172.217.169.142): 56 data bytes
64 bytes from 172.217.169.142: seq=0 ttl=115 time=2.205 ms
64 bytes from 172.217.169.142: seq=1 ttl=115 time=2.808 ms
64 bytes from 172.217.169.142: seq=2 ttl=115 time=2.803 ms
64 bytes from 172.217.169.142: seq=3 ttl=115 time=2.936 ms
64 bytes from 172.217.169.142: seq=4 ttl=115 time=2.587 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 2.205/2.667/2.936 ms
PING google.com (172.217.169.142): 56 data bytes
64 bytes from 172.217.169.142: seq=0 ttl=115 time=2.596 ms
64 bytes from 172.217.169.142: seq=1 ttl=115 time=8.053 ms
64 bytes from 172.217.169.142: seq=2 ttl=115 time=3.061 ms
64 bytes from 172.217.169.142: seq=3 ttl=115 time=3.117 ms
64 bytes from 172.217.169.142: seq=4 ttl=115 time=2.330 ms
```

## Results from step 9 and 10

```bash
MY_HOST=google.com

PING google.com (142.250.187.174): 56 data bytes
64 bytes from 142.250.187.174: seq=0 ttl=116 time=2.103 ms
64 bytes from 142.250.187.174: seq=1 ttl=116 time=2.273 ms
64 bytes from 142.250.187.174: seq=2 ttl=116 time=2.528 ms
64 bytes from 142.250.187.174: seq=3 ttl=116 time=2.733 ms
64 bytes from 142.250.187.174: seq=4 ttl=116 time=2.690 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 2.103/2.465/2.733 ms
PING google.com (172.217.169.110): 56 data bytes
64 bytes from 172.217.169.110: seq=0 ttl=115 time=2.010 ms
64 bytes from 172.217.169.110: seq=1 ttl=115 time=3.080 ms
64 bytes from 172.217.169.110: seq=2 ttl=115 time=2.607 ms
64 bytes from 172.217.169.110: seq=3 ttl=115 time=2.713 ms
64 bytes from 172.217.169.110: seq=4 ttl=115 time=2.805 ms
```

## Step 7b - yaml file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: task-15
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: task-15
  namespace: task-15
data:
  MY_HOST: "google.com"
---
apiVersion: v1
kind: Pod
metadata:
  name: task-15b
  namespace: task-15
spec:
  containers:
    - name: task-15b
      image: agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
      command: ["bash", "-c"]
      args: ["export MY_HOST=$(cat /root/config/MY_HOST) && /script/loop-script.sh"]
      volumeMounts:
        - name: config
          mountPath: "/root/config/"
          readOnly: true
  volumes:
  - name: config
    configMap:
      name: task-15
```

## Results from step 8:

```bash
PING google.com (142.250.184.142): 56 data bytes
64 bytes from 142.250.184.142: seq=0 ttl=116 time=1.947 ms
64 bytes from 142.250.184.142: seq=1 ttl=116 time=2.243 ms
64 bytes from 142.250.184.142: seq=2 ttl=116 time=2.518 ms
64 bytes from 142.250.184.142: seq=3 ttl=116 time=2.515 ms
64 bytes from 142.250.184.142: seq=4 ttl=116 time=3.092 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 1.947/2.463/3.092 ms
PING google.com (142.250.184.142): 56 data bytes
64 bytes from 142.250.184.142: seq=0 ttl=116 time=2.095 ms
64 bytes from 142.250.184.142: seq=1 ttl=116 time=2.300 ms
64 bytes from 142.250.184.142: seq=2 ttl=116 time=2.691 ms
64 bytes from 142.250.184.142: seq=3 ttl=116 time=2.567 ms
64 bytes from 142.250.184.142: seq=4 ttl=116 time=2.847 ms
```

## Results from step 9 and 10:

```bash
MY_HOST=google.com

PING google.com (142.250.187.142): 56 data bytes
64 bytes from 142.250.187.142: seq=0 ttl=116 time=12.104 ms
64 bytes from 142.250.187.142: seq=1 ttl=116 time=2.819 ms
64 bytes from 142.250.187.142: seq=2 ttl=116 time=2.939 ms
64 bytes from 142.250.187.142: seq=3 ttl=116 time=2.545 ms
64 bytes from 142.250.187.142: seq=4 ttl=116 time=2.956 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 2.545/4.672/12.104 ms
PING google.com (142.250.187.142): 56 data bytes
64 bytes from 142.250.187.142: seq=0 ttl=116 time=2.668 ms
64 bytes from 142.250.187.142: seq=1 ttl=116 time=3.390 ms
64 bytes from 142.250.187.142: seq=2 ttl=116 time=2.576 ms
64 bytes from 142.250.187.142: seq=3 ttl=116 time=2.233 ms
64 bytes from 142.250.187.142: seq=4 ttl=116 time=2.549 ms
```
