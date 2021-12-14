# K8s task 5 - cron job that prints hello and time every minute: 

## Yaml configuration:

```bash
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cron-job-server
  end:
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cron-job-server
            image: alpine
            command: ["/bin/sh"]
            args: 
            - -c
            - echo Hello from the cron-job-server, the time is $(date +%T).
          restartPolicy: Never
```

## Output:

```bash
kubectl logs cron-job-server-27324573--1-trs27
```

```bash
Hello from the cron-job-server, the time is 09:33:02.
```

## Removing the cronjob:

```bash
kubectl delete cronjobs.batch cron-job-server
```
