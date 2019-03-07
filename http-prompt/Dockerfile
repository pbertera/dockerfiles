FROM alpine:latest

RUN apk update && apk add python bash py-pip

RUN pip install http-prompt

ENTRYPOINT ["http-prompt"]

