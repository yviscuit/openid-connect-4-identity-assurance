FROM python:3.7-alpine

WORKDIR /opt

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        gcc \
        libc-dev \
        libxml2-dev \
        libxslt-dev && \
    pip install xml2rfc

RUN cd /tmp && \
    wget https://github.com/mmarkdown/mmark/releases/download/v2.0.52/mmark_2.0.52_linux_amd64.tgz && \
    tar zxvf mmark_2.0.52_linux_amd64.tgz && \
    mv mmark /usr/local/bin/mmark

