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
