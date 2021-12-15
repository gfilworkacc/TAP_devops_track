# K8s task 7:<br/>Create a deployment w/ joji95/k8s-static-web-app image and expose port 80 with NodePort; <br/>Use imperative command to create the deployment;<br/>Use declerative configuration file to create the deployment;<br/>Access the application running within minikube.

## Imperative approach:

```bash
kubectl run static-web-app --image=joji95/k8s-static-web-app 
kubectl expose deployment static-web-app --type=NodePort --name=static --port=80
```

### Results:

```bash
minikube service list
```

```bash
|-------------|------------|--------------|------------------------|
|  NAMESPACE  |    NAME    | TARGET PORT  |          URL           |
|-------------|------------|--------------|------------------------|
| default     | kubernetes | No node port |
| default     | static     |           80 | http://192.168.49.2:80 |
| kube-system | kube-dns   | No node port |
|-------------|------------|--------------|------------------------|
```

```bash
curl 192.168.49.2:80

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="main.css">
  <title>Kubernetes</title>
</head>
<body>
  <h1 class="center">Let's learn K8s</h1>
  <img src="kubernetes.gif" alt="kubernetes" class="center">
</body>
</html>
```

## Declerative approach:

Yaml file content:

```bash
---
apiVersion: v1
kind: Service
metadata:
  name: task-7-job
spec:
  selector:
    app: task-7-job
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: task-7-job
  labels:
    app: task-7-job
spec:
  containers:
    - name: task-7-job
      image: joji95/k8s-static-web-app
```
