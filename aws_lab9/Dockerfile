FROM --platform=linux/amd64 python:alpine

WORKDIR /script

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 80

CMD [ "/bin/sh", "-c", "(python3 app.py &) && python3 -m http.server --directory state 80" ]
