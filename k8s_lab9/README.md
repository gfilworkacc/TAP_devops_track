# K8s task 9: <br/>
# Create a Pod that attempts to allocate more memory than its limit <br/>
# * Use the namespace <br/>
# * Configure request of 50MiB and limit of 100MiB <br/>
# * With polinux/stress image try to allocate 250MiB of memory <br/>
#   * stress --vm 1 --vm-bytes 250M --vm-hang 1 <br/>
# * Check the details of the pod <br/>

## Yaml configuration file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: lab9-pod
  labels:
    name: lab9-pod
---
apiVersion: v1
kind: Pod
metadata:
  name: lab9-pod
spec:
  containers:
  - name: lab9-pod
    image: polinux/stress
    resources:
      requests:
        memory: "50Mi"
      limits:
        memory: "100Mi"
    command: ["/usr/local/bin/stress"]
    args: ["--vm", "1", "--vm-bytes", "250Mi", "--vm-hang", "1"]
  restartPolicy: Never
```

## Execution and results:

```bash
kubectl apply -f pod_mem_2.yaml -n=lab9-pod
```

```bash
kubectl get pods/lab9-pod -n=lab9-pod -o json
```

The container is terminated with an error:

```bash
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"name\":\"lab9-pod\",\"namespace\":\"lab9-pod\"},\"spec\":{\"containers\":[{\"args\":[\"--vm\",\"1\",\"--vm-bytes\",\"250M\",\"--vm-hang\",\"1\",\"--verbose\"],\"command\":[\"/usr/local/bin/stress\"],\"image\":\"polinux/stress\",\"name\":\"lab9-pod\",\"resources\":{\"limits\":{\"memory\":\"100Mi\"},\"requests\":{\"memory\":\"50Mi\"}}}],\"restartPolicy\":\"Never\"}}\n"
        },
        "creationTimestamp": "2021-12-15T13:24:01Z",
        "name": "lab9-pod",
        "namespace": "lab9-pod",
        "resourceVersion": "62594",
        "uid": "2b65d285-eb29-46a6-be9c-7e7bd5d737b2"
    },
    "spec": {
        "containers": [
            {
                "args": [
                    "--vm",
                    "1",
                    "--vm-bytes",
                    "250M",
                    "--vm-hang",
                    "1",
                    "--verbose"
                ],
                "command": [
                    "/usr/local/bin/stress"
                ],
                "image": "polinux/stress",
                "imagePullPolicy": "Always",
                "name": "lab9-pod",
                "resources": {
                    "limits": {
                        "memory": "100Mi"
                    },
                    "requests": {
                        "memory": "50Mi"
                    }
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "kube-api-access-ft2ld",
                        "readOnly": true
                    }
                ]
            }
        ],
        "dnsPolicy": "ClusterFirst",
        "enableServiceLinks": true,
        "nodeName": "minikube",
        "preemptionPolicy": "PreemptLowerPriority",
        "priority": 0,
        "restartPolicy": "Never",
        "schedulerName": "default-scheduler",
        "securityContext": {},
        "serviceAccount": "default",
        "serviceAccountName": "default",
        "terminationGracePeriodSeconds": 30,
        "tolerations": [
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/not-ready",
                "operator": "Exists",
                "tolerationSeconds": 300
            },
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/unreachable",
                "operator": "Exists",
                "tolerationSeconds": 300
            }
        ],
        "volumes": [
            {
                "name": "kube-api-access-ft2ld",
                "projected": {
                    "defaultMode": 420,
                    "sources": [
                        {
                            "serviceAccountToken": {
                                "expirationSeconds": 3607,
                                "path": "token"
                            }
                        },
                        {
                            "configMap": {
                                "items": [
                                    {
                                        "key": "ca.crt",
                                        "path": "ca.crt"
                                    }
                                ],
                                "name": "kube-root-ca.crt"
                            }
                        },
                        {
                            "downwardAPI": {
                                "items": [
                                    {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        },
                                        "path": "namespace"
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    },
    "status": {
        "conditions": [
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:24:01Z",
                "status": "True",
                "type": "Initialized"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:24:01Z",
                "message": "containers with unready status: [lab9-pod]",
                "reason": "ContainersNotReady",
                "status": "False",
                "type": "Ready"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:24:01Z",
                "message": "containers with unready status: [lab9-pod]",
                "reason": "ContainersNotReady",
                "status": "False",
                "type": "ContainersReady"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:24:01Z",
                "status": "True",
                "type": "PodScheduled"
            }
        ],
        "containerStatuses": [
            {
                "containerID": "docker://b7a406b54cf598253e42875fa77f41ccfb02a75246a585f6aee8c89e37bb2bf1",
                "image": "polinux/stress:latest",
                "imageID": "docker-pullable://polinux/stress@sha256:b6144f84f9c15dac80deb48d3a646b55c7043ab1d83ea0a697c09097aaad21aa",
                "lastState": {},
                "name": "lab9-pod",
                "ready": false,
                "restartCount": 0,
                "started": false,
                "state": {
                    "terminated": {
                        "containerID": "docker://b7a406b54cf598253e42875fa77f41ccfb02a75246a585f6aee8c89e37bb2bf1",
                        "exitCode": 1,
                        "finishedAt": "2021-12-15T13:24:04Z",
                        "reason": "Error",
                        "startedAt": "2021-12-15T13:24:04Z"
                    }
                }
            }
        ],
        "hostIP": "192.168.49.2",
        "phase": "Failed",
        "podIP": "172.17.0.3",
        "podIPs": [
            {
                "ip": "172.17.0.3"
            }
        ],
        "qosClass": "Burstable",
        "startTime": "2021-12-15T13:24:01Z"
    }
}
```

Reading the logs:

```bash
kubectl logs lab9-pod -n=lab9-pod
```

```bash
stress: info: [1] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
stress: dbug: [1] using backoff sleep of 3000us
stress: dbug: [1] --> hogvm worker 1 [7] forked
stress: dbug: [7] allocating 262144000 bytes ...
stress: dbug: [7] touching bytes in strides of 4096 bytes ...
stress: FAIL: [1] (415) <-- worker 7 got signal 9
stress: WARN: [1] (417) now reaping child worker processes
stress: FAIL: [1] (421) kill error: No such process
stress: FAIL: [1] (451) failed run completed in 0s
```
