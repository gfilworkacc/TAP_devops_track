# Docker and virtualization lab4 - task2:

## Copy hello.py from task 1 and create Dockerfile file in the same directory with the following content:

```bash
FROM alpine

ARG username
ARG group

RUN apk update && apk upgrade && apk add "bash"

RUN adduser $username -D
RUN addgroup $group	

WORKDIR /

COPY --chown=$username:$group hello.py . 

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["ls -l hello.py"]
```
## Build the image with arguments and run it in a container

```bash
docker build --build-arg username=Georgi --build-arg group=interns -t test_arg:Georgi.interns .

docker run test_arg:Georgi.interns
```
