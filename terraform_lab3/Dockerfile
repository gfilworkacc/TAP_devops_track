#Do not forget architecture issue.
FROM --platform=linux/amd64 python:alpine

ENV FLASK_APP flask_app.py

WORKDIR /app

COPY flask_app.py requirements.txt ./

RUN pip3 install -r requirements.txt

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
