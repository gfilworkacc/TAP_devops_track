# Docker and virtualization lab5

## Copy hello.py from lab 4 and create Dockerfile file in the same directory with the following content:

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
docker build --build-arg username=Georgi --build-arg group=interns -t alpine_with_bash .

docker run alpine_with_bash
```
