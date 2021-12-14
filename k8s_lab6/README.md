# K8s task 6 - create a job that spawns pods from a queue until it is empty.\nEach pod should echo a message.

## Yaml file content:

```bash
---
apiVersion: batch/v1
kind: Job
metadata:
  name: task-6-job
spec:
  completions: 10
  completionMode: Indexed
  template:
    metadata:
      name: task-6-job
    spec:
      containers:
      - name: task-6-job
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - echo Container is up on $(date +%d/%m/%Y) at $(date +%T).
      restartPolicy: Never
```

## Job description:

```bash
kubectl describe jobs.batch task-6-job
```

```bash
Name:               task-6-job
Namespace:          default
Selector:           controller-uid=0593c536-09df-4d3c-af07-2fccce2c2da7
Labels:             controller-uid=0593c536-09df-4d3c-af07-2fccce2c2da7
                    job-name=task-6-job
Annotations:        <none>
Parallelism:        1
Completions:        10
Completion Mode:    Indexed
Start Time:         Tue, 14 Dec 2021 14:36:41 +0200
Completed At:       Tue, 14 Dec 2021 14:36:55 +0200
Duration:           14s
Pods Statuses:      0 Active / 10 Succeeded / 0 Failed
Completed Indexes:  0-9
Pod Template:
  Labels:  controller-uid=0593c536-09df-4d3c-af07-2fccce2c2da7
           job-name=task-6-job
  Containers:
   task-6-job:
    Image:      busybox:stable
    Port:       <none>
    Host Port:  <none>
    Command:
      /bin/sh
      -c
    Args:
      echo Container is up on $(date +%d/%m/%Y) at $(date +%T).
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From            Message
  ----    ------            ----  ----            -------
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-0-4fhx6
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-1-rqgjl
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-2-dg9d6
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-3-g27kx
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-4-zk92w
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-5-lwpjx
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-6-pbnsp
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-7-g57jw
  Normal  SuccessfulCreate  17m   job-controller  Created pod: task-6-job-8-whkqh
  Normal  SuccessfulCreate  16m   job-controller  (combined from similar events): Created pod: task-6-job-9-wlx64
  Normal  Completed         16m   job-controller  Job completed
```

## Output:

```bash
for pod in $(kubectl get pods | awk 'NR > 1 {print $1}');do kubectl logs $pod;done
```

```bash
Container is up on 14/12/2021 at 12:36:42.
Container is up on 14/12/2021 at 12:36:44.
Container is up on 14/12/2021 at 12:36:45.
Container is up on 14/12/2021 at 12:36:46.
Container is up on 14/12/2021 at 12:36:47.
Container is up on 14/12/2021 at 12:36:48.
Container is up on 14/12/2021 at 12:36:50.
Container is up on 14/12/2021 at 12:36:51.
Container is up on 14/12/2021 at 12:36:53.
Container is up on 14/12/2021 at 12:36:55.
```
