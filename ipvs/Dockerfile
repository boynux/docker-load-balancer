FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y ipvsadm curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
