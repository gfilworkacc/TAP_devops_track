# K8s task 10: <br/>
# Create a Pod with CPU limit and request in a separate namespace <br/>
# * Create a namespace <br/>
# * Configure CPU request of 0.5 and limit of 1 <br/>
# * With vish/stress image try to use 2 CPUs <br/>
#   * -cpus "2" <br/>
# * Check the details of the pod <br/>
# * Fetch the metrics for the pod <br/>

## Yaml configuration file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: lab10-pod
  labels:
    name: lab10-pod
---
apiVersion: v1
kind: Pod
metadata:
  name: lab10-pod
spec:
  containers:
  - name: lab10-pod
    image: vish/stress
    resources:
      requests:
        memory: "100Mi"
        cpu: "0.5"
      limits:
        cpu: "1"
        memory: "200Mi"
        #command: ["/stress"]
    args: ["-cpus", "2"]
  restartPolicy: Never
```

## Pod's details:

```bash
kubectl get -n lab10-pod pod lab10-pod -o json
```

```bash
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"name\":\"lab10-pod\",\"namespace\":\"lab10-pod\"},\"spec\":{\"containers\":[{\"args\":[\"-cpus\",\"2\"],\"image\":\"vish/stress\",\"name\":\"lab10-pod\",\"resources\":{\"limits\":{\"cpu\":\"1\",\"memory\":\"200Mi\"},\"requests\":{\"cpu\":\"0.5\",\"memory\":\"100Mi\"}}}],\"restartPolicy\":\"Never\"}}\n"
        },
        "creationTimestamp": "2021-12-15T13:53:35Z",
        "name": "lab10-pod",
        "namespace": "lab10-pod",
        "resourceVersion": "63880",
        "uid": "6dfc7b39-ebd4-499d-b163-867677adfd2f"
    },
    "spec": {
        "containers": [
            {
                "args": [
                    "-cpus",
                    "2"
                ],
                "image": "vish/stress",
                "imagePullPolicy": "Always",
                "name": "lab10-pod",
                "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "200Mi"
                    },
                    "requests": {
                        "cpu": "500m",
                        "memory": "100Mi"
                    }
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "kube-api-access-7vrm9",
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
                "name": "kube-api-access-7vrm9",
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
                "lastTransitionTime": "2021-12-15T13:53:35Z",
                "status": "True",
                "type": "Initialized"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:53:37Z",
                "status": "True",
                "type": "Ready"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:53:37Z",
                "status": "True",
                "type": "ContainersReady"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2021-12-15T13:53:35Z",
                "status": "True",
                "type": "PodScheduled"
            }
        ],
        "containerStatuses": [
            {
                "containerID": "docker://77b846a0b6feac5353d7894929f42a440fd1ad0e9466c147d9bb6b649323d494",
                "image": "vish/stress:latest",
                "imageID": "docker-pullable://vish/stress@sha256:b6456a3df6db5e063e1783153627947484a3db387be99e49708c70a9a15e7177",
                "lastState": {},
                "name": "lab10-pod",
                "ready": true,
                "restartCount": 0,
                "started": true,
                "state": {
                    "running": {
                        "startedAt": "2021-12-15T13:53:37Z"
                    }
                }
            }
        ],
        "hostIP": "192.168.49.2",
        "phase": "Running",
        "podIP": "172.17.0.3",
        "podIPs": [
            {
                "ip": "172.17.0.3"
            }
        ],
        "qosClass": "Burstable",
        "startTime": "2021-12-15T13:53:35Z"
    }
}
```

## Metrics from top:

```bash
kubectl top pod -n lab10-pod lab10-pod
```

```bash
NAME        CPU(cores)   MEMORY(bytes)   
lab10-pod   1001m        0Mi             
```
