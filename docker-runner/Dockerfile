FROM python:2.7-alpine

RUN pip --no-cache-dir install docker-py

ADD docker-runner /sbin/

WORKDIR /data

ENTRYPOINT ["python", "/sbin/docker-runner"]
