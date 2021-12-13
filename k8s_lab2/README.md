# K8s task 2 - setting resources, start cluster, list services and pods normal and with detailed info:
## Commands and their output step by step:

```bash
minikube config set cpus 2
minikube config set memory 2048MB
```

```bash
minikube config view
```

```bash
- cpus: 2
- memory: 2048MB
```

```bash
minikube start
minikube status
```

```bash
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

```bash
kubectl get services
```

```bash
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   35m
```

```bash
kubectl get services kubernetes -o json
```

```bash
{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "creationTimestamp": "2021-12-13T08:04:53Z",
        "labels": {
            "component": "apiserver",
            "provider": "kubernetes"
        },
        "name": "kubernetes",
        "namespace": "default",
        "resourceVersion": "206",
        "uid": "44770fcb-fc1d-48b6-b55f-fe4cd8567eb9"
    },
    "spec": {
        "clusterIP": "10.96.0.1",
        "clusterIPs": [
            "10.96.0.1"
        ],
        "internalTrafficPolicy": "Cluster",
        "ipFamilies": [
            "IPv4"
        ],
        "ipFamilyPolicy": "SingleStack",
        "ports": [
            {
                "name": "https",
                "port": 443,
                "protocol": "TCP",
                "targetPort": 8443
            }
        ],
        "sessionAffinity": "None",
        "type": "ClusterIP"
    },
    "status": {
        "loadBalancer": {}
    }
}
```

```bash
kubectl get pod -A
```

```bash
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-cqp2g           1/1     Running   0          38m
kube-system   etcd-minikube                      1/1     Running   0          38m
kube-system   kube-apiserver-minikube            1/1     Running   0          38m
kube-system   kube-controller-manager-minikube   1/1     Running   0          38m
kube-system   kube-proxy-mhnq8                   1/1     Running   0          38m
kube-system   kube-scheduler-minikube            1/1     Running   0          38m
kube-system   storage-provisioner                1/1     Running   0          38m
```

```bash
kubectl get pod -A -o json
```


```bash
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "creationTimestamp": "2021-12-13T08:05:08Z",
                "generateName": "coredns-78fcd69978-",
                "labels": {
                    "k8s-app": "kube-dns",
                    "pod-template-hash": "78fcd69978"
                },
                "name": "coredns-78fcd69978-cqp2g",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "apps/v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "ReplicaSet",
                        "name": "coredns-78fcd69978",
                        "uid": "0fa9c05f-7bd3-49cf-9cc5-3045cbb12f09"
                    }
                ],
                "resourceVersion": "461",
                "uid": "cc232d88-947b-484e-973d-6665db08d7cc"
            },
            "spec": {
                "containers": [
                    {
                        "args": [
                            "-conf",
                            "/etc/coredns/Corefile"
                        ],
                        "image": "k8s.gcr.io/coredns/coredns:v1.8.4",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 5,
                            "httpGet": {
                                "path": "/health",
                                "port": 8080,
                                "scheme": "HTTP"
                            },
                            "initialDelaySeconds": 60,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 5
                        },
                        "name": "coredns",
                        "ports": [
                            {
                                "containerPort": 53,
                                "name": "dns",
                                "protocol": "UDP"
                            },
                            {
                                "containerPort": 53,
                                "name": "dns-tcp",
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 9153,
                                "name": "metrics",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "httpGet": {
                                "path": "/ready",
                                "port": 8181,
                                "scheme": "HTTP"
                            },
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 1
                        },
                        "resources": {
                            "limits": {
                                "memory": "170Mi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "memory": "70Mi"
                            }
                        },
                        "securityContext": {
                            "allowPrivilegeEscalation": false,
                            "capabilities": {
                                "add": [
                                    "NET_BIND_SERVICE"
                                ],
                                "drop": [
                                    "all"
                                ]
                            },
                            "readOnlyRootFilesystem": true
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/coredns",
                                "name": "config-volume",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-thjmb",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "Default",
                "enableServiceLinks": true,
                "nodeName": "minikube",
                "nodeSelector": {
                    "kubernetes.io/os": "linux"
                },
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000000000,
                "priorityClassName": "system-cluster-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {},
                "serviceAccount": "coredns",
                "serviceAccountName": "coredns",
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "key": "CriticalAddonsOnly",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node-role.kubernetes.io/master"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node-role.kubernetes.io/control-plane"
                    },
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
                        "configMap": {
                            "defaultMode": 420,
                            "items": [
                                {
                                    "key": "Corefile",
                                    "path": "Corefile"
                                }
                            ],
                            "name": "coredns"
                        },
                        "name": "config-volume"
                    },
                    {
                        "name": "kube-api-access-thjmb",
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
                        "lastTransitionTime": "2021-12-13T08:05:08Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:08Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://6f2cd98d947d17463115377586b4cf885f4844f83df2a10321bf552bd847f82b",
                        "image": "k8s.gcr.io/coredns/coredns:v1.8.4",
                        "imageID": "docker-pullable://k8s.gcr.io/coredns/coredns@sha256:6e5a02c21641597998b4be7cb5eb1e7b02c0d8d23cce4dd09f4682d463798890",
                        "lastState": {},
                        "name": "coredns",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:05:09Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "172.17.0.2",
                "podIPs": [
                    {
                        "ip": "172.17.0.2"
                    }
                ],
                "qosClass": "Burstable",
                "startTime": "2021-12-13T08:05:08Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "annotations": {
                    "kubeadm.kubernetes.io/etcd.advertise-client-urls": "https://192.168.49.2:2379",
                    "kubernetes.io/config.hash": "08a3871e1baa241b73e5af01a6d01393",
                    "kubernetes.io/config.mirror": "08a3871e1baa241b73e5af01a6d01393",
                    "kubernetes.io/config.seen": "2021-12-13T08:04:55.758062587Z",
                    "kubernetes.io/config.source": "file",
                    "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                },
                "creationTimestamp": "2021-12-13T08:04:56Z",
                "labels": {
                    "component": "etcd",
                    "tier": "control-plane"
                },
                "name": "etcd-minikube",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "controller": true,
                        "kind": "Node",
                        "name": "minikube",
                        "uid": "e4b3e0ca-f147-4f18-81b6-32943b79e2b6"
                    }
                ],
                "resourceVersion": "385",
                "uid": "89f555a6-89d3-4c56-917f-707141c49c82"
            },
            "spec": {
                "containers": [
                    {
                        "command": [
                            "etcd",
                            "--advertise-client-urls=https://192.168.49.2:2379",
                            "--cert-file=/var/lib/minikube/certs/etcd/server.crt",
                            "--client-cert-auth=true",
                            "--data-dir=/var/lib/minikube/etcd",
                            "--initial-advertise-peer-urls=https://192.168.49.2:2380",
                            "--initial-cluster=minikube=https://192.168.49.2:2380",
                            "--key-file=/var/lib/minikube/certs/etcd/server.key",
                            "--listen-client-urls=https://127.0.0.1:2379,https://192.168.49.2:2379",
                            "--listen-metrics-urls=http://127.0.0.1:2381",
                            "--listen-peer-urls=https://192.168.49.2:2380",
                            "--name=minikube",
                            "--peer-cert-file=/var/lib/minikube/certs/etcd/peer.crt",
                            "--peer-client-cert-auth=true",
                            "--peer-key-file=/var/lib/minikube/certs/etcd/peer.key",
                            "--peer-trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt",
                            "--proxy-refresh-interval=70000",
                            "--snapshot-count=10000",
                            "--trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt"
                        ],
                        "image": "k8s.gcr.io/etcd:3.5.0-0",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 8,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/health",
                                "port": 2381,
                                "scheme": "HTTP"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "name": "etcd",
                        "resources": {
                            "requests": {
                                "cpu": "100m",
                                "memory": "100Mi"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 24,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/health",
                                "port": 2381,
                                "scheme": "HTTP"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/var/lib/minikube/etcd",
                                "name": "etcd-data"
                            },
                            {
                                "mountPath": "/var/lib/minikube/certs/etcd",
                                "name": "etcd-certs"
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000001000,
                "priorityClassName": "system-node-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "seccompProfile": {
                        "type": "RuntimeDefault"
                    }
                },
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoExecute",
                        "operator": "Exists"
                    }
                ],
                "volumes": [
                    {
                        "hostPath": {
                            "path": "/var/lib/minikube/certs/etcd",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "etcd-certs"
                    },
                    {
                        "hostPath": {
                            "path": "/var/lib/minikube/etcd",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "etcd-data"
                    }
                ]
            },
            "status": {
                "conditions": [
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:06Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:06Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://22f225174c2a7794f318f8c96e994a63392a945ac89c839b80fc832abdd9f418",
                        "image": "k8s.gcr.io/etcd:3.5.0-0",
                        "imageID": "docker-pullable://k8s.gcr.io/etcd@sha256:9ce33ba33d8e738a5b85ed50b5080ac746deceed4a7496c550927a7a19ca3b6d",
                        "lastState": {},
                        "name": "etcd",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:04:44Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "Burstable",
                "startTime": "2021-12-13T08:04:56Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "annotations": {
                    "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint": "192.168.49.2:8443",
                    "kubernetes.io/config.hash": "5a60ad17d917e03c0e9b4ca796aa9460",
                    "kubernetes.io/config.mirror": "5a60ad17d917e03c0e9b4ca796aa9460",
                    "kubernetes.io/config.seen": "2021-12-13T08:04:55.758088412Z",
                    "kubernetes.io/config.source": "file",
                    "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                },
                "creationTimestamp": "2021-12-13T08:04:56Z",
                "labels": {
                    "component": "kube-apiserver",
                    "tier": "control-plane"
                },
                "name": "kube-apiserver-minikube",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "controller": true,
                        "kind": "Node",
                        "name": "minikube",
                        "uid": "e4b3e0ca-f147-4f18-81b6-32943b79e2b6"
                    }
                ],
                "resourceVersion": "344",
                "uid": "0c4b05ea-8fe4-4c9f-8db3-6f4a5385507a"
            },
            "spec": {
                "containers": [
                    {
                        "command": [
                            "kube-apiserver",
                            "--advertise-address=192.168.49.2",
                            "--allow-privileged=true",
                            "--authorization-mode=Node,RBAC",
                            "--client-ca-file=/var/lib/minikube/certs/ca.crt",
                            "--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota",
                            "--enable-bootstrap-token-auth=true",
                            "--etcd-cafile=/var/lib/minikube/certs/etcd/ca.crt",
                            "--etcd-certfile=/var/lib/minikube/certs/apiserver-etcd-client.crt",
                            "--etcd-keyfile=/var/lib/minikube/certs/apiserver-etcd-client.key",
                            "--etcd-servers=https://127.0.0.1:2379",
                            "--kubelet-client-certificate=/var/lib/minikube/certs/apiserver-kubelet-client.crt",
                            "--kubelet-client-key=/var/lib/minikube/certs/apiserver-kubelet-client.key",
                            "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
                            "--proxy-client-cert-file=/var/lib/minikube/certs/front-proxy-client.crt",
                            "--proxy-client-key-file=/var/lib/minikube/certs/front-proxy-client.key",
                            "--requestheader-allowed-names=front-proxy-client",
                            "--requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt",
                            "--requestheader-extra-headers-prefix=X-Remote-Extra-",
                            "--requestheader-group-headers=X-Remote-Group",
                            "--requestheader-username-headers=X-Remote-User",
                            "--secure-port=8443",
                            "--service-account-issuer=https://kubernetes.default.svc.cluster.local",
                            "--service-account-key-file=/var/lib/minikube/certs/sa.pub",
                            "--service-account-signing-key-file=/var/lib/minikube/certs/sa.key",
                            "--service-cluster-ip-range=10.96.0.0/12",
                            "--tls-cert-file=/var/lib/minikube/certs/apiserver.crt",
                            "--tls-private-key-file=/var/lib/minikube/certs/apiserver.key"
                        ],
                        "image": "k8s.gcr.io/kube-apiserver:v1.22.3",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 8,
                            "httpGet": {
                                "host": "192.168.49.2",
                                "path": "/livez",
                                "port": 8443,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "name": "kube-apiserver",
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "httpGet": {
                                "host": "192.168.49.2",
                                "path": "/readyz",
                                "port": 8443,
                                "scheme": "HTTPS"
                            },
                            "periodSeconds": 1,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "resources": {
                            "requests": {
                                "cpu": "250m"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 24,
                            "httpGet": {
                                "host": "192.168.49.2",
                                "path": "/livez",
                                "port": 8443,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/ssl/certs",
                                "name": "ca-certs",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/etc/ca-certificates",
                                "name": "etc-ca-certificates",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/var/lib/minikube/certs",
                                "name": "k8s-certs",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/usr/local/share/ca-certificates",
                                "name": "usr-local-share-ca-certificates",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/usr/share/ca-certificates",
                                "name": "usr-share-ca-certificates",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000001000,
                "priorityClassName": "system-node-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "seccompProfile": {
                        "type": "RuntimeDefault"
                    }
                },
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoExecute",
                        "operator": "Exists"
                    }
                ],
                "volumes": [
                    {
                        "hostPath": {
                            "path": "/etc/ssl/certs",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "ca-certs"
                    },
                    {
                        "hostPath": {
                            "path": "/etc/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "etc-ca-certificates"
                    },
                    {
                        "hostPath": {
                            "path": "/var/lib/minikube/certs",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "k8s-certs"
                    },
                    {
                        "hostPath": {
                            "path": "/usr/local/share/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "usr-local-share-ca-certificates"
                    },
                    {
                        "hostPath": {
                            "path": "/usr/share/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "usr-share-ca-certificates"
                    }
                ]
            },
            "status": {
                "conditions": [
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:58Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:58Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://a41182d890ecd09e1c2fa60519732a17d25e73ea62024ee3af50d5b97c85d546",
                        "image": "k8s.gcr.io/kube-apiserver:v1.22.3",
                        "imageID": "docker-pullable://k8s.gcr.io/kube-apiserver@sha256:6ee1c59e9c1fb570e7958e267a6993988eaa22448beb70d99de7afb21e862e9d",
                        "lastState": {},
                        "name": "kube-apiserver",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:04:45Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "Burstable",
                "startTime": "2021-12-13T08:04:56Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "annotations": {
                    "kubernetes.io/config.hash": "8b8f48de5a060759b091c9bd8713f19c",
                    "kubernetes.io/config.mirror": "8b8f48de5a060759b091c9bd8713f19c",
                    "kubernetes.io/config.seen": "2021-12-13T08:04:55.758091307Z",
                    "kubernetes.io/config.source": "file",
                    "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                },
                "creationTimestamp": "2021-12-13T08:04:56Z",
                "labels": {
                    "component": "kube-controller-manager",
                    "tier": "control-plane"
                },
                "name": "kube-controller-manager-minikube",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "controller": true,
                        "kind": "Node",
                        "name": "minikube",
                        "uid": "e4b3e0ca-f147-4f18-81b6-32943b79e2b6"
                    }
                ],
                "resourceVersion": "341",
                "uid": "75be9619-c241-4be4-bf7a-ecb0f412fa86"
            },
            "spec": {
                "containers": [
                    {
                        "command": [
                            "kube-controller-manager",
                            "--allocate-node-cidrs=true",
                            "--authentication-kubeconfig=/etc/kubernetes/controller-manager.conf",
                            "--authorization-kubeconfig=/etc/kubernetes/controller-manager.conf",
                            "--bind-address=127.0.0.1",
                            "--client-ca-file=/var/lib/minikube/certs/ca.crt",
                            "--cluster-cidr=10.244.0.0/16",
                            "--cluster-name=mk",
                            "--cluster-signing-cert-file=/var/lib/minikube/certs/ca.crt",
                            "--cluster-signing-key-file=/var/lib/minikube/certs/ca.key",
                            "--controllers=*,bootstrapsigner,tokencleaner",
                            "--kubeconfig=/etc/kubernetes/controller-manager.conf",
                            "--leader-elect=false",
                            "--port=0",
                            "--requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt",
                            "--root-ca-file=/var/lib/minikube/certs/ca.crt",
                            "--service-account-private-key-file=/var/lib/minikube/certs/sa.key",
                            "--service-cluster-ip-range=10.96.0.0/12",
                            "--use-service-account-credentials=true"
                        ],
                        "image": "k8s.gcr.io/kube-controller-manager:v1.22.3",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 8,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/healthz",
                                "port": 10257,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "name": "kube-controller-manager",
                        "resources": {
                            "requests": {
                                "cpu": "200m"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 24,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/healthz",
                                "port": 10257,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/ssl/certs",
                                "name": "ca-certs",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/etc/ca-certificates",
                                "name": "etc-ca-certificates",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/usr/libexec/kubernetes/kubelet-plugins/volume/exec",
                                "name": "flexvolume-dir"
                            },
                            {
                                "mountPath": "/var/lib/minikube/certs",
                                "name": "k8s-certs",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/etc/kubernetes/controller-manager.conf",
                                "name": "kubeconfig",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/usr/local/share/ca-certificates",
                                "name": "usr-local-share-ca-certificates",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/usr/share/ca-certificates",
                                "name": "usr-share-ca-certificates",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000001000,
                "priorityClassName": "system-node-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "seccompProfile": {
                        "type": "RuntimeDefault"
                    }
                },
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoExecute",
                        "operator": "Exists"
                    }
                ],
                "volumes": [
                    {
                        "hostPath": {
                            "path": "/etc/ssl/certs",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "ca-certs"
                    },
                    {
                        "hostPath": {
                            "path": "/etc/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "etc-ca-certificates"
                    },
                    {
                        "hostPath": {
                            "path": "/usr/libexec/kubernetes/kubelet-plugins/volume/exec",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "flexvolume-dir"
                    },
                    {
                        "hostPath": {
                            "path": "/var/lib/minikube/certs",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "k8s-certs"
                    },
                    {
                        "hostPath": {
                            "path": "/etc/kubernetes/controller-manager.conf",
                            "type": "FileOrCreate"
                        },
                        "name": "kubeconfig"
                    },
                    {
                        "hostPath": {
                            "path": "/usr/local/share/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "usr-local-share-ca-certificates"
                    },
                    {
                        "hostPath": {
                            "path": "/usr/share/ca-certificates",
                            "type": "DirectoryOrCreate"
                        },
                        "name": "usr-share-ca-certificates"
                    }
                ]
            },
            "status": {
                "conditions": [
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://4aae17cc1173308a404da186dca980c7978baedfaa7f4cf2538d6fbcfbcbc243",
                        "image": "k8s.gcr.io/kube-controller-manager:v1.22.3",
                        "imageID": "docker-pullable://k8s.gcr.io/kube-controller-manager@sha256:e67dbfd3796b7ce04fee80acb52876928c290224a91862c5849c3ab0fa31ca78",
                        "lastState": {},
                        "name": "kube-controller-manager",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:04:45Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "Burstable",
                "startTime": "2021-12-13T08:04:56Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "creationTimestamp": "2021-12-13T08:05:07Z",
                "generateName": "kube-proxy-",
                "labels": {
                    "controller-revision-hash": "674d79d6f9",
                    "k8s-app": "kube-proxy",
                    "pod-template-generation": "1"
                },
                "name": "kube-proxy-mhnq8",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "apps/v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "DaemonSet",
                        "name": "kube-proxy",
                        "uid": "c5360d62-fbbd-463b-a742-ace454e35755"
                    }
                ],
                "resourceVersion": "456",
                "uid": "bde803b3-12af-43b8-8db5-36053e8e745d"
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [
                                {
                                    "matchFields": [
                                        {
                                            "key": "metadata.name",
                                            "operator": "In",
                                            "values": [
                                                "minikube"
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                },
                "containers": [
                    {
                        "command": [
                            "/usr/local/bin/kube-proxy",
                            "--config=/var/lib/kube-proxy/config.conf",
                            "--hostname-override=$(NODE_NAME)"
                        ],
                        "env": [
                            {
                                "name": "NODE_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            }
                        ],
                        "image": "k8s.gcr.io/kube-proxy:v1.22.3",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "kube-proxy",
                        "resources": {},
                        "securityContext": {
                            "privileged": true
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/var/lib/kube-proxy",
                                "name": "kube-proxy"
                            },
                            {
                                "mountPath": "/run/xtables.lock",
                                "name": "xtables-lock"
                            },
                            {
                                "mountPath": "/lib/modules",
                                "name": "lib-modules",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-j6sxp",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "nodeSelector": {
                    "kubernetes.io/os": "linux"
                },
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000001000,
                "priorityClassName": "system-node-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {},
                "serviceAccount": "kube-proxy",
                "serviceAccountName": "kube-proxy",
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/not-ready",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/unreachable",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node.kubernetes.io/disk-pressure",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node.kubernetes.io/memory-pressure",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node.kubernetes.io/pid-pressure",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node.kubernetes.io/unschedulable",
                        "operator": "Exists"
                    },
                    {
                        "effect": "NoSchedule",
                        "key": "node.kubernetes.io/network-unavailable",
                        "operator": "Exists"
                    }
                ],
                "volumes": [
                    {
                        "configMap": {
                            "defaultMode": 420,
                            "name": "kube-proxy"
                        },
                        "name": "kube-proxy"
                    },
                    {
                        "hostPath": {
                            "path": "/run/xtables.lock",
                            "type": "FileOrCreate"
                        },
                        "name": "xtables-lock"
                    },
                    {
                        "hostPath": {
                            "path": "/lib/modules",
                            "type": ""
                        },
                        "name": "lib-modules"
                    },
                    {
                        "name": "kube-api-access-j6sxp",
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
                        "lastTransitionTime": "2021-12-13T08:05:07Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:07Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://44d4a6ab724b413ef06ea9d6f2abd9dabb3546641900fe3bab9b72e5037c8f04",
                        "image": "k8s.gcr.io/kube-proxy:v1.22.3",
                        "imageID": "docker-pullable://k8s.gcr.io/kube-proxy@sha256:8d0561b2e5d0ccb9c49a25e7b415bef12637a07a872703dc252c2de3b458fc4f",
                        "lastState": {},
                        "name": "kube-proxy",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:05:09Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "BestEffort",
                "startTime": "2021-12-13T08:05:07Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "annotations": {
                    "kubernetes.io/config.hash": "eee9e2da42102bf0a05e1e7b00e318bf",
                    "kubernetes.io/config.mirror": "eee9e2da42102bf0a05e1e7b00e318bf",
                    "kubernetes.io/config.seen": "2021-12-13T08:04:43.923501818Z",
                    "kubernetes.io/config.source": "file",
                    "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                },
                "creationTimestamp": "2021-12-13T08:04:54Z",
                "labels": {
                    "component": "kube-scheduler",
                    "tier": "control-plane"
                },
                "name": "kube-scheduler-minikube",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "controller": true,
                        "kind": "Node",
                        "name": "minikube",
                        "uid": "e4b3e0ca-f147-4f18-81b6-32943b79e2b6"
                    }
                ],
                "resourceVersion": "346",
                "uid": "93b025b4-f9c4-42b5-aecd-c3244492e9e1"
            },
            "spec": {
                "containers": [
                    {
                        "command": [
                            "kube-scheduler",
                            "--authentication-kubeconfig=/etc/kubernetes/scheduler.conf",
                            "--authorization-kubeconfig=/etc/kubernetes/scheduler.conf",
                            "--bind-address=127.0.0.1",
                            "--kubeconfig=/etc/kubernetes/scheduler.conf",
                            "--leader-elect=false",
                            "--port=0"
                        ],
                        "image": "k8s.gcr.io/kube-scheduler:v1.22.3",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 8,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/healthz",
                                "port": 10259,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "name": "kube-scheduler",
                        "resources": {
                            "requests": {
                                "cpu": "100m"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 24,
                            "httpGet": {
                                "host": "127.0.0.1",
                                "path": "/healthz",
                                "port": 10259,
                                "scheme": "HTTPS"
                            },
                            "initialDelaySeconds": 10,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "timeoutSeconds": 15
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/kubernetes/scheduler.conf",
                                "name": "kubeconfig",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 2000001000,
                "priorityClassName": "system-node-critical",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "seccompProfile": {
                        "type": "RuntimeDefault"
                    }
                },
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoExecute",
                        "operator": "Exists"
                    }
                ],
                "volumes": [
                    {
                        "hostPath": {
                            "path": "/etc/kubernetes/scheduler.conf",
                            "type": "FileOrCreate"
                        },
                        "name": "kubeconfig"
                    }
                ]
            },
            "status": {
                "conditions": [
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:02Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:02Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:04:56Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://84e1e442b4eeb732aae1b7b59232afc7342661038f2d409a61c758895fa271f8",
                        "image": "k8s.gcr.io/kube-scheduler:v1.22.3",
                        "imageID": "docker-pullable://k8s.gcr.io/kube-scheduler@sha256:cac7ea67201a84c00f3e8d9be51877c25fb539055ac404c4a9d2dd4c79d3fdab",
                        "lastState": {},
                        "name": "kube-scheduler",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:04:45Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "Burstable",
                "startTime": "2021-12-13T08:04:56Z"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Pod",
            "metadata": {
                "annotations": {
                    "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"labels\":{\"addonmanager.kubernetes.io/mode\":\"Reconcile\",\"integration-test\":\"storage-provisioner\"},\"name\":\"storage-provisioner\",\"namespace\":\"kube-system\"},\"spec\":{\"containers\":[{\"command\":[\"/storage-provisioner\"],\"image\":\"gcr.io/k8s-minikube/storage-provisioner:v5\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"storage-provisioner\",\"volumeMounts\":[{\"mountPath\":\"/tmp\",\"name\":\"tmp\"}]}],\"hostNetwork\":true,\"serviceAccountName\":\"storage-provisioner\",\"volumes\":[{\"hostPath\":{\"path\":\"/tmp\",\"type\":\"Directory\"},\"name\":\"tmp\"}]}}\n"
                },
                "creationTimestamp": "2021-12-13T08:04:57Z",
                "labels": {
                    "addonmanager.kubernetes.io/mode": "Reconcile",
                    "integration-test": "storage-provisioner"
                },
                "name": "storage-provisioner",
                "namespace": "kube-system",
                "resourceVersion": "465",
                "uid": "fb808d60-4ecd-4a10-b182-334113971477"
            },
            "spec": {
                "containers": [
                    {
                        "command": [
                            "/storage-provisioner"
                        ],
                        "image": "gcr.io/k8s-minikube/storage-provisioner:v5",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "storage-provisioner",
                        "resources": {},
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/tmp",
                                "name": "tmp"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cbrsp",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostNetwork": true,
                "nodeName": "minikube",
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 0,
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {},
                "serviceAccount": "storage-provisioner",
                "serviceAccountName": "storage-provisioner",
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
                        "hostPath": {
                            "path": "/tmp",
                            "type": "Directory"
                        },
                        "name": "tmp"
                    },
                    {
                        "name": "kube-api-access-cbrsp",
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
                        "lastTransitionTime": "2021-12-13T08:05:07Z",
                        "status": "True",
                        "type": "Initialized"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "Ready"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:10Z",
                        "status": "True",
                        "type": "ContainersReady"
                    },
                    {
                        "lastProbeTime": null,
                        "lastTransitionTime": "2021-12-13T08:05:07Z",
                        "status": "True",
                        "type": "PodScheduled"
                    }
                ],
                "containerStatuses": [
                    {
                        "containerID": "docker://b66e0b9c4bb1129f6e66bc4becc3f8b84c50dca5cf3cce74327ff33bc15e728e",
                        "image": "gcr.io/k8s-minikube/storage-provisioner:v5",
                        "imageID": "docker-pullable://gcr.io/k8s-minikube/storage-provisioner@sha256:18eb69d1418e854ad5a19e399310e52808a8321e4c441c1dddad8977a0d7a944",
                        "lastState": {},
                        "name": "storage-provisioner",
                        "ready": true,
                        "restartCount": 0,
                        "started": true,
                        "state": {
                            "running": {
                                "startedAt": "2021-12-13T08:05:09Z"
                            }
                        }
                    }
                ],
                "hostIP": "192.168.49.2",
                "phase": "Running",
                "podIP": "192.168.49.2",
                "podIPs": [
                    {
                        "ip": "192.168.49.2"
                    }
                ],
                "qosClass": "BestEffort",
                "startTime": "2021-12-13T08:05:07Z"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": "",
        "selfLink": ""
    }
}
```
