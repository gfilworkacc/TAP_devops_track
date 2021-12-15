# K8s task 11: <br/>
# Create a Pod that has a CPU request so big that it exceeds the capacity of any Node in your cluster <br/>
# * Use the namespace <br/>
# * Configure CPU request 100 and limit 100 <br/>
# * With vish/stress image try to use 2 CPUs <br/>
#   * -cpus "2" <br/>
# * Check the details of the pod <br/>

## Yaml configuration file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: lab11-pod
  labels:
    name: lab11-pod
---
apiVersion: v1
kind: Pod
metadata:
  name: lab11-pod
spec:
  containers:
  - name: lab11-pod
    image: vish/stress
    resources:
      requests:
        memory: "100Mi"
        cpu: "100"
      limits:
        cpu: "100"
        memory: "200Mi"
    args: ["-cpus", "2"]
  restartPolicy: Never
```

## Pod's details:

```bash
kubectl get pods -n lab11-pod lab11-pod -o json
```

```bash
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"name\":\"lab11-pod\",\"namespace\":\"lab11-pod\"},\"spec\":{\"containers\":[{\"args\":[\"-cpus\",\"2\"],\"image\":\"vish/stress\",\"name\":\"lab11-pod\",\"resources\":{\"limits\":{\"cpu\":\"100\",\"memory\":\"200Mi\"},\"requests\":{\"cpu\":\"100\",\"memory\":\"100Mi\"}}}],\"restartPolicy\":\"Never\"}}\n"
        },
        "creationTimestamp": "2021-12-15T14:21:53Z",
        "name": "lab11-pod",
        "namespace": "lab11-pod",
        "resourceVersion": "65088",
        "uid": "e69f0993-b9a8-485d-9513-21a5d5133cc8"
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
                "name": "lab11-pod",
                "resources": {
                    "limits": {
                        "cpu": "100",
                        "memory": "200Mi"
                    },
                    "requests": {
                        "cpu": "100",
                        "memory": "100Mi"
                    }
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "kube-api-access-wkbdr",
                        "readOnly": true
                    }
                ]
            }
        ],
        "dnsPolicy": "ClusterFirst",
        "enableServiceLinks": true,
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
                "name": "kube-api-access-wkbdr",
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
                "lastTransitionTime": "2021-12-15T14:21:53Z",
                "message": "0/1 nodes are available: 1 Insufficient cpu.",
                "reason": "Unschedulable",
                "status": "False",
                "type": "PodScheduled"
            }
        ],
        "phase": "Pending",
        "qosClass": "Burstable"
    }
}
```
