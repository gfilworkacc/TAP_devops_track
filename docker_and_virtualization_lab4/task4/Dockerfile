FROM alpine

ARG username
ARG group

RUN apk update \
	&& apk upgrade \
	&& apk add "bash" \
	&& adduser $username -D \
	&& addgroup $group	

WORKDIR /

COPY --chown=$username:$group hello.py . 

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["ls -l hello.py"]
