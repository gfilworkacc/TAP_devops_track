# K8s task 12:<br/>
# * Create an Nginx docker image or Apache docker image with some basic index.html with Dockerfile<br/>
# * Push the image to your personal Dockerhub repository<br/>
# * Create a Deployment and Service w/ this custom image on port 80 and expose it<br/>
# * Tunnel the ip w/ minikube service [you-service] --url<br/>
# * Get a shell to the running container with kubectl exec<br/>
# * Edit your index.html<br/>
# * Reload the page and check the changes<br/>

## index.html content:

```html
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h1>Hello, Master! I am here to serve.</h1>
</body>
</html>
```

## Dockerfile content:

```bash
FROM nginx:stable
WORKDIR /usr/share/nginx/html
COPY index.html .
```

## Container is up and running:

```bash
curl localhost
```

```bash
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h1>Hello, Master! I am here to serve.</h1>
</body>
</html>
```

## Tag and push to Docker hub:

```bash
docker tag task12-image:latest agw7uwh2tivf45vcjrb9vmoeog/task12-image:latest
docker image push agw7uwh2tivf45vcjrb9vmoeog/task12-image:latest
```

## Deployment and service yaml file content:

```bash
---
apiVersion: v1
kind: Service
metadata:
  name: task-12
spec:
  selector:
    app: task-12
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: task-12
  labels:
    app: task-12
spec:
  replicas: 1
  selector:
    matchLabels:
      app: task-12
  template:
    metadata:
      labels:
        app: task-12
    spec:
      containers:
      - name: task-12
        image: agw7uwh2tivf45vcjrb9vmoeog/task12-image
```

## Get the service ip address:

```bash
minikube service list | grep task-12
```

```bash
| default              | task-12                   |           80 | http://192.168.49.2:80 |
```

## Check the default html page:

```bash
curl 192.168.49.2
```

```bash
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h1>Hello, Master! I am here to serve.</h1>
</body>
</html>
```

## Change and check the content again:

```bash
kubectl exec task-12-7fdf9c9b4b-jgqrk -- /bin/sed -in 's/serve\./serve you :)/' /usr/share/nginx/html/index.html
```

```bash
curl 192.168.49.2
```

```bash
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h1>Hello, Master! I am here to serve you :)</h1>
</body>
</html>
```
