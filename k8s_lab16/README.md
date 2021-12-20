# K8s task 16: Do the same tasks (as task 15) but create a secret instead of configmap this time.<br/>

## Bash script content:

```bash
#!/usr/bin/env bash
while true
do
	sleep 5
	ping -c 5 "$MY_HOST"
done
```

## Dockerfile content:

```bash
FROM bash

WORKDIR /script

COPY loop-script.sh /script

RUN chmod a+x /script/loop-script.sh

CMD ["bash", "/script/loop-script.sh"]
```

## Tag and push the image to the repository:

```bash
docker tag task-15:latest agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
docker push agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
```

## Secret file content:

```bash
apiVersion: v1
kind: Secret
metadata:
  name: task-16
  namespace: task-16
type: Opaque
stringData:
  MY_HOST: google.com
```

## Config values as environment variable - yaml file content: 

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: task-16
---
apiVersion: v1
kind: Pod
metadata:
  name: task-16a
  namespace: task-16
spec:
  containers:
    - name: task-16a
      image: agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
      env:
        - name: MY_HOST
          valueFrom:
            secretKeyRef:
              name: task-16
              key: MY_HOST
      command: ["bash", "-c"]
      args: ["export MY_HOST=$MY_HOST && /script/loop-script.sh"]
```

## Results from the log file:

```bash
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=3.153 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=2.376 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=5.232 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=2.100 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=2.026 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 2.026/2.977/5.232 ms
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=2.106 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=3.357 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=4.448 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=3.272 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=1.903 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 1.903/3.017/4.448 ms
```

## Showing the environment variable and ping results:

```bash
MY_HOST=google.com

PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=5.741 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=2.825 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=3.240 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=2.386 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=2.065 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 2.065/3.251/5.741 ms
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=5.994 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=1.968 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=5.515 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=1.911 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=2.070 ms
```

## Mounting the secret inside the pod - yaml file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: task-16
---
apiVersion: v1
kind: Pod
metadata:
  name: task-16b
  namespace: task-16
spec:
  containers:
    - name: task-16b
      image: agw7uwh2tivf45vcjrb9vmoeog/task-15:latest
      command: ["bash", "-c"]
      args: ["export MY_HOST=$(cat /root/config/MY_HOST) && /script/loop-script.sh"]
      volumeMounts:
        - name: config
          mountPath: "/root/config/"
          readOnly: true
  volumes:
  - name: config
    secret:
      secretName: task-16
```

## Results:

```bash
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=5.048 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=2.691 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=1.828 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=2.623 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=4.910 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 1.828/3.420/5.048 ms
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=1.923 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=1.899 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=2.330 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=3.101 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=1.894 ms
```

## Showing the environment variable and ping results:

```bash
MY_HOST=google.com

PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=1.903 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=2.303 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=4.095 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=2.343 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=3.450 ms

--- google.com ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 1.903/2.818/4.095 ms
PING google.com (172.217.169.206): 56 data bytes
64 bytes from 172.217.169.206: seq=0 ttl=116 time=4.533 ms
64 bytes from 172.217.169.206: seq=1 ttl=116 time=3.490 ms
64 bytes from 172.217.169.206: seq=2 ttl=116 time=5.628 ms
64 bytes from 172.217.169.206: seq=3 ttl=116 time=7.172 ms
64 bytes from 172.217.169.206: seq=4 ttl=116 time=3.862 ms
```
