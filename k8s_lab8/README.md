# K8s task 8: <br/>
# Create a Pod with memory limit and request in a separate namespace <br/>
# * Create a namespace <br/>
# * Configure request of 100MiB and limit of 200MiB <br/>
# * With polinux/stress image try to allocate 150MiB of memory <br/>
# * stress --vm 1 --vm-bytes 150M --vm-hang 1 <br/>
# * Check the details of the pod <br/>
# * Enable minikube metric-server <br/>
#   * Fetch the metrics for the pod <br/>

## Yaml configuration file content:

```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: lab8-pod
  labels:
    name: lab8-pod
---
apiVersion: v1
kind: Pod
metadata:
  name: lab8-pod
spec:
  containers:
  - name: lab8-pod
    image: polinux/stress
    resources:
      requests:
        memory: "100Mi"
      limits:
        memory: "200Mi"
    command: ["/usr/local/bin/stress"]
    args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1", "--verbose"]
  restartPolicy: Never
```

## Launching the pod in namespace lab8-pod and getting information:

```bash
kubectl apply -f pod.yaml --namespace=lab8-pod
kubectl get pods --namespace=lab8-pod  -o yaml
```

```bash
apiVersion: v1
items:
- apiVersion: v1
  kind: Pod
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"lab8-pod","namespace":"lab8-pod"},"spec":{"containers":[{"args":["--vm","1","--vm-bytes","150M","--vm-hang","1","--verbose"],"command":["/usr/local/bin/stress"],"image":"polinux/stress","name":"lab8-pod","resources":{"limits":{"memory":"200Mi"},"requests":{"memory":"100Mi"}}}],"restartPolicy":"Never"}}
    creationTimestamp: "2021-12-15T11:15:51Z"
    name: lab8-pod
    namespace: lab8-pod
    resourceVersion: "56739"
    uid: 209b0cf6-b0bd-4494-b7cb-26638e10e5e8
  spec:
    containers:
    - args:
      - --vm
      - "1"
      - --vm-bytes
      - 150M
      - --vm-hang
      - "1"
      - --verbose
      command:
      - /usr/local/bin/stress
      image: polinux/stress
      imagePullPolicy: Always
      name: lab8-pod
      resources:
        limits:
          memory: 200Mi
        requests:
          memory: 100Mi
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
      volumeMounts:
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-x9sh9
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: minikube
    preemptionPolicy: PreemptLowerPriority
    priority: 0
    restartPolicy: Never
    schedulerName: default-scheduler
    securityContext: {}
    serviceAccount: default
    serviceAccountName: default
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
      key: node.kubernetes.io/not-ready
      operator: Exists
      tolerationSeconds: 300
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
      tolerationSeconds: 300
    volumes:
    - name: kube-api-access-x9sh9
      projected:
        defaultMode: 420
        sources:
        - serviceAccountToken:
            expirationSeconds: 3607
            path: token
        - configMap:
            items:
            - key: ca.crt
              path: ca.crt
            name: kube-root-ca.crt
        - downwardAPI:
            items:
            - fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
              path: namespace
  status:
    conditions:
    - lastProbeTime: null
      lastTransitionTime: "2021-12-15T11:15:51Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2021-12-15T11:15:54Z"
      status: "True"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2021-12-15T11:15:54Z"
      status: "True"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2021-12-15T11:15:51Z"
      status: "True"
      type: PodScheduled
    containerStatuses:
    - containerID: docker://db9ecc4369ac5a0b96d392cd4a9ab36c857c3056e55d71479294eb47d0abca7c
      image: polinux/stress:latest
      imageID: docker-pullable://polinux/stress@sha256:b6144f84f9c15dac80deb48d3a646b55c7043ab1d83ea0a697c09097aaad21aa
      lastState: {}
      name: lab8-pod
      ready: true
      restartCount: 0
      started: true
      state:
        running:
          startedAt: "2021-12-15T11:15:54Z"
    hostIP: 192.168.49.2
    phase: Running
    podIP: 172.17.0.3
    podIPs:
    - ip: 172.17.0.3
    qosClass: Burstable
    startTime: "2021-12-15T11:15:51Z"
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```

## Information from top:

```bash
kubectl top pod -n lab8-pod lab8-pod
```

```bash
NAME       CPU(cores)   MEMORY(bytes)   
lab8-pod   78m          150Mi           
```

## Starting the minikube dashboard in the background. For the rest of the results, please look at the png files.

```bash
minikube dashboard &
```
